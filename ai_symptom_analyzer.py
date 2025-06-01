import re
from typing import List, Dict, Any

class SymptomAnalyzer:
    def __init__(self):
        # Define common conditions and their associated symptoms
        self.conditions = {
            "Common Cold": {
                "symptoms": ["runny nose", "sore throat", "cough", "congestion", "sneezing"],
                "remedies": [
                    "Rest and get plenty of sleep",
                    "Stay hydrated with warm fluids",
                    "Use over-the-counter cold medications",
                    "Try saline nasal drops",
                    "Use a humidifier"
                ]
            },
            "Flu": {
                "symptoms": ["fever", "body aches", "fatigue", "cough", "sore throat", "headache"],
                "remedies": [
                    "Rest and stay hydrated",
                    "Take over-the-counter pain relievers",
                    "Use a humidifier",
                    "Stay home to prevent spreading",
                    "Consider antiviral medications if prescribed"
                ]
            },
            "Allergies": {
                "symptoms": ["sneezing", "itchy eyes", "runny nose", "congestion", "post-nasal drip"],
                "remedies": [
                    "Take antihistamines",
                    "Use nasal sprays",
                    "Avoid allergens",
                    "Keep windows closed during high pollen times",
                    "Use air purifiers"
                ]
            },
            "Migraine": {
                "symptoms": ["severe headache", "nausea", "sensitivity to light", "sensitivity to sound"],
                "remedies": [
                    "Rest in a dark, quiet room",
                    "Apply cold or warm compresses",
                    "Stay hydrated",
                    "Take prescribed migraine medications",
                    "Practice stress management"
                ]
            },
            "Gastroenteritis": {
                "symptoms": ["nausea", "vomiting", "diarrhea", "abdominal pain", "fever"],
                "remedies": [
                    "Stay hydrated with clear fluids",
                    "Follow the BRAT diet (Bananas, Rice, Applesauce, Toast)",
                    "Rest and avoid strenuous activity",
                    "Avoid dairy and fatty foods",
                    "Consider over-the-counter anti-diarrheal medications"
                ]
            }
        }

    def analyze_symptoms(self, symptoms_text: str) -> Dict[str, Any]:
        """
        Analyze symptoms and return possible conditions with probabilities
        """
        symptoms_text = symptoms_text.lower()
        results = []

        for condition, data in self.conditions.items():
            # Count matching symptoms
            matching_symptoms = sum(1 for symptom in data["symptoms"] 
                                 if symptom in symptoms_text)
            
            if matching_symptoms > 0:
                # Calculate probability based on number of matching symptoms
                probability = matching_symptoms / len(data["symptoms"])
                
                results.append({
                    "condition": condition,
                    "probability": probability,
                    "home_remedies": data["remedies"]
                })

        # Sort results by probability
        results.sort(key=lambda x: x["probability"], reverse=True)
        
        # Take top 3 results
        top_results = results[:3]

        return {
            "suggestions": top_results
        }

    def get_home_remedies(self, condition: str) -> List[str]:
        """
        Get home remedies for a specific condition
        """
        return self.conditions.get(condition, {}).get("remedies", [
            "Rest and stay hydrated",
            "Take over-the-counter pain relievers if needed",
            "Monitor symptoms and seek medical attention if they worsen"
        ]) 