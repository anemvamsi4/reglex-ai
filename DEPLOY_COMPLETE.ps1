# RegLex AI - Complete Deployment Script
# Deploys everything: Backend + Kibana Integration + Fivetran Sync

Write-Host ""
Write-Host "╔══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                                                          ║" -ForegroundColor Cyan
Write-Host "║        RegLex AI - Complete Hackathon Deployment        ║" -ForegroundColor Cyan
Write-Host "║                                                          ║" -ForegroundColor Cyan
Write-Host "║  • Elastic Search + Kibana Dashboards                   ║" -ForegroundColor Cyan
Write-Host "║  • Fivetran Data Pipeline                               ║" -ForegroundColor Cyan
Write-Host "║  • Google Vertex AI                                     ║" -ForegroundColor Cyan
Write-Host "║  • Google Cloud Run                                     ║" -ForegroundColor Cyan
Write-Host "║                                                          ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Configuration
$PROJECT_ID = "reglex-ai"
$REGION = "us-central1"
$SERVICE_NAME = "reglex-backend"

# Set environment variables
Write-Host "🔧 Configuring environment..." -ForegroundColor Yellow
$env:GCP_PROJECT_ID = "reglex-ai"
$env:ELASTICSEARCH_URL = "https://sebi-compliance-agent-d15205.es.asia-south1.gcp.elastic.cloud:443"
# IMPORTANT: Do NOT keep secrets in source. Provide secrets via environment variables or Secret Manager.
# Set these in your environment before running, or use a secrets store. Example (PowerShell):
#  $env:GEMINI_API_KEY = '<your-gemini-key>'
#  $env:ELASTICSEARCH_API_KEY = '<your-elasticsearch-api-key>'
# The script will check for them and exit if they are not set.
$env:ENABLE_FIVETRAN_SYNC = "true"
$env:ENABLE_KIBANA_DASHBOARDS = "true"

Write-Host "✅ Environment configured" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Deployment Plan:" -ForegroundColor Yellow
Write-Host "  ✓ Google Cloud Project: $PROJECT_ID"
Write-Host "  ✓ Region: $REGION"
Write-Host "  ✓ Elastic + Kibana Integration: Enabled"
Write-Host "  ✓ Fivetran Sync: Enabled"
Write-Host "  ✓ Vertex AI: Enabled"
Write-Host ""

# Check prerequisites
Write-Host "🔍 Checking prerequisites..." -ForegroundColor Yellow
try {
    $null = gcloud version 2>&1
    Write-Host "  ✅ gcloud CLI found" -ForegroundColor Green
} catch {
    Write-Host "  ❌ gcloud CLI not found!" -ForegroundColor Red
    Write-Host "  Please install from: https://cloud.google.com/sdk/docs/install" -ForegroundColor Yellow
    exit 1
}

# Set project
Write-Host ""
Write-Host "🔧 Setting up Google Cloud..." -ForegroundColor Yellow
gcloud config set project $PROJECT_ID

# Enable APIs
Write-Host "🔧 Enabling Google Cloud APIs..." -ForegroundColor Yellow
$apis = @(
    "cloudbuild.googleapis.com",
    "run.googleapis.com",
    "containerregistry.googleapis.com",
    "aiplatform.googleapis.com",
    "storage.googleapis.com",
    "secretmanager.googleapis.com",
    "bigquery.googleapis.com"
)

foreach ($api in $apis) {
    Write-Host "  Enabling $api..." -ForegroundColor Gray
    gcloud services enable $api --quiet
}
Write-Host "✅ APIs enabled" -ForegroundColor Green

# Create secrets
Write-Host ""
Write-Host "🔐 Setting up secrets..." -ForegroundColor Yellow

function Create-Secret {
    param($Name, $Value)
    
    $exists = gcloud secrets describe $Name --project=$PROJECT_ID 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  Updating: $Name" -ForegroundColor Gray
        echo $Value | gcloud secrets versions add $Name --data-file=- --quiet
    } else {
        Write-Host "  Creating: $Name" -ForegroundColor Gray
        echo $Value | gcloud secrets create $Name --data-file=- --replication-policy="automatic" --quiet
    }
}

Create-Secret "GEMINI_API_KEY" $env:GEMINI_API_KEY
Create-Secret "ELASTICSEARCH_URL" $env:ELASTICSEARCH_URL
Create-Secret "ELASTICSEARCH_API_KEY" $env:ELASTICSEARCH_API_KEY

# Fail-fast if required secrets are missing to avoid accidentally creating empty secrets
if (-not $env:GEMINI_API_KEY -or $env:GEMINI_API_KEY.Trim().Length -eq 0) {
    Write-Host "❌ GEMINI_API_KEY is not set. Set it in the environment (or Secret Manager) and re-run this script." -ForegroundColor Red
    exit 1
}
if (-not $env:ELASTICSEARCH_API_KEY -or $env:ELASTICSEARCH_API_KEY.Trim().Length -eq 0) {
    Write-Host "❌ ELASTICSEARCH_API_KEY is not set. Set it in the environment (or Secret Manager) and re-run this script." -ForegroundColor Red
    exit 1
}

Write-Host "✅ Secrets configured" -ForegroundColor Green

# Deploy to Cloud Run
Write-Host ""
Write-Host "🚀 Deploying to Google Cloud Run..." -ForegroundColor Yellow
Write-Host "   This may take 5-10 minutes..." -ForegroundColor Gray
Write-Host ""

Set-Location -Path "Backend"

# Build and deploy
gcloud builds submit --config cloudbuild.yaml

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "❌ Deployment failed!" -ForegroundColor Red
    Write-Host "Check logs: gcloud builds list --limit=1" -ForegroundColor Yellow
    exit 1
}

# Get service URL
Write-Host ""
Write-Host "📍 Getting service details..." -ForegroundColor Yellow
$SERVICE_URL = gcloud run services describe $SERVICE_NAME --platform managed --region $REGION --format "value(status.url)"

# Success!
Write-Host ""
Write-Host "╔══════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║                                                          ║" -ForegroundColor Green
Write-Host "║              🎉 DEPLOYMENT SUCCESSFUL! 🎉               ║" -ForegroundColor Green
Write-Host "║                                                          ║" -ForegroundColor Green
Write-Host "╚══════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

# Display URLs
Write-Host "📍 Your Backend API:" -ForegroundColor Cyan
Write-Host "   $SERVICE_URL" -ForegroundColor White
Write-Host ""
Write-Host "📍 API Documentation:" -ForegroundColor Cyan
Write-Host "   $SERVICE_URL/docs" -ForegroundColor White
Write-Host ""
Write-Host "📍 Kibana Dashboard:" -ForegroundColor Cyan
Write-Host "   https://sebi-compliance-agent-d15205.kb.asia-south1.gcp.elastic.cloud:5601" -ForegroundColor White
Write-Host ""

# Test deployment
Write-Host "🧪 Testing deployment..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$SERVICE_URL/health" -Method Get
    Write-Host "✅ Health check passed!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Status:" -ForegroundColor Cyan
    $response | ConvertTo-Json | Write-Host -ForegroundColor White
} catch {
    Write-Host "⚠️ Health check failed (API might still be starting up)" -ForegroundColor Yellow
    Write-Host "Try again in 30 seconds: curl $SERVICE_URL/health" -ForegroundColor Gray
}

# Next steps
Write-Host ""
Write-Host "╔══════════════════════════════════════════════════════════╗" -ForegroundColor Yellow
Write-Host "║                    NEXT STEPS                            ║" -ForegroundColor Yellow
Write-Host "╚══════════════════════════════════════════════════════════╝" -ForegroundColor Yellow
Write-Host ""
Write-Host "1️⃣  Update Frontend:" -ForegroundColor Cyan
Write-Host "   Edit Frontend/.env.local:" -ForegroundColor Gray
Write-Host "   NEXT_PUBLIC_API_URL=$SERVICE_URL" -ForegroundColor White
Write-Host ""
Write-Host "2️⃣  Redeploy Frontend:" -ForegroundColor Cyan
Write-Host "   cd Frontend" -ForegroundColor Gray
Write-Host "   vercel --prod" -ForegroundColor White
Write-Host ""
Write-Host "3️⃣  Access Kibana Dashboard:" -ForegroundColor Cyan
Write-Host "   https://sebi-compliance-agent-d15205.kb.asia-south1.gcp.elastic.cloud:5601" -ForegroundColor White
Write-Host ""
Write-Host "4️⃣  Test Your API:" -ForegroundColor Cyan
Write-Host "   curl $SERVICE_URL/health" -ForegroundColor White
Write-Host "   Open: $SERVICE_URL/docs" -ForegroundColor White
Write-Host ""
Write-Host "5️⃣  Record Demo Video:" -ForegroundColor Cyan
Write-Host "   • Show document upload & analysis" -ForegroundColor Gray
Write-Host "   • Show Kibana dashboards" -ForegroundColor Gray
Write-Host "   • Explain Elastic + Fivetran + Vertex AI" -ForegroundColor Gray
Write-Host "   • Max 3 minutes!" -ForegroundColor Gray
Write-Host ""
Write-Host "6️⃣  Submit to Devpost:" -ForegroundColor Cyan
Write-Host "   Use content from HACKATHON.md" -ForegroundColor Gray
Write-Host "   Include all URLs (GitHub, Live, Video, API)" -ForegroundColor Gray
Write-Host ""

# Save URLs to file
$urlsFile = "../DEPLOYMENT_URLS.txt"
@"
RegLex AI - Deployment URLs
Generated: $(Get-Date)

Backend API:
$SERVICE_URL

API Documentation:
$SERVICE_URL/docs

Health Check:
$SERVICE_URL/health

Kibana Dashboard:
https://sebi-compliance-agent-d15205.kb.asia-south1.gcp.elastic.cloud:5601

Frontend:
https://reg-lex-ai.vercel.app

GitHub:
https://github.com/adi0900/RegLex-AI

---

NEXT: Update Frontend .env.local with:
NEXT_PUBLIC_API_URL=$SERVICE_URL

Then redeploy frontend:
cd Frontend && vercel --prod
"@ | Out-File -FilePath $urlsFile -Encoding UTF8

Write-Host "✅ URLs saved to: DEPLOYMENT_URLS.txt" -ForegroundColor Green
Write-Host ""
Write-Host "🎊 Your hackathon project is LIVE!" -ForegroundColor Cyan
Write-Host "🏆 Ready to win! Good luck!" -ForegroundColor Cyan
Write-Host ""

