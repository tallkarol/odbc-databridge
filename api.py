"""
Simple API Server for ODBC DataBridge

Provides HTTP endpoints to trigger data export scripts.
Designed for Google Cloud deployment (Cloud Run, App Engine, GCE).

Usage:
    # Development
    python api.py
    
    # Production (with gunicorn)
    gunicorn -w 4 -b 0.0.0.0:8080 api:app
"""

import sys
import os
from flask import Flask, request, jsonify

# Add parent directory to path to import modules
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from connectors.odbc_connector import ODBCConnector
from connectors.logger_utils import setup_logger
from connectors.config_loader import get_db_config, get_endpoint
from services.birdeye_export import export_to_birdeye
import json
import requests

app = Flask(__name__)
logger = setup_logger('api')


@app.route('/', methods=['GET'])
def health_check():
    """Health check endpoint."""
    return jsonify({
        'status': 'healthy',
        'service': 'odbc-databridge-api',
        'version': '1.0.0'
    }), 200


@app.route('/api/birdeye/export', methods=['POST'])
def trigger_birdeye_export():
    """
    Trigger the Birdeye export script.
    
    Optional JSON body:
    {
        "brand_name": "specific_brand"  # Optional: filter by brand
    }
    
    Returns:
        JSON response with export results
    """
    logger.info("Received request to trigger Birdeye export")
    
    try:
        # Get optional brand filter from request
        data = request.get_json(silent=True) or {}
        brand_filter = data.get('brand_name')
        
        if brand_filter:
            logger.info(f"Filtering by brand: {brand_filter}")
        
        # Load configuration
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
            
            # Simple test query - just get one record
            query = "SELECT * FROM databricks LIMIT 1"
            params = None
            
            # Execute query
            logger.info("Executing data query")
            if params:
                results = connector.execute_query(query, params)
            else:
                results = connector.execute_query(query)
            
            logger.info(f"Retrieved {len(results)} records from database")
            
            # Export data for Birdeye
            logger.info("Exporting data for Birdeye")
            output_file = export_to_birdeye(results, logger)
            logger.info(f"Data exported successfully to {output_file}")
        
        # Prepare response
        response = {
            'status': 'success',
            'message': 'Birdeye export completed successfully',
            'record_count': len(results),
            'output_file': output_file
        }
        
        if brand_filter:
            response['brand_filter'] = brand_filter
        
        logger.info("Birdeye export completed successfully")
        return jsonify(response), 200
        
    except Exception as e:
        logger.error(f"Error during Birdeye export: {e}", exc_info=True)
        return jsonify({
            'status': 'error',
            'message': str(e)
        }), 500


if __name__ == "__main__":
    # Development server
    port = int(os.environ.get('PORT', 8080))
    app.run(host='0.0.0.0', port=port, debug=False)
