import sys
from PyQt6.QtWidgets import (QApplication, QMainWindow, QWidget, QVBoxLayout,
                            QTextEdit, QPushButton, QLabel, QProgressBar,
                            QScrollArea, QFrame, QTabWidget, QLineEdit,
                            QComboBox, QHBoxLayout, QGridLayout)
from PyQt6.QtCore import Qt, QThread, pyqtSignal, QTimer
from PyQt6.QtGui import QFont, QPalette, QColor
import speech_recognition as sr
from ai_symptom_analyzer import SymptomAnalyzer
from doctor_search import DoctorSearch, Doctor

class VoiceRecorderThread(QThread):
    finished = pyqtSignal(str)
    error = pyqtSignal(str)
    status = pyqtSignal(str)

    def run(self):
        try:
            recognizer = sr.Recognizer()
            with sr.Microphone() as source:
                self.status.emit("Adjusting for ambient noise...")
                recognizer.adjust_for_ambient_noise(source)
                self.status.emit("Recording... Speak now")
                audio = recognizer.listen(source, timeout=5)
                self.status.emit("Processing speech...")
                text = recognizer.recognize_google(audio)
                self.finished.emit(text)
        except sr.WaitTimeoutError:
            self.error.emit("No speech detected")
        except sr.UnknownValueError:
            self.error.emit("Could not understand audio")
        except Exception as e:
            self.error.emit(f"Error: {str(e)}")

class AnalysisThread(QThread):
    finished = pyqtSignal(dict)
    progress = pyqtSignal(int)

    def __init__(self, symptoms, analyzer):
        super().__init__()
        self.symptoms = symptoms
        self.analyzer = analyzer

    def run(self):
        try:
            # Simulate progress
            for i in range(0, 101, 10):
                self.progress.emit(i)
                self.msleep(100)
            
            # Get analysis results
            results = self.analyzer.analyze_symptoms(self.symptoms)
            self.finished.emit(results)
        except Exception as e:
            self.finished.emit({"error": str(e)})

class TelemedicineApp(QMainWindow):
    def __init__(self):
        super().__init__()
        self.analyzer = SymptomAnalyzer()
        self.doctor_search = DoctorSearch()
        self.init_ui()

    def init_ui(self):
        self.setWindowTitle('Telemedicine')
        self.setMinimumSize(800, 900)

        # Create central widget and layout
        central_widget = QWidget()
        self.setCentralWidget(central_widget)
        layout = QVBoxLayout(central_widget)
        layout.setSpacing(10)
        layout.setContentsMargins(20, 20, 20, 20)

        # Title
        title = QLabel('Telemedicine')
        title.setFont(QFont('Arial', 24, QFont.Weight.Bold))
        title.setAlignment(Qt.AlignmentFlag.AlignCenter)
        layout.addWidget(title)

        # Create tab widget
        tabs = QTabWidget()
        layout.addWidget(tabs)

        # Symptom Analysis Tab
        symptom_tab = QWidget()
        symptom_layout = QVBoxLayout(symptom_tab)
        
        # Move existing symptom analysis widgets to the tab
        self.symptom_input = QTextEdit()
        self.symptom_input.setPlaceholderText('Describe your symptoms here...')
        self.symptom_input.setMinimumHeight(100)
        symptom_layout.addWidget(self.symptom_input)

        self.voice_btn = QPushButton('🎤 Record Voice')
        self.voice_btn.setStyleSheet("""
            QPushButton {
                background-color: #2196F3;
                color: white;
                border: none;
                padding: 10px;
                border-radius: 5px;
            }
            QPushButton:hover {
                background-color: #1976D2;
            }
        """)
        self.voice_btn.clicked.connect(self.record_voice)
        symptom_layout.addWidget(self.voice_btn)

        self.recording_label = QLabel('')
        self.recording_label.setStyleSheet('color: #2196F3;')
        symptom_layout.addWidget(self.recording_label)

        self.analyze_btn = QPushButton('🔍 Analyze Symptoms')
        self.analyze_btn.setStyleSheet("""
            QPushButton {
                background-color: #4CAF50;
                color: white;
                border: none;
                padding: 10px;
                border-radius: 5px;
            }
            QPushButton:hover {
                background-color: #388E3C;
            }
        """)
        self.analyze_btn.clicked.connect(self.analyze_symptoms)
        symptom_layout.addWidget(self.analyze_btn)

        self.progress_bar = QProgressBar()
        self.progress_bar.setVisible(False)
        symptom_layout.addWidget(self.progress_bar)

        results_frame = QFrame()
        results_frame.setFrameStyle(QFrame.Shape.StyledPanel)
        results_layout = QVBoxLayout(results_frame)

        scroll_area = QScrollArea()
        scroll_area.setWidgetResizable(True)
        scroll_area.setMinimumHeight(200)

        self.results_label = QLabel()
        self.results_label.setWordWrap(True)
        self.results_label.setTextFormat(Qt.TextFormat.RichText)
        scroll_area.setWidget(self.results_label)
        results_layout.addWidget(scroll_area)
        symptom_layout.addWidget(results_frame)

        tabs.addTab(symptom_tab, "Symptom Analysis")

        # Doctor Search Tab
        doctor_tab = QWidget()
        doctor_layout = QVBoxLayout(doctor_tab)

        # Search form
        search_form = QGridLayout()
        
        location_label = QLabel("Location:")
        self.location_input = QLineEdit()
        self.location_input.setPlaceholderText("Enter your city or address")
        search_form.addWidget(location_label, 0, 0)
        search_form.addWidget(self.location_input, 0, 1)

        specialization_label = QLabel("Specialization:")
        self.specialization_input = QComboBox()
        self.specialization_input.addItems([
            "General Medicine",
            "Pediatrics",
            "Cardiology",
            "Dermatology",
            "Orthopedics",
            "Neurology",
            "Gynecology"
        ])
        search_form.addWidget(specialization_label, 1, 0)
        search_form.addWidget(self.specialization_input, 1, 1)

        radius_label = QLabel("Search Radius (km):")
        self.radius_input = QComboBox()
        self.radius_input.addItems(["5", "10", "20", "50"])
        self.radius_input.setCurrentText("10")
        search_form.addWidget(radius_label, 2, 0)
        search_form.addWidget(self.radius_input, 2, 1)

        search_btn = QPushButton("🔍 Search Doctors")
        search_btn.setStyleSheet("""
            QPushButton {
                background-color: #2196F3;
                color: white;
                border: none;
                padding: 10px;
                border-radius: 5px;
            }
            QPushButton:hover {
                background-color: #1976D2;
            }
        """)
        search_btn.clicked.connect(self.search_doctors)
        search_form.addWidget(search_btn, 3, 0, 1, 2)

        doctor_layout.addLayout(search_form)

        # Results area
        self.doctor_results = QScrollArea()
        self.doctor_results.setWidgetResizable(True)
        self.doctor_results.setMinimumHeight(400)
        
        self.doctor_results_widget = QWidget()
        self.doctor_results_layout = QVBoxLayout(self.doctor_results_widget)
        self.doctor_results.setWidget(self.doctor_results_widget)
        
        doctor_layout.addWidget(self.doctor_results)
        tabs.addTab(doctor_tab, "Find Doctors")

        # Set window style
        self.setStyleSheet("""
            QMainWindow {
                background-color: white;
            }
            QTextEdit, QLineEdit {
                border: 1px solid #BDBDBD;
                border-radius: 5px;
                padding: 5px;
            }
            QProgressBar {
                border: 1px solid #BDBDBD;
                border-radius: 5px;
                text-align: center;
            }
            QProgressBar::chunk {
                background-color: #4CAF50;
            }
            QComboBox {
                border: 1px solid #BDBDBD;
                border-radius: 5px;
                padding: 5px;
            }
        """)

    def record_voice(self):
        self.voice_btn.setEnabled(False)
        self.recording_thread = VoiceRecorderThread()
        self.recording_thread.finished.connect(self.on_recording_finished)
        self.recording_thread.error.connect(self.on_recording_error)
        self.recording_thread.status.connect(self.on_recording_status)
        self.recording_thread.start()

    def on_recording_finished(self, text):
        self.symptom_input.setText(text)
        self.recording_label.setText("Recording completed!")
        self.voice_btn.setEnabled(True)
        QTimer.singleShot(3000, lambda: self.recording_label.setText(""))

    def on_recording_error(self, error):
        self.recording_label.setText(error)
        self.voice_btn.setEnabled(True)
        QTimer.singleShot(3000, lambda: self.recording_label.setText(""))

    def on_recording_status(self, status):
        self.recording_label.setText(status)

    def analyze_symptoms(self):
        symptoms = self.symptom_input.toPlainText()
        if symptoms:
            self.progress_bar.setVisible(True)
            self.progress_bar.setValue(0)
            self.analyze_btn.setEnabled(False)
            
            self.analysis_thread = AnalysisThread(symptoms, self.analyzer)
            self.analysis_thread.progress.connect(self.update_progress)
            self.analysis_thread.finished.connect(self.on_analysis_finished)
            self.analysis_thread.start()

    def update_progress(self, value):
        self.progress_bar.setValue(value)

    def on_analysis_finished(self, results):
        self.progress_bar.setVisible(False)
        self.analyze_btn.setEnabled(True)
        
        if "error" in results:
            self.results_label.setText(f"<span style='color: red;'>Error: {results['error']}</span>")
        else:
            html = "<h3>Analysis Results:</h3>"
            for suggestion in results.get("suggestions", []):
                html += f"<p><b>Condition:</b> {suggestion['condition']}<br>"
                html += f"<b>Probability:</b> {suggestion['probability']:.2%}<br>"
                html += "<b>Home Remedies:</b><ul>"
                for remedy in suggestion['home_remedies']:
                    html += f"<li>{remedy}</li>"
                html += "</ul></p>"
            self.results_label.setText(html)

    def search_doctors(self):
        location = self.location_input.text()
        specialization = self.specialization_input.currentText()
        radius = float(self.radius_input.currentText())

        if not location:
            self.show_doctor_results("Please enter a location")
            return

        # Clear previous results
        self.clear_doctor_results()

        # Search for doctors
        doctors = self.doctor_search.search_nearby_doctors(location, specialization, radius)
        
        if not doctors:
            self.show_doctor_results("No doctors found in your area")
            return

        # Display results
        for doctor in doctors:
            doctor_card = QFrame()
            doctor_card.setFrameStyle(QFrame.Shape.StyledPanel)
            doctor_card.setStyleSheet("""
                QFrame {
                    background-color: #f5f5f5;
                    border-radius: 5px;
                    margin: 5px;
                }
            """)
            
            card_layout = QVBoxLayout(doctor_card)
            
            # Doctor name and rating
            name_layout = QHBoxLayout()
            name_label = QLabel(f"<b>{doctor.name}</b>")
            rating_label = QLabel(f"⭐ {doctor.rating:.1f}")
            name_layout.addWidget(name_label)
            name_layout.addWidget(rating_label)
            card_layout.addLayout(name_layout)
            
            # Specialization
            card_layout.addWidget(QLabel(f"<i>{doctor.specialization}</i>"))
            
            # Address and distance
            card_layout.addWidget(QLabel(f"📍 {doctor.address}"))
            card_layout.addWidget(QLabel(f"Distance: {doctor.distance:.1f} km"))
            
            # Phone
            card_layout.addWidget(QLabel(f"📞 {doctor.phone}"))
            
            self.doctor_results_layout.addWidget(doctor_card)

    def clear_doctor_results(self):
        while self.doctor_results_layout.count():
            item = self.doctor_results_layout.takeAt(0)
            if item.widget():
                item.widget().deleteLater()

    def show_doctor_results(self, message):
        self.clear_doctor_results()
        label = QLabel(message)
        label.setAlignment(Qt.AlignmentFlag.AlignCenter)
        self.doctor_results_layout.addWidget(label)

if __name__ == '__main__':
    app = QApplication(sys.argv)
    window = TelemedicineApp()
    window.show()
    sys.exit(app.exec()) 