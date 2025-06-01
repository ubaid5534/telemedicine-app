class ApiConfig {
  // Development
  static const String devBaseUrl = 'http://localhost:8000';
  
  // Production (Replace with your Render.com URL after deployment)
  static const String prodBaseUrl = 'https://symptom-analysis-api.onrender.com';
  
  // Current environment
  static const bool isProduction = false;
  
  // Get the current base URL
  static String get baseUrl => isProduction ? prodBaseUrl : devBaseUrl;
  
  // API endpoints
  static String get analyzeSymptoms => '$baseUrl/analyze-symptoms';
  
  // API timeout settings
  static const int connectTimeout = 5000; // 5 seconds
  static const int receiveTimeout = 3000; // 3 seconds
  
  // API headers
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Error messages
  static const String networkError = 'Network error occurred. Please check your connection.';
  static const String serverError = 'Server error occurred. Please try again later.';
  static const String timeoutError = 'Request timed out. Please try again.';
} 