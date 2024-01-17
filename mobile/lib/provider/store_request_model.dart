class StoreRequestModel<T> {
  T? data;
  bool isFetched = false;

  StoreRequestModel({this.data, required this.isFetched});

  reset() {
    data = null;
    isFetched = false;
  }
}
