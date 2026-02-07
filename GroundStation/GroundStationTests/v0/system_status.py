import time

START_TIME = time.time()

def get_uptime():
    t = int(time.time() - START_TIME)
    return f"{t//3600:02d}x{(t%3600)//60:02d}x{t%60:02d}"

def get_status():
    return "OK"
