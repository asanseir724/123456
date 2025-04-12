
#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}ایجاد مخزن گیت‌هاب جدید${NC}"
echo -e "${BLUE}=========================================${NC}"

# دریافت توکن گیت‌هاب
echo -e "${YELLOW}توکن شخصی گیت‌هاب خود را وارد کنید:${NC}"
read -s GITHUB_TOKEN
echo -e "${GREEN}توکن دریافت شد${NC}"

# دریافت نام کاربری گیت‌هاب
echo -e "${YELLOW}نام کاربری گیت‌هاب خود را وارد کنید:${NC}"
read GITHUB_USERNAME

# دریافت نام مخزن جدید
echo -e "${YELLOW}نام مخزن جدید را وارد کنید:${NC}"
read NEW_REPO_NAME

# دریافت توضیحات مخزن
echo -e "${YELLOW}توضیحات مخزن را وارد کنید (اختیاری):${NC}"
read REPO_DESCRIPTION
REPO_DESCRIPTION=${REPO_DESCRIPTION:-"مخزن ربات مدیریت اشتراک تلگرام"}

# دریافت وضعیت عمومی/خصوصی بودن مخزن
echo -e "${YELLOW}آیا مخزن خصوصی باشد؟ (y/n):${NC}"
read IS_PRIVATE
if [[ "$IS_PRIVATE" == "y" || "$IS_PRIVATE" == "Y" ]]; then
    PRIVATE_STATUS="true"
else
    PRIVATE_STATUS="false"
fi

# نمایش اطلاعات برای تأیید
echo -e "\n${BLUE}اطلاعات مخزن جدید:${NC}"
echo -e "${YELLOW}نام کاربری:${NC} $GITHUB_USERNAME"
echo -e "${YELLOW}نام مخزن:${NC} $NEW_REPO_NAME"
echo -e "${YELLOW}توضیحات:${NC} $REPO_DESCRIPTION"
if [[ "$PRIVATE_STATUS" == "true" ]]; then
    echo -e "${YELLOW}وضعیت:${NC} خصوصی"
else
    echo -e "${YELLOW}وضعیت:${NC} عمومی"
fi

# دریافت تأیید نهایی
echo -e "\n${YELLOW}آیا برای ایجاد مخزن مطمئن هستید؟ (y/n):${NC}"
read CONFIRM
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
    echo -e "${RED}عملیات لغو شد.${NC}"
    exit 1
fi

# ایجاد مخزن جدید در گیت‌هاب
echo -e "\n${YELLOW}[1/5] در حال ایجاد مخزن گیت‌هاب جدید...${NC}"
CREATE_RESPONSE=$(curl -s -X POST -H "Authorization: token $GITHUB_TOKEN" \
     -H "Accept: application/vnd.github.v3+json" \
     -d "{\"name\":\"$NEW_REPO_NAME\", \"description\":\"$REPO_DESCRIPTION\", \"private\":$PRIVATE_STATUS}" \
     "https://api.github.com/user/repos")

# بررسی پاسخ ایجاد مخزن
if [[ "$CREATE_RESPONSE" == *"Bad credentials"* ]]; then
    echo -e "${RED}خطا: توکن گیت‌هاب نامعتبر است.${NC}"
    exit 1
elif [[ "$CREATE_RESPONSE" == *"name already exists"* ]]; then
    echo -e "${RED}خطا: مخزنی با این نام قبلاً ایجاد شده است.${NC}"
    
    # پرسش برای استفاده از مخزن موجود
    echo -e "${YELLOW}آیا می‌خواهید با همین مخزن موجود ادامه دهید؟ (y/n):${NC}"
    read USE_EXISTING
    if [[ "$USE_EXISTING" != "y" && "$USE_EXISTING" != "Y" ]]; then
        exit 1
    fi
    echo -e "${YELLOW}استفاده از مخزن موجود...${NC}"
else
    echo -e "${GREEN}مخزن گیت‌هاب با موفقیت ایجاد شد!${NC}"
fi

# ایجاد .gitignore مناسب
echo -e "\n${YELLOW}[2/5] ایجاد فایل .gitignore...${NC}"
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

# Log files
logs/
*.log

# Database files
*.db
*.sqlite
*.sqlite3

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
EOF

# بازنشانی مخزن گیت محلی
echo -e "\n${YELLOW}[3/5] تنظیم مخزن گیت محلی...${NC}"
if [ -d ".git" ]; then
    rm -rf .git
    echo -e "${GREEN}مخزن محلی قبلی حذف شد.${NC}"
fi

# ایجاد README.md پایه
echo -e "\n${YELLOW}[4/5] ایجاد فایل README.md...${NC}"
cat > README.md << EOF
# $NEW_REPO_NAME

$REPO_DESCRIPTION

## ویژگی‌ها

- مدیریت خودکار اشتراک تلگرام
- پشتیبانی از پرداخت‌های ارز دیجیتال
- پنل مدیریت
- پشتیبانی از وبهوک‌ها
- پشتیبانی از SSL برای ارتباط امن

## نصب سریع

برای نصب معمولی، از دستور زیر استفاده کنید:

\`\`\`bash
bash <(curl -s https://raw.githubusercontent.com/$GITHUB_USERNAME/$NEW_REPO_NAME/main/install.sh)
\`\`\`

## نصب با پشتیبانی SSL (توصیه شده)

برای نصب با پشتیبانی SSL (برای وب‌هوک تلگرام)، از دستور زیر استفاده کنید:

\`\`\`bash
sudo bash -c "\$(curl -s https://raw.githubusercontent.com/$GITHUB_USERNAME/$NEW_REPO_NAME/main/full_install_ssl.sh)"
\`\`\`
EOF

# راه‌اندازی گیت و ارسال کدها به مخزن
echo -e "\n${YELLOW}[5/5] آماده‌سازی و ارسال کدها به گیت‌هاب...${NC}"
git init
git add .
git config user.email "user@example.com"
git config user.name "$GITHUB_USERNAME"
git commit -m "نسخه اولیه ربات"

# تنظیم remote و ارسال
git remote add origin https://$GITHUB_TOKEN@github.com/$GITHUB_USERNAME/$NEW_REPO_NAME.git
git branch -M main
git push -u origin main

if [ $? -eq 0 ]; then
    # پاکسازی توکن از تنظیمات
    git remote remove origin
    git remote add origin https://github.com/$GITHUB_USERNAME/$NEW_REPO_NAME.git
    
    echo -e "\n${GREEN}✅ عملیات با موفقیت انجام شد!${NC}"
    echo -e "${BLUE}-------------------------------------------${NC}"
    echo -e "${YELLOW}آدرس مخزن:${NC} https://github.com/$GITHUB_USERNAME/$NEW_REPO_NAME"
    echo -e "${YELLOW}دستور clone:${NC} git clone https://github.com/$GITHUB_USERNAME/$NEW_REPO_NAME.git"
    echo -e "${BLUE}-------------------------------------------${NC}"
else
    echo -e "\n${RED}❌ خطا در ارسال کدها به گیت‌هاب!${NC}"
    echo -e "${YELLOW}لطفاً موارد زیر را بررسی کنید:${NC}"
    echo -e "1. توکن گیت‌هاب معتبر باشد"
    echo -e "2. توکن دسترسی کافی داشته باشد (نیاز به دسترسی repo)"
    echo -e "3. اتصال اینترنت برقرار باشد"
fi

echo -e "${BLUE}=========================================${NC}"
