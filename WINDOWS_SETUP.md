# Windows Setup Guide for BigQuery Agent

This guide specifically covers setting up the BigQuery Agent with MCP Toolbox on Windows systems.

## Prerequisites

- Windows 10/11
- Git Bash or PowerShell
- Python 3.9+
- Google Cloud Project with BigQuery API enabled
- Google API Key or Application Default Credentials

## Step-by-Step Installation

### 1. Clone and Setup Project

```bash
git clone <your-repo-url>
cd bq-agent
```

### 2. Download Windows MCP Toolbox

Download the latest Windows version of the MCP Toolbox:

```bash
curl -O https://storage.googleapis.com/genai-toolbox/v0.12.0/windows/amd64/toolbox.exe
```

### 3. Verify Toolbox Installation

Test that the toolbox works:

```bash
./toolbox.exe --version
```

Expected output:
```
toolbox version 0.12.0+binary.windows.amd64.d19cfc1e7ec2e20214ec118548dd8435966933f1
```

### 4. Configure Environment Variables

Create/update your `.env` file in the `agents/` directory:

```bash
cd agents
cp .env.example .env
```

Edit `agents/.env` with your configuration:

```bash
# Google AI Configuration
GOOGLE_GENAI_USE_VERTEXAI=0
GOOGLE_API_KEY=your_google_api_key_here

# BigQuery Configuration
BIGQUERY_PROJECT=your-project-id
BIGQUERY_LOCATION=US
GOOGLE_CLOUD_REGION=US
GOOGLE_CLOUD_LOCATION=US

# SSL Configuration (if needed for corporate environments)
SSL_CERT_FILE=
CURL_CA_BUNDLE=
REQUESTS_CA_BUNDLE=
PYTHONHTTPSVERIFY=0
```

**Find your project ID:**
```bash
gcloud config get-value project
```

### 5. Create MCP Configuration

Create a `.mcp.json` file in your project root:

```json
{
  "mcpServers": {
    "bigquery": {
      "command": "./toolbox.exe",
      "args": ["--prebuilt", "bigquery", "--stdio"],
      "env": {
        "BIGQUERY_PROJECT": "your-project-id"
      }
    }
  }
}
```

### 6. Test BigQuery Connection

Test that the toolbox can connect to your BigQuery project:

```bash
export BIGQUERY_PROJECT=your-project-id
echo '{"jsonrpc":"2.0","id":1,"method":"tools/list","params":{}}' | ./toolbox.exe --prebuilt bigquery --stdio
```

You should see a JSON response with available BigQuery tools.

### 7. Start the ADK Web Server

Navigate to the project root and start the ADK web server:

```bash
cd ..
adk web agents
```

### 8. Access the Web Interface

Open your browser and go to:
```
http://localhost:8000
```

Select `bq-agent-app` and start chatting with your BigQuery data!

## Testing the Setup

Try these example queries in the web interface:

- "Show me the first 10 rows from my tables"
- "What datasets do I have?"
- "How many tables are in my dataset?"
- "SELECT * FROM your_table_name LIMIT 5"

## Windows-Specific Troubleshooting

### "Exec format error"
- You downloaded the Linux binary instead of Windows
- Re-download: `curl -O https://storage.googleapis.com/genai-toolbox/v0.12.0/windows/amd64/toolbox.exe`

### "Command not found"
- Make sure you're using `./toolbox.exe` (with .exe extension)
- If using PowerShell, try: `.\toolbox.exe --version`

### "Permission denied"
- On Windows with Git Bash, no chmod is needed
- Ensure you're in the correct directory

### BIGQUERY_PROJECT errors
- Verify your `.mcp.json` includes the project ID
- Check that your `.env` file has `BIGQUERY_PROJECT` set
- Make sure you're using your actual project ID from `gcloud config get-value project`

## Directory Structure

After setup, your project should look like:

```
bq-agent/
├── .mcp.json                   # MCP Toolbox configuration
├── toolbox.exe                 # Windows MCP Toolbox binary
├── agents/
│   ├── .env                    # Environment configuration
│   └── bq-agent-app/
│       ├── __init__.py
│       ├── agent.py           # Main agent configuration
│       └── README.md
├── .gitignore
└── README.md
```

## Next Steps

- Explore the MCP Toolbox capabilities: `./toolbox.exe --prebuilt bigquery --help`
- Customize your agent in `agents/bq-agent-app/agent.py`
- Add more tools from the ADK toolset
- Configure additional BigQuery datasets

## Support

If you encounter issues:
1. Check this troubleshooting guide
2. Verify all prerequisites are met
3. Review the main README.md
4. Open an issue in the repository
