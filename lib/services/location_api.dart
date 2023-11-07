import 'dart:convert';
import 'package:http/http.dart' as http;


class LocationAPI {
  LocationAPI();

  Future<String> fetchData() async {
    var _city = '';
    final resp = await http.get(Uri.parse('https://geolocation-db.com/json/'));
    if (resp.statusCode == 200) {
      final _data = LocationModel.fromJson(json.decode(resp.body));
      _city = _data.city + ","+_data.state + ","+_data.countryName+ ","+_data.postal;
    }
    return _city;
  }
  Future<String> fetchData1() async {
    var _city = '';
    final resp = await http.get(Uri.parse('https://geolocation-db.com/json/'));
    if (resp.statusCode == 200) {
      final _data = LocationModel.fromJson(json.decode(resp.body));
      _city = _data.iPv4;
  }
    return _city;
  }
}

LocationModel locationModelFromJson(String str) =>
    LocationModel.fromJson(json.decode(str));

String locationModelToJson(LocationModel data) => json.encode(data.toJson());

class LocationModel {
  LocationModel({
    required this.countryCode,
    required this.countryName,
    required this.city,
    required this.postal,
    required this.latitude,
    required this.longitude,
    required this.iPv4,
    required this.state,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
    countryCode: json['country_code'],
    countryName: json['country_name'],
    city: json['city'],
    postal: json['postal'],
    latitude: json['latitude'].toDouble(),
    longitude: json['longitude'].toDouble(),
    iPv4: json['IPv4'],
    state: json['state'],
  );

  String countryCode;
  String countryName;
  String city;
  dynamic postal;
  double latitude;
  double longitude;
  String iPv4;
  String state;

  Map<String, dynamic> toJson() => {
    'country_code': countryCode,
    'country_name': countryName,
    'city': city,
    'postal': postal,
    'latitude': latitude,
    'longitude': longitude,
    'IPv4': iPv4,
    'state': state,
  };
}