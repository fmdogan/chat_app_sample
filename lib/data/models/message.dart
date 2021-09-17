import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  late String text;
  late String from;
  late Timestamp time;

  Message({
    required this.text,
    required this.from,
    required this.time,
  });

  Map<String, Object?> toDocument() {
    return {
      'text': text,
      'from': from,
      'time': time,
    };
  }

  static Message fromDocument(DocumentSnapshot _doc) {
    final _docData = _doc.data() as Map<String, dynamic>;
    // ignore: unnecessary_null_comparison
    if (_docData == null) throw Exception();
    return Message(
      text: _docData['text'],
      from: _docData['from'],
      time: _docData['time'],
    );
  }

  Map<String, Object?> toJson() {
    return {
      'text': text,
      'from': from,
      'time': time,
    };
  }

  static String timestampToString(Message _message) {
    // in case the time is like 7:5 instead of 07:05
    int _hour = _message.time.toDate().hour;
    int _minute = _message.time.toDate().minute;
    String _timeHour = _hour < 10 ? '0' + _hour.toString() : _hour.toString();
    String _timeMinute = _minute < 10 ? '0' + _minute.toString() : _minute.toString();
    return _timeHour + ':' + _timeMinute;
  }

  static Message fromJson(Map<String, Object> json) {
    return Message(
      text: json['text'] as String,
      from: json['from'] as String,
      time: json['time'] as Timestamp,
    );
  }
}
