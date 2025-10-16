"""
Example Service Template

This is a template for creating new service integration scripts.
Copy this file and customize for your specific service integration needs.

Usage:
    python services/example_service.py
    
Cron example:
    # Run every hour
    0 * * * * cd /path/to/odbc-databridge && python services/example_service.py
"""

import sys
import os

# Add parent directory to path to import modules
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from connectors.odbc_connector import ODBCConnector
from connectors.logger_utils import setup_logger
from connectors.config_loader import get_db_config, get_endpoint
import requests


def process_data(data):
    """
    Process the data retrieved from the database.
    
    Args:
        data: List of dictionaries containing the query results
        
    Returns:
        Processed data ready for export
    """
    # Example processing: transform and enrich customer journey data
    processed = []
    for row in data:
        processed.append({
            'id': row.get('id'),
            'brand': row.get('brand_name'),
            'customer': row.get('customer_name'),
            'contact_email': row.get('email'),
            'contact_phone': row.get('phone'),
            'location': f"{row.get('city')}, {row.get('state')} {row.get('zip')}",
            'stage': row.get('journey_stage'),
            'service': row.get('service_type'),
            'lead_source': row.get('lead_source'),
            'value': float(row.get('estimated_value', 0)),
            'lead_date': str(row.get('lead_date'))
        })
    return processed


def export_data(data, logger, output_path='exports/example_export.json'):
    """
    Export processed data to destination.
    Sends data to Zapier mock endpoint and saves locally.
    
    Args:
        data: Processed data to export
        logger: Logger instance for logging
        output_path: Path to save the export file
    """
    import json
    
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    
    # Save data locally
    with open(output_path, 'w') as f:
        json.dump(data, f, indent=2, default=str)
    
    # Send data to endpoint
    try:
        endpoint = get_endpoint('example_service')
        logger.info(f"Sending data to endpoint: {endpoint}")
        
        response = requests.post(
            endpoint,
            json={'data': data, 'service': 'example_service', 'record_count': len(data)},
            headers={'Content-Type': 'application/json'},
            timeout=30
        )
        
        response.raise_for_status()
        logger.info(f"Successfully sent data to endpoint. Status: {response.status_code}")
        
    except Exception as e:
        logger.error(f"Failed to send data to endpoint: {e}")
        # Don't raise - allow local export to succeed even if webhook fails
    
    return output_path


def main():
    """Main execution function."""
    # Set up logging with your service name
    logger = setup_logger('example_service')
    
    logger.info("Starting example service process")
    
    try:
        # Load configuration from .env file
        logger.info("Loading configuration")
        DB_CONFIG = get_db_config()
        
        # Initialize connector with database configuration
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
            
            # Query customer journey data for all active leads
            # This demonstrates querying leads that need follow-up
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
                    journey_stage,
                    service_type,
                    lead_source,
                    estimated_value,
                    lead_date
                FROM customer_journey
                WHERE journey_stage IN ('Fresh Lead', 'Appointment Set')
                    AND active = 1
                ORDER BY lead_date DESC
            """
            
            # Execute query
            logger.info("Executing data query")
            data = connector.execute_query(query)
            logger.info(f"Retrieved {len(data)} records from database")
            
            # Process the data
            logger.info("Processing data")
            processed_data = process_data(data)
            
            # Export data
            logger.info("Exporting data")
            output_file = export_data(processed_data, logger)
            logger.info(f"Data exported successfully to {output_file}")
        
        # Connection automatically closed by context manager
        logger.info("Process completed successfully")
        
    except Exception as e:
        logger.error(f"Error during process: {e}", exc_info=True)
        sys.exit(1)


if __name__ == "__main__":
    main()
