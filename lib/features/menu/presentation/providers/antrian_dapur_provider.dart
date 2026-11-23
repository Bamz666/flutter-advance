import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Data simulasi: jumlah antrian dapur yang berubah tiap 3 detik.
Stream<int> antrianDapur() async* {
  const data = [3, 4, 5, 4, 2, 3];
  var i = 0;

  while (true) {
    yield data[i % data.length];
    i++;
    await Future<void>.delayed(const Duration(seconds: 3));
  }
}

final antrianDapurProvider = StreamProvider<int>((ref) => antrianDapur());
