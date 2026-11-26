import 'package:equatable/equatable.dart';

class AuthSession extends Equatable {
  const AuthSession({required this.username, required this.nama});

  final String username;
  final String nama;

  @override
  List<Object?> get props => [username, nama];
}
