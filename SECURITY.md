# Security Guidelines

## Overview

This document outlines security best practices for deploying and maintaining the ODBC DataBridge API.

## ⚠️ Before Deploying

### 1. Never Commit Secrets

The following files are in `.gitignore` and should NEVER be committed:
- `.env` - Contains your database credentials
- `config.py` - May contain credentials

**Always verify before committing:**
```bash
# Check what will be committed
git status

# If you see .env or config.py, DO NOT commit them
```

### 2. Protect Your Credentials

Your deployment requires these sensitive values:
- Database password
- Database server IP (less sensitive but still private)
- Webhook URLs (contain unique identifiers)

**How we protect them:**
- ✅ Passwords are passed as script parameters (not hardcoded)
- ✅ Environment variables in Cloud Run (not in source code)
- ✅ app.yaml uses placeholder text, not real passwords
- ✅ Documentation shows examples with YOUR_PASSWORD placeholders

## 🔒 Production Deployment Security

### Use Google Cloud Secret Manager (Recommended)

Instead of passing passwords as environment variables, use Secret Manager:

```bash
# Create a secret
echo -n "your_db_password" | gcloud secrets create db-password --data-file=-

# Deploy with secret reference
gcloud run deploy odbc-databridge \
  --source . \
  --region us-central1 \
  --set-secrets "DB_PASSWORD=db-password:latest" \
  --set-env-vars "DB_DRIVER=MySQL ODBC 8.0 Unicode Driver,DB_SERVER=34.152.118.156,DB_DATABASE=odcb_databridge-db,DB_USERNAME=odcb-databridge-db,DB_PORT=3306,BIRDEYE_ENDPOINT=https://hooks.zapier.com/hooks/catch/23151206/umyaaov/,LOG_DIR=logs,LOG_LEVEL=INFO"
```

**Benefits:**
- Passwords are encrypted at rest
- Access is audited
- Rotation is easier
- Never appears in logs or environment variable listings

### Restrict API Access

By default, the API is deployed with `--allow-unauthenticated` for easy testing.

**For production, restrict access:**

```bash
# Deploy without public access
gcloud run deploy odbc-databridge \
  --source . \
  --region us-central1 \
  --no-allow-unauthenticated

# Then use IAM to control access
gcloud run services add-iam-policy-binding odbc-databridge \
  --region us-central1 \
  --member="serviceAccount:caller@project.iam.gserviceaccount.com" \
  --role="roles/run.invoker"
```

**Calling authenticated endpoints:**
```bash
# Get identity token
TOKEN=$(gcloud auth print-identity-token)

# Call API with token
curl -H "Authorization: Bearer $TOKEN" https://your-service-url/api/birdeye/export
```

## 🛡️ Database Security

### 1. Use Private IP (Recommended)

Instead of public IP (34.152.118.156), use Cloud SQL Proxy or Private IP:

```bash
# Using Cloud SQL Proxy
gcloud run deploy odbc-databridge \
  --source . \
  --region us-central1 \
  --add-cloudsql-instances PROJECT:REGION:INSTANCE \
  --set-env-vars "DB_SERVER=/cloudsql/PROJECT:REGION:INSTANCE"
```

### 2. Limit Database Permissions

Create a dedicated database user for the API with minimal permissions:

```sql
-- Create user for API
CREATE USER 'odbc_api'@'%' IDENTIFIED BY 'strong_password';

-- Grant only SELECT permission on specific table
GRANT SELECT ON odcb_databridge-db.customer_journey TO 'odbc_api'@'%';

-- Flush privileges
FLUSH PRIVILEGES;
```

### 3. Use SSL/TLS Connections

Add SSL parameters to your connection string if supported by your ODBC driver.

## 🔐 Webhook Security

Your Zapier webhook URLs contain unique identifiers:
```
https://hooks.zapier.com/hooks/catch/23151206/umyaaov/
```

**Best practices:**
- Treat these URLs as secrets (they allow anyone to send data to your Zapier)
- Rotate them if exposed
- Consider adding signature verification in Zapier
- Monitor webhook logs for suspicious activity

## 📋 Security Checklist

Before going to production:

- [ ] Database password stored in Secret Manager (not environment variables)
- [ ] API access restricted with IAM authentication
- [ ] Database user has minimal permissions (SELECT only)
- [ ] Database connection uses private IP or Cloud SQL Proxy
- [ ] SSL/TLS enabled for database connections
- [ ] Webhook URLs monitored for abuse
- [ ] Logging enabled and reviewed regularly
- [ ] No secrets in source code or documentation
- [ ] `.env` file in `.gitignore`
- [ ] Regular security updates applied

## 🚨 What to Do If Credentials Are Exposed

### If database password is compromised:
1. Immediately rotate the password in Cloud SQL
2. Update the secret in Secret Manager
3. Redeploy the service

```bash
# Update secret
echo -n "new_password" | gcloud secrets versions add db-password --data-file=-

# Service will pick up new version automatically
```

### If webhook URL is compromised:
1. Generate new webhook URL in Zapier
2. Update BIRDEYE_ENDPOINT in Cloud Run
3. Monitor for unauthorized usage

```bash
gcloud run services update odbc-databridge \
  --region us-central1 \
  --set-env-vars "BIRDEYE_ENDPOINT=https://new-url"
```

## 📊 Monitoring

Monitor your service for security issues:

```bash
# Check recent logs for errors or suspicious activity
gcloud run services logs read odbc-databridge --region us-central1 --limit 100

# View access logs
gcloud logging read "resource.type=cloud_run_revision AND resource.labels.service_name=odbc-databridge" --limit 50 --format json
```

## 📚 Additional Resources

- [Google Cloud Run Security](https://cloud.google.com/run/docs/securing/overview)
- [Secret Manager Best Practices](https://cloud.google.com/secret-manager/docs/best-practices)
- [Cloud SQL Security Best Practices](https://cloud.google.com/sql/docs/mysql/security-best-practices)

## Summary

**For quick testing (current setup):**
- ✅ Passwords passed as parameters
- ✅ Public API access
- ⚠️ Environment variables (acceptable for testing)

**For production (recommended):**
- ✅ Secret Manager for passwords
- ✅ IAM authentication for API
- ✅ Private IP for database
- ✅ Minimal database permissions
- ✅ Regular monitoring and updates
