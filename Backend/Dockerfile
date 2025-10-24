FROM python:3.11-slim

WORKDIR /app

# Install system dependencies if needed (for PDFs, etc.)
RUN apt-get update && apt-get install -y build-essential libpoppler-cpp-dev && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy backend code
COPY . .

# ✅ Copy service account key into container
COPY credentials.json /app/credentials.json

EXPOSE 8080
CMD ["uvicorn", "src.pipeline.run_pipeline:app", "--host", "0.0.0.0", "--port", "8080"]
