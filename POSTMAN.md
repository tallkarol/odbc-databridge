# Testing with Postman

Quick guide for testing the API with Postman.

## Setup

1. Start the API server locally:
   ```bash
   python api.py
   ```
   
   Or use the deployed URL if running on Google Cloud.

2. Open Postman

## Health Check Test

1. Create a new request
2. Set method: `GET`
3. Set URL: `http://localhost:8080/`
4. Click "Send"

Expected Response:
```json
{
  "status": "healthy",
  "service": "odbc-databridge-api",
  "version": "1.0.0"
}
```

## Trigger Birdeye Export (All Brands)

1. Create a new request
2. Set method: `POST`
3. Set URL: `http://localhost:8080/api/birdeye/export`
4. Click "Send"

Expected Response:
```json
{
  "status": "success",
  "message": "Birdeye export completed successfully",
  "record_count": 42,
  "output_file": "exports/birdeye_export.json"
}
```

## Trigger Birdeye Export (Specific Brand)

1. Create a new request
2. Set method: `POST`
3. Set URL: `http://localhost:8080/api/birdeye/export`
4. Go to the "Body" tab
5. Select "raw" and "JSON" from the dropdown
6. Enter the JSON body:
   ```json
   {
     "brand_name": "YourBrandName"
   }
   ```
7. Click "Send"

Expected Response:
```json
{
  "status": "success",
  "message": "Birdeye export completed successfully",
  "record_count": 15,
  "output_file": "exports/birdeye_export.json",
  "brand_filter": "YourBrandName"
}
```

## Using with Google Cloud Deployed API

Simply replace `http://localhost:8080` with your Google Cloud URL:

**Cloud Run:**
```
https://odbc-databridge-XXXXXXXXXX-uc.a.run.app
```

**App Engine:**
```
https://your-project-id.appspot.com
```

## Tips

- Save your requests in a Postman Collection for reuse
- Use Postman Environment variables to switch between local and cloud URLs
- Check the API logs for detailed information about what happened
- The exported data is saved to `exports/birdeye_export.json`
