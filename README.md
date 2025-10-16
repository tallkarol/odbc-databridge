# odbc-databridge

A Google Cloud hosted repository of use-case specific Python scripts for implementation alongside an ODBC connection to a data warehouse. Scripts access a SQL database and process data for export/integration with other services.

## Features

- **Reusable ODBC Connector**: A simple connector module that can be imported across multiple service scripts
- **Service-Specific Scripts**: Single-destination scripts for each integration (e.g., Birdeye)
- **File-Based Logging**: All operations logged to text files in the `logs/` directory
- **Cron-Ready**: Designed to run on scheduled intervals via cron jobs
- **Simple & Expandable**: Minimal structure that's easy to understand and extend

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

### 2. Configure Database Connection

Copy the example configuration file and update with your credentials:

```bash
cp config.example.py config.py
```

Edit `config.py` with your database details:

```python
DB_CONFIG = {
    'driver': 'ODBC Driver 17 for SQL Server',
    'server': 'your-server.database.windows.net',
    'database': 'your-database-name',
    'username': 'your-username',
    'password': 'your-password',
    'port': None  # Optional
}
```

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
from config import DB_CONFIG

def main():
    logger = setup_logger('your_service_name')
    logger.info("Starting export process")
    
    connector = ODBCConnector(**DB_CONFIG)
    
    with connector.get_connection() as conn:
        data = connector.execute_query("YOUR SQL QUERY")
        # Process and export data
    
    connector.close()
    logger.info("Export completed")

if __name__ == "__main__":
    main()
```

## Using the ODBC Connector

The connector is reusable across all scripts:

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

# Use with context manager
with connector.get_connection() as conn:
    # Execute SELECT queries
    results = connector.execute_query("SELECT * FROM table WHERE id = ?", (123,))
    
    # Execute INSERT/UPDATE/DELETE
    rows_affected = connector.execute_non_query("UPDATE table SET status = ? WHERE id = ?", ('active', 123))

# Clean up
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

- Never commit `config.py` to version control (it's in `.gitignore`)
- Use environment variables or secure secret management for production
- Restrict file permissions on `config.py`: `chmod 600 config.py`

## License

This project is provided as-is for internal use.
