
#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}GitHub Push Script${NC}"
echo -e "${BLUE}=========================================${NC}"

# Get GitHub repository URL
echo -e "${YELLOW}Enter GitHub repository URL:${NC}"
read REPO_URL

# Extract username and repo name from URL
if [[ $REPO_URL =~ github\.com\/([^\/]+)\/([^\/]+)(\.git)?$ ]]; then
    USERNAME="${BASH_REMATCH[1]}"
    REPO_NAME="${BASH_REMATCH[2]}"
else
    echo -e "${RED}Invalid GitHub URL format${NC}"
    exit 1
fi

# Get GitHub token securely
echo -e "${YELLOW}Enter your GitHub personal access token:${NC}"
read -s TOKEN
echo -e "${GREEN}Using provided GitHub token${NC}"

# Configure Git if not already configured
if ! git config --global user.email >/dev/null 2>&1; then
    echo -e "${YELLOW}Configuring Git user email...${NC}"
    git config --global user.email "user@example.com"
fi

if ! git config --global user.name >/dev/null 2>&1; then
    echo -e "${YELLOW}Configuring Git username...${NC}"
    git config --global user.name "$USERNAME"
fi

# Check if .git directory exists
if [ -d ".git" ]; then
    echo -e "${GREEN}Git repository already exists.${NC}"
    
    # Update remote origin with token-based URL
    echo -e "${YELLOW}Updating remote origin...${NC}"
    git remote remove origin 2>/dev/null
    git remote add origin "https://$TOKEN@github.com/$USERNAME/$REPO_NAME.git"
else
    echo -e "${YELLOW}Initializing Git repository...${NC}"
    git init
    git remote add origin "https://$TOKEN@github.com/$USERNAME/$REPO_NAME.git"
fi

echo -e "\n${YELLOW}[1/4] Adding all changes...${NC}"
git add .

echo -e "\n${YELLOW}[2/4] Committing changes...${NC}"
echo -e "${YELLOW}Enter commit message (default: Update bot code):${NC}"
read COMMIT_MESSAGE
COMMIT_MESSAGE="${COMMIT_MESSAGE:-Update bot code}"

git commit -m "$COMMIT_MESSAGE"

echo -e "\n${YELLOW}[3/4] Fetching remote branches...${NC}"
git fetch origin 2>/dev/null || true

# Try to determine the default branch
DEFAULT_BRANCH=$(git ls-remote --symref origin HEAD 2>/dev/null | grep "ref:" | awk '{print $2}' | sed 's/refs\/heads\///')
DEFAULT_BRANCH="${DEFAULT_BRANCH:-main}"  # Default to main if we can't determine

echo -e "\n${YELLOW}[4/4] Pushing to GitHub...${NC}"
# Try pushing to the determined default branch first
if ! git push -u origin "$DEFAULT_BRANCH"; then
    echo -e "${RED}Failed to push to $DEFAULT_BRANCH branch${NC}"
    
    # If the default branch is main, try master as fallback
    if [ "$DEFAULT_BRANCH" = "main" ]; then
        echo -e "${YELLOW}Trying to push to master branch instead...${NC}"
        if git push -u origin master; then
            echo -e "${GREEN}✅ Successfully pushed to master branch!${NC}"
            exit 0
        fi
    # If the default branch is master, try main as fallback
    elif [ "$DEFAULT_BRANCH" = "master" ]; then
        echo -e "${YELLOW}Trying to push to main branch instead...${NC}"
        if git push -u origin main; then
            echo -e "${GREEN}✅ Successfully pushed to main branch!${NC}"
            exit 0
        fi
    fi
    
    # If we get here, both attempts failed or the default branch was neither main nor master
    echo -e "${YELLOW}Creating and pushing to a new branch instead...${NC}"
    NEW_BRANCH="update_$(date +%Y%m%d_%H%M%S)"
    git checkout -b "$NEW_BRANCH"
    
    if git push -u origin "$NEW_BRANCH"; then
        echo -e "${GREEN}✅ Successfully pushed to new branch: $NEW_BRANCH${NC}"
        echo -e "${YELLOW}Visit your repository to create a pull request from this branch.${NC}"
        exit 0
    else
        echo -e "${RED}❌ Failed to push to GitHub. Please check your credentials and repository access.${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}✅ Successfully pushed to $DEFAULT_BRANCH branch!${NC}"
fi

echo -e "${BLUE}=========================================${NC}"
