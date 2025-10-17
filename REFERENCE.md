# ODBC DataBridge - Reference Guide

Technical reference for maintaining code standards and understanding the project architecture.

## Project Purpose

Simple, expandable Python ODBC databridge for Google Cloud hosting. Connects to data warehouses (MySQL, SQL Server, etc.) via ODBC and processes data for service integrations. Designed to run on schedules (cron jobs) with minimal complexity.

## Design Principles

1. **Simple** - No over-engineering. Proof of concept that works.
2. **DRY** - Don't Repeat Yourself. Reusable connector module.
3. **Separated Concerns** - Clear separation: connectors/ for infrastructure, services/ for business logic.
4. **Secure** - Credentials in `.env`, never in code.
5. **Expandable** - Easy to add new service integrations by copying template.

## Directory Structure

```
odbc-databridge/
├── connectors/              # Reusable infrastructure modules
│   ├── __init__.py
│   ├── odbc_connector.py    # ODBC connection handler (context manager)
│   ├── logger_utils.py      # Centralized logging setup
│   └── config_loader.py     # Load config from .env files
├── services/                # Business logic - one file per integration
│   ├── __init__.py
│   ├── birdeye_export.py    # Birdeye integration (real use-case example)
│   └── example_service.py   # Clean template for new integrations
├── logs/                    # Log files (git-ignored)
├── exports/                 # Export data files (git-ignored)
├── .env.example             # Environment configuration template
├── .gitignore               # Excludes logs, exports, .env
├── requirements.txt         # Python dependencies
├── test_structure.py        # Validation script
├── SETUP.md                 # Setup guide (for users)
└── REFERENCE.md             # This file (for AI agents)
```

## Key Libraries and Their Use

### Core Libraries (Required)

1. **pyodbc (4.0.39+)** - ODBC database connectivity
   - Works with Simba drivers, Microsoft SQL Server drivers, MySQL drivers
   - Used via `ODBCConnector` wrapper in `connectors/odbc_connector.py`
   - Handles parameterized queries for security
   - Use: Primary database connectivity

2. **python-dotenv (1.0.0+)** - Environment variable management
   - Loads configuration from `.env` files
   - Used in `connectors/config_loader.py`
   - Use: Secure credential storage

3. **requests (2.31.0+)** - HTTP library
   - Makes POST requests to external APIs/webhooks
   - Currently configured for Zapier endpoints
   - Use: Send data to external services

### Optional Libraries (Available)

4. **pandas (2.0.0+)** - Data manipulation and analysis
   - Use when: Need to transform, aggregate, or analyze data
   - Example: Grouping, filtering, calculated columns
   - Can read directly from ODBC connection
   - Not required for simple pass-through scripts

5. **sqlalchemy (2.0.0+)** - SQL toolkit and ORM
   - Use when: Need ORM or database abstraction
   - Alternative to raw pyodbc for complex applications
   - Provides connection pooling
   - Not required for simple scripts

## Code Standards

### Service Script Pattern

All service scripts follow this pattern:

```python
"""
Service Name

Description of what this service does.

Usage: python services/service_name.py
"""

import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from connectors.odbc_connector import ODBCConnector
from connectors.logger_utils import setup_logger
from connectors.config_loader import get_db_config, get_endpoint
import requests

def main():
    logger = setup_logger('service_name')
    logger.info("Starting process")
    
    try:
        DB_CONFIG = get_db_config()
        connector = ODBCConnector(**DB_CONFIG)
        
        with connector:  # Always use context manager
            data = connector.execute_query("SELECT * FROM table")
            
            # Process and export
            endpoint = get_endpoint('service_name')
            response = requests.post(endpoint, json={'data': data})
            
        logger.info("Process completed")
    except Exception as e:
        logger.error(f"Error: {e}", exc_info=True)
        sys.exit(1)

if __name__ == "__main__":
    main()
```

### Key Patterns

1. **Always use context manager** for database connections:
   ```python
   with connector:
       data = connector.execute_query(query)
   ```

2. **Always use parameterized queries** to prevent SQL injection:
   ```python
   connector.execute_query("SELECT * FROM table WHERE id = ?", (user_id,))
   ```

3. **Always log important events**:
   ```python
   logger.info("Starting process")
   logger.error(f"Error: {e}", exc_info=True)
   ```

4. **Always handle errors gracefully**:
   ```python
   try:
       # operation
   except Exception as e:
       logger.error(f"Failed: {e}")
       sys.exit(1)
   ```

## Configuration

### .env File Structure

```bash
# Database - use Simba for ODBC connections
DB_DRIVER=MariaDB Unicode  # Or: Simba SQL Server ODBC Driver
DB_SERVER=your-server-address
DB_DATABASE=your-database-name
DB_USERNAME=your-username
DB_PASSWORD=your-password
DB_PORT=3306  # Optional, leave empty if not needed

# API Endpoints - Zapier webhook (easy to swap to another endpoint)
BIRDEYE_ENDPOINT=https://hooks.zapier.com/hooks/catch/23151206/umyaaov/
EXAMPLE_SERVICE_ENDPOINT=https://hooks.zapier.com/hooks/catch/23151206/umyaaov/

# Logging
LOG_DIR=logs
LOG_LEVEL=INFO
```

### Loading Configuration

```python
from connectors.config_loader import get_db_config, get_endpoint

DB_CONFIG = get_db_config()  # Returns dict with driver, server, database, etc.
endpoint = get_endpoint('service_name')  # Returns URL from {SERVICE_NAME}_ENDPOINT
```

## Module Reference

### connectors/odbc_connector.py

**ODBCConnector class** - Reusable database connector

Methods:
- `__init__(driver, server, database, username, password, port=None)` - Initialize
- `connect()` - Establish connection
- `execute_query(query, params=None)` - Execute SELECT, returns list of dicts
- `execute_non_query(query, params=None)` - Execute INSERT/UPDATE/DELETE, returns row count
- `close()` - Close connection
- Context manager support (`with` statement)

### connectors/logger_utils.py

**setup_logger(script_name)** - Create configured logger

- Creates logger with file and console handlers
- Logs to `logs/{script_name}_{date}.log`
- Returns logger instance

### connectors/config_loader.py

**get_db_config()** - Load database configuration from .env
- Returns dict: `{'driver': ..., 'server': ..., 'database': ..., 'username': ..., 'password': ..., 'port': ...}`

**get_endpoint(service_name)** - Load API endpoint from .env
- Returns URL string from `{SERVICE_NAME}_ENDPOINT`

## Commands for Common Tasks

### Development
```bash
# Install dependencies
pip install -r requirements.txt

# Validate structure
python test_structure.py

# Run a service
python services/birdeye_export.py
python services/example_service.py
```

### Monitoring
```bash
# View logs
cat logs/birdeye_export_*.log
tail -f logs/birdeye_export_*.log  # Live follow

# View exports
cat exports/birdeye_export.json
```

### Creating New Service
```bash
# Copy template
cp services/example_service.py services/new_service.py

# Edit the file:
# 1. Update logger name: setup_logger('new_service')
# 2. Update SQL query
# 3. Update endpoint reference: get_endpoint('new_service')
# 4. Add endpoint to .env: NEW_SERVICE_ENDPOINT=https://...

# Test
python services/new_service.py
```

### Scheduling
```bash
# Edit crontab
crontab -e

# Add schedule
0 2 * * * cd /path/to/odbc-databridge && python services/birdeye_export.py
```

## API Integration

### Current Setup
- Posts to Zapier webhook endpoints
- Configurable per service in `.env`
- Easy to swap to any other HTTP endpoint

### Changing Endpoint
1. Update `.env` with new URL
2. No code changes needed

### Payload Format
```json
{
  "data": [...],           // Query results
  "service": "service_name",
  "record_count": 123
}
```

## Service Scripts

### birdeye_export.py
- **Purpose:** Real use-case example proving the concept
- **What it does:** Queries customer data and exports to Birdeye service
- **Use as:** Reference for building real integrations
- **DO NOT:** Delete or heavily modify - it proves the use-case

### example_service.py
- **Purpose:** Clean scaffold for creating new services
- **What it does:** Template with placeholder query and processing
- **Use as:** Starting point - copy and customize for new integrations
- **DO NOT:** Add real business logic here - keep it generic

## Database Support

### Tested/Supported
- **Google Cloud MySQL** - Use MariaDB Unicode ODBC driver
- **Microsoft SQL Server** - Use Simba or Microsoft ODBC drivers
- Any ODBC-compatible database

### Driver Configuration
Specify driver name in `.env` `DB_DRIVER` field. Common options:
- `MariaDB Unicode`
- `Simba SQL Server ODBC Driver`
- `ODBC Driver 17 for SQL Server`
- `PostgreSQL Unicode`

## Testing

### Validation Script
`test_structure.py` checks:
- All required files exist
- Python syntax is valid
- Logger functionality works
- Imports work correctly

Run: `python test_structure.py`

### Manual Testing
1. Configure `.env` with test database
2. Update query in service script
3. Run service: `python services/birdeye_export.py`
4. Check logs: `cat logs/birdeye_export_*.log`
5. Verify exports: `cat exports/birdeye_export.json`

## Maintenance Guidelines for AI Agents

### When Adding New Features
1. Keep it simple - don't over-engineer
2. Maintain DRY - add to connectors/ if reusable
3. Maintain separation - services/ for business logic only
4. Update this file if adding new patterns
5. Test with `test_structure.py`

### When Modifying Existing Code
1. **birdeye_export.py** - Be careful, it proves the use-case
2. **example_service.py** - Keep it generic and clean
3. **connectors/** - These are reusable, changes affect all services
4. Always use context managers, parameterized queries, logging

### File Types to Never Commit
- `.env` (credentials)
- `logs/*.log` (log files)
- `exports/*` (export data)
- `__pycache__/` (Python cache)

### Code Style
- Use type hints in connectors/
- Comprehensive docstrings in connectors/
- Comments only when necessary in services/
- Follow existing patterns

## Dependencies

Defined in `requirements.txt`:
```
pyodbc>=4.0.39           # ODBC connectivity (works with Simba)
python-dotenv>=1.0.0     # Environment configuration
pandas>=2.0.0            # Data manipulation (optional use)
sqlalchemy>=2.0.0        # SQL toolkit (optional use)
requests>=2.31.0         # HTTP/API integration
```

Install: `pip install -r requirements.txt`

## Security

- Credentials in `.env` only, never in code
- `.env` is in `.gitignore`
- Parameterized queries prevent SQL injection
- Restrict `.env` permissions: `chmod 600 .env`
- For production: Use cloud secret management (Google Secret Manager)

## Project Status

✅ **Ready for use** - This is a working proof of concept
- Simba ODBC support: ✅ (via pyodbc)
- Pandas support: ✅ (available but optional)
- SQLAlchemy support: ✅ (available but optional)
- Secure credentials: ✅ (.env files)
- Zapier integration: ✅ (easy to swap endpoints)
- Real use-case: ✅ (birdeye_export.py)
- Clean template: ✅ (example_service.py)
- Simple & expandable: ✅

## Quick Reference for AI Agents

**Adding a new service integration:**
1. `cp services/example_service.py services/new_service.py`
2. Update logger name to `'new_service'`
3. Update SQL query for use case
4. Add `NEW_SERVICE_ENDPOINT` to `.env`
5. Update endpoint reference to `get_endpoint('new_service')`
6. Test with `python services/new_service.py`

**Current endpoint strategy:**
- All services post to Zapier webhook for now
- Easy to swap by changing URL in `.env`
- No code changes needed to change endpoints

**Library choices:**
- Use pyodbc (via ODBCConnector) for all ODBC connections
- Use Simba drivers when needed
- Pandas and SQLAlchemy available but optional
- Keep services simple unless complexity is needed
