#!/bin/bash

# Environment variables
if [ -z "$ENCRYPTION_PASSWORD" ] || [ -z "$ENCRYPTION_SALT" ] || [ -z "$GITHUB_REPO_URL" ] || [ -z "$GITHUB_BRANCH" ]; then
    echo "Error: Required environment variables are missing."
    echo "Please set ENCRYPTION_PASSWORD, ENCRYPTION_SALT, GITHUB_REPO_URL, and GITHUB_BRANCH."
    exit 1
fi

# Configurable file paths
#ENCRYPTED_FILE="buddy-1mg.enc"       # Encrypted file
#DECRYPTED_FILE="buddy-1mg"           # Output decrypted file
#REPO_DIR="/Users/Atif/Code/scrypthub"        # Local directory for the Git repository

cd "$REPO_DIR"

# Navigate to the repository or clone if missing
if [ ! -d "$REPO_DIR" ]; then
    echo "Cloning repository..."
    git clone "$GITHUB_REPO_URL" "$REPO_DIR"
fi

cd "$REPO_DIR" || exit
git checkout "$GITHUB_BRANCH"

# Pull the latest changes
git pull origin "$GITHUB_BRANCH"

# Check if the encrypted file exists
if [ ! -f "$ENCRYPTED_FILE" ]; then
    echo "Error: Encrypted file '$ENCRYPTED_FILE' not found in the repository."
    exit 1
fi

# Decrypt the file using OpenSSL with PBKDF2 and the provided password/salt
openssl enc -aes-256-cbc -d -pbkdf2 -in "$ENCRYPTED_FILE" -out "$DECRYPTED_FILE" -pass pass:"$ENCRYPTION_PASSWORD"
#openssl enc -aes-256-cbc -d -pbkdf2 -in "$ENCRYPTED_FILE" -out "$DECRYPTED_FILE" -pass pass:"$ENCRYPTION_PASSWORD" -S "$ENCRYPTION_SALT"

if [ $? -ne 0 ]; then
    echo "Error: Decryption failed."
    exit 1
fi

echo "File decrypted successfully: $DECRYPTED_FILE"
