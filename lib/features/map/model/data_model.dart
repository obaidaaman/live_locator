class UserData {
  final String latitude;
  final String longitude;
  final String dateTime;

  UserData(this.latitude, this.longitude, this.dateTime);

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'time': dateTime,
    };
  }

  // Convert a Map to a CheckIn instance
  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      map['latitude'],
      map['longitude'],
      map['time'],
    );
  }
}
