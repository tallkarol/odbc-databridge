# ODBC DataBridge - Setup Guide

Get from fresh clone to locally tested in minutes.

## Prerequisites

- Python 3.7+
- ODBC driver installed (see [Driver Installation](#driver-installation))
- Database credentials for Google Cloud MySQL (or other ODBC-compatible database)

## Quick Setup Steps

### 1. Install Python Dependencies

```bash
pip install -r requirements.txt
```

### 2. Configure Database Credentials

Copy the environment template:

```bash
cp .env.example .env
```

Edit `.env` with your Google Cloud MySQL credentials:

```bash
# For Google Cloud MySQL
DB_DRIVER=MySQL ODBC 8.0 Unicode Driver
DB_SERVER=your-instance-ip-or-domain
DB_DATABASE=your-database-name
DB_USERNAME=your-username
DB_PASSWORD=your-password
DB_PORT=3306

# For other databases (SQL Server with Simba)
# DB_DRIVER=Simba SQL Server ODBC Driver
# DB_SERVER=your-server.database.windows.net
# DB_DATABASE=your-database
# DB_USERNAME=your-username
# DB_PASSWORD=your-password
# DB_PORT=

# API Endpoints (Zapier webhook for testing)
BIRDEYE_ENDPOINT=https://hooks.zapier.com/hooks/catch/23151206/umyaaov/
EXAMPLE_SERVICE_ENDPOINT=https://hooks.zapier.com/hooks/catch/23151206/umyaaov/

# Logging
LOG_DIR=logs
LOG_LEVEL=INFO
```

**Where to edit credentials:**
- Edit the `.env` file in the project root directory
- Never commit this file (it's in `.gitignore`)

### 3. Test the Setup

Validate the project structure:

```bash
python test_structure.py
```

You should see all checks passing (✓).

### 4. Customize Service Script

The `birdeye_export.py` script demonstrates a real use-case. To test it:

1. Open `services/birdeye_export.py`
2. Update the SQL query (lines 94-103) to match your database schema:

```python
query = """
    SELECT 
        id,
        name,
        email
    FROM your_actual_table
    WHERE active = 1
"""
```

### 5. Run and Test

Run the Birdeye service:

```bash
python services/birdeye_export.py
```

Check the logs:

```bash
cat logs/birdeye_export_*.log
```

Check the exported data:

```bash
cat exports/birdeye_export.json
```

The script will:
- Connect to your database
- Execute the query
- Send data to the Zapier endpoint
- Save data locally in `exports/`
- Log everything to `logs/`

## Creating Your Own Service

To create a new service integration:

1. **Copy the template:**
   ```bash
   cp services/example_service.py services/my_service.py
   ```

2. **Update the logger name** (line 91):
   ```python
   logger = setup_logger('my_service')
   ```

3. **Update the SQL query** (lines 116-123) for your use case

4. **Customize the `process_data()` function** (lines 27-45) if needed

5. **Add your endpoint to `.env`:**
   ```bash
   MY_SERVICE_ENDPOINT=https://your-webhook-url.com
   ```

6. **Update endpoint reference** (line 68):
   ```python
   endpoint = get_endpoint('my_service')
   ```

7. **Run and test:**
   ```bash
   python services/my_service.py
   ```

## Commands Reference

### Install Dependencies
```bash
pip install -r requirements.txt
```

### Run Services
```bash
python services/birdeye_export.py
python services/my_service.py
```

### View Logs
```bash
# List all logs
ls -lt logs/

# View specific log
cat logs/birdeye_export_*.log
tail -f logs/birdeye_export_*.log  # Follow live
```

### View Exports
```bash
# List all exports
ls -lt exports/

# View specific export
cat exports/birdeye_export.json
```

### Validate Structure
```bash
python test_structure.py
```

### Schedule with Cron

Edit crontab:
```bash
crontab -e
```

Add schedule (example runs daily at 2 AM):
```bash
0 2 * * * cd /path/to/odbc-databridge && /usr/bin/python3 services/birdeye_export.py
```

Common cron patterns:
```bash
# Every 15 minutes
*/15 * * * * cd /path/to/odbc-databridge && python services/my_service.py

# Every hour
0 * * * * cd /path/to/odbc-databridge && python services/my_service.py

# Weekdays at 9 AM
0 9 * * 1-5 cd /path/to/odbc-databridge && python services/my_service.py
```

## Driver Installation

### MySQL (for Google Cloud MySQL)

**Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install -y unixodbc unixodbc-dev
sudo apt-get install -y libmyodbc
```

**macOS:**
```bash
brew install mysql-connector-odbc
```

**Verify installation:**
```bash
odbcinst -q -d
```

### SQL Server (Simba or Microsoft drivers)

**Ubuntu/Debian:**
```bash
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list | sudo tee /etc/apt/sources.list.d/mssql-release.list
sudo apt-get update
sudo ACCEPT_EULA=Y apt-get install -y msodbcsql17
```

**Simba drivers:** Download from Simba website and follow installation instructions.

## Troubleshooting

### Cannot connect to database
- Verify credentials in `.env` file
- Check that ODBC driver is installed: `odbcinst -q -d`
- Ensure database allows connections from your IP
- For Google Cloud MySQL: Check firewall rules and authorized networks
- Test connection: Try with another tool (e.g., `mysql` command line)

### Module import errors
- Install dependencies: `pip install -r requirements.txt`
- Run from project root directory

### Logs not created
- Ensure `logs/` directory exists (it should be created automatically)
- Check file permissions
- Verify script is running without errors

### Zapier endpoint not receiving data
- This is a mock endpoint for testing - it may not show all data
- Check script logs for HTTP response codes
- Update to your real endpoint URL when ready

### Driver not found
- Install appropriate ODBC driver (see [Driver Installation](#driver-installation))
- Update `DB_DRIVER` in `.env` to match installed driver name
- List installed drivers: `odbcinst -q -d`

## Next Steps

1. ✅ Dependencies installed
2. ✅ `.env` configured with database credentials
3. ✅ Test script runs successfully
4. ✅ Logs and exports are created
5. → Customize for your use cases
6. → Set up cron schedules
7. → Update endpoints when ready for production

## Security Notes

- Never commit `.env` to version control (it's in `.gitignore`)
- Restrict `.env` permissions: `chmod 600 .env`
- Use strong database passwords
- For production: Consider using cloud secret management (Google Secret Manager, AWS Secrets Manager, etc.)
