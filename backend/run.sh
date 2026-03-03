#!/bin/bash

# Swim360 Backend - Quick Start Script

echo "🏊 Starting Swim360 Backend..."

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
echo "🔧 Activating virtual environment..."
source venv/bin/activate

# Install/update dependencies
echo "📚 Installing dependencies..."
pip install -r requirements.txt

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "⚠️  .env file not found!"
    echo "📝 Copying .env.example to .env..."
    cp .env.example .env
    echo ""
    echo "⚠️  IMPORTANT: Please update .env with your actual credentials before running the server!"
    echo ""
    exit 1
fi

# Run the server
echo "🚀 Starting FastAPI server..."
echo "📍 API will be available at: http://localhost:8000"
echo "📖 API docs at: http://localhost:8000/api/v1/docs"
echo ""

uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
