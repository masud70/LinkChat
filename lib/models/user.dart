class User {
  int? id;
  String name;
  String username;
  String password;
  String userType;
  double lat;
  double lng;
  String timestamp;

  User({
    this.id,
    required this.name,
    required this.username,
    required this.password,
    required this.userType,
    this.lat = 0.0,
    this.lng = 0.0,
    required this.timestamp,
  });

  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'password': password,
      'userType': userType,
      'lat': lat,
      'lng': lng,
      'timestamp': timestamp,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      username: map['username'],
      password: map['password'],
      userType: map['userType'],
      lat: map['lat'],
      lng: map['lng'],
      timestamp: map['timestamp'],
    );
  }
}
