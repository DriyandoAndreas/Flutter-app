//******* */ class GAC model
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
     this.kodeKelas,
     this.namaKelas,
     this.active,
     this.noHp,
     this.penghuni,
     this.namaLengkap,
     this.waGroup,
     this.tahunAjaran,
     this.kodePegawai,
  });
  factory KelasModel.fromJson(Map<String, dynamic> json) {
    return KelasModel(
      active: json['active'] ?? '',
      kodeKelas: json['kode_kelas'] ?? '',
      namaKelas: json['nama_kelas'] ?? '',
      namaLengkap: json['nama_lengkap'] ?? '',
      noHp: json['no_hp'] ?? '',
      penghuni: json['penghuni'] ?? '',
      waGroup: json['wagroup'] ?? '',
      tahunAjaran: json['tahun_ajaran'] ?? '',
      kodePegawai: json['kode_pegawai'] ?? '',
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
  String? nis;
  String? namaLengkap;

  KelasOpenModel({ this.nis,  this.namaLengkap});

  factory KelasOpenModel.fromJson(Map<String, dynamic> json) {
    return KelasOpenModel(
      nis: json['nis'] ?? '',
      namaLengkap: json['nama_lengkap'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'nis': nis,
      'nama_lengkap': namaLengkap,
    };
  }
}

///************** */ class SAT model
class KelasSatModel {
  String? kodeKelas;
  String? namaKelas;
  String? penghuni;
  String? namaLengkap;
  String? kodePegawai;
  String? waGroup;
  String? tahunAjaran;
  String? myclass;

  KelasSatModel({
    this.kodeKelas,
    this.namaKelas,
    this.penghuni,
    this.namaLengkap,
    this.kodePegawai,
    this.waGroup,
    this.tahunAjaran,
    this.myclass,
  });
  factory KelasSatModel.fromJson(Map<String, dynamic> json) {
    return KelasSatModel(
      kodeKelas: json['kode_kelas'] ?? '',
      namaKelas: json['nama_kelas'] ?? '',
      namaLengkap: json['nama_lengkap'] ?? '',
      kodePegawai: json['kode_pegawai'] ?? '',
      waGroup: json['wagroup'] ?? '',
      tahunAjaran: json['tahun_ajaran'] ?? '',
      myclass: json['myclass'] ?? '',
    );
  }
}

class KelasSatOpenModel {
  String? nis;
  String? namalengkap;

  KelasSatOpenModel({
    this.nis,
    this.namalengkap,
  });
  factory KelasSatOpenModel.fromJson(Map<String, dynamic> json) {
    return KelasSatOpenModel(
      nis: json['nis'] ?? '',
      namalengkap: json['nama_lengkap'] ?? '',
    );
  }
}
