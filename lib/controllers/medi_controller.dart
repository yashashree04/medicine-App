import 'package:flutter/material.dart';
import 'package:flutter_application_1/database/db_services.dart';
import 'package:flutter_application_1/database/notification.dart';
import 'package:flutter_application_1/models/medi_model.dart';

class MedicineController extends ChangeNotifier {
  final DBService _db = DBService();
  final NotificationService _notifier = NotificationService();

  List<Medicine> _medicines = [];
  List<Medicine> get medicines => _medicines;

  MedicineController() {
    loadMedicines();
  }

  Future<void> loadMedicines() async {
    _medicines = await _db.getMedicines();
    _medicines.sort((a, b) => a.time.compareTo(b.time));
    notifyListeners();
  }

Future<void> addMedicine(String name, String dose, DateTime time) async {
  
  if (time.isBefore(DateTime.now())) {
    time = time.add(const Duration(days: 1));
  }

  final med = Medicine(name: name, dose: dose, time: time);

  final id = await _db.insertMedicine(med);

  await _notifier.scheduleNotification(id, name, time);

  await loadMedicines();
}

}
