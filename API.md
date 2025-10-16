# API Quick Reference

## Starting the API

**Development:**
```bash
python api.py
```

**Production:**
```bash
gunicorn -w 4 -b 0.0.0.0:8080 api:app
```

## Endpoints

### Health Check
```bash
GET /
```

Example:
```bash
curl http://localhost:8080/
```

Response:
```json
{
  "status": "healthy",
  "service": "odbc-databridge-api",
  "version": "1.0.0"
}
```

### Trigger Birdeye Export

```bash
POST /api/birdeye/export
```

**Export all brands:**
```bash
curl -X POST http://localhost:8080/api/birdeye/export
```

**Export specific brand:**
```bash
curl -X POST http://localhost:8080/api/birdeye/export \
  -H "Content-Type: application/json" \
  -d '{"brand_name": "YourBrandName"}'
```

Success Response:
```json
{
  "status": "success",
  "message": "Birdeye export completed successfully",
  "record_count": 42,
  "output_file": "exports/birdeye_export.json",
  "brand_filter": "YourBrandName"
}
```

Error Response:
```json
{
  "status": "error",
  "message": "Error message here"
}
```

## Deploy to Google Cloud

### Cloud Run (Recommended)

```bash
gcloud run deploy odbc-databridge \
  --source . \
  --region us-central1 \
  --allow-unauthenticated \
  --set-env-vars DB_DRIVER="MySQL ODBC 8.0 Unicode Driver" \
  --set-env-vars DB_SERVER="your-ip" \
  --set-env-vars DB_DATABASE="your-db" \
  --set-env-vars DB_USERNAME="your-user" \
  --set-env-vars DB_PASSWORD="your-password" \
  --set-env-vars DB_PORT="3306" \
  --set-env-vars BIRDEYE_ENDPOINT="https://your-endpoint.com"
```

Or use the provided `Dockerfile`.

### App Engine

Edit `app.yaml` with your credentials, then:
```bash
gcloud app deploy
```

## Testing

Test the API server:
```bash
python test_api.py
```

## Postman Testing

1. Create a new request in Postman
2. Set method to `POST`
3. Set URL to `http://localhost:8080/api/birdeye/export`
4. (Optional) Add JSON body:
   ```json
   {
     "brand_name": "YourBrandName"
   }
   ```
5. Send request

## Notes

- The API uses the same database configuration as the CLI scripts
- All exports are saved to the `exports/` directory
- All logs are saved to the `logs/` directory
- Brand filtering is case-sensitive
