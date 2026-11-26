import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Sinyal bahwa sesi login berakhir. Nilainya bertambah setiap kali
/// sesi berakhir; pihak lain cukup mendengarkan perubahannya.
class SessionExpiredNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void terjadi() => state++;
}

final sessionExpiredProvider = NotifierProvider<SessionExpiredNotifier, int>(
  SessionExpiredNotifier.new,
);
