# ODBC Databridge - Project Summary

## Overview
Simple, expandable Python-based ODBC databridge for Google Cloud hosting. Connects to data warehouses and processes data for service integrations.

## Directory Structure
```
odbc-databridge/
├── connectors/                 # Reusable connector modules
│   ├── __init__.py
│   ├── odbc_connector.py      # ODBC connection handler (context manager)
│   └── logger_utils.py        # Logging utilities
├── services/                   # Service-specific scripts
│   ├── __init__.py
│   ├── birdeye_export.py      # Example: Birdeye integration
│   └── example_service.py     # Template for new integrations
├── logs/                       # Log files (git-ignored)
│   └── .gitkeep
├── exports/                    # Export data files (git-ignored)
│   └── .gitkeep
├── .gitignore                  # Excludes logs, exports, config.py
├── config.example.py           # Configuration template
├── requirements.txt            # Python dependencies
├── test_structure.py           # Validation test script
├── README.md                   # Full documentation
├── QUICKSTART.md              # Quick setup guide
└── PROJECT_SUMMARY.md         # This file
```

## Key Components

### 1. ODBCConnector (`connectors/odbc_connector.py`)
Reusable database connector with:
- Context manager support for automatic connection management
- Query execution (`execute_query`)
- Non-query execution (`execute_non_query`)
- Proper error handling and logging
- Type hints and comprehensive docstrings

**Usage:**
```python
from connectors.odbc_connector import ODBCConnector

connector = ODBCConnector(**DB_CONFIG)
with connector:
    data = connector.execute_query("SELECT * FROM table")
```

### 2. Logger Utilities (`connectors/logger_utils.py`)
Centralized logging configuration:
- Logs to timestamped text files
- Console output for monitoring
- Configurable log levels
- Consistent formatting across all scripts

### 3. Service Scripts (`services/*.py`)
Single-destination integration scripts:
- Each script handles one service integration
- Follows consistent pattern
- Uses reusable connector
- Logs all operations
- Designed for cron scheduling

### 4. Configuration (`config.example.py`)
Template for database credentials:
- Separate from code (git-ignored)
- Simple dictionary structure
- Easy to customize per environment

## Features

✅ **Reusable Connector** - Import across all scripts
✅ **Context Manager** - Automatic connection cleanup
✅ **File Logging** - All operations logged to text files
✅ **Cron-Ready** - Designed for scheduled execution
✅ **Simple & Expandable** - Easy to add new integrations
✅ **Type Safe** - Type hints throughout
✅ **Well Documented** - README, QUICKSTART, and docstrings
✅ **Security Conscious** - Sensitive files git-ignored

## Quick Start

1. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

2. **Configure database:**
   ```bash
   cp config.example.py config.py
   # Edit config.py with your credentials
   ```

3. **Run validation test:**
   ```bash
   python test_structure.py
   ```

4. **Run a service script:**
   ```bash
   python services/birdeye_export.py
   ```

5. **Check logs:**
   ```bash
   cat logs/birdeye_export_*.log
   ```

## Adding New Integrations

1. Copy template: `cp services/example_service.py services/new_service.py`
2. Update logger name: `logger = setup_logger('new_service')`
3. Customize SQL query and processing logic
4. Run and test: `python services/new_service.py`
5. Add to crontab for scheduling

## Cron Scheduling Examples

```bash
# Daily at 2 AM
0 2 * * * cd /path/to/odbc-databridge && python services/birdeye_export.py

# Every hour
0 * * * * cd /path/to/odbc-databridge && python services/birdeye_export.py

# Every 15 minutes
*/15 * * * * cd /path/to/odbc-databridge && python services/birdeye_export.py

# Weekdays at 9 AM
0 9 * * 1-5 cd /path/to/odbc-databridge && python services/birdeye_export.py
```

## Dependencies

- `pyodbc>=4.0.39` - ODBC database connectivity
- `python-dotenv>=1.0.0` - Environment variable management
- Python 3.7+ - Core runtime

## Design Principles

1. **Simplicity** - No over-engineering, just what's needed
2. **Reusability** - DRY principle with shared connector
3. **Expandability** - Easy to add new service integrations
4. **Maintainability** - Clear structure and documentation
5. **Security** - Configuration separated from code
6. **Reliability** - Comprehensive logging and error handling

## Testing

Run the validation test to verify structure:
```bash
python test_structure.py
```

This checks:
- All required files exist
- Python syntax is valid
- Logger functionality works
- Context manager is properly implemented

## Documentation

- **README.md** - Comprehensive setup and usage guide
- **QUICKSTART.md** - Fast-track setup for new users
- **PROJECT_SUMMARY.md** - This overview document
- **Docstrings** - Inline documentation in all modules

## Support

For issues or questions:
1. Check the README.md troubleshooting section
2. Review logs in the `logs/` directory
3. Verify configuration in `config.py`
4. Run `python test_structure.py` to validate setup

---

**Status:** ✅ Complete and ready for use
**Last Updated:** 2025-10-16
