#!/bin/bash
#
# Quick deployment script for ODBC DataBridge to Google Cloud Run
#
# Usage:
#   ./deploy.sh [PASSWORD]
#
# If PASSWORD is not provided, you will be prompted to enter it.
#

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  ODBC DataBridge - Cloud Run Deploy${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check if gcloud is installed
if ! command -v gcloud &> /dev/null; then
    echo -e "${RED}Error: gcloud CLI is not installed.${NC}"
    echo "Please install it from: https://cloud.google.com/sdk/docs/install"
    exit 1
fi

# Check if user is logged in
if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" &> /dev/null; then
    echo -e "${YELLOW}You are not logged in to gcloud.${NC}"
    echo "Running: gcloud auth login"
    gcloud auth login
fi

# Get current project
PROJECT_ID=$(gcloud config get-value project 2>/dev/null)
if [ -z "$PROJECT_ID" ]; then
    echo -e "${RED}Error: No project set.${NC}"
    echo "Please set your project with: gcloud config set project YOUR_PROJECT_ID"
    exit 1
fi

echo -e "${GREEN}✓ Using project: ${PROJECT_ID}${NC}"
echo ""

# Get database password
if [ -z "$1" ]; then
    echo -e "${YELLOW}Please enter your database password:${NC}"
    read -s DB_PASSWORD
    echo ""
else
    DB_PASSWORD="$1"
fi

if [ -z "$DB_PASSWORD" ]; then
    echo -e "${RED}Error: Database password is required.${NC}"
    exit 1
fi

# Configuration
REGION="us-central1"
SERVICE_NAME="odbc-databridge"

# Database configuration (from .env file)
DB_DRIVER="MySQL ODBC 8.0 Unicode Driver"
DB_SERVER="34.152.118.156"
DB_DATABASE="odcb_databridge-db"
DB_USERNAME="odcb-databridge-db"
DB_PORT="3306"

# API Endpoints
BIRDEYE_ENDPOINT="https://hooks.zapier.com/hooks/catch/23151206/umyaaov/"
EXAMPLE_SERVICE_ENDPOINT="https://hooks.zapier.com/hooks/catch/23151206/umyaaov/"

# Logging
LOG_DIR="logs"
LOG_LEVEL="INFO"

echo -e "${BLUE}Configuration:${NC}"
echo "  Service Name: ${SERVICE_NAME}"
echo "  Region: ${REGION}"
echo "  Database Server: ${DB_SERVER}"
echo "  Database Name: ${DB_DATABASE}"
echo "  Database User: ${DB_USERNAME}"
echo ""

# Enable required APIs
echo -e "${BLUE}Step 1: Enabling required APIs...${NC}"
gcloud services enable run.googleapis.com --quiet 2>/dev/null || echo "  (already enabled)"
gcloud services enable cloudbuild.googleapis.com --quiet 2>/dev/null || echo "  (already enabled)"
gcloud services enable containerregistry.googleapis.com --quiet 2>/dev/null || echo "  (already enabled)"
echo -e "${GREEN}✓ APIs enabled${NC}"
echo ""

# Deploy to Cloud Run
echo -e "${BLUE}Step 2: Deploying to Cloud Run...${NC}"
echo "This may take a few minutes..."
echo ""

gcloud run deploy ${SERVICE_NAME} \
  --source . \
  --region ${REGION} \
  --allow-unauthenticated \
  --set-env-vars "DB_DRIVER=${DB_DRIVER}" \
  --set-env-vars "DB_SERVER=${DB_SERVER}" \
  --set-env-vars "DB_DATABASE=${DB_DATABASE}" \
  --set-env-vars "DB_USERNAME=${DB_USERNAME}" \
  --set-env-vars "DB_PASSWORD=${DB_PASSWORD}" \
  --set-env-vars "DB_PORT=${DB_PORT}" \
  --set-env-vars "BIRDEYE_ENDPOINT=${BIRDEYE_ENDPOINT}" \
  --set-env-vars "EXAMPLE_SERVICE_ENDPOINT=${EXAMPLE_SERVICE_ENDPOINT}" \
  --set-env-vars "LOG_DIR=${LOG_DIR}" \
  --set-env-vars "LOG_LEVEL=${LOG_LEVEL}" \
  --quiet

echo ""
echo -e "${GREEN}✓ Deployment complete!${NC}"
echo ""

# Get service URL
SERVICE_URL=$(gcloud run services describe ${SERVICE_NAME} --region ${REGION} --format='value(status.url)')

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Deployment Successful!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${BLUE}Service URL:${NC} ${SERVICE_URL}"
echo ""
echo -e "${BLUE}Test your deployment:${NC}"
echo ""
echo "1. Health Check:"
echo "   curl ${SERVICE_URL}/"
echo ""
echo "2. Birdeye Export:"
echo "   curl -X POST ${SERVICE_URL}/api/birdeye/export"
echo ""
echo "3. View Logs:"
echo "   gcloud run services logs read ${SERVICE_NAME} --region ${REGION} --limit 50"
echo ""
echo -e "${GREEN}Done!${NC}"
