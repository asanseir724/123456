
#!/bin/bash

# Output color formatting
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}Transfer Code to GitHub${NC}"
echo -e "${BLUE}=========================================${NC}"

# Get GitHub token
if [ -z "$1" ]; then
  echo -e "${YELLOW}Please enter your GitHub token:${NC}"
  read GITHUB_TOKEN
else
  GITHUB_TOKEN=$1
fi

# Get repository name
if [ -z "$2" ]; then
  echo -e "${YELLOW}Enter repository name (default: telegram-premium-bot):${NC}"
  read -e -i "telegram-premium-bot" REPO_NAME
  REPO_NAME=${REPO_NAME:-telegram-premium-bot}
else
  REPO_NAME=$2
fi

# Get GitHub username
if [ -z "$3" ]; then
  echo -e "${YELLOW}Enter your GitHub username:${NC}"
  read GITHUB_USERNAME
else
  GITHUB_USERNAME=$3
fi

# Create new GitHub repository
echo -e "\n${YELLOW}[1/5] Creating GitHub repository...${NC}"
curl -s -X POST -H "Authorization: token $GITHUB_TOKEN" \
     -d "{\"name\":\"$REPO_NAME\", \"description\":\"Telegram Subscription Management Bot\", \"private\":true}" \
     "https://api.github.com/user/repos"

if [ $? -ne 0 ]; then
  echo -e "${RED}Error creating GitHub repository. Please check your token and username.${NC}"
  exit 1
fi

# Create .gitignore file
echo -e "\n${YELLOW}[2/5] Creating Git files...${NC}"
echo "
# Python compiled bytecode
__pycache__/
*.py[cod]
*$py.class

# Python distribution / packaging
.Python
env/
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg

# Environment files
.env
.venv
env/
venv/
ENV/
.env.local

# Logs
logs/
*.log

# System folders
.DS_Store
.idea/
.vscode/

# Databases
*.sqlite
*.db

# Deploy folder
deploy/
deploy.zip

# Certificates and keys
*.pem
*.key
*.crt" > .gitignore

# Prepare local repository and push to GitHub
echo -e "\n${YELLOW}[3/5] Preparing local Git repository...${NC}"
git init
git add .
git config --local user.email "your-email@example.com"
git config --local user.name "$GITHUB_USERNAME"
git commit -m "Initial version of Telegram Subscription Management Bot"

echo -e "\n${YELLOW}[4/5] Setting up remote repository...${NC}"
git remote add origin https://$GITHUB_TOKEN@github.com/$GITHUB_USERNAME/$REPO_NAME.git

echo -e "\n${YELLOW}[5/5] Pushing code to GitHub...${NC}"
git push -u origin master

# Display information
echo -e "\n${GREEN}✅ Code successfully pushed to GitHub!${NC}"
echo -e "${BLUE}-------------------------------------------${NC}"
echo -e "${YELLOW}Repository URL:${NC} https://github.com/$GITHUB_USERNAME/$REPO_NAME"
echo -e "${YELLOW}Clone command:${NC} git clone https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"
echo -e "${BLUE}-------------------------------------------${NC}"
echo -e "${GREEN}To install the bot on a server, run this command:${NC}"
echo -e "wget -O install.sh https://raw.githubusercontent.com/$GITHUB_USERNAME/$REPO_NAME/master/install.sh && chmod +x install.sh && ./install.sh"
echo -e "${BLUE}=========================================${NC}"
