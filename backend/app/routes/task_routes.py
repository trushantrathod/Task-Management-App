from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database import SessionLocal
from app import crud, schemas

router = APIRouter(prefix="/tasks", tags=["Tasks"])

# DB Dependency
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# CREATE
@router.post("/")
async def create(task: schemas.TaskCreate, db: Session = Depends(get_db)):
    return await crud.create_task(db, task)

# GET ALL
@router.get("/", response_model=list[schemas.TaskResponse])
def read_all(db: Session = Depends(get_db)):
    return crud.get_tasks(db)

# UPDATE
@router.put("/{task_id}")
async def update(task_id: int, task: schemas.TaskUpdate, db: Session = Depends(get_db)):
    updated = await crud.update_task(db, task_id, task)
    if not updated:
        raise HTTPException(status_code=404, detail="Task not found")
    return updated

# DELETE
@router.delete("/{task_id}")
def delete(task_id: int, db: Session = Depends(get_db)):
    deleted = crud.delete_task(db, task_id)
    if not deleted:
        raise HTTPException(status_code=404, detail="Task not found")
    return {"message": "Deleted successfully"}