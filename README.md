# ODBC DataBridge API

A Flask-based API service that bridges ODBC database connections with external services like Birdeye through Zapier webhooks.

## 🚀 Quick Deploy to Google Cloud

**Want to deploy right now?** See **[DEPLOYMENT_STEPS.md](DEPLOYMENT_STEPS.md)** for the fastest path to production.

```bash
# One command deployment:
./deploy.sh YOUR_DATABASE_PASSWORD
```

## 📚 Documentation

- **[DEPLOYMENT_STEPS.md](DEPLOYMENT_STEPS.md)** - Step-by-step deployment guide (START HERE)
- **[QUICKSTART.md](QUICKSTART.md)** - Quick reference for deployment
- **[DEPLOY.md](DEPLOY.md)** - Comprehensive deployment documentation
- **[API.md](API.md)** - API endpoint reference
- **[SETUP.md](SETUP.md)** - Local development setup
- **[POSTMAN.md](POSTMAN.md)** - Postman testing guide

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

### Cloud Run (Recommended)

```bash
./deploy.sh YOUR_DATABASE_PASSWORD
```

See [DEPLOYMENT_STEPS.md](DEPLOYMENT_STEPS.md) for detailed instructions.

### App Engine

```bash
# Edit app.yaml with your credentials
gcloud app deploy
```

## Configuration

Configure via environment variables (`.env` file or Cloud Run environment):

- `DB_DRIVER` - ODBC driver name (e.g., "MariaDB Unicode")
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
# Automated testing
./test_deployment.sh

# Or manually
curl https://your-service-url.run.app/
curl -X POST https://your-service-url.run.app/api/birdeye/export
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
1. Check the [DEPLOYMENT_STEPS.md](DEPLOYMENT_STEPS.md) troubleshooting section
2. View logs: `gcloud run services logs read odbc-databridge --region us-central1 --limit 50`
3. Open an issue in the repository
