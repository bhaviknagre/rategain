# 1. VPC and Networking Module
module "vpc" {
  source                = "./modules/vpc"
  project_id            = var.project_id
  region                = var.region
  vpc_name              = var.vpc_name
  subnet_name           = var.subnet_name
  subnet_cidr           = var.subnet_cidr
  pod_ip_cidr_range     = var.pod_ip_cidr_range
  service_ip_cidr_range = var.service_ip_cidr_range
}

# 1.1 Firewall Rules Module
module "firewall" {
  source               = "./modules/firewall"
  project_id           = var.project_id
  vpc_name             = var.vpc_name
  vpc_network_name     = module.vpc.network_name
  enable_flow_logs     = true
  allow_external_https = false
  allow_external_http  = false

  depends_on = [module.vpc]
}

# 1.2 IAM Service Accounts Module
module "iam" {
  source     = "./modules/iam"
  project_id = var.project_id
}

# 1.3 Secrets Manager Module
module "secrets_manager" {
  source                        = "./modules/secrets_manager"
  project_id                    = var.project_id
  database_password_secret_id   = var.database_password_secret_id
  database_password             = var.database_password
  gke_service_account           = module.iam.gke_node_service_account_email
  migration_service_account     = module.iam.migration_service_account_email

  depends_on = [module.iam]
}

# 2. GKE Cluster Module
module "gke" {
  source                = "./modules/gke"
  project_id            = var.project_id
  region                = var.region
  cluster_name          = var.cluster_name
  network_name          = module.vpc.network_name
  subnet_name           = module.vpc.subnet_name
  node_count            = var.gke_node_count
  min_node_count        = var.gke_min_node_count
  max_node_count        = var.gke_max_node_count
  machine_type          = var.gke_machine_type
  node_service_account  = module.iam.gke_node_service_account_email
  pod_ip_range_name     = "gke-pods"
  service_ip_range_name = "gke-services"

  depends_on = [module.firewall, module.iam]
}

# 3. Artifact Registry Module
module "artifact_registry" {
  source        = "./modules/artifact_registry"
  project_id    = var.project_id
  region        = var.region
  repository_id = var.artifact_registry_id
}

# 4. PostgreSQL (Primary & Replica) Module
module "postgresql" {
  source                = "./modules/postgresql"
  project_id            = var.project_id
  region                = var.region
  primary_instance_name = var.db_primary_instance_name
  replica_instance_name = var.db_replica_instance_name
  tier                  = var.db_tier
  database_name         = var.db_name
  database_user         = var.db_user
  database_password     = var.database_password
  network_id            = module.vpc.network_id

  depends_on = [module.firewall]
}

# 5. BigQuery Module
module "bigquery" {
  source     = "./modules/bigquery"
  project_id = var.project_id
  region     = var.region
  dataset_id = var.bigquery_dataset_id
  table_id   = var.bigquery_table_id
}

# 6. Firestore Module
module "firestore" {
  source     = "./modules/firestore"
  project_id = var.project_id
  region     = var.firestore_region
}

# 7. Memorystore (Redis) Module
module "redis" {
  source              = "./modules/redis"
  project_id          = var.project_id
  region              = var.region
  redis_instance_name = var.redis_instance_name
  tier                = var.redis_tier
  memory_size_gb      = var.redis_memory_size_gb
  authorized_network  = module.vpc.network_id

  depends_on = [module.firewall]
}

# 8. Pub/Sub Module
module "pubsub" {
  source            = "./modules/pubsub"
  project_id        = var.project_id
  topic_name        = var.pubsub_topic_name
  subscription_name = var.pubsub_subscription_name
}

# 9. Cloud Storage (GCS) Module
module "gcs" {
  source      = "./modules/gcs"
  project_id  = var.project_id
  region      = var.region
  bucket_name = var.gcs_bucket_name
}

# 10. Kubernetes Apps Deployments Module (Elasticsearch & ClickHouse)
module "k8s_deployments" {
  source    = "./modules/k8s_deployments"
  namespace = "infra"

  depends_on = [module.gke]
}
