import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class HealthRecordsScreen extends StatefulWidget {
  const HealthRecordsScreen({super.key});

  @override
  State<HealthRecordsScreen> createState() => _HealthRecordsScreenState();
}

class _HealthRecordsScreenState extends State<HealthRecordsScreen> {
  int _selectedIndex = 0;
  final List<String> _categories = [
    'Overview',
    'Medical History',
    'Vitals',
    'Medications',
    'Allergies',
    'Documents',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Records'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddRecordDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Tabs
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(_categories[index]),
                    selected: _selectedIndex == index,
                    onSelected: (selected) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          // Content
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildOverview();
      case 1:
        return _buildMedicalHistory();
      case 2:
        return _buildVitals();
      case 3:
        return _buildMedications();
      case 4:
        return _buildAllergies();
      case 5:
        return _buildDocuments();
      default:
        return const Center(child: Text('Select a category'));
    }
  }

  Widget _buildOverview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Health Summary Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Health Summary',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSummaryItem('Blood Pressure', '120/80'),
                      _buildSummaryItem('Heart Rate', '72'),
                      _buildSummaryItem('Temperature', '37°C'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Recent Activity
          const Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.medical_services),
                ),
                title: Text('Visit to Dr. ${['Smith', 'Johnson', 'Williams'][index]}'),
                subtitle: Text(
                  DateFormat('MMM dd, yyyy').format(
                    DateTime.now().subtract(Duration(days: index * 7)),
                  ),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigate to visit details
                },
              );
            },
          ),
          const SizedBox(height: 16),

          // Health Trends
          const Text(
            'Health Trends',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 3),
                      const FlSpot(1, 1),
                      const FlSpot(2, 4),
                      const FlSpot(3, 2),
                      const FlSpot(4, 5),
                    ],
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildMedicalHistory() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            title: Text('Condition ${index + 1}'),
            subtitle: Text('Diagnosed on ${DateFormat('MMM dd, yyyy').format(DateTime.now().subtract(Duration(days: index * 30)))}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Show condition details
            },
          ),
        );
      },
    );
  }

  Widget _buildVitals() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      itemBuilder: (context, index) {
        final vitals = [
          {'name': 'Blood Pressure', 'value': '120/80', 'unit': 'mmHg'},
          {'name': 'Heart Rate', 'value': '72', 'unit': 'bpm'},
          {'name': 'Temperature', 'value': '37', 'unit': '°C'},
          {'name': 'Blood Oxygen', 'value': '98', 'unit': '%'},
        ];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vitals[index]['name']!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      vitals[index]['value']!,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      vitals[index]['unit']!,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: 0.7,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMedications() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.medication),
            ),
            title: Text('Medication ${index + 1}'),
            subtitle: Text('${index + 1} tablet daily'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Show medication details
            },
          ),
        );
      },
    );
  }

  Widget _buildAllergies() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 2,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.red,
              child: Icon(Icons.warning, color: Colors.white),
            ),
            title: Text('Allergy ${index + 1}'),
            subtitle: const Text('Severe reaction'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Show allergy details
            },
          ),
        );
      },
    );
  }

  Widget _buildDocuments() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Card(
          child: InkWell(
            onTap: () {
              // Open document
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.description,
                  size: 48,
                  color: Colors.blue[700],
                ),
                const SizedBox(height: 8),
                Text(
                  'Document ${index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'PDF',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddRecordDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add New Record',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.medical_services),
                title: const Text('Add Medical Condition'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to add condition screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.favorite),
                title: const Text('Add Vital Signs'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to add vitals screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.medication),
                title: const Text('Add Medication'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to add medication screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.warning),
                title: const Text('Add Allergy'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to add allergy screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.description),
                title: const Text('Upload Document'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to document upload screen
                },
              ),
            ],
          ),
        );
      },
    );
  }
} 