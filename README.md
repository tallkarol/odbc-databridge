# ODBC DataBridge API

A Flask-based API service that bridges ODBC database connections with external services like Birdeye through Zapier webhooks.

## 🚀 Quick Deploy to Google Cloud

Deploy to Cloud Run with one command:

```bash
./deploy.sh YOUR_DATABASE_PASSWORD
```

## Features

- **REST API** for triggering data exports
- **ODBC Database Connectivity** (MySQL, SQL Server, etc.)
- **Webhook Integration** with Zapier
- **Google Cloud Ready** (Cloud Run, App Engine)
- **Docker Support** for containerized deployment

## API Endpoints

### Health Check
```
GET /
```

### Birdeye Export
```
POST /api/birdeye/export
```

Optional JSON body:
```json
{
  "brand_name": "YourBrand"
}
```

## Local Development

1. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

2. **Create `.env` file:**
   ```bash
   cp .env.example .env
   # Edit .env with your database credentials
   ```

3. **Run the API:**
   ```bash
   python api.py
   ```

4. **Test:**
   ```bash
   curl http://localhost:8080/
   curl -X POST http://localhost:8080/api/birdeye/export
   ```

## Google Cloud Deployment

### Initial Deployment

```bash
./deploy.sh YOUR_DATABASE_PASSWORD
```

### Update Existing Deployment

To update an existing Cloud Run deployment with code changes:

```bash
# Method 1: Using the deploy script (recommended)
./deploy.sh YOUR_DATABASE_PASSWORD

# Method 2: Using gcloud CLI directly
gcloud run deploy odbc-databridge \
  --source . \
  --region us-central1

# Method 3: Update specific environment variables only
gcloud run services update odbc-databridge \
  --region us-central1 \
  --set-env-vars "DB_PASSWORD=new_password"
```

View deployment logs:
```bash
gcloud run services logs read odbc-databridge --region us-central1 --limit 50
```

## Configuration

Configure via environment variables (`.env` file or Cloud Run environment):

- `DB_DRIVER` - ODBC driver name (e.g., "MariaDB")
- `DB_SERVER` - Database server address
- `DB_DATABASE` - Database name
- `DB_USERNAME` - Database username
- `DB_PASSWORD` - Database password
- `DB_PORT` - Database port (e.g., 3306 for MySQL)
- `BIRDEYE_ENDPOINT` - Zapier webhook URL for Birdeye
- `EXAMPLE_SERVICE_ENDPOINT` - Zapier webhook URL for other services
- `LOG_DIR` - Directory for log files
- `LOG_LEVEL` - Logging level (INFO, DEBUG, ERROR)

## Testing Deployment

```bash
# Get your service URL
SERVICE_URL=$(gcloud run services describe odbc-databridge --region us-central1 --format='value(status.url)')

# Test health check
curl $SERVICE_URL/

# Test Birdeye export endpoint
curl -X POST $SERVICE_URL/api/birdeye/export
```

## Architecture

```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│   Client    │────▶│  Flask API   │────▶│   Database  │
│  (curl/app) │     │ (Cloud Run)  │     │   (MySQL)   │
└─────────────┘     └──────────────┘     └─────────────┘
                           │
                           │
                           ▼
                    ┌──────────────┐
                    │    Zapier    │
                    │   Webhook    │
                    └──────────────┘
```

## Tech Stack

- **Python 3.11+**
- **Flask** - Web framework
- **pyodbc** - ODBC database connectivity
- **gunicorn** - WSGI HTTP server
- **Docker** - Containerization
- **Google Cloud Run** - Serverless deployment

## License

See LICENSE file for details.

## Support

For issues or questions:
1. View logs: `gcloud run services logs read odbc-databridge --region us-central1 --limit 50`
2. Open an issue in the repository

## Troubleshooting

### ODBC Driver Error: "Can't open lib 'MySQL ODBC 8.0 Unicode Driver'"

This error occurs when the Cloud Run environment has the wrong driver name configured. The Dockerfile installs `odbc-mariadb` which provides the driver name **"MariaDB"** (without Unicode). You can verify this correct driver name is documented in `.env.example`.

**Solution:** Redeploy with the correct driver configuration:

```bash
# Option 1: Use the deploy script (recommended - it has the correct configuration)
./deploy.sh YOUR_DATABASE_PASSWORD

# Option 2: Update just the driver environment variable
gcloud run services update odbc-databridge \
  --region us-central1 \
  --set-env-vars "DB_DRIVER=MariaDB"
```

After updating, test the endpoint:
```bash
# Get your service URL first
SERVICE_URL=$(gcloud run services describe odbc-databridge --region us-central1 --format='value(status.url)')

# Then test the endpoint
curl -X POST $SERVICE_URL/api/birdeye/export
```
