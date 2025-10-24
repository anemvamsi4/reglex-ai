# Quick script to create .env.local with correct backend URL

Write-Host "🔧 Creating Frontend/.env.local file..." -ForegroundColor Cyan

$envContent = @"
# RegLex AI - Frontend Configuration
NEXT_PUBLIC_API_URL=https://reglex-backend-127310351608.us-central1.run.app
NEXT_PUBLIC_USE_MOCK_API=false
NEXT_PUBLIC_SKIP_AUTH=false
NEXT_PUBLIC_ENABLE_ANALYTICS=true
NEXT_PUBLIC_ENABLE_NOTIFICATIONS=true
NEXT_PUBLIC_API_TIMEOUT=300000
"@

$envPath = "Frontend\.env.local"

try {
    $envContent | Out-File -FilePath $envPath -Encoding UTF8 -Force
    Write-Host "✅ Created: $envPath" -ForegroundColor Green
    Write-Host ""
    Write-Host "📋 Content:" -ForegroundColor Yellow
    Get-Content $envPath | Write-Host
    Write-Host ""
    Write-Host "🚀 Next step: Restart your frontend dev server" -ForegroundColor Cyan
    Write-Host "   cd Frontend" -ForegroundColor Gray
    Write-Host "   npm run dev" -ForegroundColor Gray
    Write-Host ""
} catch {
    Write-Host "❌ Error: $_" -ForegroundColor Red
}

