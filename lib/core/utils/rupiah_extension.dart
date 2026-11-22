extension RupiahFormat on num {
  /// Contoh: 25000 menjadi "Rp 25.000".
  String toRupiah() {
    final digits = round().toString();
    final buffer = StringBuffer();

    for (var i = 0; i < digits.length; i++) {
      buffer.write(digits[i]);
      final sisa = digits.length - i - 1;
      if (sisa > 0 && sisa % 3 == 0) buffer.write('.');
    }

    return 'Rp $buffer';
  }
}
