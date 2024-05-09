import 'package:calendar_slider/calendar_slider.dart';
import 'package:flutter/material.dart';
import 'package:uts_mobile/navbar.dart';
import 'package:uts_mobile/style.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CalendarSlider(
        backgroundColor: AppColors.darkblue,
        dateColor: Colors.white,
        tileBackgroundColor: AppColors.darkblue,
        selectedTileBackgroundColor: Colors.white,
        monthYearTextColor: Colors.black,
        monthYearButtonBackgroundColor: Colors.white,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(Duration(days: 140)),
        lastDate: DateTime.now().add(Duration(days: 365)),
        onDateSelected: (date) {
          print(date);
        },
      ),
      drawer: NavBarScreen(),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: ListView(
          children: [
            Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                child: ListTile(
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.delete),
                      SizedBox(width: 10),
                      Icon(Icons.edit),
                    ],
                  ),
                  title: Row(
                    children: [
                      Text("Study"),
                      SizedBox(width: 8),
                      Text("12:00",
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  subtitle: Text("Kuliah Mata Pelajaran Pemrograman Mobile"),
                  leading: Container(
                    child: Icon(Icons.book,
                        color: const Color.fromARGB(255, 54, 168, 244)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                child: ListTile(
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.delete),
                      SizedBox(width: 10),
                      Icon(Icons.edit),
                    ],
                  ),
                  title: Row(
                    children: [
                      Text("Me Time"),
                      SizedBox(width: 8),
                      Text("14:00",
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  subtitle: Text("Ke Kost King Januar Main EPEP"),
                  leading: Container(
                    child: Icon(Icons.people, color: Colors.green),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddScheduleDialog(context);
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
                icon: Icon(Icons.menu)),
            SizedBox(width: 20),
            IconButton(onPressed: () {}, icon: Icon(Icons.home)),
          ],
        ),
      ),
    );
  }

  void _showAddScheduleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddScheduleDialog();
      },
    );
  }
}

class AddScheduleDialog extends StatefulWidget {
  const AddScheduleDialog({Key? key}) : super(key: key);

  @override
  State<AddScheduleDialog> createState() => _AddScheduleDialogState();
}

class _AddScheduleDialogState extends State<AddScheduleDialog> {
  String _category = 'Me Time';
  String _time = '5 MENIT';
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  bool isExpense = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: _selectedTime);
    if (picked != null && picked != _selectedTime)
      setState(() {
        _selectedTime = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Schedule'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DropdownButton<String>(
            value: _category,
            onChanged: (String? newValue) {
              setState(() {
                _category = newValue!;
              });
            },
            items: <String>['Me Time', 'Work', 'Study']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          TextField(
            decoration: InputDecoration(hintText: 'Catatan'),
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Date',
                    ),
                    child: Text(
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: InkWell(
                  onTap: () => _selectTime(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
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
          SizedBox(height: 10),
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
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(width: 10),
            ],
          ),
          Row(
            children: [
              if (isExpense) 
                DropdownButton<String>(
                  value: _time,
                  onChanged: (String? newValue) {
                    setState(() {
                      _time = newValue!;
                    });
                  },
                  items: <String>['5 MENIT', '10 MENIT', '15 MENIT', '30 MENIT']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  disabledHint: Text('Select reminder to enable'),
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
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
