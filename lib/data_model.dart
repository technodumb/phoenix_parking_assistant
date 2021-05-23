class DataModel {
  var spot;
  var parked;
  var condParked;
  DataModel({this.spot, this.parked, this.condParked});

  factory DataModel.fromJson(dynamic json) {
    return DataModel(
      spot: "${json['spot']}",
      parked: "${json['parked']}",
      condParked: "${json['condParked']}",
    );
  }

  Map toJson() => {
        "spot": spot,
        "parked": parked,
        "condParked": condParked,
      };
}
