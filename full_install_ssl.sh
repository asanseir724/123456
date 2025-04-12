
#!/bin/bash

# Color settings for messages
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}نصب کامل ربات مدیریت اشتراک تلگرام با SSL${NC}"
echo -e "${BLUE}=========================================${NC}"

# Install git if not installed
if ! command -v git &> /dev/null; then
    echo -e "\n${YELLOW}Git یافت نشد. در حال نصب git...${NC}"
    apt-get update
    apt-get install -y git curl
fi

# Create a directory for the bot
echo -e "\n${YELLOW}ایجاد دایرکتوری نصب...${NC}"
mkdir -p ~/telegram-bot
cd ~/telegram-bot

# Clone the repository
echo -e "\n${YELLOW}کلون کردن مخزن...${NC}"
git clone https://github.com/YOUR_GITHUB_USERNAME/telegram-premium-bot.git .

# Make scripts executable
echo -e "\n${YELLOW}اعطای دسترسی اجرا به اسکریپت‌ها...${NC}"
chmod +x *.sh

# Run the installation script with SSL
echo -e "\n${YELLOW}اجرای اسکریپت نصب با پشتیبانی SSL...${NC}"
./install_with_ssl.sh

echo -e "\n${GREEN}نصب با پشتیبانی SSL کامل شد!${NC}"
echo -e "${BLUE}ربات در مسیر زیر نصب شده است:${NC} $(pwd)"
echo -e "${BLUE}=========================================${NC}"

# Prompt for bot token
echo -e "\n${YELLOW}آیا می‌خواهید توکن ربات تلگرام را تنظیم کنید؟ (y/n):${NC}"
read SET_TOKEN
if [[ "$SET_TOKEN" == "y" || "$SET_TOKEN" == "Y" ]]; then
    echo -e "${YELLOW}لطفاً توکن ربات تلگرام را وارد کنید:${NC}"
    read BOT_TOKEN
    if [ ! -z "$BOT_TOKEN" ]; then
        # Update .env file
        sed -i "s/TELEGRAM_BOT_TOKEN=.*/TELEGRAM_BOT_TOKEN=$BOT_TOKEN/" .env
        echo -e "${GREEN}توکن ربات با موفقیت تنظیم شد.${NC}"
        
        # Restart service
        sudo systemctl restart telegrambot.service
        echo -e "${GREEN}سرویس ربات مجدداً راه‌اندازی شد.${NC}"
    fi
fi

echo -e "\n${GREEN}✅ ربات آماده استفاده است!${NC}"
echo -e "${BLUE}=========================================${NC}"
