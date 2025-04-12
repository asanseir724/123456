
#!/bin/bash

# تنظیمات رنگی برای پیام‌ها
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}راه‌اندازی SSL برای ربات تلگرام${NC}"
echo -e "${BLUE}=========================================${NC}"

# نصب Certbot و پیش‌نیازها
echo -e "\n${YELLOW}[1/5] نصب Certbot و پیش‌نیازها...${NC}"
apt-get update
apt-get install -y certbot python3-certbot-nginx nginx

# دریافت دامنه از کاربر
echo -e "\n${YELLOW}[2/5] تنظیم دامنه برای گواهی SSL...${NC}"
echo -e "${YELLOW}لطفاً دامنه یا زیردامنه خود را وارد کنید (مثال: bot.example.com):${NC}"
read DOMAIN

# بررسی وجود دامنه
if [ -z "$DOMAIN" ]; then
    echo -e "${RED}دامنه وارد نشده است. عملیات لغو شد.${NC}"
    exit 1
fi

# تنظیم Nginx
echo -e "\n${YELLOW}[3/5] تنظیم Nginx برای دامنه $DOMAIN...${NC}"
cat > /etc/nginx/sites-available/$DOMAIN <<EOF
server {
    listen 80;
    server_name $DOMAIN;

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

ln -sf /etc/nginx/sites-available/$DOMAIN /etc/nginx/sites-enabled/

# بررسی پیکربندی و راه‌اندازی مجدد Nginx
nginx -t
if [ $? -eq 0 ]; then
    echo -e "${GREEN}پیکربندی Nginx با موفقیت تأیید شد.${NC}"
    systemctl restart nginx
    echo -e "${GREEN}Nginx مجددا راه‌اندازی شد.${NC}"
else
    echo -e "${RED}خطا در پیکربندی Nginx. لطفا مشکل را رفع کنید.${NC}"
    exit 1
fi

# دریافت گواهی SSL با Certbot
echo -e "\n${YELLOW}[4/5] دریافت گواهی SSL از Let's Encrypt...${NC}"
certbot --nginx -d $DOMAIN --non-interactive --agree-tos --email admin@$DOMAIN

if [ $? -eq 0 ]; then
    echo -e "${GREEN}گواهی SSL با موفقیت دریافت و نصب شد.${NC}"
else
    echo -e "${RED}خطا در دریافت گواهی SSL.${NC}"
    echo -e "${YELLOW}ممکن است نیاز باشد دامنه به IP سرور اشاره کند و مدتی منتظر بمانید تا تغییرات DNS اعمال شود.${NC}"
    exit 1
fi

# تنظیم وب‌هوک تلگرام
echo -e "\n${YELLOW}[5/5] تنظیم وب‌هوک تلگرام...${NC}"
echo -e "برای تنظیم وب‌هوک تلگرام، از آدرس زیر استفاده کنید:"
echo -e "${GREEN}https://$DOMAIN/telegram-webhook${NC}"

echo -e "\n${GREEN}✅ راه‌اندازی SSL به پایان رسید.${NC}"
echo -e "${BLUE}پنل مدیریت اکنون در آدرس زیر قابل دسترسی است:${NC}"
echo -e "${GREEN}https://$DOMAIN/admin${NC}"
echo -e "${BLUE}=========================================${NC}"

# دستورالعمل برای تنظیم وب‌هوک
echo -e "\n${YELLOW}برای تنظیم وب‌هوک در ربات تلگرام:${NC}"
echo -e "1. به پنل مدیریت وارد شوید"
echo -e "2. به بخش تنظیمات ربات بروید"
echo -e "3. آدرس وب‌هوک را به صورت https://$DOMAIN/telegram-webhook وارد کنید"
echo -e "4. روی دکمه 'تنظیم وب‌هوک' کلیک کنید"
echo -e "${BLUE}=========================================${NC}"
