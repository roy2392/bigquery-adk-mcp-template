@echo off
echo.
echo ===========================================
echo  BigQuery Agent Setup Verification Script
echo ===========================================
echo.

echo [1/5] Checking if toolbox.exe exists...
if exist "toolbox.exe" (
    echo ✓ toolbox.exe found
) else (
    echo ✗ toolbox.exe not found - run: curl -O https://storage.googleapis.com/genai-toolbox/v0.12.0/windows/amd64/toolbox.exe
    goto end
)

echo.
echo [2/5] Testing toolbox version...
.\toolbox.exe --version
if %errorlevel% equ 0 (
    echo ✓ Toolbox working correctly
) else (
    echo ✗ Toolbox failed to run
    goto end
)

echo.
echo [3/5] Checking .mcp.json configuration...
if exist ".mcp.json" (
    echo ✓ .mcp.json found
) else (
    echo ✗ .mcp.json not found - see README.md for configuration
    goto end
)

echo.
echo [4/5] Checking .env configuration...
if exist "agents\.env" (
    echo ✓ agents\.env found
) else (
    echo ✗ agents\.env not found - copy from agents\.env.example
    goto end
)

echo.
echo [5/5] Testing BigQuery connectivity...
echo This will test if the toolbox can connect to BigQuery...
set /p project_id=Enter your BigQuery project ID: 
set BIGQUERY_PROJECT=%project_id%
echo {"jsonrpc":"2.0","id":1,"method":"tools/list","params":{}} | .\toolbox.exe --prebuilt bigquery --stdio > nul 2>&1
if %errorlevel% equ 0 (
    echo ✓ BigQuery connection successful
) else (
    echo ✗ BigQuery connection failed - check your project ID and credentials
)

echo.
echo ===========================================
echo  Setup verification complete!
echo ===========================================
echo.
echo Next steps:
echo 1. cd agents
echo 2. adk web .
echo 3. Open http://localhost:8000 in your browser
echo.

:end
pause
