# Google Cloud Deployment Guide

This guide provides step-by-step instructions for deploying the ODBC DataBridge API to Google Cloud.

## Prerequisites

1. **Google Cloud Account**: Ensure you have a Google Cloud account and billing enabled
2. **Google Cloud CLI**: Install the gcloud CLI tool
   ```bash
   # Install gcloud CLI (if not already installed)
   # Visit: https://cloud.google.com/sdk/docs/install
   
   # Or use the installer:
   curl https://sdk.cloud.google.com | bash
   exec -l $SHELL
   ```

3. **Login to Google Cloud**:
   ```bash
   gcloud auth login
   ```

4. **Set your project ID** (replace `YOUR_PROJECT_ID` with your actual Google Cloud project ID):
   ```bash
   gcloud config set project YOUR_PROJECT_ID
   ```

5. **Enable required APIs**:
   ```bash
   gcloud services enable run.googleapis.com
   gcloud services enable cloudbuild.googleapis.com
   gcloud services enable containerregistry.googleapis.com
   ```

## Deployment Options

There are **two recommended deployment options**: Cloud Run (recommended) and App Engine (legacy).

---

## Option 1: Cloud Run (Recommended - Modern & Scalable)

Cloud Run is the recommended option for deploying containerized applications. It's serverless, scales automatically, and you only pay for what you use.

### Quick Deploy (Single Command)

Replace `YOUR_DB_PASSWORD` with your actual database password:

```bash
gcloud run deploy odbc-databridge \
  --source . \
  --region us-central1 \
  --allow-unauthenticated \
  --set-env-vars "DB_DRIVER=MySQL ODBC 8.0 Unicode Driver" \
  --set-env-vars "DB_SERVER=34.152.118.156" \
  --set-env-vars "DB_DATABASE=odcb_databridge-db" \
  --set-env-vars "DB_USERNAME=odcb-databridge-db" \
  --set-env-vars "DB_PASSWORD=YOUR_DB_PASSWORD" \
  --set-env-vars "DB_PORT=3306" \
  --set-env-vars "BIRDEYE_ENDPOINT=https://hooks.zapier.com/hooks/catch/23151206/umyaaov/" \
  --set-env-vars "EXAMPLE_SERVICE_ENDPOINT=https://hooks.zapier.com/hooks/catch/23151206/umyaaov/" \
  --set-env-vars "LOG_DIR=logs" \
  --set-env-vars "LOG_LEVEL=INFO"
```

**What happens:**
- Google Cloud will automatically detect your Dockerfile
- Build the container image
- Deploy to Cloud Run
- Provide you with a public URL

### Alternative: Deploy with Pre-built Docker Image

If you prefer to build locally first:

```bash
# 1. Build the Docker image
docker build -t gcr.io/YOUR_PROJECT_ID/odbc-databridge:latest .

# 2. Push to Google Container Registry
docker push gcr.io/YOUR_PROJECT_ID/odbc-databridge:latest

# 3. Deploy to Cloud Run
gcloud run deploy odbc-databridge \
  --image gcr.io/YOUR_PROJECT_ID/odbc-databridge:latest \
  --region us-central1 \
  --allow-unauthenticated \
  --set-env-vars "DB_DRIVER=MySQL ODBC 8.0 Unicode Driver,DB_SERVER=34.152.118.156,DB_DATABASE=odcb_databridge-db,DB_USERNAME=odcb-databridge-db,DB_PASSWORD=YOUR_DB_PASSWORD,DB_PORT=3306,BIRDEYE_ENDPOINT=https://hooks.zapier.com/hooks/catch/23151206/umyaaov/,EXAMPLE_SERVICE_ENDPOINT=https://hooks.zapier.com/hooks/catch/23151206/umyaaov/,LOG_DIR=logs,LOG_LEVEL=INFO"
```

### Get the Service URL

After deployment, get your service URL:

```bash
gcloud run services describe odbc-databridge --region us-central1 --format='value(status.url)'
```

---

## Option 2: App Engine (Legacy - Simple but Less Flexible)

App Engine is simpler but less flexible than Cloud Run.

### Prerequisites for App Engine

1. **Create an App Engine application** (one-time setup):
   ```bash
   gcloud app create --region=us-central
   ```

### Deploy to App Engine

1. **Edit app.yaml** - Open `app.yaml` and replace `YOUR_PASSWORD_HERE` with your actual database password:
   ```yaml
   DB_PASSWORD: "your_actual_password"
   ```

2. **Deploy**:
   ```bash
   gcloud app deploy
   ```

3. **Get the service URL**:
   ```bash
   gcloud app browse
   ```

---

## Testing Your Deployment

Once deployed, you'll get a URL (e.g., `https://odbc-databridge-xxxxx-uc.a.run.app` for Cloud Run).

### Test the health check endpoint:

```bash
curl https://YOUR_SERVICE_URL/
```

Expected response:
```json
{
  "status": "healthy",
  "service": "odbc-databridge-api",
  "version": "1.0.0"
}
```

### Test the Birdeye export endpoint:

```bash
curl -X POST https://YOUR_SERVICE_URL/api/birdeye/export \
  -H "Content-Type: application/json"
```

Expected response:
```json
{
  "status": "success",
  "message": "Birdeye export completed successfully",
  "record_count": 42,
  "output_file": "exports/birdeye_export.json"
}
```

### Test with brand filter:

```bash
curl -X POST https://YOUR_SERVICE_URL/api/birdeye/export \
  -H "Content-Type: application/json" \
  -d '{"brand_name": "YourBrandName"}'
```

---

## Troubleshooting

### View logs (Cloud Run):
```bash
gcloud run services logs read odbc-databridge --region us-central1 --limit 50
```

### View logs (App Engine):
```bash
gcloud app logs tail -s default
```

### Check service status (Cloud Run):
```bash
gcloud run services describe odbc-databridge --region us-central1
```

### Database connection issues:

1. **Verify database IP is accessible from Google Cloud**:
   - Make sure your Cloud SQL instance allows connections from the Cloud Run IP range
   - Or use Cloud SQL Proxy for secure connections

2. **Test database credentials**:
   - Double-check DB_PASSWORD is correct
   - Verify DB_USERNAME has proper permissions

3. **Check ODBC driver**:
   - The Dockerfile installs `libmyodbc` which provides "MySQL ODBC 8.0 Unicode Driver"
   - If you need a different driver, modify the Dockerfile

### Update environment variables (Cloud Run):

```bash
gcloud run services update odbc-databridge \
  --region us-central1 \
  --set-env-vars "DB_PASSWORD=new_password"
```

---

## Security Best Practices

### Use Secret Manager (Recommended for Production)

Instead of storing passwords in environment variables, use Google Cloud Secret Manager:

1. **Create a secret**:
   ```bash
   echo -n "your_db_password" | gcloud secrets create db-password --data-file=-
   ```

2. **Deploy with secret**:
   ```bash
   gcloud run deploy odbc-databridge \
     --source . \
     --region us-central1 \
     --set-secrets "DB_PASSWORD=db-password:latest" \
     --set-env-vars "DB_DRIVER=MySQL ODBC 8.0 Unicode Driver,DB_SERVER=34.152.118.156,DB_DATABASE=odcb_databridge-db,DB_USERNAME=odcb-databridge-db,DB_PORT=3306,BIRDEYE_ENDPOINT=https://hooks.zapier.com/hooks/catch/23151206/umyaaov/,EXAMPLE_SERVICE_ENDPOINT=https://hooks.zapier.com/hooks/catch/23151206/umyaaov/,LOG_DIR=logs,LOG_LEVEL=INFO"
   ```

### Restrict Access

If you don't want the API to be publicly accessible:

```bash
# Deploy without --allow-unauthenticated
gcloud run deploy odbc-databridge \
  --source . \
  --region us-central1 \
  --no-allow-unauthenticated
```

Then use authentication tokens when calling the API.

---

## Quick Reference

### Useful Commands

```bash
# View all Cloud Run services
gcloud run services list

# Delete a service
gcloud run services delete odbc-databridge --region us-central1

# View logs
gcloud run services logs read odbc-databridge --region us-central1 --limit 100

# Update service with new code
gcloud run deploy odbc-databridge --source . --region us-central1

# Get service URL
gcloud run services describe odbc-databridge --region us-central1 --format='value(status.url)'
```

---

## Summary

**For quick deployment and testing:**
1. Install and login to gcloud CLI
2. Enable required APIs
3. Run the single Cloud Run deploy command with your database password
4. Test the endpoints with curl or Postman
5. Done!

**Estimated time:** 5-10 minutes for first deployment.
