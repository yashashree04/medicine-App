import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/medi_controller.dart';
import 'package:flutter_application_1/database/notification.dart';
import 'package:flutter_application_1/views/add_medi.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    NotificationService().requestExactAlarmPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Medicines')),

      
      body: Consumer<MedicineController>(
        builder: (context, controller, child) {
          if (controller.medicines.isEmpty) {
            return const Center(
              child: Text(
                'No medicines yet.\nTap + to add one.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: controller.medicines.length,
            itemBuilder: (context, index) {
              final med = controller.medicines[index];
              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.medication, color: Colors.white),
                  ),
                  title: Text(
                    med.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(med.dose),
                  trailing: Text(
                    DateFormat.jm().format(med.time),
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),

    
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          
          FloatingActionButton(
            heroTag: "test",
            backgroundColor: Colors.orange,
            onPressed: () {
              NotificationService().showTestNotification();
            },
            child: const Icon(Icons.notifications),
          ),

          const SizedBox(height: 10),

          FloatingActionButton(
            heroTag: "add",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddMedicineScreen(),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
