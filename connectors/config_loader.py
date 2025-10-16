"""
Configuration loader for ODBC Data Bridge

Loads configuration from .env file using python-dotenv.
Falls back to config.py for backward compatibility.
"""

import os
from dotenv import load_dotenv
from typing import Dict, Optional

# Load environment variables from .env file
load_dotenv()


def get_db_config() -> Dict[str, Optional[str]]:
    """
    Get database configuration from environment variables or config.py.
    
    Priority:
    1. Environment variables (.env file)
    2. config.py file (for backward compatibility)
    
    Returns:
        Dictionary with database configuration
    """
    # Try to load from environment variables first
    if os.getenv('DB_SERVER'):
        config = {
            'driver': os.getenv('DB_DRIVER', 'ODBC Driver 17 for SQL Server'),
            'server': os.getenv('DB_SERVER'),
            'database': os.getenv('DB_DATABASE'),
            'username': os.getenv('DB_USERNAME'),
            'password': os.getenv('DB_PASSWORD'),
            'port': int(os.getenv('DB_PORT')) if os.getenv('DB_PORT') else None
        }
        return config
    
    # Fall back to config.py for backward compatibility
    try:
        from config import DB_CONFIG
        return DB_CONFIG
    except ImportError:
        raise RuntimeError(
            "No configuration found. Please create a .env file from .env.example "
            "or create config.py from config.example.py"
        )


def get_endpoint(service_name: str) -> str:
    """
    Get API endpoint for a specific service.
    
    Args:
        service_name: Name of the service (e.g., 'birdeye', 'example_service')
        
    Returns:
        API endpoint URL
    """
    env_var = f"{service_name.upper()}_ENDPOINT"
    endpoint = os.getenv(env_var)
    
    if not endpoint:
        raise RuntimeError(
            f"No endpoint configured for {service_name}. "
            f"Please set {env_var} in your .env file"
        )
    
    return endpoint


def get_log_config() -> Dict[str, str]:
    """
    Get logging configuration from environment variables.
    
    Returns:
        Dictionary with log directory and level
    """
    return {
        'log_dir': os.getenv('LOG_DIR', 'logs'),
        'log_level': os.getenv('LOG_LEVEL', 'INFO')
    }
