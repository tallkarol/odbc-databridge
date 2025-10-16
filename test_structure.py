"""
Simple test script to verify the module structure and imports work correctly.
This doesn't test actual database connections but validates the code structure.

Note: pyodbc must be installed for full functionality (pip install -r requirements.txt)
"""

import sys
import os

print("Testing module structure and imports...")
print("="*50)

# Test that files exist and are valid Python
print("\nChecking file structure...")
required_files = [
    'connectors/__init__.py',
    'connectors/odbc_connector.py',
    'connectors/logger_utils.py',
    'connectors/config_loader.py',
    'services/__init__.py',
    'services/birdeye_export.py',
    'services/example_service.py',
    '.env.example',
    'requirements.txt'
]

for file_path in required_files:
    if os.path.exists(file_path):
        print(f"✓ {file_path} exists")
        # Test if it's valid Python
        if file_path.endswith('.py'):
            try:
                with open(file_path, 'r') as f:
                    compile(f.read(), file_path, 'exec')
                print(f"  ✓ Valid Python syntax")
            except SyntaxError as e:
                print(f"  ✗ Syntax error: {e}")
                sys.exit(1)
    else:
        print(f"✗ {file_path} missing")
        sys.exit(1)

# Test logger utils (doesn't require pyodbc)
print("\nTesting logger utility...")
try:
    from connectors.logger_utils import setup_logger
    print("✓ setup_logger imported successfully")
    
    # Test logger setup
    logger = setup_logger('test_script', log_dir='/tmp/test_logs')
    logger.info("Test log message")
    print("✓ Logger created and working")
except Exception as e:
    print(f"✗ Logger test failed: {e}")
    sys.exit(1)

# Test imports (may fail without pyodbc, which is ok for structure test)
print("\nTesting ODBC connector import...")
try:
    from connectors.odbc_connector import ODBCConnector
    print("✓ ODBCConnector imported successfully (pyodbc is available)")
    
    # Test connector initialization
    connector = ODBCConnector(
        driver='Test Driver',
        server='test-server',
        database='test-db',
        username='test-user',
        password='test-pass'
    )
    print("✓ ODBCConnector initialized successfully")
    
    # Test connection string building
    conn_str = connector._build_connection_string()
    if 'DRIVER={Test Driver}' in conn_str and 'SERVER=test-server' in conn_str:
        print("✓ Connection string built correctly")
    else:
        print(f"✗ Connection string incorrect: {conn_str}")
        sys.exit(1)
    
    # Test context manager methods
    if hasattr(connector, '__enter__') and hasattr(connector, '__exit__'):
        print("✓ Context manager methods available")
    else:
        print("✗ Context manager methods missing")
        sys.exit(1)
        
except ImportError as e:
    print(f"⚠ pyodbc not installed (expected if dependencies not installed yet)")
    print(f"  Run: pip install -r requirements.txt")
except Exception as e:
    print(f"✗ Connector test failed: {e}")
    sys.exit(1)

print("\n" + "="*50)
print("Structure validation complete! ✓")
print("="*50)
print("\nNext steps:")
print("1. Install dependencies: pip install -r requirements.txt")
print("2. Copy .env.example to .env and update credentials")
print("3. Run a service script: python services/birdeye_export.py")

