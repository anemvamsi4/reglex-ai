# 🔗 RegLex AI - All URLs

## 🌐 Deployed Applications

### Frontend (Google Cloud Run)
```
https://reglex-frontend-127310351608.us-central1.run.app
```
**Pages:**
- Landing: https://reglex-frontend-127310351608.us-central1.run.app
- Dashboard: https://reglex-frontend-127310351608.us-central1.run.app/dashboard
- Analytics (Kibana + Fivetran): https://reglex-frontend-127310351608.us-central1.run.app/dashboard/analytics
- Documents: https://reglex-frontend-127310351608.us-central1.run.app/dashboard/documents
- Upload: https://reglex-frontend-127310351608.us-central1.run.app/dashboard/upload
- Reports: https://reglex-frontend-127310351608.us-central1.run.app/dashboard/reports

### Backend API (Google Cloud Run)
```
https://reglex-backend-127310351608.us-central1.run.app
```
**Endpoints:**
- API Documentation: https://reglex-backend-127310351608.us-central1.run.app/docs
- Health Check: https://reglex-backend-127310351608.us-central1.run.app/health
- Interactive API: https://reglex-backend-127310351608.us-central1.run.app/redoc

---

## 🔍 Elastic Cloud

### Elasticsearch Cluster
```
https://sebi-compliance-agent-d15205.es.asia-south1.gcp.elastic.cloud:443
```
**Details:**
- Cluster ID: `sebi-compliance-agent-d15205`
- Region: `asia-south1` (Mumbai)
- Index: `sebi_compliance_index`
- Search Type: Hybrid (BM25 + Vector)

### Kibana Dashboard
```
https://sebi-compliance-agent-d15205.kb.asia-south1.gcp.elastic.cloud
```
**Dashboards:**
- RegLex Compliance Overview
- Risk Analytics
- Violation Patterns

---

## 📊 Google Cloud Resources

### BigQuery Dataset
```
Project: reglex-ai
Dataset: reglex_compliance
```
**Tables:**
- `compliance_analyses` - Document-level results
- `clause_verifications` - Clause-by-clause compliance
- `risk_metrics` - Risk assessment data

**BigQuery Console:**
```
https://console.cloud.google.com/bigquery?project=reglex-ai&d=reglex_compliance
```

### Cloud Run Services
```
https://console.cloud.google.com/run?project=reglex-ai&region=us-central1
```

### Google Cloud Storage
```
https://console.cloud.google.com/storage/browser?project=reglex-ai
```

---

## 🔄 Fivetran

### Connector (Custom Python SDK)
**Type:** Custom data connector  
**Source:** RegLex Compliance API  
**Destination:** BigQuery (`reglex-ai:reglex_compliance`)  
**Sync Frequency:** Hourly  

**Fivetran Console:**
```
https://fivetran.com/dashboard/connectors
```

---

## 📁 Source Code

### GitHub Repository
```
https://github.com/adi0900/RegLex-AI
```

### Key Files to Show Judges:
- Backend Integration: `Backend/src/compliance_checker/enhanced_elastic_search.py`
- Kibana Setup: `Backend/src/kibana_integration/kibana_dashboard.py`
- Fivetran Connector: `Backend/src/fivetran_integration/fivetran_connector.py`
- Vertex AI: `Backend/src/llm_provider/verifier_llms/vertex_ai_verifier.py`
- Frontend Analytics: `Frontend/components/dashboard/KibanaDashboard.tsx`

---

## 🎥 Demo URLs (for Video)

### Start Here:
1. **Frontend:** https://reglex-frontend-127310351608.us-central1.run.app
2. **Navigate to Analytics:** Click "Dashboard" → "Analytics" (🔥 badge)
3. **Show Kibana Tab:** Beautiful charts and metrics
4. **Show Fivetran Tab:** Data pipeline visualization
5. **Try Upload:** Upload a compliance document
6. **Show Results:** Real-time analysis with Vertex AI

### API Demo:
1. **API Docs:** https://reglex-backend-127310351608.us-central1.run.app/docs
2. **Test Health:** https://reglex-backend-127310351608.us-central1.run.app/health
3. **Try Hybrid Search:** Use the `/search` endpoint in docs

---

## 🔐 Configuration (For Your Reference)

### Environment Variables in Use:
```bash
# Backend
GEMINI_API_KEY=AIzaSyBp-oTm2GCsV7Jtwy658xE1gydqa_r51s4
ELASTICSEARCH_URL=https://sebi-compliance-agent-d15205.es.asia-south1.gcp.elastic.cloud:443
GCP_PROJECT_ID=reglex-ai
ENVIRONMENT=production

# Frontend
NEXT_PUBLIC_API_URL=https://reglex-backend-127310351608.us-central1.run.app
NEXT_PUBLIC_USE_MOCK_API=false
```

### Google Cloud Project:
```
Project ID: reglex-ai
Project Number: 127310351608
Region: us-central1 (Iowa)
```

---

## ✅ Testing Checklist

- [ ] Frontend loads: https://reglex-frontend-127310351608.us-central1.run.app
- [ ] Backend health: https://reglex-backend-127310351608.us-central1.run.app/health
- [ ] Analytics dashboard: /dashboard/analytics
- [ ] Kibana charts visible
- [ ] Fivetran pipeline visible
- [ ] Document upload works
- [ ] API documentation accessible

---

**Last Updated:** October 24, 2025  
**Status:** ✅ All systems deployed and operational

