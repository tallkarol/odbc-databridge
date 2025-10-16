"""
Logging utility for ODBC Data Bridge scripts

Provides consistent logging configuration across all service scripts.
"""

import logging
import os
from datetime import datetime


def setup_logger(script_name: str, log_dir: str = 'logs', log_level: str = 'INFO') -> logging.Logger:
    """
    Set up a logger for a service script with file and console handlers.
    
    Args:
        script_name: Name of the script (used for log filename)
        log_dir: Directory to store log files
        log_level: Logging level (DEBUG, INFO, WARNING, ERROR, CRITICAL)
    
    Returns:
        Configured logger instance
    """
    # Create logs directory if it doesn't exist
    os.makedirs(log_dir, exist_ok=True)
    
    # Create logger
    logger = logging.getLogger(script_name)
    logger.setLevel(getattr(logging, log_level.upper()))
    
    # Clear existing handlers to avoid duplicates
    logger.handlers.clear()
    
    # Create file handler with timestamp in filename
    timestamp = datetime.now().strftime('%Y%m%d')
    log_filename = os.path.join(log_dir, f"{script_name}_{timestamp}.log")
    file_handler = logging.FileHandler(log_filename)
    file_handler.setLevel(getattr(logging, log_level.upper()))
    
    # Create console handler
    console_handler = logging.StreamHandler()
    console_handler.setLevel(getattr(logging, log_level.upper()))
    
    # Create formatter
    formatter = logging.Formatter(
        '%(asctime)s - %(name)s - %(levelname)s - %(message)s',
        datefmt='%Y-%m-%d %H:%M:%S'
    )
    
    file_handler.setFormatter(formatter)
    console_handler.setFormatter(formatter)
    
    # Add handlers to logger
    logger.addHandler(file_handler)
    logger.addHandler(console_handler)
    
    return logger
