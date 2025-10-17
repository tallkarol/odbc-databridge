"""
Reusable ODBC Database Connector

This module provides a simple and reusable connection handler for ODBC databases.
Can be imported and used across multiple service scripts.
"""

import pyodbc
import logging
from typing import Optional, List, Dict, Any


class ODBCConnector:
    """
    A reusable ODBC connector for data warehouse connections.
    
    Usage:
        from connectors.odbc_connector import ODBCConnector
        
        connector = ODBCConnector(
            driver='ODBC Driver 17 for SQL Server',
            server='your-server.database.windows.net',
            database='your-database',
            username='your-username',
            password='your-password'
        )
        
        # Use as context manager (recommended)
        with connector:
            data = connector.execute_query("SELECT * FROM table")
            
        # Or manage connection manually
        connector.connect()
        data = connector.execute_query("SELECT * FROM table")
        connector.close()
    """
    
    def __init__(self, driver: str, server: str, database: str, 
                 username: str, password: str, port: Optional[int] = None):
        """
        Initialize the ODBC connector with connection parameters.
        
        Args:
            driver: ODBC driver name (e.g., 'ODBC Driver 17 for SQL Server')
            server: Database server address
            database: Database name
            username: Database username
            password: Database password
            port: Optional port number
        """
        self.driver = driver
        self.server = server
        self.database = database
        self.username = username
        self.password = password
        self.port = port
        self.connection = None
        
    def _build_connection_string(self) -> str:
        """Build the ODBC connection string from parameters."""
        conn_str = f"DRIVER={{{self.driver}}};SERVER={self.server}"
        
        # Add port if specified - use ;PORT= format for MariaDB/MySQL, not comma
        if self.port:
            conn_str += f";PORT={self.port}"
            
        conn_str += (
            f";DATABASE={self.database};"
            f"UID={self.username};"
            f"PWD={self.password}"
        )
        
        return conn_str
    
    def connect(self) -> pyodbc.Connection:
        """
        Connect to the database.
        
        Returns:
            pyodbc.Connection: Active database connection
            
        Raises:
            pyodbc.Error: If connection fails
        """
        try:
            connection_string = self._build_connection_string()
            # Log connection string without password for debugging
            safe_conn_str = connection_string.replace(f"PWD={self.password}", "PWD=***")
            logging.info(f"Attempting to connect with connection string: {safe_conn_str}")
            
            self.connection = pyodbc.connect(connection_string)
            logging.info("Successfully connected to database")
            return self.connection
        except pyodbc.Error as e:
            logging.error(f"Failed to connect to database: {e}")
            raise
    
    def get_connection(self) -> pyodbc.Connection:
        """
        Get a connection to the database (alias for connect()).
        
        Returns:
            pyodbc.Connection: Active database connection
            
        Raises:
            pyodbc.Error: If connection fails
        """
        return self.connect()
    
    def __enter__(self):
        """Context manager entry - establishes database connection."""
        self.connect()
        return self
    
    def __exit__(self, exc_type, exc_val, exc_tb):
        """Context manager exit - closes database connection."""
        self.close()
        return False
    
    def execute_query(self, query: str, params: Optional[tuple] = None) -> List[Dict[str, Any]]:
        """
        Execute a SELECT query and return results as a list of dictionaries.
        
        Args:
            query: SQL query string
            params: Optional tuple of query parameters
            
        Returns:
            List of dictionaries with column names as keys
        """
        if not self.connection:
            raise RuntimeError("No active connection. Use context manager (with statement) or call connect() first.")
        
        try:
            cursor = self.connection.cursor()
            
            if params:
                cursor.execute(query, params)
            else:
                cursor.execute(query)
            
            columns = [column[0] for column in cursor.description]
            results = []
            
            for row in cursor.fetchall():
                results.append(dict(zip(columns, row)))
            
            logging.info(f"Query executed successfully, returned {len(results)} rows")
            return results
            
        except pyodbc.Error as e:
            logging.error(f"Query execution failed: {e}")
            raise
    
    def execute_non_query(self, query: str, params: Optional[tuple] = None) -> int:
        """
        Execute an INSERT, UPDATE, or DELETE query.
        
        Args:
            query: SQL query string
            params: Optional tuple of query parameters
            
        Returns:
            Number of rows affected
        """
        if not self.connection:
            raise RuntimeError("No active connection. Use context manager (with statement) or call connect() first.")
        
        try:
            cursor = self.connection.cursor()
            
            if params:
                cursor.execute(query, params)
            else:
                cursor.execute(query)
            
            self.connection.commit()
            rows_affected = cursor.rowcount
            
            logging.info(f"Non-query executed successfully, {rows_affected} rows affected")
            return rows_affected
            
        except pyodbc.Error as e:
            self.connection.rollback()
            logging.error(f"Non-query execution failed: {e}")
            raise
    
    def close(self):
        """Close the database connection."""
        if self.connection:
            self.connection.close()
            self.connection = None
            logging.info("Database connection closed")
