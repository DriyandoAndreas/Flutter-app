class KonselingModel {
  String? nis;
  String? kodePegawai;
  String? nama;
  String? namaKelas;
  String? kasus;
  String? petugas;
  String? tanggal;
  String? penanganan;
  String? nilai;
  String? tanggalJam;
  String? kodeKelas;
  String? kodeScore;
  String? kdKonseling;
  KonselingModel({
    required this.nama,
    required this.nis,
    required this.kodePegawai,
    required this.namaKelas,
    required this.kasus,
    required this.petugas,
    required this.tanggal,
    required this.penanganan,
    required this.nilai,
    required this.tanggalJam,
    required this.kodeKelas,
    required this.kodeScore,
    required this.kdKonseling,
  });

  factory KonselingModel.fromJson(Map<String, dynamic> json) {
    return KonselingModel(
      nama: json['nama_lengkap'],
      nis: json['nis'],
      kodePegawai: json['kode_pegawai'],
      namaKelas: json['nama_kelas'],
      kasus: json['kasus'],
      petugas: json['petugas'],
      tanggal: json['tanggal'],
      penanganan: json['penanganan'],
      nilai: json['nilai'],
      tanggalJam: json['tanggal_jam'],
      kodeKelas: json['kode_kelas'],
      kodeScore: json['kode_score'],
      kdKonseling: json['kd_konseling'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'nama_lengkap': nama,
      'nis': nis,
      'kode_pegawai': kodePegawai,
      'nama_kelas': namaKelas,
      'kasus': kasus,
      'petugas': petugas,
      'tanggal': tanggal,
      'penanganan': penanganan,
      'nilai': nilai,
      'tanggal_jam': tanggalJam,
      'kode_kelas': kodeKelas,
      'kode_score': kodeScore,
      'kd_konseling': kdKonseling,
    };
  }
}

class ShowKelasModel {
  String? namaKelas;
  String? kodeKelas;

  ShowKelasModel({required this.namaKelas, required this.kodeKelas});
  factory ShowKelasModel.fromJson(Map<String, dynamic> json) {
    return ShowKelasModel(
      namaKelas: json['nama_kelas'],
      kodeKelas: json['kode_kelas'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'nama_kelas': namaKelas,
      'kode_kelas': kodeKelas,
    };
  }
}

class PoinModel {
  String? kodeScore;
  String? deskripsi;
  String? nilai;
  String? jenisScore;

  PoinModel({
    required this.kodeScore,
    required this.deskripsi,
    required this.nilai,
    required this.jenisScore,
  });
  factory PoinModel.fromJson(Map<String, dynamic> json) {
    return PoinModel(
      kodeScore: json['kode_score'],
      deskripsi: json['deskripsi'],
      nilai: json['nilai'],
      jenisScore: json['jenis_score'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'kode_score': kodeScore,
      'deskripsi': deskripsi,
      'nilai': nilai,
      'jenis_score': jenisScore,
    };
  }
}