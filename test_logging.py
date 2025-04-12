#!/usr/bin/env python3
"""
اسکریپت تست سیستم لاگینگ
این اسکریپت همه لاگرهای سیستم را تست می‌کند و به شما نشان می‌دهد آیا آنها به درستی کار می‌کنند یا خیر
"""

import os
import sys
import logging
import logging_config
import time
from datetime import datetime

def main():
    print("Starting logging system test...")

    # Ensure log directory exists
    if not os.path.exists(logging_config.LOG_DIR):
        try:
            os.makedirs(logging_config.LOG_DIR)
            print(f"Log directory created: {logging_config.LOG_DIR}")
        except Exception as e:
            print(f"Error creating log directory: {str(e)}")
            sys.exit(1)

    # Reset loggers
    loggers = logging_config.setup_all_loggers()

    print(f"Log directory path: {os.path.abspath(logging_config.LOG_DIR)}")

    # Test logging in all loggers
    for logger_name, logger in loggers.items():
        # Test different log levels
        logger.debug(f"DEBUG test message in logger {logger_name}")
        logger.info(f"INFO test message in logger {logger_name}")
        logger.warning(f"WARNING test message in logger {logger_name}")
        logger.error(f"ERROR test message in logger {logger_name}")

        print(f"✅ Logger '{logger_name}' tested")


    print("\nOverall log status:")

    # Display all log files and their sizes
    log_files = [f for f in os.listdir(logging_config.LOG_DIR) if f.endswith('.log')]
    for log_file in log_files:
        full_path = os.path.join(logging_config.LOG_DIR, log_file)
        file_size = os.path.getsize(full_path)
        last_modified = datetime.fromtimestamp(os.path.getmtime(full_path)).strftime('%Y-%m-%d %H:%M:%S')
        print(f"  {log_file}: {file_size} بایت (آخرین بروزرسانی: {last_modified})")

    print("\nتست لاگینگ به پایان رسید. لطفاً فایل‌های لاگ را در پوشه logs بررسی کنید.")

if __name__ == "__main__":
    main()