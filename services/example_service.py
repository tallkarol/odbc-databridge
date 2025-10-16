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


def process_data(data):
    """
    Process the data retrieved from the database.
    
    Args:
        data: List of dictionaries containing the query results
        
    Returns:
        Processed data ready for export
    """
    # Example processing: transform data as needed
    processed = []
    for row in data:
        processed.append({
            'id': row.get('id'),
            'name': row.get('name'),
            # Add your processing logic here
        })
    return processed


def export_data(data, output_path='exports/example_export.json'):
    """
    Export processed data to destination.
    
    Args:
        data: Processed data to export
        output_path: Path to save the export file
    """
    import json
    
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    
    with open(output_path, 'w') as f:
        json.dump(data, f, indent=2, default=str)
    
    return output_path


def main():
    """Main execution function."""
    # Set up logging with your service name
    logger = setup_logger('example_service')
    
    logger.info("Starting example service process")
    
    try:
        # Import configuration
        try:
            from config import DB_CONFIG
        except ImportError:
            logger.error("config.py not found. Please copy config.example.py to config.py and update with your credentials.")
            sys.exit(1)
        
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
        
        # Connect to database
        with connector.get_connection() as conn:
            logger.info("Connected to database successfully")
            
            # Define your SQL query
            query = """
                SELECT 
                    id,
                    name,
                    created_date
                FROM your_table
                WHERE status = ?
            """
            
            # Execute query with parameters
            logger.info("Executing data query")
            data = connector.execute_query(query, ('active',))
            logger.info(f"Retrieved {len(data)} records from database")
            
            # Process the data
            logger.info("Processing data")
            processed_data = process_data(data)
            
            # Export data
            logger.info("Exporting data")
            output_file = export_data(processed_data)
            logger.info(f"Data exported successfully to {output_file}")
            
        # Close connection
        connector.close()
        logger.info("Process completed successfully")
        
    except Exception as e:
        logger.error(f"Error during process: {e}", exc_info=True)
        sys.exit(1)


if __name__ == "__main__":
    main()
