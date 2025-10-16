"""
Simple test script to verify the API server works.
Tests the health check endpoint.
"""

import sys
import os
import time
import requests
from multiprocessing import Process

# Add parent directory to path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

def start_api_server():
    """Start the API server in a subprocess."""
    from api import app
    app.run(host='0.0.0.0', port=8080, debug=False, use_reloader=False)

def test_api():
    """Test the API endpoints."""
    print("Testing API Server...")
    print("=" * 50)
    
    # Start API server in background
    print("\nStarting API server...")
    server_process = Process(target=start_api_server)
    server_process.start()
    
    # Wait for server to start
    time.sleep(3)
    
    try:
        # Test health check endpoint
        print("\nTesting health check endpoint...")
        response = requests.get('http://localhost:8080/')
        
        if response.status_code == 200:
            print("✓ Health check endpoint working")
            print(f"  Response: {response.json()}")
        else:
            print(f"✗ Health check failed with status {response.status_code}")
            return False
        
        print("\n" + "=" * 50)
        print("API tests completed successfully! ✓")
        print("=" * 50)
        return True
        
    except Exception as e:
        print(f"✗ Test failed: {e}")
        return False
        
    finally:
        # Stop server
        server_process.terminate()
        server_process.join()
        print("\nAPI server stopped")

if __name__ == "__main__":
    success = test_api()
    sys.exit(0 if success else 1)
