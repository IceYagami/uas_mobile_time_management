
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uts_mobile/controller/schedule_controller.dart';
import 'package:uts_mobile/models/schedule_model.dart';
import 'package:uts_mobile/utils/contants.dart';

class EditScheduleDialog extends StatefulWidget {
  const EditScheduleDialog({
    super.key,
    required this.scheduleItem,
  });

  final ScheduleItemModel scheduleItem;

  @override
  State<EditScheduleDialog> createState() => _EditScheduleDialogState();
}

class _EditScheduleDialogState extends State<EditScheduleDialog> {
  final catatanController = TextEditingController();
  bool isReminder = false;
  final schedule = Get.find<ScheduleController>();

  late int _category;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late int _reminder;

  @override
  void initState() {
    super.initState();
    _category = widget.scheduleItem.kategori;
    _selectedDate = DateTime.parse(widget.scheduleItem.tanggal);
    _selectedTime = TimeOfDay.fromDateTime(
        DateFormat('hh:mm').parse(widget.scheduleItem.waktu));
    _reminder = widget.scheduleItem.pengingat;
    catatanController.text = widget.scheduleItem.catatan;
    isReminder = _reminder > 0;
  }

  @override
  void dispose() {
    catatanController.dispose();
    super.dispose();
  }

  Future<void> _editSchedule() async {
    if (catatanController.text.isEmpty) {
      Get.snackbar('Warning', 'Catatan belum diisi!');
      return;
    }

    var updatedSchedule = ScheduleItemModel(
      id: widget.scheduleItem.id,
      userId: widget.scheduleItem.userId,
      catatan: catatanController.text,
      kategori: _category,
      tanggal: _selectedDate.toIso8601String(),
      waktu: _selectedTime.format(context),
      pengingat: isReminder ? _reminder : 0,
    );

    await schedule.updateTask(updatedSchedule);

    Get.back();

    Get.snackbar(
      'Success',
      'Berhasil memperbarui jadwal ${updatedSchedule.id}',
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
    return AlertDialog(
      title: const Text('Edit Schedule'),
      content: SingleChildScrollView(
        child: Column(
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
              decoration: const InputDecoration(hintText: 'Catatan'),
              controller: catatanController,
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Tanggal',
                      ),
                      child: Text(
                        DateFormat('dd/MM/yyyy').format(_selectedDate),
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
                        labelText: 'Waktu',
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
                  value: isReminder,
                  onChanged: (bool value) {
                    setState(() {
                      isReminder = value;
                    });
                  },
                ),
                Text(
                  isReminder ? 'Reminder' : '',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 10),
                if (isReminder)
                  DropdownButton<int>(
                    value: _reminder,
                    onChanged: (int? newValue) {
                      setState(() {
                        _reminder = newValue!;
                      });
                    },
                    items: reminderItem.asMap().entries.map((entry) {
                      int index = entry.key;
                      String value = '${entry.value} Menit';
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
            _editSchedule();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
