# Quick Start Guide

This guide will help you get started with the ODBC Data Bridge in just a few minutes.

## Prerequisites

- Python 3.7 or higher
- Access to a database with ODBC connectivity
- Appropriate ODBC driver installed for your database

## Step-by-Step Setup

### 1. Install Python Dependencies

```bash
pip install -r requirements.txt
```

### 2. Set Up Configuration

Create your configuration file from the template:

```bash
cp config.example.py config.py
```

Edit `config.py` with your database credentials:

```python
DB_CONFIG = {
    'driver': 'ODBC Driver 17 for SQL Server',  # Your ODBC driver
    'server': 'myserver.database.windows.net',  # Your server
    'database': 'mydatabase',                    # Your database
    'username': 'myusername',                    # Your username
    'password': 'mypassword',                    # Your password
    'port': None                                 # Optional port
}
```

### 3. Test the Setup

Run the structure validation test:

```bash
python test_structure.py
```

You should see all checks passing (✓).

### 4. Customize a Service Script

Edit one of the service scripts to use your actual SQL queries:

```bash
# Open the Birdeye export script
nano services/birdeye_export.py

# Or create a new one from the template
cp services/example_service.py services/my_service.py
nano services/my_service.py
```

Update the SQL query to match your needs:

```python
query = """
    SELECT 
        column1,
        column2,
        column3
    FROM your_actual_table
    WHERE your_conditions = 1
"""
```

### 5. Run Your Service Script

```bash
python services/birdeye_export.py
```

Check the logs directory for output:

```bash
ls -l logs/
cat logs/birdeye_export_*.log
```

### 6. Set Up Automated Scheduling

Edit your crontab:

```bash
crontab -e
```

Add a schedule (example runs daily at 2 AM):

```bash
0 2 * * * cd /path/to/odbc-databridge && python services/birdeye_export.py
```

Save and exit. Your script will now run automatically!

## Creating Additional Service Scripts

To add a new service integration:

1. Copy the example template:
   ```bash
   cp services/example_service.py services/new_service.py
   ```

2. Update the script name in the logger:
   ```python
   logger = setup_logger('new_service')
   ```

3. Customize the SQL query for your use case

4. Modify the `process_data()` function for your specific needs

5. Update the `export_data()` function to format output correctly

6. Run and test:
   ```bash
   python services/new_service.py
   ```

## Common Cron Schedules

```bash
# Every 15 minutes
*/15 * * * * cd /path/to/odbc-databridge && python services/my_script.py

# Every hour
0 * * * * cd /path/to/odbc-databridge && python services/my_script.py

# Daily at 2 AM
0 2 * * * cd /path/to/odbc-databridge && python services/my_script.py

# Weekdays at 9 AM
0 9 * * 1-5 cd /path/to/odbc-databridge && python services/my_script.py

# First day of every month at midnight
0 0 1 * * cd /path/to/odbc-databridge && python services/my_script.py
```

## Troubleshooting

### Cannot connect to database

- Verify your credentials in `config.py`
- Check that the ODBC driver is installed
- Ensure your server allows connections from your IP
- Check firewall settings

### Module import errors

- Make sure you've installed dependencies: `pip install -r requirements.txt`
- Verify you're running from the project root directory

### Cron job not running

- Check cron logs: `grep CRON /var/log/syslog`
- Ensure you used absolute paths in crontab
- Verify Python path is correct in crontab
- Check file permissions

### Log files not created

- Ensure the `logs/` directory exists
- Check file permissions on the logs directory
- Verify the script is running (check for errors)

## Next Steps

- Review the main README.md for detailed documentation
- Customize queries for your specific data needs
- Add error handling for your specific use cases
- Set up monitoring for cron jobs
- Consider using environment variables for sensitive config

## Support

For issues or questions, please refer to the main README.md or open an issue in the repository.
