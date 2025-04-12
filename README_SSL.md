
# راهنمای راه‌اندازی SSL برای ربات تلگرام

<div dir="rtl">

این راهنما به شما کمک می‌کند تا گواهی SSL را برای ربات تلگرام خود نصب کنید تا بتوانید از وب‌هوک استفاده کنید.

## چرا به SSL نیاز داریم؟

تلگرام فقط از وب‌هوک‌های HTTPS پشتیبانی می‌کند، بنابراین برای استفاده از وب‌هوک باید SSL نصب شود. استفاده از وب‌هوک به جای polling باعث کاهش مصرف منابع سرور و پاسخگویی سریع‌تر می‌شود.

## نصب خودکار

برای نصب خودکار ربات با پشتیبانی SSL، از دستور زیر استفاده کنید:

```bash
sudo bash -c "$(curl -s https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/telegram-premium-bot/main/full_install_ssl.sh)"
```

این دستور به طور خودکار:
1. ربات را نصب می‌کند
2. Nginx را تنظیم می‌کند
3. گواهی SSL را با Let's Encrypt دریافت می‌کند
4. وب‌هوک را تنظیم می‌کند

## نصب دستی SSL برای نصب موجود

اگر قبلاً ربات را نصب کرده‌اید و فقط می‌خواهید SSL اضافه کنید:

```bash
cd ~/premium-bot
chmod +x setup_ssl.sh
./setup_ssl.sh
```

## بررسی وب‌هوک

پس از نصب SSL، می‌توانید وضعیت وب‌هوک خود را بررسی کنید:

```bash
cd ~/premium-bot
python3 -c "import run_telegram_bot; run_telegram_bot.check_webhook()"
```

## عیب‌یابی

اگر با مشکلی مواجه شدید:

1. مطمئن شوید دامنه شما به IP سرور اشاره دارد
2. مطمئن شوید پورت‌های 80 و 443 باز هستند
3. لاگ‌های Nginx را بررسی کنید: `sudo tail -f /var/log/nginx/error.log`
4. لاگ‌های Certbot را بررسی کنید: `sudo certbot certificates`

## استفاده از پولینگ به جای وب‌هوک

اگر نمی‌توانید SSL تنظیم کنید، همیشه می‌توانید از حالت پولینگ استفاده کنید:

```bash
cd ~/premium-bot
python3 -c "import run_telegram_bot; run_telegram_bot.disable_webhook()"
python3 run_telegram_bot.py
```

</div>
