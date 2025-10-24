#!/bin/bash

# RegLex AI - Frontend Deployment to Google Cloud Storage + Cloud CDN
# Alternative: Deploy to Cloud Run for containerized hosting

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}╔════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   RegLex AI - Frontend Deployment             ║${NC}"
echo -e "${GREEN}╔════════════════════════════════════════════════╗${NC}"
echo ""

PROJECT_ID=${GCP_PROJECT_ID:-"reglex-ai"}
BACKEND_URL=${BACKEND_URL:-"https://reglex-backend-xxxxx.run.app"}
BUCKET_NAME="${PROJECT_ID}-frontend"

echo -e "${YELLOW}📋 Configuration:${NC}"
echo "  Project: ${PROJECT_ID}"
echo "  Backend URL: ${BACKEND_URL}"
echo "  Bucket: ${BUCKET_NAME}"
echo ""

# Set project
gcloud config set project ${PROJECT_ID}

# Build frontend
echo -e "${YELLOW}🏗️  Building Next.js frontend...${NC}"
cd Frontend

# Set environment variable for build
export NEXT_PUBLIC_API_URL=${BACKEND_URL}

# Install and build
npm install
npm run build

# Create storage bucket if not exists
echo -e "${YELLOW}☁️  Setting up Cloud Storage...${NC}"
if ! gsutil ls -b gs://${BUCKET_NAME} &> /dev/null; then
    gsutil mb -p ${PROJECT_ID} gs://${BUCKET_NAME}
    gsutil web set -m index.html -e 404.html gs://${BUCKET_NAME}
    gsutil iam ch allUsers:objectViewer gs://${BUCKET_NAME}
fi

# Upload to Cloud Storage
echo -e "${YELLOW}📤 Uploading to Cloud Storage...${NC}"
gsutil -m rsync -r -d out/ gs://${BUCKET_NAME}

echo ""
echo -e "${GREEN}✅ Frontend deployed to: https://storage.googleapis.com/${BUCKET_NAME}/index.html${NC}"
echo ""
echo -e "${YELLOW}💡 For custom domain, set up Cloud CDN:${NC}"
echo "  1. Create load balancer"
echo "  2. Point to bucket: ${BUCKET_NAME}"
echo "  3. Configure SSL certificate"
echo ""

