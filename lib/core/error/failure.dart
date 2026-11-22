import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Tidak ada koneksi internet.']);
}

final class ParsingFailure extends Failure {
  const ParsingFailure([
    super.message = 'Data dari server tidak sesuai format.',
  ]);
}

final class UnknownFailure extends Failure {
  const UnknownFailure([
    super.message = 'Terjadi kesalahan yang tidak diketahui.',
  ]);
}
