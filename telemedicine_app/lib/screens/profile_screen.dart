import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Implement settings
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const CircleAvatar(
            radius: 50,
            child: Icon(Icons.person, size: 50),
          ),
          const SizedBox(height: 16),
          const Text(
            'John Doe',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const Text(
            'john.doe@example.com',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Personal Information',
            [
              _buildInfoTile(Icons.phone, 'Phone', '+1 234 567 890'),
              _buildInfoTile(Icons.location_on, 'Address', '123 Main St, City'),
              _buildInfoTile(Icons.cake, 'Date of Birth', 'January 1, 1990'),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            'Emergency Contacts',
            [
              _buildInfoTile(Icons.person, 'Primary Contact', 'Jane Doe (Spouse)'),
              _buildInfoTile(Icons.phone, 'Emergency Phone', '+1 234 567 891'),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            'Medical Information',
            [
              _buildInfoTile(Icons.bloodtype, 'Blood Type', 'O+'),
              _buildInfoTile(Icons.medical_services, 'Allergies', 'None'),
              _buildInfoTile(Icons.medication, 'Current Medications', 'None'),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement edit profile
            },
            child: const Text('Edit Profile'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () {
              // TODO: Implement logout
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 