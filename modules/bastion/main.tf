# Create a dedicated Service Account for the Bastion VM
resource "google_service_account" "bastion" {
  account_id   = "bastion-sftp-sa"
  display_name = "Service Account for Bastion and SFTP Server"
  project      = var.project_id
}

# Grant necessary basic roles for logging and monitoring
resource "google_project_iam_member" "bastion_logging" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.bastion.email}"
}

resource "google_project_iam_member" "bastion_monitoring" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.bastion.email}"
}

# Grant Secret Manager Accessor on the Tailscale auth key
resource "google_secret_manager_secret_iam_member" "bastion_tailscale" {
  project   = var.project_id
  secret_id = var.tailscale_secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.bastion.email}"
}

# Grant Secret Manager Accessor on the SFTP password
resource "google_secret_manager_secret_iam_member" "bastion_sftp_pass" {
  project   = var.project_id
  secret_id = var.sftp_password_secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.bastion.email}"
}

# Grant Secret Manager Accessor on the SFTP SSH Key
resource "google_secret_manager_secret_iam_member" "bastion_sftp_ssh_key" {
  project   = var.project_id
  secret_id = var.sftp_ssh_key_secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.bastion.email}"
}

# Create Compute Engine VM (Private Bastion + SFTP)
resource "google_compute_instance" "bastion" {
  name         = "bastion-sftp-server"
  machine_type = "e2-micro"
  zone         = var.zone != "" ? var.zone : "${var.region}-a"
  project      = var.project_id

  can_ip_forward = true # Required for Tailscale subnet router

  tags = ["bastion"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 20
    }
  }

  network_interface {
    subnetwork = var.subnet_id
    # No access_config block means NO public IP. Truly private.
  }

  service_account {
    email  = google_service_account.bastion.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  metadata_startup_script = <<EOF
#!/bin/bash
set -e

# Update packages and install prerequisites
apt-get update -y
apt-get install -y curl apt-transport-https gnupg

# Install Tailscale
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.noarch.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.tailscale-keyring.list | tee /etc/apt/sources.list.d/tailscale.list
apt-get update -y
apt-get install -y tailscale

# Enable IP forwarding for Subnet Routing
echo 'net.ipv4.ip_forward = 1' | tee -a /etc/sysctl.d/99-tailscale.conf
echo 'net.ipv6.conf.all.forwarding = 1' | tee -a /etc/sysctl.d/99-tailscale.conf
sysctl -p /etc/sysctl.d/99-tailscale.conf

# Fetch Tailscale auth key from Secret Manager
TAILSCALE_AUTH_KEY=$(gcloud secrets versions access latest --secret="${var.tailscale_secret_id}" || true)

if [ -n "$TAILSCALE_AUTH_KEY" ]; then
  # Start Tailscale, advertise the VPC subnets, and accept routes from the tailnet
  tailscale up --authkey="$TAILSCALE_AUTH_KEY" --advertise-routes="${var.subnet_cidr}" --accept-routes
else
  echo "Tailscale auth key not set or unavailable in GSM. Continuing without tailscale connection."
  tailscale up --accept-routes
fi

# Configure Jailed SFTP Server
# 1. Create a group for SFTP users
groupadd -f sftponly

# 2. Create the sftpuser user if they do not exist
if ! id "sftpuser" &>/dev/null; then
  useradd -m -g sftponly -s /sbin/nologin -d /home/sftpuser sftpuser
fi

# 3. Secure the home directory for Chroot jail (must be owned by root, not writable by user)
chown root:root /home/sftpuser
chmod 755 /home/sftpuser

# 4. Create an uploads folder where the user has full write access
mkdir -p /home/sftpuser/uploads
chown sftpuser:sftponly /home/sftpuser/uploads
chmod 700 /home/sftpuser/uploads

# 5. Configure sshd to use Chroot directory and force SFTP protocol
if ! grep -q "Match Group sftponly" /etc/ssh/sshd_config; then
  cat << 'SSHDCFG' >> /etc/ssh/sshd_config

# SFTP chroot configuration added by Terraform
Match Group sftponly
    ChrootDirectory /home/%u
    ForceCommand internal-sftp
    AllowTcpForwarding no
    X11Forwarding no
    PasswordAuthentication yes
SSHDCFG
fi

# 6. Retrieve password and SSH keys from GSM if available
SFTP_PASS=$(gcloud secrets versions access latest --secret="${var.sftp_password_secret_id}" || echo "TempDefaultSFTPPass1!")
echo "sftpuser:$SFTP_PASS" | chpasswd

SFTP_SSH_KEY=$(gcloud secrets versions access latest --secret="${var.sftp_ssh_key_secret_id}" || true)
if [ -n "$SFTP_SSH_KEY" ]; then
  mkdir -p /home/sftpuser/.ssh
  echo "$SFTP_SSH_KEY" > /home/sftpuser/.ssh/authorized_keys
  chown -R sftpuser:sftponly /home/sftpuser/.ssh
  chmod 700 /home/sftpuser/.ssh
  chmod 600 /home/sftpuser/.ssh/authorized_keys
fi

# Restart SSH service
systemctl restart sshd
EOF

  depends_on = [
    google_secret_manager_secret_iam_member.bastion_tailscale,
    google_secret_manager_secret_iam_member.bastion_sftp_pass,
    google_secret_manager_secret_iam_member.bastion_sftp_ssh_key
  ]
}
