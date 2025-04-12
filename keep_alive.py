
from flask import Flask
import threading
import logging
import os
import time
from run_telegram_bot import start_polling

# Set up logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

# Create Flask app
app = Flask(__name__)

@app.route('/')
def home():
    return "Bot is alive and running!"

@app.route('/health')
def health():
    return "OK", 200

def run_web_server():
    """Run Flask web server in a thread"""
    app.run(host='0.0.0.0', port=5000, debug=False, threaded=True)

def keep_alive():
    """Start a thread to run the web server"""
    server_thread = threading.Thread(target=run_web_server)
    server_thread.daemon = True
    server_thread.start()
    logger.info("Keep-alive web server started")

def start_bot_thread():
    """Start the Telegram bot in a separate thread"""
    bot_thread = threading.Thread(target=start_polling)
    bot_thread.daemon = True
    bot_thread.start()
    logger.info("Telegram bot started in separate thread")
    return bot_thread

# Main execution
if __name__ == "__main__":
    logger.info("Starting keep-alive system")
    
    # Start the web server
    keep_alive()
    
    # Start the bot
    bot_thread = start_bot_thread()
    
    # Keep the main thread alive
    try:
        while True:
            # Check if bot thread is still alive, restart if needed
            if not bot_thread.is_alive():
                logger.warning("Bot thread died, restarting...")
                bot_thread = start_bot_thread()
            
            time.sleep(60)  # Check every minute
    except KeyboardInterrupt:
        logger.info("Program terminated by user")
    except Exception as e:
        logger.error(f"Unexpected error: {str(e)}")
        raise
