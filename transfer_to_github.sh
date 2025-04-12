
#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}انتقال کد به گیت‌هاب با پشتیبانی SSL${NC}"
echo -e "${BLUE}=========================================${NC}"

# دریافت توکن گیت‌هاب
echo -e "${YELLOW}توکن شخصی گیت‌هاب خود را وارد کنید:${NC}"
read -s GITHUB_TOKEN
echo -e "${GREEN}توکن دریافت شد${NC}"

# دریافت نام کاربری گیت‌هاب
echo -e "${YELLOW}نام کاربری گیت‌هاب خود را وارد کنید:${NC}"
read GITHUB_USERNAME

# دریافت نام مخزن
echo -e "${YELLOW}نام مخزن را وارد کنید (پیش‌فرض: telegram-premium-bot):${NC}"
read -e -i "telegram-premium-bot" REPO_NAME
REPO_NAME=${REPO_NAME:-telegram-premium-bot}

# بررسی وجود مخزن
echo -e "\n${YELLOW}[1/6] بررسی وجود مخزن...${NC}"
REPO_CHECK=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: token $GITHUB_TOKEN" \
     "https://api.github.com/repos/$GITHUB_USERNAME/$REPO_NAME")

if [ "$REPO_CHECK" == "200" ]; then
    echo -e "${YELLOW}مخزن قبلاً وجود دارد. آیا مایل به ادامه هستید؟ (y/n)${NC}"
    read CONTINUE
    if [[ "$CONTINUE" != "y" && "$CONTINUE" != "Y" ]]; then
        echo -e "${RED}عملیات لغو شد.${NC}"
        exit 1
    fi
else
    echo -e "${YELLOW}در حال ایجاد مخزن جدید...${NC}"
    curl -s -X POST -H "Authorization: token $GITHUB_TOKEN" \
         -d "{\"name\":\"$REPO_NAME\", \"description\":\"ربات مدیریت اشتراک تلگرام با پشتیبانی SSL\", \"private\":true}" \
         "https://api.github.com/user/repos"
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}خطا در ایجاد مخزن گیت‌هاب. لطفاً توکن و نام کاربری خود را بررسی کنید.${NC}"
        exit 1
    fi
    echo -e "${GREEN}مخزن با موفقیت ایجاد شد.${NC}"
fi

# ایجاد فایل README.md
echo -e "\n${YELLOW}[2/6] ایجاد فایل‌های مستندات...${NC}"
cat > README.md << EOF
# $REPO_NAME

ربات مدیریت اشتراک تلگرام با پشتیبانی SSL

## ویژگی‌ها

- مدیریت اشتراک‌های کاربران
- پنل مدیریت حرفه‌ای
- پشتیبانی از پرداخت ارز دیجیتال
- پشتیبانی از وب‌هوک تلگرام
- پشتیبانی از SSL برای ارتباط امن
- پنل API مستندسازی شده

## نصب سریع

### نصب معمولی
\`\`\`bash
bash <(curl -s https://raw.githubusercontent.com/$GITHUB_USERNAME/$REPO_NAME/main/install.sh)
\`\`\`

### نصب با پشتیبانی SSL (توصیه شده)
\`\`\`bash
sudo bash -c "\$(curl -s https://raw.githubusercontent.com/$GITHUB_USERNAME/$REPO_NAME/main/full_install_ssl.sh)"
\`\`\`

## راهنمای استفاده

برای اطلاعات بیشتر به فایل README_SSL.md مراجعه کنید.
EOF

# ایجاد .gitignore
echo -e "${YELLOW}ایجاد فایل .gitignore...${NC}"
cat > .gitignore << EOF
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
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
*.egg-info/
.installed.cfg
*.egg

# Virtual Environment
venv/
ENV/
.env
.venv/

# Log files
logs/
*.log

# Database files
*.db
*.sqlite
*.sqlite3

# Local configuration
instance/
config_local.py

# OS specific files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# IDE files
.idea/
.vscode/
*.swp
*.swo

# Sensitive data
*_token*
*.token*
*.key
*.pem
EOF

# بروزرسانی فایل one_line_ssl_install.txt
echo -e "${YELLOW}بروزرسانی فایل نصب یک خطی SSL...${NC}"
echo "sudo bash -c \"\$(curl -s https://raw.githubusercontent.com/$GITHUB_USERNAME/$REPO_NAME/main/full_install_ssl.sh)\"" > one_line_ssl_install.txt

# آماده‌سازی گیت و ارسال کد
echo -e "\n${YELLOW}[3/6] آماده‌سازی مخزن گیت...${NC}"
if [ -d ".git" ]; then
    rm -rf .git
    echo -e "${GREEN}مخزن گیت قبلی حذف شد.${NC}"
fi

git init
git add .
git config user.email "user@example.com"
git config user.name "$GITHUB_USERNAME"

echo -e "\n${YELLOW}[4/6] ثبت تغییرات...${NC}"
git commit -m "نسخه کامل ربات تلگرام با پشتیبانی SSL"

echo -e "\n${YELLOW}[5/6] تنظیم مخزن از راه دور...${NC}"
git remote add origin https://$GITHUB_TOKEN@github.com/$GITHUB_USERNAME/$REPO_NAME.git

echo -e "\n${YELLOW}[6/6] ارسال کد به گیت‌هاب...${NC}"
git branch -M main
git push -u origin main --force

if [ $? -eq 0 ]; then
    # پاکسازی توکن از تنظیمات
    git remote remove origin
    git remote add origin https://github.com/$GITHUB_USERNAME/$REPO_NAME.git
    
    echo -e "\n${GREEN}✅ کد با موفقیت به گیت‌هاب منتقل شد!${NC}"
    echo -e "${BLUE}-------------------------------------------${NC}"
    echo -e "${YELLOW}آدرس مخزن:${NC} https://github.com/$GITHUB_USERNAME/$REPO_NAME"
    echo -e "${YELLOW}دستور clone:${NC} git clone https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"
    echo -e "${BLUE}-------------------------------------------${NC}"
    echo -e "${GREEN}دستور نصب SSL (توصیه شده):${NC}"
    echo -e "sudo bash -c \"\$(curl -s https://raw.githubusercontent.com/$GITHUB_USERNAME/$REPO_NAME/main/full_install_ssl.sh)\""
    echo -e "${BLUE}-------------------------------------------${NC}"
    echo -e "${YELLOW}برای دیدن دستور نصب یک خطی:${NC} cat one_line_ssl_install.txt"
else
    echo -e "\n${RED}❌ خطا در ارسال کد به گیت‌هاب!${NC}"
    echo -e "${YELLOW}لطفاً موارد زیر را بررسی کنید:${NC}"
    echo -e "1. توکن گیت‌هاب معتبر باشد"
    echo -e "2. توکن دسترسی کافی داشته باشد (نیاز به دسترسی repo)"
    echo -e "3. اتصال اینترنت برقرار باشد"
fi

echo -e "${BLUE}=========================================${NC}"
