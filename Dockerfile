FROM python:3.11-slim

WORKDIR /app

# Install ODBC drivers
RUN apt-get update && apt-get install -y \
    unixodbc unixodbc-dev \
    odbc-mariadb \
    && rm -rf /var/lib/apt/lists/*

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
