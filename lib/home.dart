import 'package:calendar_slider/calendar_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uts_mobile/controller/schedule_controller.dart';
import 'package:uts_mobile/drawer.dart';
import 'package:uts_mobile/models/schedule_model.dart';
import 'package:uts_mobile/schedule/add_schedule.dart';
import 'package:uts_mobile/schedule/edit_schedule.dart';
import 'package:uts_mobile/utils/contants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final schedule = Get.find<ScheduleController>();

  final CalendarSliderController _firstController = CalendarSliderController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late DateTime _selectedDate;
  String _selectedCategory = 'All';

  @override
  void initState() {
    _selectedDate = DateTime.now();

    super.initState();
  }

  int getDaysInMonth(int year, int month) {
    if (month == 12) {
      year++;
      month = 1;
    } else {
      month++;
    }

    DateTime firstDayNextMonth = DateTime(year, month, 1);
    DateTime lastDayCurrentMonth =
        firstDayNextMonth.subtract(const Duration(days: 1));

    return lastDayCurrentMonth.day;
  }

  void _showAddScheduleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddScheduleDialog();
      },
    );
  }

  void _changeSelectedDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void _changeCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  List<ScheduleItemModel> _processTasks(List<ScheduleItemModel> tasks) {
    Map<String, List<ScheduleItemModel>> groupedTasks = {};

    for (var task in tasks) {
      final startTime = DateFormat("hh:mm").parse(task.waktu);
      String hour = DateFormat.H().format(startTime);

      groupedTasks.putIfAbsent(hour, () => []);
      groupedTasks[hour]!.add(task);
    }

    groupedTasks.forEach((hour, tasks) {
      tasks.sort((a, b) {
        final startTimeA = DateFormat('hh:mm').parse(a.waktu);
        final startTimeB = DateFormat('hh:mm').parse(b.waktu);
        return startTimeB.compareTo(startTimeA);
      });
    });

    List<ScheduleItemModel> sortedTasks = [];

    for (var tasks in groupedTasks.values) {
      sortedTasks.addAll(tasks);
    }

    return sortedTasks;
  }

  Iterable<ScheduleItemModel> _filterByDateAndCategory() {
    return schedule.data.where((task) {
      DateTime taskDateRaw = DateTime.parse(task.tanggal);

      DateTime formattedTaskDate = DateTime(
        taskDateRaw.year,
        taskDateRaw.month,
        taskDateRaw.day,
      );

      DateTime formattedSelectedDate = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
      );

      bool matchesDate =
          formattedTaskDate.isAtSameMomentAs(formattedSelectedDate);
      bool matchesCategory = _selectedCategory == 'All' ||
          kategoriItem[task.kategori] == _selectedCategory;

      return matchesDate && matchesCategory;
    });
  }

  Widget _buildCategoryButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: kategoriItem.map((category) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: ElevatedButton(
            onPressed: () => _changeCategory(category),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  _selectedCategory == category ? Colors.blue : Colors.white,
            ),
            child: Text(
              category,
              style: TextStyle(color: Colors.black),
            ),
          ),
        );
      }).toList()
        ..add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: ElevatedButton(
              onPressed: () => _changeCategory('All'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _selectedCategory == 'All' ? Colors.blue : Colors.white,
              ),
              child: const Text(
                'All',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
    );
  }

  Widget _buildScheduleList() {
    final schedules = _processTasks(_filterByDateAndCategory().toList());

    if (schedules.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text(
            "No Schedule",
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return Expanded(
        child: ListView.builder(
      itemCount: schedules.length,
      itemBuilder: (context, index) {
        final sc = schedules[index];
        final timeStr = DateFormat("hh:mm").parse(sc.waktu);
        final formattedTime = DateFormat("hh:mm a").format(timeStr);

        return Card(
          elevation: 10,
          child: ListTile(
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () async {
                    await schedule.deleteTask(sc);
                    Get.snackbar("Deleted", "Success Delete ${sc.id}",
                        backgroundColor: Colors.red);
                  },
                  icon: const Icon(Icons.delete),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return EditScheduleDialog(
                          scheduleItem: sc,
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),
            title: Row(
              children: [
                Text(kategoriItem[sc.kategori]),
                const SizedBox(width: 8),
                Text(
                  formattedTime,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            subtitle: Text(sc.catatan),
            leading: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.book, color: Color(0xFF36A8F4)),
            ),
          ),
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Schedule"),
      ),
      drawer: const DrawerScreen(),
      body: Column(
        children: [
          CalendarSlider(
            initialDate: DateTime.now(),
            firstDate: DateTime.now().subtract(const Duration(days: 100)),
            lastDate: DateTime.now().add(const Duration(days: 100)),
            onDateSelected: _changeSelectedDate,
            controller: _firstController,
            backgroundColor: Color.fromARGB(255, 33, 150, 243),
            monthYearButtonBackgroundColor: Colors.white,
            monthYearTextColor: Colors.black,
          ),
          const SizedBox(height: 10.0),
          _buildCategoryButtons(),
          Obx(() {
            return _buildScheduleList();
          }),
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          onPressed: () => _showAddScheduleDialog(context),
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}
