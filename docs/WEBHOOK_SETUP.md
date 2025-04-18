# راهنمای تنظیم وب‌هوک تلگرام

این راهنما مراحل تنظیم و پیکربندی وب‌هوک برای ربات تلگرام را توضیح می‌دهد. استفاده از وب‌هوک به جای polling منابع سرور را بهینه می‌کند و برای استفاده در محیط تولید توصیه می‌شود.

## پیش‌نیازها

1. یک سرور با دسترسی عمومی به اینترنت
2. یک دامنه یا زیردامنه معتبر
3. گواهی SSL برای ارتباط امن (الزامی برای وب‌هوک تلگرام)
4. توکن ربات تلگرام از BotFather

## مراحل تنظیم وب‌هوک

### 1. تنظیم سرور با گواهی SSL

تلگرام فقط از وب‌هوک‌های HTTPS پشتیبانی می‌کند، بنابراین نیاز به گواهی SSL دارید.

برای نصب خودکار و کانفیگ Let's Encrypt در سرور لینوکس، از اسکریپت زیر استفاده کنید:

```bash
bash setup_https.sh
```

این اسکریپت:
- Certbot را نصب می‌کند
- یک گواهی SSL رایگان برای دامنه شما دریافت می‌کند
- Nginx یا Apache را برای استفاده از SSL تنظیم می‌کند

### 2. تنظیم وب‌هوک در فایل .env

فایل `.env` خود را با آدرس وب‌هوک کامل به‌روزرسانی کنید:

```
WEBHOOK_URL=https://your-domain.com/telegram_webhook
```

مطمئن شوید که این URL از HTTPS استفاده می‌کند و به اینترنت عمومی قابل دسترسی است.

### 3. ثبت وب‌هوک با API تلگرام

راه‌های مختلفی برای تنظیم وب‌هوک وجود دارد:

#### روش 1: استفاده از اسکریپت خودکار

ساده‌ترین راه استفاده از اسکریپت تنظیم وب‌هوک است:

```bash
python set_webhook.py
```

این اسکریپت به صورت خودکار:
- آدرس وب‌هوک را از فایل .env می‌خواند
- API تلگرام را برای تنظیم وب‌هوک فراخوانی می‌کند
- نتیجه را اعلام می‌کند

#### روش 2: پنل مدیریت

می‌توانید از صفحه تنظیمات ربات در پنل مدیریت وب استفاده کنید:

1. به آدرس `https://your-domain.com/admin` بروید
2. وارد حساب ادمین شوید
3. به بخش "تنظیمات ربات" بروید
4. روی دکمه "تنظیم وب‌هوک" کلیک کنید

#### روش 3: درخواست HTTP مستقیم

می‌توانید مستقیماً از API تلگرام استفاده کنید:

```bash
curl -F "url=https://your-domain.com/telegram_webhook" https://api.telegram.org/bot<YOUR_BOT_TOKEN>/setWebhook
```

### 4. تایید تنظیمات وب‌هوک

برای تأیید اینکه وب‌هوک به درستی تنظیم شده است:

```bash
curl https://api.telegram.org/bot<YOUR_BOT_TOKEN>/getWebhookInfo
```

خروجی باید شامل URL وب‌هوک شما و `has_custom_certificate`: `false` باشد (اگر از گواهی معتبر استفاده می‌کنید).

## عیب‌یابی وب‌هوک

اگر وب‌هوک کار نمی‌کند:

1. **مشکلات SSL**: مطمئن شوید گواهی SSL معتبر است و به درستی نصب شده است.
   ```bash
   openssl s_client -connect your-domain.com:443 -servername your-domain.com
   ```

2. **مشکلات فایروال**: مطمئن شوید پورت 443 (HTTPS) باز است.
   ```bash
   sudo ufw status  # برای Ubuntu
   sudo iptables -L  # برای سایر توزیع‌های لینوکس
   ```

3. **مشکلات لاگ**: لاگ‌های وب‌هوک را بررسی کنید.
   ```bash
   # از پنل مدیریت یا مستقیماً از فایل
   tail -f logs/webhook.log
   ```

4. **آزمایش مسیر وب‌هوک**: آزمایش کنید که آیا مسیر وب‌هوک قابل دسترسی است.
   ```bash
   curl -I https://your-domain.com/telegram_webhook
   ```

## تغییر از وب‌هوک به حالت polling

اگر می‌خواهید به حالت polling بازگردید:

1. وب‌هوک را حذف کنید:
   ```bash
   curl https://api.telegram.org/bot<YOUR_BOT_TOKEN>/deleteWebhook
   ```

2. اسکریپت حالت polling را اجرا کنید:
   ```bash
   bash polling_mode.sh
   ```

## نکات امنیتی

1. آدرس IP سرورهای تلگرام در طول زمان تغییر می‌کند، محدود کردن دسترسی به IP معمولاً توصیه نمی‌شود.

2. می‌توانید یک توکن امنیتی اضافی به URL وب‌هوک اضافه کنید:
   ```
   https://your-domain.com/telegram_webhook/YOUR_SECRET_TOKEN
   ```

3. مطمئن شوید فایل `.env` حاوی توکن ربات و سایر اطلاعات حساس، محافظت شده است.