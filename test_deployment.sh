#!/bin/bash
#
# Test script for ODBC DataBridge deployment
#
# Usage:
#   ./test_deployment.sh [SERVICE_URL]
#
# If SERVICE_URL is not provided, you will be prompted to enter it.
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  ODBC DataBridge - Test Deployment${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Get service URL
if [ -z "$1" ]; then
    # Try to get it from gcloud
    SERVICE_URL=$(gcloud run services describe odbc-databridge --region us-central1 --format='value(status.url)' 2>/dev/null || echo "")
    
    if [ -z "$SERVICE_URL" ]; then
        echo -e "${YELLOW}Please enter your service URL:${NC}"
        echo "Example: https://odbc-databridge-xxxxx-uc.a.run.app"
        read SERVICE_URL
    else
        echo -e "${GREEN}Found service URL: ${SERVICE_URL}${NC}"
        echo ""
    fi
else
    SERVICE_URL="$1"
fi

if [ -z "$SERVICE_URL" ]; then
    echo -e "${RED}Error: Service URL is required.${NC}"
    exit 1
fi

# Remove trailing slash if present
SERVICE_URL=${SERVICE_URL%/}

echo -e "${BLUE}Testing service at: ${SERVICE_URL}${NC}"
echo ""

# Test 1: Health Check
echo -e "${BLUE}Test 1: Health Check${NC}"
echo "GET ${SERVICE_URL}/"
echo ""
RESPONSE=$(curl -s -w "\nHTTP_STATUS:%{http_code}" "${SERVICE_URL}/")
HTTP_STATUS=$(echo "$RESPONSE" | grep "HTTP_STATUS:" | cut -d: -f2)
BODY=$(echo "$RESPONSE" | grep -v "HTTP_STATUS:")

if [ "$HTTP_STATUS" = "200" ]; then
    echo -e "${GREEN}✓ Health check passed${NC}"
    echo "$BODY" | python3 -m json.tool 2>/dev/null || echo "$BODY"
else
    echo -e "${RED}✗ Health check failed (HTTP $HTTP_STATUS)${NC}"
    echo "$BODY"
fi
echo ""
echo "---"
echo ""

# Test 2: Birdeye Export
echo -e "${BLUE}Test 2: Birdeye Export (POST)${NC}"
echo "POST ${SERVICE_URL}/api/birdeye/export"
echo ""
RESPONSE=$(curl -s -w "\nHTTP_STATUS:%{http_code}" -X POST "${SERVICE_URL}/api/birdeye/export" -H "Content-Type: application/json")
HTTP_STATUS=$(echo "$RESPONSE" | grep "HTTP_STATUS:" | cut -d: -f2)
BODY=$(echo "$RESPONSE" | grep -v "HTTP_STATUS:")

if [ "$HTTP_STATUS" = "200" ]; then
    echo -e "${GREEN}✓ Birdeye export successful${NC}"
    echo "$BODY" | python3 -m json.tool 2>/dev/null || echo "$BODY"
else
    echo -e "${RED}✗ Birdeye export failed (HTTP $HTTP_STATUS)${NC}"
    echo "$BODY"
fi
echo ""
echo "---"
echo ""

# Test 3: Birdeye Export with Brand Filter
echo -e "${BLUE}Test 3: Birdeye Export with Brand Filter${NC}"
echo "POST ${SERVICE_URL}/api/birdeye/export"
echo 'Body: {"brand_name": "TestBrand"}'
echo ""
RESPONSE=$(curl -s -w "\nHTTP_STATUS:%{http_code}" -X POST "${SERVICE_URL}/api/birdeye/export" \
  -H "Content-Type: application/json" \
  -d '{"brand_name": "TestBrand"}')
HTTP_STATUS=$(echo "$RESPONSE" | grep "HTTP_STATUS:" | cut -d: -f2)
BODY=$(echo "$RESPONSE" | grep -v "HTTP_STATUS:")

if [ "$HTTP_STATUS" = "200" ]; then
    echo -e "${GREEN}✓ Birdeye export with filter successful${NC}"
    echo "$BODY" | python3 -m json.tool 2>/dev/null || echo "$BODY"
else
    echo -e "${YELLOW}⚠ Birdeye export with filter returned HTTP $HTTP_STATUS (may be expected if brand doesn't exist)${NC}"
    echo "$BODY"
fi
echo ""
echo "---"
echo ""

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Testing Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${BLUE}View logs with:${NC}"
echo "  gcloud run services logs read odbc-databridge --region us-central1 --limit 50"
echo ""
