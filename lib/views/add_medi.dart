import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/medi_controller.dart';
import 'package:provider/provider.dart';

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _doseController = TextEditingController();
  TimeOfDay? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Medicine')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Medicine Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Medicine Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter medicine name' : null,
              ),

              const SizedBox(height: 15),

              // Dose
              TextFormField(
                controller: _doseController,
                decoration: const InputDecoration(
                  labelText: 'Dose (e.g. 1 pill)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter dose' : null,
              ),

              const SizedBox(height: 15),

              // Time Picker
              ListTile(
                title: Text(
                  _selectedTime == null
                      ? 'Select Time'
                      : 'Time: ${_selectedTime!.format(context)}',
                ),
                trailing: const Icon(Icons.access_time, color: Colors.teal),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    setState(() => _selectedTime = picked);
                  }
                },
              ),

              const Spacer(),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.all(15),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        _selectedTime != null) {
                      final now = DateTime.now();

                      // 🔥 CREATE DATE + TIME
                      DateTime scheduledTime = DateTime(
                        now.year,
                        now.month,
                        now.day,
                        _selectedTime!.hour,
                        _selectedTime!.minute,
                      );

                      // 🔥 FORCE FUTURE TIME (CRITICAL FIX)
                      if (scheduledTime.isBefore(now)) {
                        scheduledTime =
                            scheduledTime.add(const Duration(days: 1));
                      }

                      Provider.of<MedicineController>(
                        context,
                        listen: false,
                      ).addMedicine(
                        _nameController.text.trim(),
                        _doseController.text.trim(),
                        scheduledTime,
                      );

                      Navigator.pop(context);
                    } else if (_selectedTime == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select time'),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Save Medicine',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
