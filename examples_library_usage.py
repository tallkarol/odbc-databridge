"""
Examples of how to use different libraries in this project

This file demonstrates how to use:
- pyodbc with ODBCConnector
- pandas for data manipulation
- sqlalchemy for alternative database connectivity
- requests for API calls
"""

import sys
import os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from connectors.odbc_connector import ODBCConnector
from connectors.config_loader import get_db_config, get_endpoint
from connectors.logger_utils import setup_logger
import pandas as pd
import sqlalchemy
import requests


def example_1_basic_pyodbc_usage():
    """
    Example 1: Basic pyodbc usage with ODBCConnector
    This is the standard way to query the database.
    """
    logger = setup_logger('example_pyodbc')
    logger.info("Example 1: Basic pyodbc usage")
    
    DB_CONFIG = get_db_config()
    connector = ODBCConnector(**DB_CONFIG)
    
    with connector:
        # Query returns list of dictionaries
        data = connector.execute_query("SELECT TOP 10 * FROM your_table")
        logger.info(f"Retrieved {len(data)} rows")
        return data


def example_2_pandas_from_odbc():
    """
    Example 2: Using pandas with pyodbc connection
    Convert query results to pandas DataFrame for data manipulation.
    """
    logger = setup_logger('example_pandas')
    logger.info("Example 2: Using pandas with ODBC")
    
    DB_CONFIG = get_db_config()
    connector = ODBCConnector(**DB_CONFIG)
    
    with connector:
        # Get raw data
        data = connector.execute_query("SELECT * FROM your_table")
        
        # Convert to pandas DataFrame
        df = pd.DataFrame(data)
        
        # Now you can use pandas operations
        logger.info(f"DataFrame shape: {df.shape}")
        logger.info(f"Columns: {df.columns.tolist()}")
        
        # Example: filter and aggregate
        # filtered = df[df['status'] == 'active']
        # summary = df.groupby('category')['amount'].sum()
        
        return df


def example_3_sqlalchemy_connection():
    """
    Example 3: Using SQLAlchemy for database connectivity
    SQLAlchemy provides an ORM and more advanced database abstraction.
    """
    logger = setup_logger('example_sqlalchemy')
    logger.info("Example 3: Using SQLAlchemy")
    
    # Get config
    DB_CONFIG = get_db_config()
    
    # Build SQLAlchemy connection string
    # Format: mssql+pyodbc://user:pass@server/database?driver=ODBC+Driver+17+for+SQL+Server
    driver = DB_CONFIG['driver'].replace(' ', '+')
    connection_string = (
        f"mssql+pyodbc://{DB_CONFIG['username']}:{DB_CONFIG['password']}"
        f"@{DB_CONFIG['server']}/{DB_CONFIG['database']}?driver={driver}"
    )
    
    # Create engine
    engine = sqlalchemy.create_engine(connection_string)
    
    # Option A: Use pandas with SQLAlchemy
    # df = pd.read_sql("SELECT * FROM your_table", engine)
    
    # Option B: Use raw SQLAlchemy
    with engine.connect() as connection:
        result = connection.execute(sqlalchemy.text("SELECT TOP 10 * FROM your_table"))
        data = [dict(row) for row in result]
        logger.info(f"Retrieved {len(data)} rows using SQLAlchemy")
        return data


def example_4_pandas_read_sql():
    """
    Example 4: Using pandas read_sql with pyodbc
    Directly read SQL query results into a DataFrame.
    """
    logger = setup_logger('example_pandas_sql')
    logger.info("Example 4: Using pandas read_sql")
    
    DB_CONFIG = get_db_config()
    connector = ODBCConnector(**DB_CONFIG)
    
    with connector:
        # Use pandas to read SQL directly
        query = "SELECT * FROM your_table WHERE status = ?"
        df = pd.read_sql(query, connector.connection, params=('active',))
        
        logger.info(f"Retrieved DataFrame with shape: {df.shape}")
        return df


def example_5_send_to_api():
    """
    Example 5: Sending data to external API endpoint
    Uses requests library to POST data to a webhook.
    """
    logger = setup_logger('example_api')
    logger.info("Example 5: Sending data to API")
    
    # Get sample data
    DB_CONFIG = get_db_config()
    connector = ODBCConnector(**DB_CONFIG)
    
    with connector:
        data = connector.execute_query("SELECT TOP 5 * FROM your_table")
        
        # Get endpoint URL
        endpoint = get_endpoint('example_service')
        
        # Prepare payload
        payload = {
            'timestamp': pd.Timestamp.now().isoformat(),
            'record_count': len(data),
            'data': data
        }
        
        # Send to API
        logger.info(f"Sending data to {endpoint}")
        response = requests.post(
            endpoint,
            json=payload,
            headers={'Content-Type': 'application/json'},
            timeout=30
        )
        
        logger.info(f"API response status: {response.status_code}")
        return response


def example_6_pandas_data_processing():
    """
    Example 6: Advanced data processing with pandas
    Shows common pandas operations for data transformation.
    """
    logger = setup_logger('example_pandas_processing')
    logger.info("Example 6: Advanced pandas data processing")
    
    DB_CONFIG = get_db_config()
    connector = ODBCConnector(**DB_CONFIG)
    
    with connector:
        data = connector.execute_query("SELECT * FROM your_table")
        df = pd.DataFrame(data)
        
        # Example transformations
        # 1. Filter data
        # filtered = df[df['amount'] > 100]
        
        # 2. Add calculated column
        # df['amount_with_tax'] = df['amount'] * 1.1
        
        # 3. Group and aggregate
        # summary = df.groupby('category').agg({
        #     'amount': ['sum', 'mean', 'count'],
        #     'customer_id': 'nunique'
        # })
        
        # 4. Sort
        # sorted_df = df.sort_values('amount', ascending=False)
        
        # 5. Pivot
        # pivot = df.pivot_table(
        #     values='amount',
        #     index='category',
        #     columns='status',
        #     aggfunc='sum'
        # )
        
        logger.info("Data processing complete")
        return df


if __name__ == "__main__":
    print("=" * 60)
    print("Library Usage Examples for ODBC DataBridge")
    print("=" * 60)
    print()
    print("This file contains examples of using:")
    print("  1. pyodbc with ODBCConnector (basic usage)")
    print("  2. pandas with ODBC data")
    print("  3. SQLAlchemy for advanced database operations")
    print("  4. pandas read_sql for direct SQL to DataFrame")
    print("  5. requests for API integration")
    print("  6. pandas for data transformation")
    print()
    print("To use these examples:")
    print("  1. Configure your .env file with database credentials")
    print("  2. Update the SQL queries with your actual table names")
    print("  3. Uncomment and run the specific example functions")
    print()
    print("=" * 60)
