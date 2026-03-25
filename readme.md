# FlowTask - Task Management App

A full-stack Task Management application built as part of the Flodo AI Take-Home Assignment.

---

## 🚀 Tech Stack

### Frontend
- Flutter (Dart)
- Provider (State Management)

### Backend
- FastAPI (Python)
- SQLite Database

---

## ✨ Features

### Core Features
- Create, Read, Update, Delete (CRUD) tasks
- Task fields:
  - Title
  - Description
  - Due Date
  - Status (To-Do, In Progress, Done)
  - Blocked By (dependency on another task)

---

### UI & UX
- Clean and responsive UI
- Blocked tasks are visually greyed out and disabled
- Status-based color indicators
- Loading indicator with 2-second simulated delay
- Prevents duplicate submissions

---

### Functionality
- 🔍 Search tasks by title
- 🎯 Filter tasks by status
- ✏️ Edit existing tasks (pre-filled form)
- 🗑 Delete tasks
- ✅ Toggle task status (Done / To-Do)

---

### Advanced Requirement
- 💾 Draft persistence:
  - If user leaves the form, input is saved locally using SharedPreferences
  - Draft reloads automatically when reopening the form

---

## 📱 Screens

- Home Screen (Task List)
- Task Creation / Edit Screen

---

## ⚙️ Setup Instructions

### 1. Clone Repository

```bash
git clone <your-repo-link>
cd flowtask_app