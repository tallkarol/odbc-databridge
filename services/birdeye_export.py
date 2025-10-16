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
from connectors.config_loader import get_db_config, get_endpoint
import json
import requests


def export_to_birdeye(data, logger, output_path='exports/birdeye_export.json'):
    """
    Export data in a format suitable for Birdeye integration.
    Sends data to Zapier mock endpoint and saves locally.
    
    Args:
        data: List of dictionaries containing the data to export
        logger: Logger instance for logging
        output_path: Path to save the exported file
    """
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    
    # Save data locally
    with open(output_path, 'w') as f:
        json.dump(data, f, indent=2, default=str)
    
    # Send data to Zapier endpoint
    try:
        endpoint = get_endpoint('birdeye')
        logger.info(f"Sending data to Birdeye endpoint: {endpoint}")
        
        response = requests.post(
            endpoint,
            json={'data': data, 'service': 'birdeye', 'record_count': len(data)},
            headers={'Content-Type': 'application/json'},
            timeout=30
        )
        
        response.raise_for_status()
        logger.info(f"Successfully sent data to Birdeye endpoint. Status: {response.status_code}")
        
    except Exception as e:
        logger.error(f"Failed to send data to Birdeye endpoint: {e}")
        # Don't raise - allow local export to succeed even if webhook fails
    
    return output_path


def main():
    """Main execution function for Birdeye export."""
    # Set up logging
    logger = setup_logger('birdeye_export')
    
    logger.info("Starting Birdeye export process")
    
    try:
        # Load configuration from .env file
        logger.info("Loading configuration")
        DB_CONFIG = get_db_config()
        
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
        
        # Connect to database using context manager
        with connector:
            logger.info("Connected to database successfully")
            
            # Query customer journey data for BirdEye review requests
            # Focus on completed jobs for review solicitation
            query = """
                SELECT 
                    id,
                    brand_name,
                    customer_name,
                    email,
                    phone,
                    address,
                    city,
                    state,
                    zip,
                    service_type,
                    job_completed_date,
                    actual_value,
                    notes
                FROM customer_journey
                WHERE journey_stage = 'Job Completed'
                    AND active = 1
                    AND job_completed_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAYS)
                ORDER BY job_completed_date DESC
            """
            
            # Execute query
            logger.info("Executing data query")
            data = connector.execute_query(query)
            logger.info(f"Retrieved {len(data)} records from database")
            
            # Export data for Birdeye
            logger.info("Exporting data for Birdeye")
            output_file = export_to_birdeye(data, logger)
            logger.info(f"Data exported successfully to {output_file}")
        
        # Connection automatically closed by context manager
        logger.info("Birdeye export completed successfully")
        
    except Exception as e:
        logger.error(f"Error during Birdeye export: {e}", exc_info=True)
        sys.exit(1)


if __name__ == "__main__":
    main()
