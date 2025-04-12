# Project Contribution Guide

Thank you for your interest in contributing to the Telegram Premium Subscription Management System! This guide is designed to help you contribute effectively.

## Contribution Process

1. First, fork the main repository.
2. Create a new branch for feature development or bug fixing:
   ```
   git checkout -b feature/my-new-feature
   ```
   or
   ```
   git checkout -b fix/issue-description
   ```
3. Make your changes and commit regularly:
   ```
   git commit -am 'Add some feature'
   ```
4. Push your branch to your forked repository:
   ```
   git push origin feature/my-new-feature
   ```
5. Submit a Pull Request to the main repository.

## Coding Standards

* Follow PEP 8 for Python code
* Add appropriate comments (preferably in English)
* Write tests for any major changes
* Document API changes thoroughly
* New features should be compatible with the rest of the code

## What you can improvد دهید؟

* بهبود مستندات و راهنمای کاربر
* اضافه کردن زبان‌های بیشتر به رابط کاربری
* پشتیبانی از درگاه‌های پرداخت بیشتر
* بهینه‌سازی عملکرد
* اضافه کردن ویژگی‌های جدید
* رفع باگ‌های موجود
* بهبود امنیت سیستم

## ساختار پروژه

آشنایی با ساختار پروژه برای مشارکت موثر ضروری است:

* `api.py`: پیاده‌سازی API
* `app.py`: اپلیکیشن فلسک
* `models.py`: مدل‌های دیتابیس
* `run_telegram_bot.py`: منطق اصلی ربات تلگرام
* `config_manager.py`: مدیریت تنظیمات
* `static/` و `templates/`: فایل‌های فرانت‌اند

## گزارش مشکلات

اگر مشکلی در کد پیدا کردید اما فرصت رفع آن را ندارید، لطفاً یک Issue ایجاد کنید و موارد زیر را مشخص کنید:

* عنوان واضح و مختصر
* توضیح دقیق مشکل
* مراحل بازتولید مشکل
* رفتار مورد انتظار
* اسکرین‌شات (در صورت امکان)

## سوالات

اگر سوالی دارید، می‌توانید از بخش Issues استفاده کنید یا به ایمیل پشتیبانی پروژه پیام دهید.

با تشکر از مشارکت شما!