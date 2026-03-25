from sqlalchemy.orm import Session
from app import models, schemas
import asyncio

# CREATE
async def create_task(db: Session, task: schemas.TaskCreate):
    await asyncio.sleep(2)  # simulate delay

    db_task = models.Task(**task.dict())
    db.add(db_task)
    db.commit()
    db.refresh(db_task)
    return db_task

# GET ALL
def get_tasks(db: Session):
    tasks = db.query(models.Task).all()

    task_map = {task.id: task for task in tasks}

    result = []

    for task in tasks:
        is_blocked = False

        if task.blocked_by:
            parent = task_map.get(task.blocked_by)

            if parent and parent.status != "Done":
                is_blocked = True

        result.append({
            "id": task.id,
            "title": task.title,
            "description": task.description,
            "due_date": task.due_date,
            "status": task.status,
            "blocked_by": task.blocked_by,
            "is_blocked": is_blocked
        })

    return result

# UPDATE
async def update_task(db: Session, task_id: int, updated: schemas.TaskUpdate):
    await asyncio.sleep(2)

    task = db.query(models.Task).filter(models.Task.id == task_id).first()
    if not task:
        return None

    for key, value in updated.dict().items():
        setattr(task, key, value)

    db.commit()
    db.refresh(task)
    return task

# DELETE
def delete_task(db: Session, task_id: int):
    task = db.query(models.Task).filter(models.Task.id == task_id).first()
    if not task:
        return None

    db.delete(task)
    db.commit()
    return task