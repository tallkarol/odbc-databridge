# Library Usage Guide

This guide explains the libraries available in the ODBC DataBridge project and how to use them.

## Available Libraries

### 1. pyodbc (ODBC Connectivity)

**Purpose:** Connect to databases using ODBC drivers, including Microsoft SQL Server and Simba drivers.

**Key Features:**
- Works with any ODBC-compatible driver (SQL Server, Simba, PostgreSQL, MySQL, etc.)
- Direct SQL execution
- Parameterized queries for security

**Usage:**
```python
from connectors.odbc_connector import ODBCConnector
from connectors.config_loader import get_db_config

DB_CONFIG = get_db_config()
connector = ODBCConnector(**DB_CONFIG)

with connector:
    data = connector.execute_query("SELECT * FROM table WHERE id = ?", (123,))
    # Returns list of dictionaries
```

**Simba Drivers:**
To use Simba ODBC drivers, simply specify the driver name in your `.env` file:
```bash
DB_DRIVER=Simba SQL Server ODBC Driver
```

### 2. pandas (Data Manipulation)

**Purpose:** Advanced data manipulation, transformation, and analysis.

**Key Features:**
- DataFrames for tabular data
- Powerful filtering, grouping, and aggregation
- Time series operations
- Data cleaning and transformation

**Usage:**
```python
import pandas as pd
from connectors.odbc_connector import ODBCConnector
from connectors.config_loader import get_db_config

DB_CONFIG = get_db_config()
connector = ODBCConnector(**DB_CONFIG)

with connector:
    # Method 1: Convert query results to DataFrame
    data = connector.execute_query("SELECT * FROM table")
    df = pd.DataFrame(data)
    
    # Method 2: Use pandas read_sql directly
    df = pd.read_sql("SELECT * FROM table", connector.connection)
    
    # Now use pandas operations
    filtered = df[df['amount'] > 100]
    summary = df.groupby('category')['amount'].sum()
    df['amount_with_tax'] = df['amount'] * 1.1
```

### 3. SQLAlchemy (ORM and Database Abstraction)

**Purpose:** Object-relational mapping and advanced database operations.

**Key Features:**
- ORM for working with database tables as Python objects
- Database abstraction layer
- Connection pooling
- Cross-database compatibility

**Usage:**
```python
import sqlalchemy
import pandas as pd
from connectors.config_loader import get_db_config

DB_CONFIG = get_db_config()

# Build connection string
driver = DB_CONFIG['driver'].replace(' ', '+')
connection_string = (
    f"mssql+pyodbc://{DB_CONFIG['username']}:{DB_CONFIG['password']}"
    f"@{DB_CONFIG['server']}/{DB_CONFIG['database']}?driver={driver}"
)

# Create engine
engine = sqlalchemy.create_engine(connection_string)

# Use with pandas
df = pd.read_sql("SELECT * FROM table", engine)

# Or use SQLAlchemy directly
with engine.connect() as connection:
    result = connection.execute(sqlalchemy.text("SELECT * FROM table"))
    data = [dict(row) for row in result]
```

### 4. python-dotenv (Environment Configuration)

**Purpose:** Load configuration from `.env` files.

**Key Features:**
- Secure credential management
- Environment-specific configuration
- No hardcoded secrets in code

**Usage:**
```python
from connectors.config_loader import get_db_config, get_endpoint

# Get database configuration
DB_CONFIG = get_db_config()

# Get service endpoint
endpoint = get_endpoint('birdeye')
```

**.env file format:**
```bash
DB_DRIVER=ODBC Driver 17 for SQL Server
DB_SERVER=your-server.database.windows.net
DB_DATABASE=your-database
DB_USERNAME=your-username
DB_PASSWORD=your-password
BIRDEYE_ENDPOINT=https://your-endpoint.com/webhook
```

### 5. requests (HTTP API Integration)

**Purpose:** Make HTTP requests to external APIs and webhooks.

**Key Features:**
- Simple HTTP operations (GET, POST, PUT, DELETE)
- JSON support
- Timeout handling
- Error handling

**Usage:**
```python
import requests
from connectors.config_loader import get_endpoint

endpoint = get_endpoint('birdeye')

# Send data to API
response = requests.post(
    endpoint,
    json={'data': data, 'record_count': len(data)},
    headers={'Content-Type': 'application/json'},
    timeout=30
)

if response.status_code == 200:
    print("Success!")
```

## Common Patterns

### Pattern 1: Query and Transform with Pandas
```python
from connectors.odbc_connector import ODBCConnector
from connectors.config_loader import get_db_config
import pandas as pd

DB_CONFIG = get_db_config()
connector = ODBCConnector(**DB_CONFIG)

with connector:
    # Query data
    data = connector.execute_query("SELECT * FROM sales")
    
    # Convert to DataFrame
    df = pd.DataFrame(data)
    
    # Transform
    df['total_with_tax'] = df['total'] * 1.1
    summary = df.groupby('product')['total'].sum()
    
    # Convert back to dict for API
    result = summary.to_dict()
```

### Pattern 2: Query and Send to API
```python
from connectors.odbc_connector import ODBCConnector
from connectors.config_loader import get_db_config, get_endpoint
import requests

DB_CONFIG = get_db_config()
connector = ODBCConnector(**DB_CONFIG)

with connector:
    data = connector.execute_query("SELECT * FROM customers")
    
    endpoint = get_endpoint('birdeye')
    response = requests.post(
        endpoint,
        json={'customers': data},
        timeout=30
    )
```

### Pattern 3: Using SQLAlchemy with Pandas
```python
import sqlalchemy
import pandas as pd
from connectors.config_loader import get_db_config

DB_CONFIG = get_db_config()

driver = DB_CONFIG['driver'].replace(' ', '+')
connection_string = (
    f"mssql+pyodbc://{DB_CONFIG['username']}:{DB_CONFIG['password']}"
    f"@{DB_CONFIG['server']}/{DB_CONFIG['database']}?driver={driver}"
)

engine = sqlalchemy.create_engine(connection_string)

# Read entire table
df = pd.read_sql_table('customers', engine)

# Or execute custom query
query = "SELECT * FROM customers WHERE status = 'active'"
df = pd.read_sql(query, engine)

# Perform operations
active_customers = len(df)
revenue_by_region = df.groupby('region')['revenue'].sum()
```

## When to Use Which Library

### Use pyodbc (ODBCConnector) when:
- You need simple, straightforward database queries
- You want to work with dictionaries
- You need parameterized queries
- You want minimal dependencies

### Use pandas when:
- You need to manipulate or transform data
- You want to perform aggregations or grouping
- You're working with time series data
- You need to clean or reshape data
- You want to export to CSV, Excel, etc.

### Use SQLAlchemy when:
- You need an ORM for complex applications
- You want database-agnostic code
- You need connection pooling
- You're building a larger application with models

### Use requests when:
- Sending data to external APIs
- Integrating with webhooks (like Zapier)
- Making HTTP calls to REST services

## Examples File

See `examples_library_usage.py` for complete working examples of all these patterns.

## Zapier Mock Endpoint

The project is configured with a Zapier mock endpoint for testing:
```
https://hooks.zapier.com/hooks/catch/23151206/umyaaov/
```

This endpoint allows you to:
- Test API integrations without real services
- See the structure of your payloads
- Debug data format issues
- Develop and test before production

Update the endpoint in your `.env` file when moving to production.

## Best Practices

1. **Always use context managers** for database connections:
   ```python
   with connector:
       # Your code here
   ```

2. **Use parameterized queries** to prevent SQL injection:
   ```python
   connector.execute_query("SELECT * FROM table WHERE id = ?", (user_id,))
   ```

3. **Handle errors gracefully**:
   ```python
   try:
       response = requests.post(endpoint, json=data, timeout=30)
       response.raise_for_status()
   except Exception as e:
       logger.error(f"Failed to send data: {e}")
   ```

4. **Keep credentials in `.env`**, never in code:
   ```bash
   # .env file (never commit this!)
   DB_PASSWORD=your-secret-password
   ```

5. **Use pandas for data transformation**, not loops:
   ```python
   # Good
   df['total_with_tax'] = df['total'] * 1.1
   
   # Avoid
   for i, row in df.iterrows():
       df.at[i, 'total_with_tax'] = row['total'] * 1.1
   ```

## Support

For more information:
- See `README.md` for general setup
- See `QUICKSTART.md` for quick start guide
- See `examples_library_usage.py` for code examples
