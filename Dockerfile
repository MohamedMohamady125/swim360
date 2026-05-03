# Multi-stage build for smaller image size
FROM python:3.11-slim as builder

# Set working directory to backend
WORKDIR /app/backend

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY backend/requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# Final stage
FROM python:3.11-slim

# Set working directory to backend
WORKDIR /app/backend

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Copy Python dependencies from builder
COPY --from=builder /root/.local /root/.local

# Copy application code from backend directory
COPY backend/ .

# Make sure scripts in .local are usable
ENV PATH=/root/.local/bin:$PATH

# Create logs directory
RUN mkdir -p logs

# Expose port (Railway will set PORT env var)
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "import requests; requests.get('http://localhost:8000/health')" || exit 1

# Run the application - use Railway's PORT env var
CMD ["sh", "-c", "uvicorn app.main:app --host 0.0.0.0 --port ${PORT:-8000}"]
