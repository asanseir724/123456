
#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}GitHub Push Helper${NC}"
echo -e "${BLUE}=========================================${NC}"

# Get GitHub token
echo -e "${YELLOW}Enter your GitHub personal access token:${NC}"
read -s GITHUB_TOKEN
echo -e "${GREEN}Token received${NC}"

# Repository details
GITHUB_USERNAME="asanseir724"
REPO_NAME="56654456"
REPO_URL="https://github.com/$GITHUB_USERNAME/$REPO_NAME"

echo -e "\n${YELLOW}[1/4] Configuring Git...${NC}"
git config --global user.email "user@example.com"
git config --global user.name "$GITHUB_USERNAME"

# Remove old remote if it exists
git remote remove origin 2>/dev/null

# Add new remote with token
echo -e "\n${YELLOW}[2/4] Setting up remote repository...${NC}"
git remote add origin "https://$GITHUB_TOKEN@github.com/$GITHUB_USERNAME/$REPO_NAME.git"

# Add all files
echo -e "\n${YELLOW}[3/4] Adding files...${NC}"
git add .
git status

# Commit changes
echo -e "\n${YELLOW}[4/4] Committing and pushing...${NC}"
git commit -m "Update code $(date)"

# Try pushing to both main and master branches
echo -e "\n${YELLOW}Attempting to push to main branch...${NC}"
if git push -f origin main; then
  echo -e "\n${GREEN}✅ Successfully pushed to main branch!${NC}"
else
  echo -e "\n${YELLOW}Trying master branch instead...${NC}"
  if git push -f origin master; then
    echo -e "\n${GREEN}✅ Successfully pushed to master branch!${NC}"
  else
    echo -e "\n${RED}❌ Push failed. Creating a new branch...${NC}"
    git checkout -b update_$(date +%Y%m%d)
    git push -u origin update_$(date +%Y%m%d)
    echo -e "\n${GREEN}✅ Pushed to new branch: update_$(date +%Y%m%d)${NC}"
  fi
fi

echo -e "${BLUE}=========================================${NC}"
