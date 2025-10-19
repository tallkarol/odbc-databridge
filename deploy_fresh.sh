#!/bin/bash
#
# Fresh deployment script with forced rebuild (no cache)
#
# Usage:
#   ./deploy_fresh.sh [PASSWORD]
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  FRESH DEPLOYMENT - No Cache${NC}"
echo -e "${BLUE}========================================${NC}"
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
PROJECT_ID=$(gcloud config get-value project)
SERVICE_NAME="odbc-databridge"
REGION="us-central1"
IMAGE_TAG=$(date +%Y%m%d-%H%M%S)

echo -e "${GREEN}✓ Using project: ${PROJECT_ID}${NC}"
echo -e "${GREEN}✓ Image tag: ${IMAGE_TAG}${NC}"
echo ""

# Delete existing service
echo -e "${BLUE}Step 1: Removing old service...${NC}"
gcloud run services delete $SERVICE_NAME --region $REGION --quiet 2>/dev/null || echo "  (no existing service)"
echo -e "${GREEN}✓ Old service removed${NC}"
echo ""

# Build fresh image
echo -e "${BLUE}Step 2: Building fresh Docker image...${NC}"
echo "This may take a few minutes..."
gcloud builds submit \
  --tag gcr.io/$PROJECT_ID/$SERVICE_NAME:$IMAGE_TAG \
  --timeout=20m

echo -e "${GREEN}✓ Image built successfully${NC}"
echo ""

# Deploy to Cloud Run
echo -e "${BLUE}Step 3: Deploying to Cloud Run...${NC}"
gcloud run deploy $SERVICE_NAME \
  --image gcr.io/$PROJECT_ID/$SERVICE_NAME:$IMAGE_TAG \
  --region $REGION \
  --allow-unauthenticated \
  --set-env-vars "DB_DRIVER=MariaDB,DB_SERVER=34.152.118.156,DB_DATABASE=odcb_databridge-db,DB_USERNAME=odcb-databridge-db,DB_PASSWORD=${DB_PASSWORD},DB_PORT=3306,BIRDEYE_ENDPOINT=https://hooks.zapier.com/hooks/catch/23151206/umyaaov/,EXAMPLE_SERVICE_ENDPOINT=https://hooks.zapier.com/hooks/catch/23151206/umyaaov/,LOG_DIR=logs,LOG_LEVEL=INFO" \
  --quiet

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

