# Telemedicine Application

A comprehensive telemedicine solution with symptom analysis and doctor consultation features.

## Project Structure

```
Project/
├── backend/              # FastAPI backend service
│   ├── main.py          # Main FastAPI application
│   ├── requirements.txt # Python dependencies
│   └── Dockerfile      # Backend container configuration
└── telemedicine_app/    # Flutter frontend application
    ├── lib/            # Dart source code
    ├── pubspec.yaml    # Flutter dependencies
    └── README.md       # Flutter app documentation
```

## Features

- Symptom Analysis using AI
- Doctor Search and Filtering
- Video Consultations
- Health Records Management
- User Authentication

## Setup Instructions

### Backend Setup

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```

2. Create a virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

4. Run the server:
   ```bash
   uvicorn main:app --reload
   ```

### Flutter App Setup

1. Navigate to the Flutter app directory:
   ```bash
   cd telemedicine_app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Development

- Backend API runs on `http://localhost:8000`
- API documentation available at `http://localhost:8000/docs`
- Flutter app configured to connect to local backend in development

## Deployment

The application is configured for deployment on Render.com:
- Backend service: Web Service
- Environment variables configured in Render dashboard
- Automatic deployments from GitHub

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details. 