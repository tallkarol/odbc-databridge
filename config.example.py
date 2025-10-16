"""
Configuration file example for ODBC Data Bridge

Copy this file to config.py and update with your actual database credentials.
"""

# Database Configuration
DB_CONFIG = {
    'driver': 'ODBC Driver 17 for SQL Server',  # Or your specific ODBC driver
    'server': 'your-server.database.windows.net',
    'database': 'your-database-name',
    'username': 'your-username',
    'password': 'your-password',
    'port': None  # Optional, set if needed (e.g., 1433)
}

# Logging Configuration
LOG_DIR = 'logs'
LOG_LEVEL = 'INFO'  # DEBUG, INFO, WARNING, ERROR, CRITICAL
