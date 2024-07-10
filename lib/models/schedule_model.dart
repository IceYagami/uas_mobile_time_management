import 'dart:convert';

ScheduleItemModel builderFromJson(String str) =>
    ScheduleItemModel.fromJson(json.decode(str));
String builderToJson(ScheduleItemModel data) => json.encode(data.toJson());

class ScheduleItemModel {
  ScheduleItemModel({
    this.id = "",
    this.userId = "",
    required this.catatan,
    required this.kategori,
    required this.tanggal,
    required this.waktu,
    required this.pengingat,
  });

  factory ScheduleItemModel.fromJson(Map<String, dynamic> json) {
    return ScheduleItemModel(
      id: json['id'],
      catatan: json['catatan'],
      userId: json['userId'],
      kategori: json['kategori'],
      tanggal: json['tanggal'],
      waktu: json['waktu'],
      pengingat: json['pengingat'],
    );
  }

  String catatan;
  String id;
  int kategori;
  int pengingat;
  String tanggal;
  String userId;
  String waktu;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'catatan': catatan,
      'kategori': kategori,
      'tanggal': tanggal,
      'waktu': waktu,
      'pengingat': pengingat,
    };
  }
}
