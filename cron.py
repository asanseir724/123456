
import os
import time
import requests
import logging
import subprocess
from datetime import datetime

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[logging.FileHandler('logs/cron.log'), logging.StreamHandler()]
)

logger = logging.getLogger('cron_monitor')

def is_bot_running():
    """Check if the bot is running"""
    try:
        # Check keep-alive server
        response = requests.get('http://0.0.0.0:5000/health', timeout=5)
        if response.status_code == 200:
            logger.info("Keep-alive service is running")
            return True
    except Exception as e:
        logger.error(f"Keep-alive server not responding: {e}")
    
    # Check running processes
    try:
        result = subprocess.run(['pgrep', '-f', 'python.*keep_alive.py'], capture_output=True, text=True)
        if result.stdout.strip():
            return True
    except Exception as e:
        logger.error(f"Error checking processes: {e}")
    
    return False

def restart_bot():
    """Restart the bot"""
    logger.warning("Attempting to restart the bot...")
    try:
        # First kill any existing processes
        subprocess.run(['pkill', '-f', 'python.*keep_alive.py'], capture_output=True)
        time.sleep(2)
        
        # Restart the bot
        process = subprocess.Popen(['python', 'keep_alive.py'], 
                             stdout=open('logs/restart.log', 'a'),
                             stderr=subprocess.STDOUT,
                             start_new_session=True)
        
        logger.info(f"Bot successfully restarted with PID: {process.pid}")
        return True
    except Exception as e:
        logger.error(f"Error restarting bot: {e}")
        return False

def main():
    """Main cron job function"""
    logger.info("Telegram bot monitoring system started")
    
    while True:
        try:
            # Check bot status
            if not is_bot_running():
                logger.warning("Bot is not running!")
                restart_success = restart_bot()
                
                if restart_success:
                    logger.info("Bot was successfully restarted")
                else:
                    logger.error("Bot restart failed")
            else:
                logger.info(f"Status check: Bot is running - {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
            
            # Wait for next check (every 5 minutes)
            time.sleep(300)
        
        except Exception as e:
            logger.error(f"Error in monitoring system: {e}")
            time.sleep(60)  # Shorter wait time in case of error

if __name__ == "__main__":
    # Create logs directory if it doesn't exist
    os.makedirs('logs', exist_ok=True)
    main()
