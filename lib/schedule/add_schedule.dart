import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uts_mobile/controller/schedule_controller.dart';
import 'package:uts_mobile/controller/theme_controller.dart';
import 'package:uts_mobile/models/schedule_model.dart';
import 'package:uts_mobile/utils/contants.dart';

import '../services/notification/notify_helper.dart';

class AddScheduleDialog extends StatefulWidget {
  const AddScheduleDialog({super.key});

  @override
  State<AddScheduleDialog> createState() => _AddScheduleDialogState();
}

class _AddScheduleDialogState extends State<AddScheduleDialog> {
  final catatanController = TextEditingController();
  bool isExpense = false;
  final schedule = Get.find<ScheduleController>();

  int _category = 0;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  int _time = 0;

  @override
  void dispose() {
    catatanController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
  }

  _addSchedule() async {
    if (catatanController.text.isEmpty ||
        _selectedDate == false ||
        _selectedTime == false) {
      Get.snackbar('Warning', 'catatan belum diisi!');
      return;
    }

    var skema = ScheduleItemModel(
      kategori: _category,
      tanggal: _selectedDate.toString(),
      waktu: _selectedTime.format(context),
      catatan: catatanController.text,
      pengingat: _time,
    );

    await schedule.addTask(skema);
    await NotificationHelper.createScheduledNotification(skema);

    await Future.delayed(const Duration(milliseconds: 2));

    Get.back();

    Get.snackbar(
      'Succes',
      "Berhasil Menambahkan ${skema.id}",
      backgroundColor: Colors.green,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: _selectedTime);
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return AlertDialog(
      title: const Text('Add Schedule'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DropdownButton<int>(
            value: _category,
            onChanged: (int? newValue) {
              setState(() {
                _category = newValue!;
              });
            },
            items: kategoriItem.asMap().entries.map((entry) {
              int index = entry.key;
              String value = entry.value;
              return DropdownMenuItem<int>(
                value: index,
                child: Text(value),
              );
            }).toList(),
          ),
          TextField(
            decoration: InputDecoration(
                hintText: 'Catatan',
                hintStyle: TextStyle(color: themeController.hintCustomColor)),
            controller: catatanController,
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date',
                    ),
                    child: Text(
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: InkWell(
                  onTap: () => _selectTime(context),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Time',
                    ),
                    child: Text(
                      '${_selectedTime.hour}:${_selectedTime.minute}',
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Switch(
                value: isExpense,
                onChanged: (bool value) {
                  setState(() {
                    isExpense = value;
                  });
                },
              ),
              Text(
                isExpense ? 'REMINDER' : '',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(width: 10),
            ],
          ),
          Row(
            children: [
              if (isExpense)
                DropdownButton<int>(
                  value: _category,
                  onChanged: (int? newValue) {
                    setState(() {
                      _time = newValue!;
                    });
                  },
                  items: reminderItem.asMap().entries.map((entry) {
                    int index = entry.key;
                    var value = '${entry.value} MENIT';
                    return DropdownMenuItem<int>(
                      value: index,
                      child: Text(value),
                    );
                  }).toList(),
                ),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            _addSchedule();
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
