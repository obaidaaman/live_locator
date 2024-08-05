class DataModel {
  final String checkInTime;
  final String checkOutTime;
  final String latitude;
  final String longitude;

  DataModel(this.checkInTime, this.checkOutTime, this.latitude, this.longitude);

  factory DataModel.fromMap(Map<String, dynamic> userData) {
    return DataModel(
        userData['checkInTime'] ?? 'No checkin recorded',
        userData['time'] ?? 'no checkout recorded',
        userData['latitude'] ?? '0',
        userData['longitude'] ?? '0');
  }

  Map<String, dynamic> toMap() {
    return {
      'checkInTime': checkInTime,
      'time': checkOutTime,
      'latitude': latitude,
      'longitude': longitude
    };
  }
}
