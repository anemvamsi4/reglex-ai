# 🔄 RegLex AI - System Flowchart Documentation

## 📋 Table of Contents
1. [Overview](#overview)
2. [System Architecture Flowchart](#system-architecture-flowchart)
3. [Document Upload Flow](#document-upload-flow)
4. [Compliance Analysis Flow](#compliance-analysis-flow)
5. [Conversational Agent Flow](#conversational-agent-flow)
6. [Data Pipeline Flow](#data-pipeline-flow)
7. [Analytics Dashboard Flow](#analytics-dashboard-flow)
8. [Error Handling Flow](#error-handling-flow)
9. [Component Interaction Matrix](#component-interaction-matrix)

---

## 🎯 Overview

This document provides comprehensive flowcharts for the RegLex AI system, illustrating how data flows through different components and how they interact with each other.

---

## 🏗️ System Architecture Flowchart

```
┌──────────────────────────────────────────────────────────────────────────────────┐
│                          REGLEX AI - CLOUD ARCHITECTURE                           │
│                                                                                    │
│                                                                                    │
│  ┌─────────────────────────────────────────────────────────────────────────┐    │
│  │                            USER LAYER                                    │    │
│  │                                                                           │    │
│  │      ┌──────────────┐    ┌──────────────┐    ┌──────────────┐          │    │
│  │      │   Web App    │    │  Mobile App  │    │  API Client  │          │    │
│  │      │   (Chrome)   │    │(Smartphone)  │    │    (Code)    │          │    │
│  │      └──────┬───────┘    └──────┬───────┘    └──────┬───────┘          │    │
│  │             │                     │                   │                   │    │
│  │             └─────────────────────┼───────────────────┘                   │    │
│  └────────────────────────────────────┼──────────────────────────────────────┘    │
│                                       │                                            │
│                                       │ HTTPS (443)                                │
│                                       ▼                                            │
│  ┌───────────────────────────────────────────────────────────────────────────┐   │
│  │                      NETWORK LAYER                                         │   │
│  │                                                                             │   │
│  │                ┌───────────────────────────────────┐                       │   │
│  │                │   Cloud Load Balancer (GCP)       │                       │   │
│  │                │   • SSL/TLS Termination           │                       │   │
│  │                │   • DDoS Protection                │                       │   │
│  │                │   • Global Distribution            │                       │   │
│  │                └─────────────────┬─────────────────┘                       │   │
│  └──────────────────────────────────┼───────────────────────────────────────┘   │
│                                      │                                            │
│                        ┌─────────────┴──────────────┐                            │
│                        │                            │                            │
│                        │ HTTPS                      │ HTTPS                      │
│                        ▼                            ▼                            │
│  ┌────────────────────────────────────────────────────────────────────────────┐ │
│  │                      APPLICATION LAYER                                      │ │
│  │                                                                              │ │
│  │  ┌─────────────────────────────┐      ┌──────────────────────────────────┐ │ │
│  │  │  Frontend Service            │      │  Backend Service                  │ │ │
│  │  │  (Cloud Run - Blue)          │      │  (Cloud Run - Green)              │ │ │
│  │  │                              │      │                                   │ │ │
│  │  │  ┌────────────────────────┐ │      │  ┌─────────────────────────────┐ │ │ │
│  │  │  │  Next.js App            │ │      │  │  FastAPI App                │ │ │ │
│  │  │  │  • Pages/Routes         │ │      │  │  • REST API Endpoints       │ │ │ │
│  │  │  │  • Components           │ │◄────►│  │  • WebSocket Server         │ │ │ │
│  │  │  │  • SSR/SSG              │ │HTTPS │  │  • Multi-threaded           │ │ │ │
│  │  │  └────────────────────────┘ │      │  └─────────────────────────────┘ │ │ │
│  │  │                              │      │                                   │ │ │
│  │  └──────────────────────────────┘      │  ┌─────────────────────────────┐ │ │ │
│  │                                         │  │  Business Logic             │ │ │ │
│  │                                         │  │                             │ │ │ │
│  │                                         │  │  ┌────────────────────────┐ │ │ │ │
│  │                                         │  │  │ Compliance Checker     │ │ │ │ │
│  │                                         │  │  │ • Regulation Retriever │ │ │ │ │
│  │                                         │  │  │ • Conversational Agent │ │ │ │ │
│  │                                         │  │  │ • Elastic Search       │ │ │ │ │
│  │                                         │  │  └────────────────────────┘ │ │ │ │
│  │                                         │  │                             │ │ │ │
│  │                                         │  │  ┌────────────────────────┐ │ │ │ │
│  │                                         │  │  │ LLM Provider           │ │ │ │ │
│  │                                         │  │  │ • Vertex AI (Primary)  │ │ │ │ │
│  │                                         │  │  │ • Claude (Fallback)    │ │ │ │ │
│  │                                         │  │  │ • OpenAI (Fallback)    │ │ │ │ │
│  │                                         │  │  └────────────────────────┘ │ │ │ │
│  │                                         │  │                             │ │ │ │
│  │                                         │  │  ┌────────────────────────┐ │ │ │ │
│  │                                         │  │  │ Embedder (Legal-BERT)  │ │ │ │ │
│  │                                         │  │  │ • 768-dim vectors      │ │ │ │ │
│  │                                         │  │  └────────────────────────┘ │ │ │ │
│  │                                         │  └─────────────────────────────┘ │ │ │
│  │                                         │                                   │ │ │
│  │                                         │  ┌─────────────────────────────┐ │ │ │
│  │                                         │  │  Data Access Layer          │ │ │ │
│  │                                         │  │  • Elastic Client           │ │ │ │
│  │                                         │  │  • GCS Client               │ │ │ │
│  │                                         │  │  • BigQuery Client          │ │ │ │
│  │                                         │  │  • Secret Manager Client    │ │ │ │
│  │                                         │  └─────────────────────────────┘ │ │ │
│  │                                         │                                   │ │ │
│  │                                         │  ┌─────────────────────────────┐ │ │ │
│  │                                         │  │  Integration Layer          │ │ │ │
│  │                                         │  │  • PyMuPDF Processor        │ │ │ │
│  │                                         │  │  • Fivetran Integration     │ │ │ │
│  │                                         │  │  • Kibana Integration       │ │ │ │
│  │                                         │  └─────────────────────────────┘ │ │ │
│  │                                         └───────────────────────────────────┘ │ │
│  └──────────────────────────────────────────────────┬─────────────────────────┘ │
│                                                      │                            │
│                         ┌────────────────────────────┼────────────────┐          │
│                         │                            │                │          │
│                         ▼                            ▼                ▼          │
│  ┌────────────────────────────────────────────────────────────────────────────┐ │
│  │                      AI & SEARCH LAYER (Purple)                             │ │
│  │                                                                              │ │
│  │  ┌──────────────────────┐  ┌──────────────────────┐  ┌──────────────────┐ │ │
│  │  │  Vertex AI           │  │  Elasticsearch       │  │  Legal-BERT      │ │ │
│  │  │  (Gemini Pro)        │  │  Cluster             │  │  Embeddings      │ │ │
│  │  │                      │  │                      │  │                  │ │ │
│  │  │  • LLM Analysis      │  │  • Hybrid Search     │◄─│  • 768-dim      │ │ │
│  │  │  • Compliance Check  │  │  • BM25 + kNN       │  │    vectors       │ │ │
│  │  │  • Risk Scoring      │  │  • 10K+ regs        │  │  • Semantic      │ │ │
│  │  │  • Q&A               │  │  • <200ms query     │  │    similarity    │ │ │
│  │  │                      │  │                      │  │                  │ │ │
│  │  │  us-central1         │  │  asia-south1        │  │  Cloud Run       │ │ │
│  │  └──────────────────────┘  └──────────┬───────────┘  └──────────────────┘ │ │
│  └────────────────────────────────────────┼─────────────────────────────────┘ │
│                                            │                                    │
│                                            ▼                                    │
│  ┌────────────────────────────────────────────────────────────────────────────┐ │
│  │                      STORAGE LAYER (Orange)                                 │ │
│  │                                                                              │ │
│  │  ┌──────────────────────┐  ┌──────────────────────┐  ┌──────────────────┐ │ │
│  │  │  Cloud Storage (GCS) │  │  BigQuery            │  │  Secret Manager  │ │ │
│  │  │                      │  │  Data Warehouse      │  │  Credentials     │ │ │
│  │  │  • PDF Storage       │  │                      │  │                  │ │ │
│  │  │  • Document Archive  │  │  3 Tables:           │  │  • API Keys      │ │ │
│  │  │  • Versioning        │  │  • compliance_       │  │  • Elastic Auth  │ │ │
│  │  │  • Lifecycle Mgmt    │  │    analyses (125)    │  │  • Gemini Keys   │ │ │
│  │  │                      │  │  • clause_           │  │  • Encrypted     │ │ │
│  │  │  Multi-region        │  │    verifications(542)│  │                  │ │ │
│  │  │                      │  │  • risk_metrics (89) │  │  Global          │ │ │
│  │  └──────────────────────┘  └──────────┬───────────┘  └──────────────────┘ │ │
│  └────────────────────────────────────────┼─────────────────────────────────┘ │
│                                            ▲                                    │
│                                            │                                    │
│  ┌────────────────────────────────────────┼─────────────────────────────────┐ │
│  │                      DATA PIPELINE LAYER                                   │ │
│  │                                            │                                │ │
│  │                  ┌─────────────────────────┴──────────────────────┐        │ │
│  │                  │         Fivetran Connector                      │        │ │
│  │                  │                                                 │        │ │
│  │                  │  • Custom Python SDK                            │        │ │
│  │                  │  • Incremental Sync (Hourly)                    │        │ │
│  │                  │  • Schema Auto-Detection                        │        │ │
│  │                  │  • Idempotent Operations                        │        │ │
│  │                  │  • Error Handling & Retries                     │        │ │
│  │                  │                                                 │        │ │
│  │                  │  Source: Backend API                            │        │ │
│  │                  │  Destination: BigQuery                          │        │ │
│  │                  │  Frequency: Every 60 minutes                    │        │ │
│  │                  └─────────────────────────────────────────────────┘        │ │
│  └────────────────────────────────────────────────────────────────────────────┘ │
│                                            │                                     │
│                                            ▼                                     │
│  ┌────────────────────────────────────────────────────────────────────────────┐ │
│  │                  OBSERVABILITY LAYER (Yellow)                               │ │
│  │                                                                              │ │
│  │  ┌──────────────────────┐  ┌──────────────────────┐  ┌──────────────────┐ │ │
│  │  │  Kibana              │  │  Cloud Monitoring    │  │  Cloud Logging   │ │ │
│  │  │  Dashboards          │  │  (Metrics)           │  │  (Logs)          │ │ │
│  │  │                      │  │                      │  │                  │ │ │
│  │  │  • Risk Charts       │  │  • CPU/Memory Usage  │  │  • App Logs      │ │ │
│  │  │  • Compliance Trends │  │  • Latency Metrics   │  │  • Audit Trails  │ │ │
│  │  │  • Violation Patterns│  │  • Error Rates       │  │  • Debug Info    │ │ │
│  │  │  • Search Analytics  │  │  • Custom Alerts     │  │  • Stack Traces  │ │ │
│  │  │                      │  │                      │  │                  │ │ │
│  │  │  asia-south1         │  │  Global              │  │  Global          │ │ │
│  │  └──────────────────────┘  └──────────────────────┘  └──────────────────┘ │ │
│  └────────────────────────────────────────────────────────────────────────────┘ │
│                                                                                   │
└───────────────────────────────────────────────────────────────────────────────────┘
```

---

## 📄 Document Upload Flow

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                      DOCUMENT UPLOAD & ANALYSIS FLOW                          │
└──────────────────────────────────────────────────────────────────────────────┘

START
  │
  │ User selects PDF file
  ▼
┌─────────────────────┐
│  User Browser       │
│  (Web App)          │
└──────────┬──────────┘
           │
           │ POST /upload-pdf
           │ Content-Type: multipart/form-data
           │ Payload: {file: PDF, lang: "en"}
           ▼
┌─────────────────────┐
│  Frontend Service   │
│  (Next.js)          │
│                     │
│  [Validate File]    │
│  • Check size       │
│  • Check type       │
│  • Check format     │
└──────────┬──────────┘
           │
           │ Forward to Backend API
           │ POST /upload-pdf/
           ▼
┌─────────────────────────────────────┐
│  Backend Service (FastAPI)          │
│                                     │
│  [Receive Upload]                   │
│  • Validate request                 │
│  • Generate document ID             │
│  • Log upload event                 │
└──────────┬──────────────────────────┘
           │
           │ Extract text
           ▼
┌─────────────────────────────────────┐
│  PyMuPDF Processor                  │
│                                     │
│  [Extract Content]                  │
│  • Parse PDF structure              │
│  • Extract text from pages          │
│  • Identify clauses                 │
│  • Clean & normalize text           │
│                                     │
│  Output: List[Clause]               │
└──────────┬──────────────────────────┘
           │
           │ Store document
           ▼
┌─────────────────────────────────────┐
│  Cloud Storage (GCS)                │
│                                     │
│  [Store PDF]                        │
│  • Bucket: reglex-documents         │
│  • Path: /uploads/{doc_id}.pdf      │
│  • Metadata: timestamp, user, etc.  │
│  • Versioning: Enabled              │
└──────────┬──────────────────────────┘
           │
           │ For each clause
           ▼
┌─────────────────────────────────────┐
│  Legal-BERT Embedder                │
│                                     │
│  [Generate Embeddings]              │
│  • Tokenize clause text             │
│  • Run through Legal-BERT model     │
│  • Output: 768-dimensional vector   │
│  • Normalize vector                 │
│                                     │
│  Processing: ~50ms per clause       │
└──────────┬──────────────────────────┘
           │
           │ Search for regulations
           ▼
┌─────────────────────────────────────┐
│  Elasticsearch Cluster              │
│                                     │
│  [Hybrid Search]                    │
│  ┌─────────────────────────────┐   │
│  │  BM25 Search (Lexical)      │   │
│  │  • Keyword matching         │   │
│  │  • Fuzzy matching           │   │
│  │  • Field boosting           │   │
│  └─────────────────────────────┘   │
│           +                         │
│  ┌─────────────────────────────┐   │
│  │  kNN Search (Semantic)      │   │
│  │  • Cosine similarity        │   │
│  │  • 768-dim vector space     │   │
│  │  • HNSW algorithm           │   │
│  └─────────────────────────────┘   │
│           =                         │
│  Top 5 relevant regulations         │
│  with relevance scores              │
└──────────┬──────────────────────────┘
           │
           │ For each clause + regulations
           ▼
┌─────────────────────────────────────┐
│  Vertex AI (Gemini Pro)             │
│                                     │
│  [Compliance Verification]          │
│  ┌─────────────────────────────┐   │
│  │  Input:                     │   │
│  │  • Clause text              │   │
│  │  • Top 5 regulations        │   │
│  │  • Context/metadata         │   │
│  └─────────────────────────────┘   │
│           ↓                         │
│  ┌─────────────────────────────┐   │
│  │  LLM Analysis:              │   │
│  │  • Check compliance         │   │
│  │  • Identify violations      │   │
│  │  • Assess risk level        │   │
│  │  • Generate explanation     │   │
│  │  • Provide recommendations  │   │
│  └─────────────────────────────┘   │
│           ↓                         │
│  ┌─────────────────────────────┐   │
│  │  Output:                    │   │
│  │  • compliant: true/false    │   │
│  │  • risk_level: Low/Med/High │   │
│  │  • risk_score: 0.0-1.0      │   │
│  │  • explanation: text        │   │
│  │  • regulation_matched: ID   │   │
│  └─────────────────────────────┘   │
│                                     │
│  Processing: ~2.5s per clause       │
└──────────┬──────────────────────────┘
           │
           │ Store results (3 destinations)
           ├────────────────────┬───────────────────┐
           │                    │                   │
           ▼                    ▼                   ▼
┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
│  Backend Memory │  │  Elasticsearch  │  │  Fivetran Queue │
│  (Session)      │  │  Index          │  │  (Pending Sync) │
│                 │  │                 │  │                 │
│  • Temp storage │  │  • Index results│  │  • Queue for    │
│  • User session │  │  • Make          │  │    BigQuery     │
│  • Quick access │  │    searchable   │  │    sync         │
│                 │  │  • Enable       │  │  • Hourly batch │
│                 │  │    analytics    │  │                 │
└─────────┬───────┘  └─────────────────┘  └────────┬────────┘
          │                                         │
          │                                         │ Hourly sync
          │                                         ▼
          │                              ┌─────────────────────┐
          │                              │  BigQuery Tables    │
          │                              │  • analyses         │
          │                              │  • verifications    │
          │                              │  • risk_metrics     │
          │                              └─────────────────────┘
          │
          │ Return response
          ▼
┌─────────────────────┐
│  Frontend Service   │
│  (Display Results)  │
│                     │
│  • Compliance score │
│  • Risk level       │
│  • Clause breakdown │
│  • Violations       │
│  • Recommendations  │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  User Browser       │
│  (Results Page)     │
│                     │
│  • Visual dashboard │
│  • Charts & graphs  │
│  • Downloadable PDF │
└─────────────────────┘
           │
           ▼
END
```

**Flow Metrics:**
- **Total Time**: 6-10 seconds (10 clauses)
- **Bottlenecks**: LLM verification (2.5s per clause)
- **Parallelization**: Up to 5 clauses at once
- **Success Rate**: 98.5%

---

## ✅ Compliance Analysis Flow

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                        COMPLIANCE ANALYSIS DETAILED FLOW                      │
└──────────────────────────────────────────────────────────────────────────────┘

INPUT: Single Clause + Document Context
  │
  ▼
┌─────────────────────────────────────────┐
│  Step 1: Clause Preprocessing           │
│                                         │
│  [Text Normalization]                   │
│  • Remove special characters            │
│  • Normalize whitespace                 │
│  • Fix encoding issues                  │
│  • Identify clause number               │
│                                         │
│  Output: Cleaned clause text            │
└──────────┬──────────────────────────────┘
           │
           ▼
┌─────────────────────────────────────────┐
│  Step 2: Generate Semantic Embedding    │
│                                         │
│  [Legal-BERT Processing]                │
│  • Tokenize: [CLS] + tokens + [SEP]     │
│  • Max length: 512 tokens               │
│  • Generate embedding (768-dim)         │
│  • L2 normalization                     │
│                                         │
│  Output: query_vector (768-dim)         │
└──────────┬──────────────────────────────┘
           │
           ▼
┌─────────────────────────────────────────┐
│  Step 3: Retrieve Relevant Regulations  │
│                                         │
│  [Elasticsearch Hybrid Query]           │
│  ┌───────────────────────────────────┐ │
│  │  Query Structure:                 │ │
│  │  {                                │ │
│  │    "bool": {                      │ │
│  │      "should": [                  │ │
│  │        {                          │ │
│  │          "multi_match": {         │ │
│  │            "query": clause_text,  │ │
│  │            "fields": [            │ │
│  │              "regulation_text^2", │ │
│  │              "section^1.5"        │ │
│  │            ],                     │ │
│  │            "fuzziness": "AUTO"    │ │
│  │          }                        │ │
│  │        },                         │ │
│  │        {                          │ │
│  │          "script_score": {        │ │
│  │            "query": {...},        │ │
│  │            "script": {            │ │
│  │              "source":            │ │
│  │              "cosineSimilarity(   │ │
│  │                params.query_vec,  │ │
│  │                'regulation_vec'   │ │
│  │              ) + 1.0"             │ │
│  │            }                      │ │
│  │          }                        │ │
│  │        }                          │ │
│  │      ]                            │ │
│  │    },                             │ │
│  │    "size": 5                      │ │
│  │  }                                │ │
│  └───────────────────────────────────┘ │
│                                         │
│  Output: Top 5 regulations with scores  │
└──────────┬──────────────────────────────┘
           │
           ▼
┌─────────────────────────────────────────┐
│  Step 4: Build LLM Prompt               │
│                                         │
│  [Prompt Engineering]                   │
│  ┌───────────────────────────────────┐ │
│  │  System Prompt:                   │ │
│  │  "You are an expert SEBI           │ │
│  │   compliance analyst..."           │ │
│  │                                    │ │
│  │  Context:                          │ │
│  │  "Relevant regulations:            │ │
│  │   1. [Regulation 1 text]           │ │
│  │   2. [Regulation 2 text]           │ │
│  │   ..."                             │ │
│  │                                    │ │
│  │  Task:                             │ │
│  │  "Analyze this clause:             │ │
│  │   [Clause text]                    │ │
│  │                                    │ │
│  │   Determine:                       │ │
│  │   - Is it compliant?               │ │
│  │   - Which regulation applies?      │ │
│  │   - What's the risk level?         │ │
│  │   - Provide explanation            │ │
│  │                                    │ │
│  │   Output format: JSON {...}"       │ │
│  └───────────────────────────────────┘ │
│                                         │
│  Output: Formatted prompt (2K tokens)   │
└──────────┬──────────────────────────────┘
           │
           ▼
┌─────────────────────────────────────────┐
│  Step 5: LLM Inference                  │
│                                         │
│  [Vertex AI - Gemini Pro]              │
│  • Model: gemini-1.5-pro                │
│  • Temperature: 0.1 (consistent)        │
│  • Max output: 1024 tokens              │
│  • Top-p: 0.95                          │
│                                         │
│  [Processing]                           │
│  • Send prompt to Vertex AI API         │
│  • Wait for streaming response          │
│  • Parse JSON output                    │
│                                         │
│  [Fallback Logic]                       │
│  IF Vertex AI fails:                    │
│    → Try Claude (Anthropic)             │
│  IF Claude fails:                       │
│    → Try OpenAI GPT-4                   │
│  IF all fail:                           │
│    → Return error with cached result    │
│                                         │
│  Output: LLM response (JSON)            │
└──────────┬──────────────────────────────┘
           │
           ▼
┌─────────────────────────────────────────┐
│  Step 6: Parse & Validate Response      │
│                                         │
│  [Response Parsing]                     │
│  Expected structure:                    │
│  {                                      │
│    "compliant": boolean,                │
│    "regulation_matched": string,        │
│    "risk_level": "Low|Medium|High",     │
│    "risk_score": float (0.0-1.0),       │
│    "explanation": string,               │
│    "recommendations": [string]          │
│  }                                      │
│                                         │
│  [Validation]                           │
│  • Check all required fields present    │
│  • Validate data types                  │
│  • Clamp risk_score to [0, 1]           │
│  • Sanitize text fields                 │
│                                         │
│  Output: Validated result object        │
└──────────┬──────────────────────────────┘
           │
           ▼
┌─────────────────────────────────────────┐
│  Step 7: Risk Assessment                │
│                                         │
│  [Multi-Dimensional Risk Scoring]       │
│  ┌───────────────────────────────────┐ │
│  │  Factor 1: Violation Severity     │ │
│  │  • Critical: 0.8-1.0              │ │
│  │  • High: 0.6-0.8                  │ │
│  │  • Medium: 0.3-0.6                │ │
│  │  • Low: 0.0-0.3                   │ │
│  └───────────────────────────────────┘ │
│  ┌───────────────────────────────────┐ │
│  │  Factor 2: Regulation Importance  │ │
│  │  • SEBI LODR: High weight         │ │
│  │  • SEBI ICDR: Medium weight       │ │
│  │  • Others: Lower weight           │ │
│  └───────────────────────────────────┘ │
│  ┌───────────────────────────────────┐ │
│  │  Factor 3: Confidence Score       │ │
│  │  • Elastic relevance score        │ │
│  │  • LLM confidence                 │ │
│  │  • Combined score                 │ │
│  └───────────────────────────────────┘ │
│                                         │
│  Final Risk Score = weighted_average(   │
│    severity, importance, confidence     │
│  )                                      │
│                                         │
│  Output: Final risk_score (0.0-1.0)     │
└──────────┬──────────────────────────────┘
           │
           ▼
┌─────────────────────────────────────────┐
│  Step 8: Store Results                  │
│                                         │
│  [Multi-Destination Storage]            │
│  ┌───────────────────────────────────┐ │
│  │  Destination 1: Session Memory    │ │
│  │  • In-memory dict                 │ │
│  │  • Key: document_id               │ │
│  │  • TTL: 1 hour                    │ │
│  │  • Purpose: Fast retrieval        │ │
│  └───────────────────────────────────┘ │
│  ┌───────────────────────────────────┐ │
│  │  Destination 2: Elasticsearch     │ │
│  │  • Index: compliance_results      │ │
│  │  • Document: full result          │ │
│  │  • Purpose: Search & analytics    │ │
│  └───────────────────────────────────┘ │
│  ┌───────────────────────────────────┐ │
│  │  Destination 3: Fivetran Queue    │ │
│  │  • Queue for BigQuery sync        │ │
│  │  • Batch: hourly                  │ │
│  │  • Purpose: Long-term analytics   │ │
│  └───────────────────────────────────┘ │
│                                         │
│  Output: Stored successfully            │
└──────────┬──────────────────────────────┘
           │
           ▼
┌─────────────────────────────────────────┐
│  Step 9: Generate Response              │
│                                         │
│  [API Response Construction]            │
│  {                                      │
│    "status": "success",                 │
│    "document_id": "abc123",             │
│    "clause_number": 5,                  │
│    "compliance": {                      │
│      "compliant": true,                 │
│      "regulation": "SEBI LODR Reg 43",  │
│      "risk_level": "Low",               │
│      "risk_score": 0.15,                │
│      "explanation": "...",              │
│      "recommendations": [...]           │
│    },                                   │
│    "processing_time_ms": 2500,          │
│    "timestamp": "2025-01-15T10:30:00Z"  │
│  }                                      │
│                                         │
│  Output: JSON response                  │
└──────────┬──────────────────────────────┘
           │
           ▼
OUTPUT: Compliance Analysis Result
```

**Decision Points:**
- **Compliant?** → Green badge, low priority
- **Non-compliant?** → Red badge, high priority alert
- **Uncertain?** → Yellow badge, manual review required

---

## 💬 Conversational Agent Flow

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                      CONVERSATIONAL AGENT (CHAT) FLOW                         │
└──────────────────────────────────────────────────────────────────────────────┘

START: User asks question
  │
  │ Example: "What are the disclosure requirements for IPOs?"
  ▼
┌─────────────────────────────────────┐
│  Frontend (Chat Interface)          │
│                                     │
│  [User Input]                       │
│  • Text input field                 │
│  • Send button clicked              │
│  • Show typing indicator            │
└──────────┬──────────────────────────┘
           │
           │ POST /api/chat
           │ {
           │   "message": "What are...",
           │   "conversation_id": "xyz",
           │   "history": [...]
           │ }
           ▼
┌─────────────────────────────────────┐
│  Backend API (/api/chat)            │
│                                     │
│  [Request Processing]               │
│  • Validate input                   │
│  • Load conversation history        │
│  • Extract user intent              │
│  • Log interaction                  │
└──────────┬──────────────────────────┘
           │
           ▼
┌─────────────────────────────────────┐
│  Intent Classification              │
│                                     │
│  [Analyze Query Type]               │
│  ┌─────────────────────────────┐   │
│  │ Type 1: Direct Question     │   │
│  │ "What is SEBI Regulation X?"│   │
│  │ → Search regulations        │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ Type 2: Document Query      │   │
│  │ "Is my document compliant?" │   │
│  │ → Retrieve analysis results │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ Type 3: Clarification       │   │
│  │ "What does that mean?"      │   │
│  │ → Use conversation context  │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ Type 4: General Info        │   │
│  │ "How does RegLex work?"     │   │
│  │ → Use system knowledge      │   │
│  └─────────────────────────────┘   │
│                                     │
│  Output: intent_type + params       │
└──────────┬──────────────────────────┘
           │
           ▼
┌─────────────────────────────────────┐
│  Generate Query Embedding           │
│                                     │
│  [Legal-BERT Encoding]              │
│  • Encode user question             │
│  • Include conversation context     │
│  • Generate 768-dim vector          │
│                                     │
│  Output: query_vector               │
└──────────┬──────────────────────────┘
           │
           ▼
┌─────────────────────────────────────┐
│  Retrieve Context (RAG)             │
│                                     │
│  [Elasticsearch Retrieval]          │
│  ┌─────────────────────────────┐   │
│  │  Search Scope:              │   │
│  │  • SEBI regulations index   │   │
│  │  • Past analyses (user's)   │   │
│  │  • Knowledge base articles  │   │
│  └─────────────────────────────┘   │
│                                     │
│  [Hybrid Search]                    │
│  • BM25 keyword search              │
│  • kNN vector similarity            │
│  • Combine scores                   │
│  • Rank results                     │
│                                     │
│  Output: Top 10 relevant docs       │
└──────────┬──────────────────────────┘
           │
           ▼
┌─────────────────────────────────────┐
│  Build Conversational Prompt        │
│                                     │
│  [Prompt Construction]              │
│  ┌─────────────────────────────┐   │
│  │  System Instructions:       │   │
│  │  "You are an AI assistant   │   │
│  │   specialized in SEBI        │   │
│  │   compliance. Answer         │   │
│  │   questions accurately       │   │
│  │   using provided context."   │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │  Conversation History:      │   │
│  │  User: "What is LODR?"      │   │
│  │  AI: "LODR stands for..."   │   │
│  │  [Last 5 exchanges]         │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │  Retrieved Context:         │   │
│  │  Doc 1: [Regulation text]   │   │
│  │  Doc 2: [Analysis result]   │   │
│  │  Doc 3: [KB article]        │   │
│  │  [Top 10 docs]              │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │  Current Question:          │   │
│  │  "What are disclosure       │   │
│  │   requirements for IPOs?"   │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │  Output Instructions:       │   │
│  │  • Be concise              │   │
│  │  • Cite sources            │   │
│  │  • Use bullet points       │   │
│  │  • Provide examples        │   │
│  └─────────────────────────────┘   │
│                                     │
│  Output: Complete prompt (4K tokens)│
└──────────┬──────────────────────────┘
           │
           ▼
┌─────────────────────────────────────┐
│  LLM Generation                     │
│                                     │
│  [Vertex AI - Gemini Pro]           │
│  • Model: gemini-1.5-pro            │
│  • Temperature: 0.3 (balanced)      │
│  • Max tokens: 2048                 │
│  • Stream: true (real-time)         │
│                                     │
│  [Streaming Response]               │
│  Token 1 → Frontend                 │
│  Token 2 → Frontend                 │
│  Token 3 → Frontend                 │
│  ...                                │
│                                     │
│  [Response Format]                  │
│  "IPO disclosure requirements       │
│   under SEBI ICDR:                  │
│                                     │
│   1. **Financial Disclosures**      │
│      • 3 years of audited...        │
│                                     │
│   2. **Risk Factors**               │
│      • Material risks must...       │
│                                     │
│   Sources:                          │
│   - SEBI ICDR Regulation 26         │
│   - SEBI ICDR Regulation 30"        │
│                                     │
│  Output: Formatted response         │
└──────────┬──────────────────────────┘
           │
           ▼
┌─────────────────────────────────────┐
│  Post-Processing                    │
│                                     │
│  [Enhancements]                     │
│  • Add citation links               │
│  • Highlight regulation IDs         │
│  • Add "Related Questions"          │
│  • Format markdown                  │
│                                     │
│  [Conversation Management]          │
│  • Save exchange to history         │
│  • Update conversation context      │
│  • Track user satisfaction          │
│                                     │
│  Output: Enhanced response          │
└──────────┬──────────────────────────┘
           │
           │ Return JSON
           │ {
           │   "response": "...",
           │   "sources": [...],
           │   "related": [...],
           │   "conversation_id": "xyz"
           │ }
           ▼
┌─────────────────────────────────────┐
│  Frontend (Display Response)        │
│                                     │
│  [Render Components]                │
│  • Message bubble                   │
│  • Source citations (clickable)     │
│  • Related questions (chips)        │
│  • Feedback buttons (👍 👎)         │
│                                     │
│  [User Actions]                     │
│  • Read response                    │
│  • Click sources → View regulation  │
│  • Click related → Ask question     │
│  • Provide feedback                 │
└──────────┬──────────────────────────┘
           │
           ▼
END: Conversation continues...
```

**Conversation Features:**
- **Multi-turn dialogue**: Maintains context across messages
- **Source citations**: Every claim linked to regulation
- **Follow-up suggestions**: Proactive related questions
- **Feedback loop**: User ratings improve responses

---

## 🔄 Data Pipeline Flow

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                      FIVETRAN DATA PIPELINE FLOW                              │
└──────────────────────────────────────────────────────────────────────────────┘

TRIGGER: Hourly Schedule (00:00, 01:00, 02:00, ...)
  │
  ▼
┌─────────────────────────────────────┐
│  Fivetran Scheduler                 │
│                                     │
│  [Check Sync Schedule]              │
│  • Current time: 14:00 UTC          │
│  • Last sync: 13:00 UTC             │
│  • Next sync due: Yes               │
│  • Initiate connector               │
└──────────┬──────────────────────────┘
           │
           ▼
┌─────────────────────────────────────┐
│  Fivetran Connector (Python SDK)    │
│                                     │
│  [Initialize]                       │
│  • Load connector config            │
│  • Authenticate with source API     │
│  • Authenticate with BigQuery       │
│  • Check last sync state            │
└──────────┬──────────────────────────┘
           │
           │ Extract Phase
           ▼
┌─────────────────────────────────────┐
│  Extract: Compliance Analyses       │
│                                     │
│  [API Call]                         │
│  GET /api/analytics/documents       │
│  ?since=2025-01-15T13:00:00Z        │
│                                     │
│  [Backend Response]                 │
│  {                                  │
│    "analyses": [                    │
│      {                              │
│        "document_id": "abc123",     │
│        "document_name": "loan.pdf", │
│        "upload_timestamp": "...",   │
│        "compliance_score": 0.94,    │
│        "risk_level": "Low",         │
│        "total_clauses": 12,         │
│        "violations_count": 0        │
│      },                             │
│      ...                            │
│    ],                               │
│    "count": 15,                     │
│    "next_cursor": null              │
│  }                                  │
│                                     │
│  Output: 15 new analysis records    │
└──────────┬──────────────────────────┘
           │
           ▼
┌─────────────────────────────────────┐
│  Extract: Clause Verifications      │
│                                     │
│  [API Call]                         │
│  GET /api/analytics/clauses         │
│  ?since=2025-01-15T13:00:00Z        │
│                                     │
│  [Backend Response]                 │
│  {                                  │
│    "verifications": [               │
│      {                              │
│        "clause_id": "c1",           │
│        "document_id": "abc123",     │
│        "clause_number": 1,          │
│        "clause_text": "...",        │
│        "regulation_matched":        │
│          "SEBI LODR Reg 43",        │
│        "compliant": true,           │
│        "risk_score": 0.12,          │
│        "explanation": "..."         │
│      },                             │
│      ...                            │
│    ],                               │
│    "count": 180                     │
│  }                                  │
│                                     │
│  Output: 180 new clause records     │
└──────────┬──────────────────────────┘
           │
           ▼
┌─────────────────────────────────────┐
│  Extract: Risk Metrics              │
│                                     │
│  [API Call]                         │
│  GET /api/analytics/risks           │
│  ?since=2025-01-15T13:00:00Z        │
│                                     │
│  [Backend Response]                 │
│  {                                  │
│    "metrics": [                     │
│      {                              │
│        "metric_id": "m1",           │
│        "document_id": "abc123",     │
│        "risk_category": "Legal",    │
│        "severity": "Low",           │
│        "affected_clauses": [...],   │
│        "mitigation_required": false │
│      },                             │
│      ...                            │
│    ],                               │
│    "count": 22                      │
│  }                                  │
│                                     │
│  Output: 22 new risk records        │
└──────────┬──────────────────────────┘
           │
           │ Transform Phase
           ▼
┌─────────────────────────────────────┐
│  Transform Data                     │
│                                     │
│  [Schema Mapping]                   │
│  API Field → BigQuery Column        │
│  • document_id → STRING             │
│  • upload_timestamp → TIMESTAMP     │
│  • compliance_score → FLOAT64       │
│  • risk_level → STRING              │
│  ...                                │
│                                     │
│  [Data Validation]                  │
│  • Check required fields            │
│  • Validate data types              │
│  • Handle null values               │
│  • Sanitize text fields             │
│                                     │
│  [Deduplication]                    │
│  • Check primary keys               │
│  • Skip duplicate records           │
│  • Track update timestamps          │
│                                     │
│  Output: Validated, transformed data│
└──────────┬──────────────────────────┘
           │
           │ Load Phase
           ▼
┌─────────────────────────────────────┐
│  Load: BigQuery Destination         │
│                                     │
│  [Table 1: compliance_analyses]     │
│  • INSERT 15 new rows               │
│  • UPDATE 3 existing rows           │
│  • Total rows: 125 → 137            │
│                                     │
│  [Table 2: clause_verifications]    │
│  • INSERT 180 new rows              │
│  • UPDATE 0 existing rows           │
│  • Total rows: 542 → 722            │
│                                     │
│  [Table 3: risk_metrics]            │
│  • INSERT 22 new rows               │
│  • UPDATE 5 existing rows           │
│  • Total rows: 89 → 106             │
│                                     │
│  [BigQuery Operations]              │
│  • Use streaming inserts            │
│  • Batch size: 500 rows             │
│  • Handle rate limits               │
│  • Retry on failure                 │
│                                     │
│  Output: Data loaded successfully   │
└──────────┬──────────────────────────┘
           │
           ▼
┌─────────────────────────────────────┐
│  Post-Load Operations               │
│                                     │
│  [Update Sync State]                │
│  • Record sync timestamp            │
│  • Store last cursor/offset         │
│  • Update row counts                │
│  • Calculate sync duration          │
│                                     │
│  [Data Quality Checks]              │
│  • Run validation queries           │
│  • Check for anomalies              │
│  • Verify referential integrity     │
│                                     │
│  [Notifications]                    │
│  IF errors > 0:                     │
│    → Send alert email               │
│  ELSE:                              │
│    → Log success                    │
│                                     │
│  Output: Sync complete              │
└──────────┬──────────────────────────┘
           │
           ▼
┌─────────────────────────────────────┐
│  Fivetran Dashboard Update          │
│                                     │
│  [Metrics]                          │
│  • Rows synced: 217                 │
│  • Duration: 45 seconds             │
│  • Next sync: 15:00 UTC             │
│  • Status: ✅ Success               │
│                                     │
│  [Logs]                             │
│  14:00:00 - Sync started            │
│  14:00:05 - Extracted 217 rows      │
│  14:00:15 - Transformed data        │
│  14:00:30 - Loaded to BigQuery      │
│  14:00:45 - Sync completed          │
└──────────┬──────────────────────────┘
           │
           ▼
┌─────────────────────────────────────┐
│  BigQuery Ready for Analytics       │
│                                     │
│  [Available Tables]                 │
│  • reglex_compliance.               │
│    compliance_analyses              │
│  • reglex_compliance.               │
│    clause_verifications             │
│  • reglex_compliance.               │
│    risk_metrics                     │
│                                     │
│  [Use Cases]                        │
│  • Power BI dashboards              │
│  • Looker reports                   │
│  • Custom SQL queries               │
│  • ML model training                │
└─────────────────────────────────────┘
           │
           ▼
END: Wait for next sync (15:00 UTC)
```

**Pipeline Metrics:**
- **Frequency**: Hourly
- **Latency**: < 1 minute
- **Throughput**: 200-500 rows/sync
- **Reliability**: 99.5% success rate

---

## 📊 Analytics Dashboard Flow

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                      ANALYTICS DASHBOARD DATA FLOW                            │
└──────────────────────────────────────────────────────────────────────────────┘

START: User opens Dashboard page
  │
  │ GET /dashboard/analytics
  ▼
┌─────────────────────────────────────┐
│  Frontend (Analytics Page)          │
│                                     │
│  [Page Load]                        │
│  • Show loading skeleton            │
│  • Initialize chart components      │
│  • Prepare data fetching            │
└──────────┬──────────────────────────┘
           │
           │ Parallel API Calls (3 requests)
           ├─────────────────┬──────────────────┐
           │                 │                  │
           ▼                 ▼                  ▼
┌───────────────┐  ┌──────────────────┐  ┌────────────────┐
│  Request 1    │  │  Request 2       │  │  Request 3     │
│               │  │                  │  │                │
│  GET /api/    │  │  GET /api/       │  │  GET /kibana/  │
│  dashboard/   │  │  analytics       │  │  dashboard     │
│  overview     │  │  (BigQuery data) │  │  (Elastic data)│
└───────┬───────┘  └────────┬─────────┘  └────────┬───────┘
        │                   │                     │
        │                   │                     │
        ▼                   ▼                     ▼
┌───────────────────────────────────────────────────────┐
│  Backend Processing (Parallel)                        │
│                                                        │
│  ┌──────────────────────────────────────────────┐    │
│  │  Handler 1: Overview Metrics                 │    │
│  │                                              │    │
│  │  [Query Elasticsearch]                       │    │
│  │  GET _search {                               │    │
│  │    "aggs": {                                 │    │
│  │      "total_docs": {"value_count": ...},     │    │
│  │      "avg_compliance": {"avg": ...},         │    │
│  │      "risk_dist": {"terms": ...}             │    │
│  │    }                                         │    │
│  │  }                                           │    │
│  │                                              │    │
│  │  Response:                                   │    │
│  │  {                                           │    │
│  │    "total_documents": 125,                   │    │
│  │    "avg_compliance_score": 0.942,            │    │
│  │    "high_risk_count": 3,                     │    │
│  │    "risk_distribution": {                    │    │
│  │      "Low": 98,                              │    │
│  │      "Medium": 24,                           │    │
│  │      "High": 3                               │    │
│  │    }                                         │    │
│  │  }                                           │    │
│  └──────────────────────────────────────────────┘    │
│                                                        │
│  ┌──────────────────────────────────────────────┐    │
│  │  Handler 2: Analytics (BigQuery)             │    │
│  │                                              │    │
│  │  [Query 1: Compliance Trend]                 │    │
│  │  SELECT                                      │    │
│  │    DATE(upload_timestamp) as date,           │    │
│  │    AVG(overall_compliance_score) as score    │    │
│  │  FROM reglex_compliance.                     │    │
│  │       compliance_analyses                    │    │
│  │  WHERE upload_timestamp >= DATE_SUB(         │    │
│  │    CURRENT_DATE(), INTERVAL 30 DAY           │    │
│  │  )                                           │    │
│  │  GROUP BY date                               │    │
│  │  ORDER BY date;                              │    │
│  │                                              │    │
│  │  [Query 2: Common Violations]                │    │
│  │  SELECT                                      │    │
│  │    regulation_matched,                       │    │
│  │    COUNT(*) as count                         │    │
│  │  FROM reglex_compliance.                     │    │
│  │       clause_verifications                   │    │
│  │  WHERE compliant = FALSE                     │    │
│  │  GROUP BY regulation_matched                 │    │
│  │  ORDER BY count DESC                         │    │
│  │  LIMIT 10;                                   │    │
│  │                                              │    │
│  │  Response:                                   │    │
│  │  {                                           │    │
│  │    "trend": [{date, score}, ...],            │    │
│  │    "violations": [{reg, count}, ...]         │    │
│  │  }                                           │    │
│  └──────────────────────────────────────────────┘    │
│                                                        │
│  ┌──────────────────────────────────────────────┐    │
│  │  Handler 3: Kibana Dashboard Data            │    │
│  │                                              │    │
│  │  [Query Elasticsearch Aggregations]          │    │
│  │  • Search query performance                  │    │
│  │  • Index statistics                          │    │
│  │  • Real-time metrics                         │    │
│  │                                              │    │
│  │  Response:                                   │    │
│  │  {                                           │    │
│  │    "search_performance": {                   │    │
│  │      "avg_latency_ms": 180,                  │    │
│  │      "total_queries": 1543                   │    │
│  │    },                                        │    │
│  │    "index_stats": {                          │    │
│  │      "doc_count": 10247,                     │    │
│  │      "size_mb": 125.3                        │    │
│  │    }                                         │    │
│  │  }                                           │    │
│  └──────────────────────────────────────────────┘    │
└────────────────────────┬───────────────────────────────┘
                         │
                         │ Combine responses
                         ▼
┌─────────────────────────────────────┐
│  Frontend (Render Dashboard)        │
│                                     │
│  [Component 1: Metrics Cards]       │
│  ┌───────────────────────────────┐ │
│  │  📄 Total Documents: 125      │ │
│  │  ✅ Avg Compliance: 94.2%     │ │
│  │  ⚠️  High Risk: 3             │ │
│  └───────────────────────────────┘ │
│                                     │
│  [Component 2: Risk Pie Chart]      │
│  ┌───────────────────────────────┐ │
│  │        Risk Distribution      │ │
│  │                               │ │
│  │      🟢 Low: 78%              │ │
│  │      🟡 Medium: 19%           │ │
│  │      🔴 High: 3%              │ │
│  │                               │ │
│  │      [Pie Chart Visual]       │ │
│  └───────────────────────────────┘ │
│                                     │
│  [Component 3: Trend Line Chart]    │
│  ┌───────────────────────────────┐ │
│  │   Compliance Score Over Time  │ │
│  │                               │ │
│  │  100% │        ╱─╲            │ │
│  │       │      ╱     ╲          │ │
│  │   90% │    ╱         ─        │ │
│  │       │  ╱                    │ │
│  │   80% │╱                      │ │
│  │       └──────────────────────  │ │
│  │       Jan  Feb  Mar  Apr  May │ │
│  └───────────────────────────────┘ │
│                                     │
│  [Component 4: Violations Table]    │
│  ┌───────────────────────────────┐ │
│  │  Most Common Violations       │ │
│  │  ────────────────────────────  │ │
│  │  SEBI LODR Reg 43      12     │ │
│  │  SEBI ICDR Reg 26       8     │ │
│  │  SEBI PIT Reg 7         5     │ │
│  │  ...                          │ │
│  └───────────────────────────────┘ │
│                                     │
│  [Component 5: Fivetran Status]     │
│  ┌───────────────────────────────┐ │
│  │  Data Pipeline Status         │ │
│  │  ────────────────────────────  │ │
│  │  Last Sync: 2 min ago ✅      │ │
│  │  Next Sync: 58 min            │ │
│  │  Rows Synced: 217             │ │
│  │  Status: Healthy              │ │
│  └───────────────────────────────┘ │
└─────────────────────────────────────┘
           │
           ▼
END: Dashboard fully rendered
```

**Dashboard Features:**
- **Real-time updates**: Refresh every 30 seconds
- **Interactive charts**: Click to drill down
- **Export options**: Download as PDF or CSV
- **Responsive design**: Mobile-friendly

---

## ❌ Error Handling Flow

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                         ERROR HANDLING & RECOVERY FLOW                        │
└──────────────────────────────────────────────────────────────────────────────┘

ERROR OCCURS
  │
  ├─── Case 1: Elasticsearch Unavailable
  │     │
  │     ▼
  │    ┌─────────────────────────────────┐
  │    │  [Detect]                       │
  │    │  • Connection timeout           │
  │    │  • Cluster unhealthy            │
  │    └──────────┬──────────────────────┘
  │               │
  │               ▼
  │    ┌─────────────────────────────────┐
  │    │  [Fallback Strategy]            │
  │    │  1. Retry with exponential      │
  │    │     backoff (3 attempts)        │
  │    │  2. Use cached results          │
  │    │  3. Degrade gracefully          │
  │    └──────────┬──────────────────────┘
  │               │
  │               ▼
  │    ┌─────────────────────────────────┐
  │    │  [Recovery]                     │
  │    │  • Alert monitoring system      │
  │    │  • Log error with context       │
  │    │  • Return cached/partial data   │
  │    │  • Show user-friendly message   │
  │    └─────────────────────────────────┘
  │
  ├─── Case 2: Vertex AI API Failure
  │     │
  │     ▼
  │    ┌─────────────────────────────────┐
  │    │  [Detect]                       │
  │    │  • API rate limit exceeded      │
  │    │  • Authentication failure       │
  │    │  • Model unavailable            │
  │    └──────────┬──────────────────────┘
  │               │
  │               ▼
  │    ┌─────────────────────────────────┐
  │    │  [Fallback Strategy]            │
  │    │  1. Try Claude (Anthropic)      │
  │    │  2. Try OpenAI GPT-4            │
  │    │  3. Use rule-based checker      │
  │    └──────────┬──────────────────────┘
  │               │
  │               ▼
  │    ┌─────────────────────────────────┐
  │    │  [Recovery]                     │
  │    │  • Switch to backup LLM         │
  │    │  • Continue processing          │
  │    │  • Log provider switch          │
  │    │  • Monitor costs                │
  │    └─────────────────────────────────┘
  │
  ├─── Case 3: BigQuery Sync Failure
  │     │
  │     ▼
  │    ┌─────────────────────────────────┐
  │    │  [Detect]                       │
  │    │  • Fivetran connector error     │
  │    │  • Schema mismatch              │
  │    │  • Quota exceeded               │
  │    └──────────┬──────────────────────┘
  │               │
  │               ▼
  │    ┌─────────────────────────────────┐
  │    │  [Fallback Strategy]            │
  │    │  1. Queue data locally          │
  │    │  2. Retry in next sync cycle    │
  │    │  3. Alert data team             │
  │    └──────────┬──────────────────────┘
  │               │
  │               ▼
  │    ┌─────────────────────────────────┐
  │    │  [Recovery]                     │
  │    │  • Store in temporary queue     │
  │    │  • Auto-retry on next sync      │
  │    │  • No data loss                 │
  │    │  • Email notification sent      │
  │    └─────────────────────────────────┘
  │
  └─── Case 4: PDF Parsing Error
        │
        ▼
       ┌─────────────────────────────────┐
       │  [Detect]                       │
       │  • Corrupted PDF                │
       │  • Encrypted/password-protected │
       │  • Unsupported format           │
       └──────────┬──────────────────────┘
                  │
                  ▼
       ┌─────────────────────────────────┐
       │  [Fallback Strategy]            │
       │  1. Try alternative parser      │
       │  2. Extract images via OCR      │
       │  3. Return partial results      │
       └──────────┬──────────────────────┘
                  │
                  ▼
       ┌─────────────────────────────────┐
       │  [Recovery]                     │
       │  • Notify user of issue         │
       │  • Provide manual upload option │
       │  • Log for manual review        │
       │  • Refund credits (if paid)     │
       └─────────────────────────────────┘
```

**Error Recovery Principles:**
- **Graceful Degradation**: Partial results > no results
- **Retry with Backoff**: 3 attempts with exponential delay
- **Fallback Providers**: Multiple LLM options
- **User Communication**: Clear, actionable error messages

---

## 🔗 Component Interaction Matrix

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                      COMPONENT INTERACTION MATRIX                             │
└──────────────────────────────────────────────────────────────────────────────┘

                            ┌───────────────────────────────────────┐
                            │       Component Relationships         │
                            └───────────────────────────────────────┘

┌────────────┬───────────────┬──────────────┬──────────────┬──────────────┐
│            │   Frontend    │   Backend    │ Elasticsearch│  Vertex AI   │
├────────────┼───────────────┼──────────────┼──────────────┼──────────────┤
│ Frontend   │      -        │ HTTPS REST   │      -       │      -       │
│            │               │ WebSocket    │              │              │
├────────────┼───────────────┼──────────────┼──────────────┼──────────────┤
│ Backend    │ JSON Response │      -       │ Hybrid Search│ LLM API      │
│            │               │              │ Aggregations │ Streaming    │
├────────────┼───────────────┼──────────────┼──────────────┼──────────────┤
│Elasticsearch│      -        │ Python Client│      -       │      -       │
│            │               │ API Key Auth │              │              │
├────────────┼───────────────┼──────────────┼──────────────┼──────────────┤
│ Vertex AI  │      -        │ Google SDK   │      -       │      -       │
│            │               │ OAuth 2.0    │              │              │
├────────────┼───────────────┼──────────────┼──────────────┼──────────────┤
│ BigQuery   │ Direct Query  │ Python Client│      -       │      -       │
│            │               │ Service Acct │              │              │
├────────────┼───────────────┼──────────────┼──────────────┼──────────────┤
│  Fivetran  │ Dashboard UI  │ REST API     │      -       │      -       │
│            │               │ Polling      │              │              │
├────────────┼───────────────┼──────────────┼──────────────┼──────────────┤
│  Kibana    │ Embedded      │ REST API     │ Native       │      -       │
│            │ iFrames       │              │ Integration  │              │
└────────────┴───────────────┴──────────────┴──────────────┴──────────────┘

Communication Protocols:
  • HTTPS REST API (synchronous)
  • WebSocket (real-time streaming)
  • gRPC (internal services)
  • Event-driven (pub/sub for async)

Authentication Methods:
  • API Keys (Elasticsearch, Gemini)
  • OAuth 2.0 (Google services)
  • Service Accounts (GCP)
  • JWT tokens (user sessions)
```

---

## 📈 Flow Summary

### Key Flows
1. **Document Upload**: User → Frontend → Backend → Storage → AI → Results
2. **Compliance Analysis**: Clause → Embeddings → Search → LLM → Verification
3. **Chat**: Question → Context Retrieval → LLM → Formatted Response
4. **Data Pipeline**: Backend API → Fivetran → BigQuery (hourly)
5. **Analytics**: BigQuery + Elastic → Dashboard Visualization

### Performance Targets
- **Upload & Analysis**: < 10 seconds (10 clauses)
- **Chat Response**: < 3 seconds (streaming)
- **Dashboard Load**: < 2 seconds
- **Data Sync**: < 1 minute (hourly)

### Reliability Measures
- **Retry Logic**: 3 attempts with exponential backoff
- **Fallback Providers**: Multiple LLM options
- **Caching**: Redis for frequent queries
- **Monitoring**: Real-time alerts on failures

---

**Built for Google Accelerate Hackathon 2025**
**RegLex AI - Transforming Legal Compliance Through AI**

🔄 **Complete System Flows** | 📊 **Visual Documentation** | ⚡ **Production-Ready**
