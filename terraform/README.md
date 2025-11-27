# Terraform Configuration for African Griot Blog

This directory contains Terraform configurations to manage your African Griot blog infrastructure on Google Cloud Platform.

## 📁 Structure

```
terraform/
├── main.tf                    # Main infrastructure configuration
├── variables.tf               # Input variables
├── outputs.tf                 # Output values
├── terraform.tfvars.example   # Example configuration (copy to terraform.tfvars)
└── README.md                  # This file
```

## 🚀 Quick Start

### 1. Install Terraform

Download from: https://www.terraform.io/downloads

Or using Chocolatey on Windows:
```bash
choco install terraform
```

### 2. Authenticate with Google Cloud

```bash
gcloud auth application-default login
```

### 3. Create terraform.tfvars (Optional)

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
```

The default values in `variables.tf` match your current deployment, so you can skip this step if using defaults.

### 4. Initialize Terraform

```bash
terraform init
```

### 5. Import Existing Resources

Since your Cloud Run service is already deployed, import it:

```bash
# Import the Cloud Run service
terraform import google_cloud_run_service.africangriot projects/zarnite-web/locations/europe-west1/services/africangriot
```

### 6. Preview Changes

```bash
terraform plan
```

### 7. Apply Configuration

```bash
terraform apply
```

Type `yes` when prompted.

## 📦 What This Manages

- ✅ **Cloud Run Service** - Your containerized blog application
- ✅ **Cloud Storage Bucket** - For future persistent image uploads
- ✅ **IAM Policies** - Public access for the service and bucket
- ✅ **Cloud Build Trigger** - CI/CD from GitHub
- ✅ **Artifact Registry** - Docker image repository
- ✅ **API Enablement** - Required Google Cloud APIs

## 🔧 Current Configuration

Based on your deployed service:

- **Project**: zarnite-web
- **Region**: europe-west1
- **Service**: africangriot
- **CPU**: 1000m (1 core)
- **Memory**: 512Mi
- **Min/Max Instances**: 1 (cost-effective for small project)
- **Storage**: Ephemeral (in-memory posts, temporary uploads)

## 📝 Common Commands

```bash
# Initialize Terraform
terraform init

# Format configuration files
terraform fmt

# Validate configuration
terraform validate

# Preview changes
terraform plan

# Apply changes
terraform apply

# Show current state
terraform show

# List resources
terraform state list

# Destroy all resources (CAREFUL!)
terraform destroy
```

## 🔄 CI/CD Integration

The configuration includes a Cloud Build trigger that:
- Monitors your GitHub repo (ZAN-Web-rr/Africangriot)
- Builds Docker image on push to main branch
- Deploys to Cloud Run automatically
- Tags images with commit SHA and 'latest'

## 🔐 Remote State (Recommended for Production)

Store state in Google Cloud Storage:

1. Create a bucket for state:
```bash
gsutil mb gs://africangriot-terraform-state
gsutil versioning set on gs://africangriot-terraform-state
```

2. Uncomment backend configuration in `main.tf`:
```hcl
backend "gcs" {
  bucket = "africangriot-terraform-state"
  prefix = "terraform/state"
}
```

3. Reinitialize:
```bash
terraform init -migrate-state
```

## ⚠️ Important Notes

### Ephemeral Storage
- Posts are stored in-memory (will reset on container restart)
- Uploaded images are temporary (lost on restart/redeploy)
- Good for: Testing, demos, small projects
- Not ideal for: Production with persistent data needs

### Future Persistence
The GCS bucket is pre-configured but not actively used. When you're ready to add persistence:
1. Install `@google-cloud/storage` npm package
2. Update server.js to use GCS for uploads
3. Add a database (MongoDB, PostgreSQL) for posts

## 💰 Cost Optimization

Current settings are optimized for low costs:
- Min instances: 1 (always ready, minimal cold starts)
- Max instances: 1 (prevents unexpected scaling costs)
- Memory: 512Mi (adequate for ephemeral storage)
- CPU: 1 core (sufficient for small traffic)

## 🆘 Troubleshooting

**Error: API not enabled**
```bash
gcloud services enable run.googleapis.com
gcloud services enable cloudbuild.googleapis.com
gcloud services enable artifactregistry.googleapis.com
```

**Error: Permission denied**
```bash
gcloud auth application-default login
```

**Error: Resource already exists**
Use `terraform import` to bring existing resources under Terraform management.

## 📚 Resources

- [Terraform Google Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [Cloud Run Documentation](https://cloud.google.com/run/docs)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html)

---

Made with ❤️ by Emmanuel Gopeh
