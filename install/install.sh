#!/bin/sh

# 1. Paths and Variables
OSCAM_PATH="/etc/tuxbox/config"
USER="anow2008"
REPO="conf"
BRANCH="main"
TMP_DIR="/tmp/github_update"

echo "-------------------------------------------------------"
echo "    Stopping Enigma2 GUI to prevent file locks..."
echo "-------------------------------------------------------"

# Stop Enigma2 GUI completely
init 4
sleep 2 

echo "-------------------------------------------------------"
echo "    Downloading repository ZIP archive..."
echo "-------------------------------------------------------"

# Clean up any old temporary directories
rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"

# Download the repository ZIP file directly
wget -q --no-check-certificate --timeout=10 --tries=2 "-O" "$TMP_DIR/repo.zip" "https://github.com/$USER/$REPO/archive/refs/heads/$BRANCH.zip"

if [ ! -f "$TMP_DIR/repo.zip" ]; then
    echo "❌ Error: Failed to download the repository ZIP file."
    echo "⚙️ Restarting Enigma2 GUI..."
    rm -rf "$TMP_DIR"
    init 3
    exit 1
fi

echo "-------------------------------------------------------"
echo "    Extracting and moving configuration files..."
echo "-------------------------------------------------------"

# Unzip the file into the temporary directory
unzip -q -o "$TMP_DIR/repo.zip" -d "$TMP_DIR"

# GitHub extracts ZIP as "RepoName-BranchName" (e.g., conf-main)
EXTRACTED_DIR="$TMP_DIR/$REPO-$BRANCH"

if [ -d "$EXTRACTED_DIR" ]; then
    # Move all files except script files, hidden files, or readme
    cp -r $EXTRACTED_DIR/* "$OSCAM_PATH/" 2>/dev/null
    
    # Clean up files you don't want in the config directory (optional safety)
    rm -f "$OSCAM_PATH/README.md" "$OSCAM_PATH/install.sh" 2>/dev/null
else
    echo "❌ Error: Failed to extract repository correctly."
    rm -rf "$TMP_DIR"
    init 3
    exit 1
fi

# Clean up temporary directory immediately
rm -rf "$TMP_DIR"

# 2. Set correct Permissions
echo "⚙️ Setting file permissions (644)..."
chmod 644 $OSCAM_PATH/oscam.* 2>/dev/null
chmod 644 $OSCAM_PATH/ncam.* 2>/dev/null
chmod 644 $OSCAM_PATH/constant.cw 2>/dev/null
chmod 644 $OSCAM_PATH/*.key 2>/dev/null

echo "-------------------------------------------------------"
echo "✅ Update completed successfully! Restarting GUI..."
echo "-------------------------------------------------------"

# 3. Restart Enigma2 GUI
init 3
