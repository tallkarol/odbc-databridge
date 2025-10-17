"""
Unit tests for the Birdeye export endpoint.
Tests JSON parsing with various request formats.
"""

import sys
import os

# Add parent directory to path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from api import app
import unittest


class TestBirdeyeEndpoint(unittest.TestCase):
    """Test cases for the /api/birdeye/export endpoint JSON parsing."""
    
    def setUp(self):
        """Set up test client."""
        self.app = app
        self.client = self.app.test_client()
        self.app.config['TESTING'] = True
    
    def test_health_check(self):
        """Test health check endpoint."""
        response = self.client.get('/')
        self.assertEqual(response.status_code, 200)
        data = response.get_json()
        self.assertEqual(data['status'], 'healthy')
    
    def test_birdeye_export_empty_body_with_json_content_type(self):
        """
        Test POST with Content-Type: application/json but empty body.
        This is the issue reported - should not return 400 error.
        """
        response = self.client.post(
            '/api/birdeye/export',
            headers={'Content-Type': 'application/json'},
            data=''
        )
        # Should not return 400 Bad Request
        # Will return 500 if database is not configured, but that's expected
        self.assertNotEqual(response.status_code, 400)
        data = response.get_json()
        # Should have valid JSON response
        self.assertIsNotNone(data)
        self.assertIn('status', data)
    
    def test_birdeye_export_with_valid_json(self):
        """Test POST with valid JSON body."""
        response = self.client.post(
            '/api/birdeye/export',
            headers={'Content-Type': 'application/json'},
            json={'brand_name': 'TestBrand'}
        )
        # Should not return 400 Bad Request
        self.assertNotEqual(response.status_code, 400)
        data = response.get_json()
        self.assertIsNotNone(data)
        self.assertIn('status', data)
    
    def test_birdeye_export_without_content_type(self):
        """Test POST without Content-Type header."""
        response = self.client.post('/api/birdeye/export')
        # Should not return 400 Bad Request
        self.assertNotEqual(response.status_code, 400)
        data = response.get_json()
        self.assertIsNotNone(data)
        self.assertIn('status', data)
    
    def test_birdeye_export_with_invalid_json(self):
        """Test POST with invalid JSON in body."""
        response = self.client.post(
            '/api/birdeye/export',
            headers={'Content-Type': 'application/json'},
            data='invalid json'
        )
        # Should not return 400 Bad Request due to JSON parsing
        # Will return 500 if database is not configured, but that's expected
        self.assertNotEqual(response.status_code, 400)
        data = response.get_json()
        self.assertIsNotNone(data)
        self.assertIn('status', data)


if __name__ == '__main__':
    print("Testing Birdeye endpoint JSON handling...")
    print("=" * 60)
    
    # Run tests
    suite = unittest.TestLoader().loadTestsFromTestCase(TestBirdeyeEndpoint)
    runner = unittest.TextTestRunner(verbosity=2)
    result = runner.run(suite)
    
    print("\n" + "=" * 60)
    if result.wasSuccessful():
        print("All tests passed! ✓")
        print("=" * 60)
        sys.exit(0)
    else:
        print("Some tests failed! ✗")
        print("=" * 60)
        sys.exit(1)
