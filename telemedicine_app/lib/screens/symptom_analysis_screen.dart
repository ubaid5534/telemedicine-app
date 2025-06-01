import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';
import 'dart:io';

class SymptomAnalysisScreen extends StatefulWidget {
  const SymptomAnalysisScreen({super.key});

  @override
  State<SymptomAnalysisScreen> createState() => _SymptomAnalysisScreenState();
}

class _SymptomAnalysisScreenState extends State<SymptomAnalysisScreen> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  final TextEditingController _symptomController = TextEditingController();
  bool _isAnalyzing = false;
  Map<String, dynamic>? _analysisResults;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    if (Platform.isWindows) {
      return;
    }
    
    try {
      await _speech.initialize(
        onStatus: (status) => print('Speech status: $status'),
        onError: (error) => print('Speech error: $error'),
      );
    } catch (e) {
      print('Failed to initialize speech: $e');
    }
  }

  void _listen() async {
    if (Platform.isWindows) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Speech recognition is not available on Windows'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            setState(() {
              _text = result.recognizedWords;
              _symptomController.text = _text;
            });
          },
          listenFor: const Duration(seconds: 30),
          pauseFor: const Duration(seconds: 3),
          partialResults: true,
          onSoundLevelChange: (level) {
            // Optional: Add visual feedback for sound level
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  Future<void> _analyzeSymptoms() async {
    if (_symptomController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please describe your symptoms first'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _analysisResults = null;
    });

    try {
      final response = await http.post(
        Uri.parse(ApiConfig.analyzeSymptoms),
        headers: ApiConfig.headers,
        body: jsonEncode({'symptoms': _symptomController.text}),
      ).timeout(
        Duration(milliseconds: ApiConfig.connectTimeout),
        onTimeout: () {
          throw TimeoutException(ApiConfig.timeoutError);
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _analysisResults = jsonDecode(response.body);
          _isAnalyzing = false;
        });
      } else {
        throw Exception('${ApiConfig.serverError} (${response.statusCode})');
      }
    } on TimeoutException {
      setState(() {
        _isAnalyzing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ApiConfig.timeoutError),
          duration: const Duration(seconds: 2),
        ),
      );
    } on SocketException {
      setState(() {
        _isAnalyzing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ApiConfig.networkError),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      setState(() {
        _isAnalyzing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${ApiConfig.serverError}: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildAnalysisResults() {
    if (_analysisResults == null) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.only(top: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Analysis Results',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Possible Conditions:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _analysisResults!['conditions']?.length ?? 0,
              itemBuilder: (context, index) {
                final condition = _analysisResults!['conditions'][index];
                return Card(
                  child: ListTile(
                    title: Text(
                      condition['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Probability: ${condition['probability']}%'),
                        if (condition['matched_symptoms'] != null)
                          Text(
                            'Matched symptoms: ${condition['matched_symptoms'].join(", ")}',
                            style: const TextStyle(fontSize: 12),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Recommended Actions:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _analysisResults!['recommendations']?.length ?? 0,
              itemBuilder: (context, index) {
                final recommendation = _analysisResults!['recommendations'][index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.check_circle_outline),
                    title: Text(recommendation),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Symptom Analysis'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _symptomController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Describe your symptoms here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _listen,
                    icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                    label: Text(_isListening ? 'Stop Listening' : 'Start Listening'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isListening ? Colors.red : null,
                      foregroundColor: _isListening ? Colors.white : null,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isAnalyzing ? null : _analyzeSymptoms,
                    icon: _isAnalyzing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.search),
                    label: Text(_isAnalyzing ? 'Analyzing...' : 'Analyze'),
                  ),
                ),
              ],
            ),
            if (_text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  _text,
                  style: const TextStyle(color: Colors.blue),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 24),
            const Text(
              'Common Symptoms',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildSymptomChip('Fever'),
                _buildSymptomChip('Headache'),
                _buildSymptomChip('Cough'),
                _buildSymptomChip('Fatigue'),
                _buildSymptomChip('Nausea'),
                _buildSymptomChip('Dizziness'),
                _buildSymptomChip('Chest Pain'),
                _buildSymptomChip('Shortness of Breath'),
              ],
            ),
            _buildAnalysisResults(),
          ],
        ),
      ),
    );
  }

  Widget _buildSymptomChip(String label) {
    return FilterChip(
      label: Text(label),
      onSelected: (selected) {
        if (selected) {
          _symptomController.text += '${_symptomController.text.isNotEmpty ? ', ' : ''}$label';
        }
      },
    );
  }

  @override
  void dispose() {
    _symptomController.dispose();
    super.dispose();
  }
} 