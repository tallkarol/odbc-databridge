#!/usr/bin/env python3
"""Test database connection with current driver configuration."""
import sys
import os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from connectors.odbc_connector import ODBCConnector
from connectors.config_loader import get_db_config

def test_connection():
    print("=" * 50)
    print("Testing Database Connection")
    print("=" * 50)
    
    try:
        # Load config
        print("\n1. Loading configuration...")
        DB_CONFIG = get_db_config()
        print(f"   Driver: {DB_CONFIG['driver']}")
        print(f"   Server: {DB_CONFIG['server']}")
        print(f"   Database: {DB_CONFIG['database']}")
        print(f"   Port: {DB_CONFIG.get('port', 'default')}")
        
        # Test connection
        print("\n2. Connecting to database...")
        connector = ODBCConnector(
            driver=DB_CONFIG['driver'],
            server=DB_CONFIG['server'],
            database=DB_CONFIG['database'],
            username=DB_CONFIG['username'],
            password=DB_CONFIG['password'],
            port=DB_CONFIG.get('port')
        )
        
        with connector:
            print("   ✓ Connected successfully!")
            
            # Test query
            print("\n3. Testing query on databricks table...")
            result = connector.execute_query("SELECT COUNT(*) as count FROM databricks")
            row_count = result[0]['count']
            print(f"   ✓ Query successful: {row_count} rows in databricks table")
            
            # Test sample data
            print("\n4. Fetching sample record...")
            sample = connector.execute_query("SELECT * FROM databricks LIMIT 1")
            if sample:
                print(f"   ✓ Sample record retrieved")
                print(f"   - Customer: {sample[0].get('customer_name', 'N/A')}")
                print(f"   - Brand: {sample[0].get('brand', 'N/A')}")
            
        print("\n" + "=" * 50)
        print("✓ ALL TESTS PASSED!")
        print("=" * 50)
        return 0
        
    except Exception as e:
        print(f"\n{'='*50}")
        print("✗ TEST FAILED")
        print("="*50)
        print(f"\nError: {e}")
        print("\nTroubleshooting:")
        print("1. Check if driver name matches installed driver")
        print("2. Verify database credentials in .env file")
        print("3. Ensure database server is accessible")
        print("4. Check if databricks table exists")
        return 1

if __name__ == "__main__":
    sys.exit(test_connection())

