# 🚀 DEPLOYMENT STEPS - Get Your API Running NOW

Follow these exact steps to deploy your ODBC DataBridge API to Google Cloud and test the Birdeye endpoint.

## Prerequisites (5 minutes)

### 1. Install Google Cloud CLI

**Mac/Linux:**
```bash
curl https://sdk.cloud.google.com | bash
exec -l $SHELL
gcloud init
```

**Windows:**
Download and run the installer from: https://cloud.google.com/sdk/docs/install

**Already have it?** Skip to step 2.

### 2. Login and Set Your Project

```bash
# Login to Google Cloud
gcloud auth login

# Set your project (you should already have a project)
gcloud config set project YOUR_PROJECT_ID

# Verify it's set correctly
gcloud config get-value project
```

## 🎯 Deploy (Choose ONE method)

### Method 1: Automated Script (EASIEST - Recommended)

```bash
# Run the deployment script with your database password
./deploy.sh YOUR_DATABASE_PASSWORD
```

**That's it!** The script will:
- ✅ Enable required Google Cloud APIs
- ✅ Build your Docker container
- ✅ Deploy to Cloud Run
- ✅ Give you the service URL

**Time:** ~5 minutes

---

### Method 2: Manual One-Line Deploy

If you prefer to see exactly what's happening:

```bash
gcloud run deploy odbc-databridge \
  --source . \
  --region us-central1 \
  --allow-unauthenticated \
  --set-env-vars "DB_DRIVER=MariaDB Unicode" \
  --set-env-vars "DB_SERVER=34.152.118.156" \
  --set-env-vars "DB_DATABASE=odcb_databridge-db" \
  --set-env-vars "DB_USERNAME=odcb-databridge-db" \
  --set-env-vars "DB_PASSWORD=YOUR_ACTUAL_PASSWORD" \
  --set-env-vars "DB_PORT=3306" \
  --set-env-vars "BIRDEYE_ENDPOINT=https://hooks.zapier.com/hooks/catch/23151206/umyaaov/" \
  --set-env-vars "EXAMPLE_SERVICE_ENDPOINT=https://hooks.zapier.com/hooks/catch/23151206/umyaaov/" \
  --set-env-vars "LOG_DIR=logs" \
  --set-env-vars "LOG_LEVEL=INFO"
```

**Don't forget to replace `YOUR_ACTUAL_PASSWORD` with your real database password!**

**Time:** ~5 minutes

---

## 🧪 Test Your Deployment

After deployment completes, you'll see output like:
```
Service [odbc-databridge] revision [odbc-databridge-00001-xyz] has been deployed and is serving 100 percent of traffic.
Service URL: https://odbc-databridge-xxxxx-uc.a.run.app
```

### Get Your Service URL

```bash
gcloud run services describe odbc-databridge --region us-central1 --format='value(status.url)'
```

### Option A: Use the Test Script (Automated)

```bash
./test_deployment.sh
```

### Option B: Manual Tests

Replace `YOUR_SERVICE_URL` with the actual URL from the deployment output.

**1. Test Health Check:**
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

**2. Test Birdeye Export (THE MAIN ONE):**
```bash
curl -X POST https://YOUR_SERVICE_URL/api/birdeye/export
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

**3. Test with Brand Filter (Optional):**
```bash
curl -X POST https://YOUR_SERVICE_URL/api/birdeye/export \
  -H "Content-Type: application/json" \
  -d '{"brand_name": "YourBrandName"}'
```

---

## 🎉 Done!

Your API is live! You can now:
- Send POST requests to `/api/birdeye/export` from anywhere
- The data will be sent to your Zapier webhook
- Data will also be saved locally in the container

---

## 🔍 Troubleshooting

### Problem: Deployment fails

**Check your project:**
```bash
gcloud config get-value project
```

**Enable required APIs manually:**
```bash
gcloud services enable run.googleapis.com
gcloud services enable cloudbuild.googleapis.com
gcloud services enable containerregistry.googleapis.com
```

### Problem: API returns 500 error

**Check the logs:**
```bash
gcloud run services logs read odbc-databridge --region us-central1 --limit 50
```

**Common issues:**
1. **Wrong database password** - Update it:
   ```bash
   gcloud run services update odbc-databridge \
     --region us-central1 \
     --set-env-vars "DB_PASSWORD=correct_password"
   ```

2. **Database connection blocked** - Make sure your Cloud SQL instance allows connections from Cloud Run

3. **ODBC driver issue** - The Dockerfile installs odbc-mariadb which provides the MariaDB Unicode driver

### Problem: Can't find service URL

```bash
gcloud run services describe odbc-databridge --region us-central1 --format='value(status.url)'
```

### View All Services

```bash
gcloud run services list
```

---

## 📊 Monitor Your Service

**View recent logs:**
```bash
gcloud run services logs read odbc-databridge --region us-central1 --limit 50
```

**Stream logs in real-time:**
```bash
gcloud run services logs tail odbc-databridge --region us-central1
```

**Check service details:**
```bash
gcloud run services describe odbc-databridge --region us-central1
```

---

## 🔄 Update Your Service

Made code changes? Redeploy with:

```bash
./deploy.sh YOUR_PASSWORD
```

Or manually:
```bash
gcloud run deploy odbc-databridge --source . --region us-central1
```

---

## 💡 Quick Reference

```bash
# Deploy
./deploy.sh YOUR_PASSWORD

# Test
./test_deployment.sh

# Get URL
gcloud run services describe odbc-databridge --region us-central1 --format='value(status.url)'

# View logs
gcloud run services logs read odbc-databridge --region us-central1 --limit 50

# Update password
gcloud run services update odbc-databridge --region us-central1 --set-env-vars "DB_PASSWORD=new_password"

# Delete service
gcloud run services delete odbc-databridge --region us-central1
```

---

## 📝 Summary

**Total time from start to finish:** ~10 minutes (first time)

**What you get:**
- ✅ Live API endpoint on Google Cloud
- ✅ Automatic scaling (scales to zero when not in use)
- ✅ HTTPS by default
- ✅ No server management needed
- ✅ Pay only for what you use

**Next steps:**
1. Deploy using `./deploy.sh YOUR_PASSWORD`
2. Test using `./test_deployment.sh` or curl commands
3. Done! Your API is ready to use
