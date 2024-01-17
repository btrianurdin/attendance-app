class ShiftModel {
  String? id;
  String? name;

  ShiftModel({this.id, this.name});

  factory ShiftModel.fromJson(json) {
    return ShiftModel(id: json['id'], name: json['name']);
  }
}

enum ShiftType { workDay, offDay }

class ShiftDetailModel {
  int? id;
  int? shiftId;
  int? day;
  ShiftType? type;
  String? checkIn;
  String? checkOut;

  ShiftDetailModel({
    this.id,
    this.shiftId,
    this.day,
    this.type,
    this.checkIn,
    this.checkOut,
  });

  factory ShiftDetailModel.fromJson(json) {
    return ShiftDetailModel(
      id: json['id'],
      shiftId: json['shift_id'],
      day: json['day'],
      type: json['type'] == 'WORKDAY' ? ShiftType.workDay : ShiftType.offDay,
      checkIn: json['check_in'],
      checkOut: json['check_out'],
    );
  }
}
