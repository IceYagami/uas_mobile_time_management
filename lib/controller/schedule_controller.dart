import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:uts_mobile/models/schedule_model.dart';
import 'package:uts_mobile/services/auth_service.dart';
import 'package:uts_mobile/services/database_service.dart';

class ScheduleController extends GetxController {
  final AuthService _auth = AuthService();
  final DatabaseService _db = DatabaseService();
  String? _recordId;
  final _requiredField = 'userId';
  final RxList<ScheduleItemModel> _scheduleCache = <ScheduleItemModel>[].obs;
  final _scheduleTable = 'schedule';

  List<ScheduleItemModel> get data => _scheduleCache;

  Future<void> init() async {
    if (_auth.currentUser == null || _recordId != null) {
      return;
    }

    try {
      _recordId = _auth.currentUser!.uid;
      await loadTasks();
    } catch (e) {
      throw Exception(e);
    }

    log('Schedule cache screen opened');
  }

  Future<List<ScheduleItemModel>> getKat({required int kategori}) async {
    return _scheduleCache.where((v) => v.kategori == kategori).toList();
  }

  Future<void> initClose() async {
    if (_auth.currentUser != null || _recordId == null) {
      return;
    }

    if (_scheduleCache.isNotEmpty) {
      _scheduleCache.clear();
    }

    _recordId = null;

    log('Schedule cache closed');
  }

  Future<void> loadTasks({bool loadMore = false, int? limit}) async {
    if (!await _db.hasCollection(_scheduleTable) ||
        _auth.currentUser == null ||
        _recordId == null) {
      return;
    }
    try {
      var querySnapShot = await _db
          .find(
            _scheduleTable,
          )
          .then(
            (value) => value.get(),
          );

      if (querySnapShot.docs.isNotEmpty) {
        List<ScheduleItemModel> loadTasks = querySnapShot.docs
            .where((doc) => doc['userId'] == _auth.currentUser!.uid)
            .map((e) => ScheduleItemModel.fromJson(e.data()))
            .toList();

        if (loadMore) {
          _scheduleCache.addAll(loadTasks);
        } else {
          _scheduleCache.assignAll(loadTasks);
        }
      }
    } catch (e) {
      // log('$e');
    }
  }

  Future<void> addTask(ScheduleItemModel schedule) async {
    if (_recordId == null) {
      return;
    }

    try {
      DocumentReference docRef =
          await _db.addData(_scheduleTable, schedule.toJson());

      schedule.userId = _auth.currentUser!.uid;
      schedule.id = docRef.id;

      _scheduleCache.add(schedule);

      await docRef.update(schedule.toJson());

      // log('Task successfully added: ${schedule.id}');
    } catch (e) {
      // log('Error adding task: $e');
      throw Exception(e);
    }
  }

  Future<void> updateTask(ScheduleItemModel schedule) async {
    if (!await _db.hasCollection(_scheduleTable) || _recordId == null) {
      return;
    }

    try {
      await _db.findOneAndUpdate(
        _scheduleTable,
        field: "id",
        isEqualTo: schedule.id,
        data: schedule.toJson(),
      );

      int index = _scheduleCache.indexWhere((t) => t.id == schedule.id);

      if (index != -1) {
        _scheduleCache[index] = schedule;
        // log('schedule successfully updated: ${schedule.id}');
      } else {
        // log('schedule not found: ${schedule.id}');
      }
    } catch (e) {
      // log('Error updating schedule: $e');
      throw Exception(e);
    }
  }

  Future<void> deleteTask(ScheduleItemModel schedule) async {
    if (!await _db.hasCollection(_scheduleTable) || _recordId == null) {
      return;
    }

    try {
      await _db.findOneAndDelete(
        _scheduleTable,
        field: 'id',
        isEqualTo: schedule.id,
      );

      _scheduleCache.removeWhere((t) => t.id == schedule.id);

      // log('Task successfully deleted: ${schedule.id}');
    } catch (e) {
      // log("Error deleting task: $e");
      throw Exception(e);
    }
  }

  Future<ScheduleItemModel?> _getTask(String id) async {
    try {
      if (_auth.currentUser == null) return null;

      final data = await _db.findOne(
        _scheduleTable,
        field: _requiredField,
        isEqualTo: id,
      );

      if (data == null) return null;

      return ScheduleItemModel.fromJson(data.data());
    } catch (e) {
      // log('Error getting task: $e');
      throw Exception(e);
    }
  }
}
