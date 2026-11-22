// ignore_for_file: avoid_print

// 1. abstract interface class: kontrak yang HARUS diimplementasikan.
abstract interface class Penyapa {
  String sapa(String nama);
}

class PenyapaSopan implements Penyapa {
  const PenyapaSopan();

  @override
  String sapa(String nama) => 'Selamat datang, $nama!';
}

// 2. Generics: satu kelas untuk banyak tipe data.
class Kotak<T> {
  const Kotak(this.isi);

  final T isi;
}

// 3. Sealed class: pilihan terbatas yang diperiksa lengkap oleh compiler.
sealed class Hasil<T> {
  const Hasil();
}

final class Berhasil<T> extends Hasil<T> {
  const Berhasil(this.data);

  final T data;
}

final class Gagal<T> extends Hasil<T> {
  const Gagal(this.pesan);

  final String pesan;
}

String tampilkan(Hasil<int> hasil) {
  return switch (hasil) {
    Berhasil(:final data) => 'Berhasil, data = $data',
    Gagal(:final pesan) => 'Gagal: $pesan',
  };
}

// 4. Records dan pattern matching.
(String, int) menuTermurah() => ('Es Teh Manis', 5000);

({String nama, int harga}) menuTerlaris() {
  return (nama: 'Nasi Goreng', harga: 25000);
}

// 5. Immutability: objek tidak diubah, tetapi disalin dengan nilai baru.
class Porsi {
  const Porsi({required this.nama, required this.jumlah});

  final String nama;
  final int jumlah;

  Porsi copyWith({String? nama, int? jumlah}) {
    return Porsi(nama: nama ?? this.nama, jumlah: jumlah ?? this.jumlah);
  }
}

// 6. Extension: menambah fungsi pada tipe yang sudah ada.
extension KapitalAwal on String {
  String get kapitalAwal {
    return isEmpty ? this : this[0].toUpperCase() + substring(1);
  }
}

void main() {
  const Penyapa penyapa = PenyapaSopan();
  print(penyapa.sapa('Peserta'));

  const kotak = Kotak<int>(5);
  print(kotak.isi);

  const Hasil<int> sukses = Berhasil(42);
  const Hasil<int> gagal = Gagal('Koneksi terputus');
  print(tampilkan(sukses));
  print(tampilkan(gagal));

  final (nama, harga) = menuTermurah();
  print('$nama seharga $harga');

  final terlaris = menuTerlaris();
  print(terlaris.nama);
  if (terlaris case (nama: final n, harga: final h) when h > 20000) {
    print('$n tergolong menu premium');
  }

  const satu = Porsi(nama: 'Es Teh', jumlah: 1);
  final dua = satu.copyWith(jumlah: 2);
  print(satu.jumlah);
  print(dua.jumlah);

  print('nasi goreng'.kapitalAwal);
}
