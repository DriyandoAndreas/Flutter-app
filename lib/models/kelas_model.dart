class KelasModel {
  String? kodeKelas;
  String? namaKelas;
  String? active;
  String? noHp;
  String? penghuni;
  String? namaLengkap;
  String? waGroup;
  String? tahunAjaran;
  String? kodePegawai;

  KelasModel({
    required this.kodeKelas,
    required this.namaKelas,
    required this.active,
    required this.noHp,
    required this.penghuni,
    required this.namaLengkap,
    required this.waGroup,
    required this.tahunAjaran,
    required this.kodePegawai,
  });
  factory KelasModel.fromJson(Map<String, dynamic> json) {
    return KelasModel(
      active: json['active'],
      kodeKelas: json['kode_kelas'],
      namaKelas: json['nama_kelas'],
      namaLengkap: json['nama_lengkap'],
      noHp: json['no_hp'],
      penghuni: json['penghuni'],
      waGroup: json['wagroup'],
      tahunAjaran: json['tahun_ajaran'],
      kodePegawai: json['kode_pegawai'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'active': active,
      'kode_kelas': kodeKelas,
      'nama_kelas': namaKelas,
      'nama_lengkap': namaLengkap,
      'no_hp': noHp,
      'penghuni': penghuni,
      'wagroup': waGroup,
      'tahun_ajaran': tahunAjaran,
      'kode_pegawai': kodePegawai,
    };
  }
}

class KelasOpenModel {
  String nis;
  String namaLengkap;

  KelasOpenModel({required this.nis, required this.namaLengkap});

  factory KelasOpenModel.fromJson(Map<String, dynamic> json) {
    return KelasOpenModel(
      nis: json['nis'],
      namaLengkap: json['nama_lengkap'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'nis': nis,
      'nama_lengkap': namaLengkap,
    };
  }
}
