class FaceModel {
  List<List>? faces;

  FaceModel({this.faces});

  factory FaceModel.fromJson(json) {
    return FaceModel(faces: json['faces']);
  }
}
