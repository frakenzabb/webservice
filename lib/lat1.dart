class MataKuliah {
  String kode;
  String nama;
  int sks;
  String nilai;

  MataKuliah(this.kode, this.nama, this.sks, this.nilai);
}

class Transkrip {
  String nama;
  String npm;
  String jurusan;
  List<MataKuliah> mataKuliah;

  Transkrip(this.nama, this.npm, this.jurusan, this.mataKuliah);
}

double hitungIPK(Transkrip transkrip) {
  double totalSKS = 0;
  double totalBobot = 0;

  for (MataKuliah mataKuliah in transkrip.mataKuliah) {
    double bobot = 0;
    switch (mataKuliah.nilai) {
      case "A":
        bobot = 4;
        break;
      case "A-":
        bobot = 3.7;
        break;
      case "B+":
        bobot = 3.3;
        break;
      // Tambahkan case untuk nilai lainnya
      default:
        bobot = 0;
    }
    totalSKS += mataKuliah.sks;
    totalBobot += bobot * mataKuliah.sks;
  }

  return totalBobot / totalSKS;
}

void main() {
  Transkrip transkrip =
      Transkrip("Azriel Dirga Efansyah", "22082010066", "Sistem Informasi", [
    MataKuliah("INF101", "Pemrograman Dasar", 3, "A"),
    MataKuliah("INF102", "Struktur Data", 4, "B+"),
    MataKuliah("INF103", "Algoritma dan Kompleksitas", 3, "A-")
  ]);

  double ipk = hitungIPK(transkrip);
  print("Nama: ${transkrip.nama}");
  print("NPM: ${transkrip.npm}");
  print("Jurusan: ${transkrip.jurusan}");
  print("IPK: ${ipk.toStringAsFixed(2)}");
}
