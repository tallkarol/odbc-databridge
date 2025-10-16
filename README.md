# odbc-databridge

A Google Cloud hosted repository of use-case specific Python scripts for implementation alongside an ODBC connection to a data warehouse. Scripts access a SQL database and process data for export/integration with other services.

## Features

- **Reusable ODBC Connector**: A simple connector module that can be imported across multiple service scripts
- **Service-Specific Scripts**: Single-destination scripts for each integration (e.g., Birdeye)
- **File-Based Logging**: All operations logged to text files in the `logs/` directory
- **Cron-Ready**: Designed to run on scheduled intervals via cron jobs
- **Simple & Expandable**: Minimal structure that's easy to understand and extend
- **Flexible Configuration**: Environment-based configuration using `.env` files
- **API Integration**: Built-in support for sending data to external endpoints (e.g., Zapier webhooks)

## Key Libraries

- **pyodbc**: ODBC database connectivity (supports Microsoft SQL Server, Simba drivers, and other ODBC-compatible databases)
- **pandas**: Data manipulation and analysis (available for advanced data processing)
- **sqlalchemy**: SQL toolkit and ORM (available for alternative database connectivity)
- **python-dotenv**: Environment variable management from `.env` files
- **requests**: HTTP library for API integrations

## Project Structure

```
odbc-databridge/
├── connectors/
│   ├── __init__.py
│   ├── odbc_connector.py      # Reusable ODBC connection handler
│   └── logger_utils.py         # Logging utilities
├── services/
│   ├── __init__.py
│   └── birdeye_export.py       # Example service script
├── logs/                        # Log files (excluded from git)
├── config.example.py            # Configuration template
├── requirements.txt             # Python dependencies
└── README.md
```

## Setup

### 1. Install Dependencies

```bash
pip install -r requirements.txt
```

### 2. Configure Database Connection and API Endpoints

Copy the example environment file and update with your credentials:

```bash
cp .env.example .env
```

Edit `.env` with your database details and API endpoints:

```bash
# Database Configuration
DB_DRIVER=ODBC Driver 17 for SQL Server
DB_SERVER=your-server.database.windows.net
DB_DATABASE=your-database-name
DB_USERNAME=your-username
DB_PASSWORD=your-password
DB_PORT=

# API Endpoints
BIRDEYE_ENDPOINT=https://hooks.zapier.com/hooks/catch/23151206/umyaaov/
EXAMPLE_SERVICE_ENDPOINT=https://hooks.zapier.com/hooks/catch/23151206/umyaaov/

# Logging Configuration
LOG_DIR=logs
LOG_LEVEL=INFO
```

**Note:** For backward compatibility, `config.py` files are still supported but `.env` files are now the preferred method.

### 3. Run a Service Script

```bash
python services/birdeye_export.py
```

## Creating New Service Scripts

To create a new service integration, copy the example pattern:

```python
import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from connectors.odbc_connector import ODBCConnector
from connectors.logger_utils import setup_logger
from connectors.config_loader import get_db_config, get_endpoint
import requests

def main():
    logger = setup_logger('your_service_name')
    logger.info("Starting export process")
    
    DB_CONFIG = get_db_config()
    connector = ODBCConnector(**DB_CONFIG)
    
    with connector:
        data = connector.execute_query("YOUR SQL QUERY")
        # Process and export data
        
        # Send to endpoint
        endpoint = get_endpoint('your_service_name')
        response = requests.post(endpoint, json={'data': data})
    
    logger.info("Export completed")

if __name__ == "__main__":
    main()
```

## Using the ODBC Connector

The connector is reusable across all scripts and supports context manager pattern:

```python
from connectors.odbc_connector import ODBCConnector

# Initialize
connector = ODBCConnector(
    driver='ODBC Driver 17 for SQL Server',
    server='your-server.database.windows.net',
    database='your-database',
    username='your-username',
    password='your-password'
)

# Use with context manager (recommended - auto closes connection)
with connector:
    # Execute SELECT queries
    results = connector.execute_query("SELECT * FROM table WHERE id = ?", (123,))
    
    # Execute INSERT/UPDATE/DELETE
    rows_affected = connector.execute_non_query("UPDATE table SET status = ? WHERE id = ?", ('active', 123))

# Or manage connection manually
connector.connect()
data = connector.execute_query("SELECT * FROM table")
connector.close()
```

## Scheduling with Cron

Add entries to your crontab to run scripts on a schedule:

```bash
# Edit crontab
crontab -e
```

Example cron schedules:

```bash
# Run Birdeye export daily at 2 AM
0 2 * * * cd /path/to/odbc-databridge && /usr/bin/python3 services/birdeye_export.py

# Run every hour
0 * * * * cd /path/to/odbc-databridge && /usr/bin/python3 services/your_script.py

# Run every 15 minutes
*/15 * * * * cd /path/to/odbc-databridge && /usr/bin/python3 services/your_script.py

# Run Monday-Friday at 9 AM
0 9 * * 1-5 cd /path/to/odbc-databridge && /usr/bin/python3 services/your_script.py
```

## Logging

All scripts automatically log to text files in the `logs/` directory:
- Log files are named: `{script_name}_{date}.log`
- Logs include timestamps, log levels, and messages
- Both file and console output are provided

Example log entry:
```
2025-10-16 14:30:00 - birdeye_export - INFO - Starting Birdeye export process
2025-10-16 14:30:01 - birdeye_export - INFO - Connected to database successfully
2025-10-16 14:30:05 - birdeye_export - INFO - Retrieved 150 records from database
```

## ODBC Driver Installation

Ensure you have the appropriate ODBC driver installed for your database:

### SQL Server (Linux)
```bash
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list | sudo tee /etc/apt/sources.list.d/mssql-release.list
sudo apt-get update
sudo ACCEPT_EULA=Y apt-get install -y msodbcsql17
```

### Other Databases
- PostgreSQL: `sudo apt-get install odbc-postgresql`
- MySQL: `sudo apt-get install libmyodbc`

## Security Notes

- Never commit `.env` or `config.py` to version control (they're in `.gitignore`)
- `.env` files are the preferred way to manage configuration
- Restrict file permissions on `.env`: `chmod 600 .env`
- For production, consider using secure secret management services (AWS Secrets Manager, Azure Key Vault, etc.)

## License

This project is provided as-is for internal use.
