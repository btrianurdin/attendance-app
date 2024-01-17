class DivisionModel {
  int? id;
  String? name;

  DivisionModel({this.id, this.name});

  factory DivisionModel.fromJson(json) {
    return DivisionModel(id: json['id'], name: json['name']);
  }
}
