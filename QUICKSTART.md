# Quick Start - Deploy to Google Cloud

Get your ODBC DataBridge API running on Google Cloud in 5 minutes.

## Step 1: Install Google Cloud CLI

If you don't have it already:
```bash
curl https://sdk.cloud.google.com | bash
exec -l $SHELL
```

Or download from: https://cloud.google.com/sdk/docs/install

## Step 2: Login and Setup

```bash
# Login to Google Cloud
gcloud auth login

# Set your project (replace with your actual project ID)
gcloud config set project YOUR_PROJECT_ID
```

## Step 3: Deploy (Choose ONE option)

### Option A: Use the deployment script (Easiest)

```bash
./deploy.sh YOUR_DATABASE_PASSWORD
```

That's it! The script will:
- Enable required APIs
- Build and deploy your application
- Give you a URL to test

### Option B: Manual deployment (One command)

```bash
gcloud run deploy odbc-databridge \
  --source . \
  --region us-central1 \
  --allow-unauthenticated \
  --set-env-vars "DB_DRIVER=MariaDB Unicode" \
  --set-env-vars "DB_SERVER=34.152.118.156" \
  --set-env-vars "DB_DATABASE=odcb_databridge-db" \
  --set-env-vars "DB_USERNAME=odcb-databridge-db" \
  --set-env-vars "DB_PASSWORD=YOUR_DATABASE_PASSWORD" \
  --set-env-vars "DB_PORT=3306" \
  --set-env-vars "BIRDEYE_ENDPOINT=https://hooks.zapier.com/hooks/catch/23151206/umyaaov/" \
  --set-env-vars "EXAMPLE_SERVICE_ENDPOINT=https://hooks.zapier.com/hooks/catch/23151206/umyaaov/" \
  --set-env-vars "LOG_DIR=logs" \
  --set-env-vars "LOG_LEVEL=INFO"
```

## Step 4: Test Your API

After deployment, you'll get a URL like: `https://odbc-databridge-xxxxx-uc.a.run.app`

### Test health check:
```bash
curl https://YOUR_SERVICE_URL/
```

### Test Birdeye export:
```bash
curl -X POST https://YOUR_SERVICE_URL/api/birdeye/export
```

## Done!

Your API is now live and ready to receive requests.

---

## Troubleshooting

**Can't connect to database?**
- Verify your database password is correct
- Check that your Cloud SQL instance allows connections from Cloud Run

**See logs:**
```bash
gcloud run services logs read odbc-databridge --region us-central1 --limit 50
```

**Get service URL:**
```bash
gcloud run services describe odbc-databridge --region us-central1 --format='value(status.url)'
```

---

For more details, see [DEPLOY.md](DEPLOY.md)
