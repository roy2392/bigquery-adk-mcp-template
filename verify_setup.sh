#!/bin/bash

echo
echo "==========================================="
echo " BigQuery Agent Setup Verification Script"
echo "==========================================="
echo

echo "[1/5] Checking if toolbox exists..."
if [ -f "toolbox" ]; then
    echo "✓ toolbox found"
else
    echo "✗ toolbox not found - download appropriate version for your OS"
    echo "Linux: curl -O https://storage.googleapis.com/genai-toolbox/v0.12.0/linux/amd64/toolbox"
    echo "macOS Intel: curl -O https://storage.googleapis.com/genai-toolbox/v0.12.0/darwin/amd64/toolbox"
    echo "macOS Apple Silicon: curl -O https://storage.googleapis.com/genai-toolbox/v0.12.0/darwin/arm64/toolbox"
    exit 1
fi

echo
echo "[2/5] Testing toolbox version..."
if ./toolbox --version > /dev/null 2>&1; then
    echo "✓ Toolbox working correctly"
    ./toolbox --version
else
    echo "✗ Toolbox failed to run - check permissions (chmod +x toolbox)"
    exit 1
fi

echo
echo "[3/5] Checking .mcp.json configuration..."
if [ -f ".mcp.json" ]; then
    echo "✓ .mcp.json found"
else
    echo "✗ .mcp.json not found - see README.md for configuration"
    exit 1
fi

echo
echo "[4/5] Checking .env configuration..."
if [ -f "agents/.env" ]; then
    echo "✓ agents/.env found"
else
    echo "✗ agents/.env not found - copy from agents/.env.example"
    exit 1
fi

echo
echo "[5/5] Testing BigQuery connectivity..."
echo "This will test if the toolbox can connect to BigQuery..."
read -p "Enter your BigQuery project ID: " project_id
export BIGQUERY_PROJECT=$project_id
if echo '{"jsonrpc":"2.0","id":1,"method":"tools/list","params":{}}' | ./toolbox --prebuilt bigquery --stdio > /dev/null 2>&1; then
    echo "✓ BigQuery connection successful"
else
    echo "✗ BigQuery connection failed - check your project ID and credentials"
fi

echo
echo "==========================================="
echo " Setup verification complete!"
echo "==========================================="
echo
echo "Next steps:"
echo "1. cd agents"
echo "2. adk web ."
echo "3. Open http://localhost:8000 in your browser"
echo
