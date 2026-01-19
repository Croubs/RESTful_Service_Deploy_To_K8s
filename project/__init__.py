from fastapi import FastAPI
import logging

app = FastAPI(title="RESTful Service",
              description='Web service for the internship Challenge',
              version='1')

# Log Status Colors 
class ColoredFormatter(logging.Formatter):
    COLORS = {
        'INFO': '\x1b[32m',     # Green
        'ERROR': '\x1b[31m',    # Red
    }
    RESET = '\x1b[0m'
    
    def format(self, record):
        color = self.COLORS.get(record.levelname, '')
        record.levelname = f"{color}{record.levelname}{self.RESET}"
        return super().format(record)

handler = logging.StreamHandler()
handler.setFormatter(ColoredFormatter("%(levelname)s:     %(name)s - %(message)s"))
logging.basicConfig(level=logging.INFO, handlers=[handler])
logger = logging.getLogger("init")

@app.on_event('startup')
def startup():
    logger.info("STARTING UP...")

@app.on_event('shutdown')
def shutdown():
    logger.info("SHUTTING DOWN...")

@app.get("/")
def read_root():
    return {"message": "Welcome"}

@app.get("/hello")
def read_hello():
    return {"Hello": "World"}

@app.get("/health")
def read_health():
    return {"detail":"OK"}
