import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class TelemedicineProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? _symptomAnalysis;
  List<Map<String, dynamic>>? _doctors;
  String? _error;
  bool _isLoading = false;

  Map<String, dynamic>? get symptomAnalysis => _symptomAnalysis;
  List<Map<String, dynamic>>? get doctors => _doctors;
  String? get error => _error;
  bool get isLoading => _isLoading;

  Future<void> analyzeSymptoms(String symptoms) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _symptomAnalysis = await _apiService.analyzeSymptoms(symptoms);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchDoctors({
    required String location,
    required String specialization,
    required int radius,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _doctors = await _apiService.searchDoctors(
        location: location,
        specialization: specialization,
        radius: radius,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
} 