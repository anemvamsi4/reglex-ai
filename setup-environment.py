#!/usr/bin/env python3
"""
RegLex AI - Environment Configuration Helper
Guides users through setting up environment variables for the hackathon project
"""

import os
import sys
from pathlib import Path


class Colors:
    """ANSI color codes"""
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    BLUE = '\033[94m'
    BOLD = '\033[1m'
    END = '\033[0m'


def print_header():
    """Print welcome header"""
    print(f"\n{Colors.BLUE}{Colors.BOLD}╔════════════════════════════════════════════════════════════════╗")
    print("║           RegLex AI - Environment Setup Helper                ║")
    print("║         Google Accelerate Hackathon - Elastic Challenge       ║")
    print(f"╚════════════════════════════════════════════════════════════════╝{Colors.END}\n")


def check_file_exists(filepath: str) -> bool:
    """Check if file exists"""
    return Path(filepath).exists()


def check_credentials():
    """Check Google Cloud credentials"""
    print(f"{Colors.BOLD}1. Checking Google Cloud Credentials...{Colors.END}")
    
    cred_file = Path("reglex-ai-e84aa0d5da22.json")
    
    if cred_file.exists():
        print(f"   {Colors.GREEN}✅ Found: {cred_file}{Colors.END}")
        return str(cred_file)
    else:
        print(f"   {Colors.YELLOW}⚠️  Not found: {cred_file}{Colors.END}")
        print(f"   {Colors.YELLOW}   Please ensure your GCP credentials file is in the project root{Colors.END}")
        return None


def check_env_file():
    """Check if .env file exists"""
    print(f"\n{Colors.BOLD}2. Checking Environment File...{Colors.END}")
    
    backend_env = Path("Backend/.env")
    env_example = Path("Backend/.env.example")
    
    if backend_env.exists():
        print(f"   {Colors.GREEN}✅ Found: Backend/.env{Colors.END}")
        return True
    else:
        print(f"   {Colors.YELLOW}⚠️  Not found: Backend/.env{Colors.END}")
        
        if env_example.exists():
            print(f"   {Colors.BLUE}💡 Creating from template...{Colors.END}")
            try:
                import shutil
                shutil.copy(env_example, backend_env)
                print(f"   {Colors.GREEN}✅ Created: Backend/.env{Colors.END}")
                return True
            except Exception as e:
                print(f"   {Colors.RED}❌ Error: {e}{Colors.END}")
                return False
        else:
            print(f"   {Colors.RED}❌ Template not found: Backend/.env.example{Colors.END}")
            return False


def validate_env_vars():
    """Validate required environment variables"""
    print(f"\n{Colors.BOLD}3. Validating Required Variables...{Colors.END}")
    
    env_file = Path("Backend/.env")
    if not env_file.exists():
        print(f"   {Colors.RED}❌ .env file not found{Colors.END}")
        return False
    
    required_vars = {
        "ELASTICSEARCH_URL": "Elastic Search endpoint",
        "ELASTICSEARCH_API_KEY": "Elastic API key",
        "GEMINI_API_KEY": "Google Gemini API key",
        "GCP_PROJECT_ID": "Google Cloud project ID"
    }
    
    with open(env_file, 'r') as f:
        content = f.read()
    
    missing = []
    for var, description in required_vars.items():
        if f"{var}=" not in content or f"{var}=your_" in content or f"{var}=\n" in content:
            missing.append((var, description))
            print(f"   {Colors.YELLOW}⚠️  Missing: {var} ({description}){Colors.END}")
        else:
            print(f"   {Colors.GREEN}✅ Set: {var}{Colors.END}")
    
    if missing:
        print(f"\n   {Colors.YELLOW}Please update the following in Backend/.env:{Colors.END}")
        for var, desc in missing:
            print(f"      • {var} - {desc}")
        return False
    
    return True


def check_elasticsearch():
    """Check Elasticsearch connection"""
    print(f"\n{Colors.BOLD}4. Checking Elasticsearch Connection...{Colors.END}")
    
    try:
        from dotenv import load_dotenv
        load_dotenv("Backend/.env")
        
        es_url = os.getenv("ELASTICSEARCH_URL")
        es_key = os.getenv("ELASTICSEARCH_API_KEY")
        
        if not es_url or not es_key:
            print(f"   {Colors.YELLOW}⚠️  Elasticsearch credentials not configured{Colors.END}")
            return False
        
        try:
            from elasticsearch import Elasticsearch
            es = Elasticsearch(es_url, api_key=es_key)
            
            if es.ping():
                print(f"   {Colors.GREEN}✅ Elasticsearch connected successfully{Colors.END}")
                
                # Show cluster info
                info = es.info()
                print(f"   {Colors.BLUE}   Cluster: {info['cluster_name']}{Colors.END}")
                print(f"   {Colors.BLUE}   Version: {info['version']['number']}{Colors.END}")
                return True
            else:
                print(f"   {Colors.RED}❌ Elasticsearch ping failed{Colors.END}")
                return False
                
        except Exception as e:
            print(f"   {Colors.RED}❌ Connection error: {e}{Colors.END}")
            return False
            
    except ImportError:
        print(f"   {Colors.YELLOW}⚠️  elasticsearch package not installed{Colors.END}")
        print(f"   {Colors.BLUE}   Run: pip install -r Backend/requirements.txt{Colors.END}")
        return False


def check_gcp_connection():
    """Check Google Cloud connection"""
    print(f"\n{Colors.BOLD}5. Checking Google Cloud Connection...{Colors.END}")
    
    try:
        from dotenv import load_dotenv
        load_dotenv("Backend/.env")
        
        cred_file = os.getenv("GOOGLE_APPLICATION_CREDENTIALS")
        
        if not cred_file or not Path(cred_file).exists():
            print(f"   {Colors.YELLOW}⚠️  GCP credentials not configured{Colors.END}")
            return False
        
        try:
            from google.cloud import storage
            
            # Set credentials
            os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = cred_file
            
            client = storage.Client()
            project_id = client.project
            
            print(f"   {Colors.GREEN}✅ Connected to GCP project: {project_id}{Colors.END}")
            return True
            
        except Exception as e:
            print(f"   {Colors.RED}❌ GCP connection error: {e}{Colors.END}")
            return False
            
    except ImportError:
        print(f"   {Colors.YELLOW}⚠️  google-cloud-storage not installed{Colors.END}")
        print(f"   {Colors.BLUE}   Run: pip install -r Backend/requirements.txt{Colors.END}")
        return False


def print_next_steps(all_good: bool):
    """Print next steps"""
    print(f"\n{Colors.BOLD}{'='*65}{Colors.END}")
    
    if all_good:
        print(f"\n{Colors.GREEN}{Colors.BOLD}🎉 Environment Setup Complete!{Colors.END}\n")
        print(f"{Colors.BOLD}Next Steps:{Colors.END}")
        print(f"  1. {Colors.BLUE}Start Backend:{Colors.END}")
        print(f"     cd Backend")
        print(f"     python -m uvicorn src.pipeline.run_pipeline:app --reload")
        print(f"\n  2. {Colors.BLUE}Start Frontend:{Colors.END}")
        print(f"     cd Frontend")
        print(f"     npm install && npm run dev")
        print(f"\n  3. {Colors.BLUE}Deploy to Google Cloud:{Colors.END}")
        print(f"     cd Backend")
        print(f"     bash deploy-gcloud.sh")
        print(f"\n  4. {Colors.BLUE}Test the API:{Colors.END}")
        print(f"     http://localhost:8080/docs")
    else:
        print(f"\n{Colors.YELLOW}{Colors.BOLD}⚠️  Setup Incomplete{Colors.END}\n")
        print(f"{Colors.BOLD}Please complete the following:{Colors.END}")
        print(f"  1. Update Backend/.env with required credentials")
        print(f"  2. Ensure Google Cloud credentials file is present")
        print(f"  3. Install dependencies: pip install -r Backend/requirements.txt")
        print(f"  4. Run this script again to validate")
    
    print(f"\n{Colors.BOLD}{'='*65}{Colors.END}\n")


def main():
    """Main setup function"""
    print_header()
    
    results = []
    
    # Run checks
    creds = check_credentials()
    results.append(creds is not None)
    
    env_exists = check_env_file()
    results.append(env_exists)
    
    if env_exists:
        env_valid = validate_env_vars()
        results.append(env_valid)
        
        # Check connections if dependencies available
        if env_valid:
            es_ok = check_elasticsearch()
            results.append(es_ok)
            
            gcp_ok = check_gcp_connection()
            results.append(gcp_ok)
    
    # Print summary
    all_good = all(results)
    print_next_steps(all_good)
    
    return 0 if all_good else 1


if __name__ == "__main__":
    try:
        sys.exit(main())
    except KeyboardInterrupt:
        print(f"\n\n{Colors.YELLOW}Setup cancelled by user{Colors.END}")
        sys.exit(1)
    except Exception as e:
        print(f"\n{Colors.RED}Error: {e}{Colors.END}")
        sys.exit(1)

