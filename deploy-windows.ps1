# RegLex AI - Windows PowerShell Deployment Script
# Google Cloud Run Deployment

Write-Host "╔════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   RegLex AI - Google Cloud Deployment         ║" -ForegroundColor Cyan
Write-Host "║   Windows PowerShell Version                   ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Configuration
$PROJECT_ID = "reglex-ai"
$REGION = "us-central1"
$SERVICE_NAME = "reglex-backend"
$IMAGE_NAME = "gcr.io/$PROJECT_ID/$SERVICE_NAME"

# Environment variables
$env:GCP_PROJECT_ID = "reglex-ai"
$env:ELASTICSEARCH_URL = "https://sebi-compliance-agent-d15205.es.asia-south1.gcp.elastic.cloud:443"
# IMPORTANT: Do NOT keep secrets in source. Provide secrets via environment variables or Secret Manager.
# Set these in your environment before running, or use a secrets store. Example (PowerShell):
#  $env:GEMINI_API_KEY = '<your-gemini-key>'
#  $env:ELASTICSEARCH_API_KEY = '<your-elasticsearch-api-key>'
# The script will check for them and exit if they are not set.

Write-Host "📋 Deployment Configuration:" -ForegroundColor Yellow
Write-Host "  Project ID: $PROJECT_ID"
Write-Host "  Region: $REGION"
Write-Host "  Service: $SERVICE_NAME"
Write-Host ""

# Check if gcloud is installed
try {
    $gcloudVersion = gcloud version 2>&1
    Write-Host "✅ gcloud CLI found" -ForegroundColor Green
} catch {
    Write-Host "❌ gcloud CLI not found. Please install Google Cloud SDK." -ForegroundColor Red
    Write-Host "   Download from: https://cloud.google.com/sdk/docs/install" -ForegroundColor Yellow
    exit 1
}

# Set project
Write-Host "🔧 Setting GCP project..." -ForegroundColor Yellow
gcloud config set project $PROJECT_ID

# Enable required APIs
Write-Host "🔧 Enabling required Google Cloud APIs..." -ForegroundColor Yellow
gcloud services enable cloudbuild.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable containerregistry.googleapis.com
gcloud services enable aiplatform.googleapis.com
gcloud services enable storage.googleapis.com
gcloud services enable secretmanager.googleapis.com

# Create or update secrets
Write-Host "🔐 Setting up secrets..." -ForegroundColor Yellow

function Create-OrUpdate-Secret {
    param($SecretName, $SecretValue)
    
    $secretExists = gcloud secrets describe $SecretName --project=$PROJECT_ID 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  Updating secret: $SecretName"
        $SecretValue | gcloud secrets versions add $SecretName --data-file=-
    } else {
        Write-Host "  Creating secret: $SecretName"
        $SecretValue | gcloud secrets create $SecretName --data-file=- --replication-policy="automatic"
    }
}

Create-OrUpdate-Secret "GEMINI_API_KEY" $env:GEMINI_API_KEY
Create-OrUpdate-Secret "ELASTICSEARCH_URL" $env:ELASTICSEARCH_URL
Create-OrUpdate-Secret "ELASTICSEARCH_API_KEY" $env:ELASTICSEARCH_API_KEY

# Fail-fast if required secrets are missing to avoid creating empty secrets
if (-not $env:GEMINI_API_KEY -or $env:GEMINI_API_KEY.Trim().Length -eq 0) {
    Write-Host "❌ GEMINI_API_KEY is not set. Set it in the environment (or Secret Manager) and re-run this script." -ForegroundColor Red
    exit 1
}
if (-not $env:ELASTICSEARCH_API_KEY -or $env:ELASTICSEARCH_API_KEY.Trim().Length -eq 0) {
    Write-Host "❌ ELASTICSEARCH_API_KEY is not set. Set it in the environment (or Secret Manager) and re-run this script." -ForegroundColor Red
    exit 1
}

# Change to Backend directory
Write-Host "📁 Changing to Backend directory..." -ForegroundColor Yellow
Set-Location -Path "Backend"

# Build and deploy using Cloud Build
Write-Host "🏗️  Building and deploying via Cloud Build..." -ForegroundColor Yellow
gcloud builds submit --config cloudbuild.yaml

# Get service URL
Write-Host "📍 Getting service URL..." -ForegroundColor Yellow
$SERVICE_URL = gcloud run services describe $SERVICE_NAME `
    --platform managed `
    --region $REGION `
    --format 'value(status.url)'

Write-Host ""
Write-Host "╔════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║   🎉 Deployment Successful!                    ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "📍 Service URL: $SERVICE_URL" -ForegroundColor Green
Write-Host "📍 Health Check: $SERVICE_URL/health" -ForegroundColor Green
Write-Host "📍 API Docs: $SERVICE_URL/docs" -ForegroundColor Green
Write-Host ""
Write-Host "💡 Next Steps:" -ForegroundColor Yellow
Write-Host "  1. Test the health endpoint: curl $SERVICE_URL/health"
Write-Host "  2. Visit the API docs: $SERVICE_URL/docs"
Write-Host "  3. Update your frontend NEXT_PUBLIC_API_URL to: $SERVICE_URL"
Write-Host ""

# Test the deployment
Write-Host "🧪 Testing deployment..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$SERVICE_URL/health" -UseBasicParsing
    Write-Host "✅ Health check passed!" -ForegroundColor Green
    Write-Host $response.Content
} catch {
    Write-Host "⚠️  Health check failed. Check logs:" -ForegroundColor Yellow
    Write-Host "   gcloud run services logs read $SERVICE_NAME --region=$REGION"
}

Write-Host ""
Write-Host "🎊 Deployment complete! Your backend is live at:" -ForegroundColor Cyan
Write-Host "   $SERVICE_URL" -ForegroundColor Cyan
Write-Host ""

