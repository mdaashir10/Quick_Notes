#!/bin/bash

# ================================================
# Student Notes Application - Run Script
# ================================================
# This script builds the application with Maven
# and deploys it to Tomcat.
# ================================================

set -e

# Configuration
TOMCAT_HOME="/home/runner/tomcat"
PROJECT_DIR="/home/runner/${REPL_SLUG}"
NOTES_DIR="${PROJECT_DIR}/notes"

echo "=============================================="
echo "  Student Notes Application - Starting..."
echo "=============================================="

# Ensure notes directory exists
mkdir -p "${NOTES_DIR}"
echo "[1/5] Notes directory ready: ${NOTES_DIR}"

# Configure Tomcat port to 5000 (Replit requirement)
echo "[2/5] Configuring Tomcat to use port 5000..."
sed -i 's/port="8080"/port="5000"/g' "${TOMCAT_HOME}/conf/server.xml"
sed -i 's/redirectPort="8443"/redirectPort="5443"/g' "${TOMCAT_HOME}/conf/server.xml"

# Copy tomcat-users.xml for authentication
echo "[3/5] Setting up authentication..."
cp "${PROJECT_DIR}/conf/tomcat-users.xml" "${TOMCAT_HOME}/conf/tomcat-users.xml"

# Build the application with Maven
echo "[4/5] Building application with Maven..."
cd "${PROJECT_DIR}"
mvn clean package -q -DskipTests

# Deploy the WAR file
echo "[5/5] Deploying to Tomcat..."
rm -rf "${TOMCAT_HOME}/webapps/ROOT"
rm -f "${TOMCAT_HOME}/webapps/ROOT.war"
cp target/notes.war "${TOMCAT_HOME}/webapps/ROOT.war"

echo "=============================================="
echo "  Application deployed successfully!"
echo "  Starting Tomcat server..."
echo "=============================================="
echo ""
echo "  Public page: http://0.0.0.0:5000/"
echo "  Admin page:  http://0.0.0.0:5000/admin/dashboard"
echo "  Admin login: admin / admin123"
echo ""
echo "=============================================="

# Start Tomcat in foreground
export CATALINA_HOME="${TOMCAT_HOME}"
export CATALINA_BASE="${TOMCAT_HOME}"
exec "${TOMCAT_HOME}/bin/catalina.sh" run
