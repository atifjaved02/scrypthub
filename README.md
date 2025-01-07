# scrypthub
One-stop place for managing and running automation tools, code snippets, or utilities.

### Replace the env variable accordingly ###

```bash
cat <<EOF >> ~/.zshrc
### Buddy Encryption ###
export ENCRYPTION_PASSWORD="abcdefghijklmnopqrstuvwxyz"
# Command to generate 8-byte hex 'xxd -l 8 -p /dev/urandom'
export ENCRYPTION_SALT="5f4dcc3b5aa765d6"  # Simple 8-byte salt in hex
export GITHUB_REPO_URL="git@github.com:atifjaved02/scrypthub.git"
export GITHUB_BRANCH="enc-scrypt"
export FILE_TO_ENCRYPT="buddy-1mg"
export ENCRYPTED_FILE="buddy-1mg.enc"
export DECRYPTED_FILE="buddy-1mg"
export REPO_DIR="\$HOME/Code/scrypthub"
alias ebuddy='~/Code/scrypthub/encrypt_and_push.sh'
alias dbuddy='~/Code/scrypthub/pull_and_decrypt.sh'
EOF

source ~/.zshrc
