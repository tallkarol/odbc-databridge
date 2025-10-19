FROM python:3.11-slim

WORKDIR /app

# Install ODBC drivers
RUN apt-get update && apt-get install -y \
    unixodbc unixodbc-dev \
    odbc-mariadb \
    && rm -rf /var/lib/apt/lists/*

# Configure MariaDB ODBC driver explicitly
RUN echo "[MariaDB]" > /etc/odbcinst.ini && \
    echo "Description=MariaDB Connector/ODBC" >> /etc/odbcinst.ini && \
    echo "Driver=/usr/lib/x86_64-linux-gnu/odbc/libmaodbc.so" >> /etc/odbcinst.ini && \
    echo "Setup=/usr/lib/x86_64-linux-gnu/odbc/libmaodbc.so" >> /etc/odbcinst.ini && \
    echo "FileUsage=1" >> /etc/odbcinst.ini

# Verify driver installation (for debugging)
RUN odbcinst -q -d

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Create necessary directories
RUN mkdir -p logs exports

# Expose port
EXPOSE 8080

# Run with gunicorn
CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 api:app
