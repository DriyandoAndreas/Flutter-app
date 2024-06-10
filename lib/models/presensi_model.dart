class PresensiModel {
  String? kodeKelas;
  String? namaKelas;
  String? H;
  String? S;
  String? I;
  String? A;
  String? T;

  PresensiModel({
    required this.kodeKelas,
    required this.namaKelas,
    required this.H,
    required this.S,
    required this.I,
    required this.A,
    required this.T,
  });
  factory PresensiModel.fromJson(Map<String, dynamic> json) {
    return PresensiModel(
      kodeKelas: json['kode_kelas'],
      namaKelas: json['nama_kelas'],
      H: json['H'],
      S: json['S'],
      I: json['I'],
      A: json['A'],
      T: json['T'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'kode_kelas': kodeKelas,
      'nama_kelas': namaKelas,
      'h': H,
      'S': S,
      'I': I,
      'A': A,
      'T': T,
    };
  }
}

class PresensiKelasOpenModel {
  String? nis;
  String? namaLengkap;
  String? absen;
  String? shortAbsen;

  PresensiKelasOpenModel({
    required this.nis,
    required this.namaLengkap,
    required this.absen,
    required this.shortAbsen,
  });
  factory PresensiKelasOpenModel.fromJson(Map<String, dynamic> json) {
    return PresensiKelasOpenModel(
      nis: json['nis'],
      namaLengkap: json['nama_lengkap'],
      absen: json['absen'],
      shortAbsen: json['short_absen'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'nis': nis,
      'nama_lengkap': namaLengkap,
      'absen': absen,
      'short_absen': shortAbsen,
    };
  }
}
