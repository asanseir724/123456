
#!/bin/bash

# Output color formatting
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}Update GitHub Repository${NC}"
echo -e "${BLUE}=========================================${NC}"

# Get repository URL
if [ -z "$1" ]; then
  echo -e "${YELLOW}Enter GitHub repository URL:${NC}"
  read -e -i "https://github.com/asanseir724/56654456" REPO_URL
  REPO_URL=${REPO_URL:-https://github.com/asanseir724/56654456}
else
  REPO_URL=$1
fi

# Extract username and repo name from URL
GITHUB_USERNAME=$(echo $REPO_URL | sed -E 's|https://github.com/([^/]+)/.*|\1|')
REPO_NAME=$(echo $REPO_URL | sed -E 's|https://github.com/[^/]+/([^/]+).*|\1|')

# Use token from parameter if provided, otherwise ask for it
if [ -z "$2" ]; then
  echo -e "${YELLOW}Enter your GitHub personal access token:${NC}"
  read -s GITHUB_TOKEN
  echo -e "${GREEN}Token received${NC}"
else
  GITHUB_TOKEN=$2
  echo -e "${GREEN}Using provided token${NC}"
fi

echo -e "\n${YELLOW}[1/4] Configuring Git...${NC}"
# Check if git is already initialized
if [ ! -d ".git" ]; then
  git init
  echo -e "${GREEN}Git repository initialized.${NC}"
else
  echo -e "${GREEN}Git repository already exists.${NC}"
fi

git config --local user.email "your-email@example.com"
git config --local user.name "$GITHUB_USERNAME"

# Check if remote exists
if git remote | grep -q "origin"; then
  echo -e "${YELLOW}Updating remote origin...${NC}"
  git remote set-url origin https://$GITHUB_TOKEN@github.com/$GITHUB_USERNAME/$REPO_NAME.git
else
  echo -e "${YELLOW}Adding remote origin...${NC}"
  git remote add origin https://$GITHUB_TOKEN@github.com/$GITHUB_USERNAME/$REPO_NAME.git
fi

echo -e "\n${YELLOW}[2/4] Adding all changes...${NC}"
git add .

echo -e "\n${YELLOW}[3/4] Committing changes...${NC}"
echo -e "${YELLOW}Enter commit message (default: Update bot code):${NC}"
read -e -i "Update bot code" COMMIT_MESSAGE
COMMIT_MESSAGE=${COMMIT_MESSAGE:-"Update bot code"}

git commit -m "$COMMIT_MESSAGE"

echo -e "\n${YELLOW}[4/4] Determining default branch and pushing to GitHub...${NC}"

# Try to detect the default branch
DEFAULT_BRANCH=$(git ls-remote --symref https://${GITHUB_TOKEN}@github.com/${GITHUB_USERNAME}/${REPO_NAME}.git HEAD | grep -o 'refs/heads/[^ ]*' | sed 's|refs/heads/||')

if [ -z "$DEFAULT_BRANCH" ]; then
  echo -e "${YELLOW}Could not detect default branch. Trying both main and master...${NC}"
  # Try pushing to main first (more common for new repos)
  git push -u origin main
  
  if [ $? -ne 0 ]; then
    echo -e "${YELLOW}Pushing to main failed, trying master...${NC}"
    git push -u origin master
    
    if [ $? -eq 0 ]; then
      echo -e "\n${GREEN}✅ Successfully updated GitHub repository using 'master' branch!${NC}"
      DEFAULT_BRANCH="master"
    else
      echo -e "\n${RED}❌ Failed to push to GitHub. Common issues:${NC}"
      echo -e "  - Invalid GitHub token"
      echo -e "  - Repository doesn't exist"
      echo -e "  - No internet connection"
      echo -e "  - Branch permissions issues"
      exit 1
    fi
  else
    echo -e "\n${GREEN}✅ Successfully updated GitHub repository using 'main' branch!${NC}"
    DEFAULT_BRANCH="main"
  fi
else
  echo -e "${YELLOW}Detected default branch: $DEFAULT_BRANCH${NC}"
  git push -u origin $DEFAULT_BRANCH
  
  if [ $? -eq 0 ]; then
    echo -e "\n${GREEN}✅ Successfully updated GitHub repository!${NC}"
  else
    echo -e "\n${RED}❌ Failed to push to GitHub. Common issues:${NC}"
    echo -e "  - Invalid GitHub token"
    echo -e "  - Repository doesn't exist"
    echo -e "  - No internet connection"
    echo -e "  - Branch permissions issues"
    exit 1
  fi
fi

echo -e "${BLUE}-------------------------------------------${NC}"
echo -e "${YELLOW}Repository URL:${NC} $REPO_URL"
echo -e "${YELLOW}Default Branch:${NC} $DEFAULT_BRANCH"
echo -e "${BLUE}-------------------------------------------${NC}"

echo -e "${BLUE}=========================================${NC}"
