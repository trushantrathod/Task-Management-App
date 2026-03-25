from fastapi import FastAPI
from app.database import engine, Base
from app.routes import task_routes

app = FastAPI(title="FlowTask API")

# Create DB tables
Base.metadata.create_all(bind=engine)

# Include routes
app.include_router(task_routes.router)

@app.get("/")
def root():
    return {"message": "API is running"}