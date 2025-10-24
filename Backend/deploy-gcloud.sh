#!/bin/bash

# RegLex AI - Google Cloud Deployment Script
# Deploys the backend to Google Cloud Run

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}╔════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   RegLex AI - Google Cloud Deployment         ║${NC}"
echo -e "${GREEN}╔════════════════════════════════════════════════╗${NC}"
echo ""

# Configuration
PROJECT_ID=${GCP_PROJECT_ID:-"reglex-ai"}
REGION=${GCP_REGION:-"us-central1"}
SERVICE_NAME="reglex-backend"
IMAGE_NAME="gcr.io/${PROJECT_ID}/${SERVICE_NAME}"

echo -e "${YELLOW}📋 Deployment Configuration:${NC}"
echo "  Project ID: ${PROJECT_ID}"
echo "  Region: ${REGION}"
echo "  Service: ${SERVICE_NAME}"
echo ""

# Check if gcloud is installed
if ! command -v gcloud &> /dev/null; then
    echo -e "${RED}❌ gcloud CLI not found. Please install Google Cloud SDK.${NC}"
    echo "   https://cloud.google.com/sdk/docs/install"
    exit 1
fi

echo -e "${GREEN}✅ gcloud CLI found${NC}"

# Set project
echo -e "${YELLOW}🔧 Setting GCP project...${NC}"
gcloud config set project ${PROJECT_ID}

# Enable required APIs
echo -e "${YELLOW}🔧 Enabling required Google Cloud APIs...${NC}"
gcloud services enable \
    cloudbuild.googleapis.com \
    run.googleapis.com \
    containerregistry.googleapis.com \
    aiplatform.googleapis.com \
    storage.googleapis.com \
    secretmanager.googleapis.com

# Create secrets if they don't exist
echo -e "${YELLOW}🔐 Setting up secrets...${NC}"

# Function to create or update secret
create_or_update_secret() {
    SECRET_NAME=$1
    SECRET_VALUE=$2
    
    if gcloud secrets describe ${SECRET_NAME} --project=${PROJECT_ID} &> /dev/null; then
        echo "  Updating secret: ${SECRET_NAME}"
        echo -n "${SECRET_VALUE}" | gcloud secrets versions add ${SECRET_NAME} --data-file=-
    else
        echo "  Creating secret: ${SECRET_NAME}"
        echo -n "${SECRET_VALUE}" | gcloud secrets create ${SECRET_NAME} --data-file=- --replication-policy="automatic"
    fi
}

# Check for environment variables and create secrets
if [ ! -z "$GEMINI_API_KEY" ]; then
    create_or_update_secret "GEMINI_API_KEY" "$GEMINI_API_KEY"
else
    echo -e "${YELLOW}  ⚠️  GEMINI_API_KEY not set${NC}"
fi

if [ ! -z "$ELASTICSEARCH_URL" ]; then
    create_or_update_secret "ELASTICSEARCH_URL" "$ELASTICSEARCH_URL"
else
    echo -e "${YELLOW}  ⚠️  ELASTICSEARCH_URL not set${NC}"
fi

if [ ! -z "$ELASTICSEARCH_API_KEY" ]; then
    create_or_update_secret "ELASTICSEARCH_API_KEY" "$ELASTICSEARCH_API_KEY"
else
    echo -e "${YELLOW}  ⚠️  ELASTICSEARCH_API_KEY not set${NC}"
fi

# Build container image
echo -e "${YELLOW}🏗️  Building container image...${NC}"
gcloud builds submit --tag ${IMAGE_NAME} .

# Deploy to Cloud Run
echo -e "${YELLOW}🚀 Deploying to Cloud Run...${NC}"
gcloud run deploy ${SERVICE_NAME} \
    --image ${IMAGE_NAME} \
    --platform managed \
    --region ${REGION} \
    --allow-unauthenticated \
    --memory 2Gi \
    --cpu 2 \
    --timeout 300 \
    --set-env-vars "ENVIRONMENT=production,GCP_PROJECT_ID=${PROJECT_ID}" \
    --set-secrets "GEMINI_API_KEY=GEMINI_API_KEY:latest,ELASTICSEARCH_URL=ELASTICSEARCH_URL:latest,ELASTICSEARCH_API_KEY=ELASTICSEARCH_API_KEY:latest" \
    --max-instances 10 \
    --min-instances 1

# Get service URL
SERVICE_URL=$(gcloud run services describe ${SERVICE_NAME} \
    --platform managed \
    --region ${REGION} \
    --format 'value(status.url)')

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   🎉 Deployment Successful!                    ║${NC}"
echo -e "${GREEN}╔════════════════════════════════════════════════╗${NC}"
echo ""
echo -e "${GREEN}📍 Service URL: ${SERVICE_URL}${NC}"
echo -e "${GREEN}📍 Health Check: ${SERVICE_URL}/health${NC}"
echo -e "${GREEN}📍 API Docs: ${SERVICE_URL}/docs${NC}"
echo ""
echo -e "${YELLOW}💡 Next Steps:${NC}"
echo "  1. Test the health endpoint: curl ${SERVICE_URL}/health"
echo "  2. Visit the API docs: ${SERVICE_URL}/docs"
echo "  3. Update your frontend NEXT_PUBLIC_API_URL to: ${SERVICE_URL}"
echo ""

