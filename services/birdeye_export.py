"""
Birdeye Export Service

This script connects to the data warehouse, retrieves data, and exports it
for integration with Birdeye service. Single destination script.

Usage:
    python services/birdeye_export.py
    
Cron example:
    # Run every day at 2 AM
    0 2 * * * cd /path/to/odbc-databridge && python services/birdeye_export.py
"""

import sys
import os

# Add parent directory to path to import modules
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from connectors.odbc_connector import ODBCConnector
from connectors.logger_utils import setup_logger
import json


def export_to_birdeye(data, output_path='exports/birdeye_export.json'):
    """
    Export data in a format suitable for Birdeye integration.
    
    Args:
        data: List of dictionaries containing the data to export
        output_path: Path to save the exported file
    """
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    
    with open(output_path, 'w') as f:
        json.dump(data, f, indent=2, default=str)
    
    return output_path


def main():
    """Main execution function for Birdeye export."""
    # Set up logging
    logger = setup_logger('birdeye_export')
    
    logger.info("Starting Birdeye export process")
    
    try:
        # Import configuration
        try:
            from config import DB_CONFIG
        except ImportError:
            logger.error("config.py not found. Please copy config.example.py to config.py and update with your credentials.")
            sys.exit(1)
        
        # Initialize connector
        logger.info("Initializing database connector")
        connector = ODBCConnector(
            driver=DB_CONFIG['driver'],
            server=DB_CONFIG['server'],
            database=DB_CONFIG['database'],
            username=DB_CONFIG['username'],
            password=DB_CONFIG['password'],
            port=DB_CONFIG.get('port')
        )
        
        # Connect to database
        with connector.get_connection() as conn:
            logger.info("Connected to database successfully")
            
            # Example query - replace with your actual query
            query = """
                SELECT 
                    customer_id,
                    customer_name,
                    email,
                    phone,
                    last_interaction_date
                FROM customers
                WHERE active = 1
            """
            
            # Execute query
            logger.info("Executing data query")
            data = connector.execute_query(query)
            logger.info(f"Retrieved {len(data)} records from database")
            
            # Export data for Birdeye
            logger.info("Exporting data for Birdeye")
            output_file = export_to_birdeye(data)
            logger.info(f"Data exported successfully to {output_file}")
            
        # Close connection
        connector.close()
        logger.info("Birdeye export completed successfully")
        
    except Exception as e:
        logger.error(f"Error during Birdeye export: {e}", exc_info=True)
        sys.exit(1)


if __name__ == "__main__":
    main()
