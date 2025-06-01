import 'package:flutter/material.dart';

class DoctorSearchScreen extends StatefulWidget {
  const DoctorSearchScreen({super.key});

  @override
  State<DoctorSearchScreen> createState() => _DoctorSearchScreenState();
}

class _DoctorSearchScreenState extends State<DoctorSearchScreen> {
  final TextEditingController _locationController = TextEditingController();
  String _selectedSpecialization = 'General Medicine';
  double _selectedRadius = 10.0;

  final List<String> _specializations = [
    'General Medicine',
    'Pediatrics',
    'Cardiology',
    'Dermatology',
    'Orthopedics',
    'Neurology',
    'Gynecology',
  ];

  final List<double> _radiusOptions = [5.0, 10.0, 20.0, 50.0];

  void _searchDoctors() {
    // TODO: Implement doctor search
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Results'),
        content: const Text('This feature will be implemented soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Doctors'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                hintText: 'Enter your city or address',
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedSpecialization,
              decoration: const InputDecoration(
                labelText: 'Specialization',
                prefixIcon: Icon(Icons.medical_services),
              ),
              items: _specializations.map((String specialization) {
                return DropdownMenuItem<String>(
                  value: specialization,
                  child: Text(specialization),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedSpecialization = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<double>(
              value: _selectedRadius,
              decoration: const InputDecoration(
                labelText: 'Search Radius',
                prefixIcon: Icon(Icons.radar),
              ),
              items: _radiusOptions.map((double radius) {
                return DropdownMenuItem<double>(
                  value: radius,
                  child: Text('$radius km'),
                );
              }).toList(),
              onChanged: (double? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedRadius = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _searchDoctors,
              icon: const Icon(Icons.search),
              label: const Text('Search Doctors'),
            ),
            const SizedBox(height: 24),
            const Text(
              'Nearby Doctors',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDoctorCard(
              name: 'Dr. John Smith',
              specialization: 'General Medicine',
              address: '123 Medical Center Dr',
              phone: '(555) 123-4567',
              rating: 4.5,
              distance: 2.5,
            ),
            _buildDoctorCard(
              name: 'Dr. Sarah Johnson',
              specialization: 'Pediatrics',
              address: '456 Health Plaza',
              phone: '(555) 234-5678',
              rating: 4.8,
              distance: 3.2,
            ),
            _buildDoctorCard(
              name: 'Dr. Michael Brown',
              specialization: 'Cardiology',
              address: '789 Heart Center',
              phone: '(555) 345-6789',
              rating: 4.2,
              distance: 4.7,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorCard({
    required String name,
    required String specialization,
    required String address,
    required String phone,
    required double rating,
    required double distance,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        specialization,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(address),
                ),
                Text(
                  '${distance.toStringAsFixed(1)} km',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.phone, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(phone),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Implement appointment booking
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Book Appointment'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Implement call functionality
                    },
                    icon: const Icon(Icons.phone),
                    label: const Text('Call'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }
} 