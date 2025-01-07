#!/bin/bash

# Environment variables
if [ -z "$ENCRYPTION_PASSWORD" ] || [ -z "$ENCRYPTION_SALT" ] || [ -z "$GITHUB_REPO_URL" ] || [ -z "$GITHUB_BRANCH" ]; then
    echo "Error: Required environment variables are missing."
    echo "Please set ENCRYPTION_PASSWORD, ENCRYPTION_SALT, GITHUB_REPO_URL, and GITHUB_BRANCH."
    exit 1
fi

# Configurable file paths
#FILE_TO_ENCRYPT="buddy-1mg"          # File to encrypt
#ENCRYPTED_FILE="buddy-1mg.enc"       # Output encrypted file
#REPO_DIR="/Users/Atif/Code/scrypthub"        # Local directory for the Git repository

cd "$REPO_DIR"

# Log the password and salt
#echo "Using Password: $ENCRYPTION_PASSWORD"
#echo "Using Salt: $ENCRYPTION_SALT"

# Ensure the file to encrypt exists
if [ ! -f "$FILE_TO_ENCRYPT" ]; then
    echo "Error: File '$FILE_TO_ENCRYPT' not found."
    exit 1
fi

# Navigate to the repository or clone if missing
if [ ! -d "$REPO_DIR" ]; then
    echo "Cloning repository..."
    git clone "$GITHUB_REPO_URL" "$REPO_DIR"
fi

cd "$REPO_DIR" || exit
git checkout "$GITHUB_BRANCH"

# Encrypt the file using OpenSSL with PBKDF2 and the provided password/salt
openssl enc -aes-256-cbc -salt -pbkdf2 -in "$FILE_TO_ENCRYPT" -out "$ENCRYPTED_FILE" -pass pass:"$ENCRYPTION_PASSWORD"
#openssl enc -aes-256-cbc -salt -pbkdf2 -in "$FILE_TO_ENCRYPT" -out "$ENCRYPTED_FILE" -pass pass:"$ENCRYPTION_PASSWORD" -S "$ENCRYPTION_SALT"

if [ $? -ne 0 ]; then
    echo "Error: Encryption failed."
    exit 1
fi

echo "File encrypted successfully: $ENCRYPTED_FILE"

# Add and commit the encrypted file to the repository
git add "$ENCRYPTED_FILE"
COMMIT_MESSAGE="Automated commit: Encrypted file $(date +'%Y-%m-%d %H:%M:%S')"
git commit -m "$COMMIT_MESSAGE"

# Push to the repository
git push origin "$GITHUB_BRANCH"

# Delete the original file
rm -f "$FILE_TO_ENCRYPT"
echo "Original file deleted."

if [ $? -ne 0 ]; then
    echo "Error: Failed to push changes to the repository."
    exit 1
fi

echo "Encrypted file committed and pushed to the repository successfully."
