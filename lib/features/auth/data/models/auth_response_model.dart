import 'package:json_annotation/json_annotation.dart';

part 'auth_response_model.g.dart';

@JsonSerializable()
class AuthResponseModel {
  const AuthResponseModel({
    required this.message,
    required this.username,
    required this.nama,
    this.accessToken,
    this.refreshToken,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);

  final String message;
  final String? accessToken;
  final String? refreshToken;
  final String username;
  final String nama;

  Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);
}
