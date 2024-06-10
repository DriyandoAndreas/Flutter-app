class NilaiKelasModel {
  String? kodeKelas;
  String? namaKelas;

  NilaiKelasModel({required this.kodeKelas, required this.namaKelas});

  factory NilaiKelasModel.fromJson(Map<String, dynamic> json) {
    return NilaiKelasModel(
      kodeKelas: json['kode_kelas'],
      namaKelas: json['nama_kelas'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'kode_kelas': kodeKelas,
      'nama_kelas': namaKelas,
    };
  }
}

class NilaiJenisModel {
  String? kodeTes;
  String? namaTes;
  String? kodeKelas;

  NilaiJenisModel({
    required this.kodeTes,
    required this.namaTes,
    required this.kodeKelas,
  });
  factory NilaiJenisModel.fromJson(Map<String, dynamic> json) {
    return NilaiJenisModel(
      kodeTes: json['kode_tes'],
      namaTes: json['nama_tes'],
      kodeKelas: json['kode_kelas'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'kode_tes': kodeTes,
      'nama_tes': namaTes,
      'kode_kelas': kodeKelas,
    };
  }
}

class ListNilaiMapelModel {
  String? kodeMengajar;
  String? namaPljrn;

  ListNilaiMapelModel({required this.kodeMengajar, required this.namaPljrn});
  factory ListNilaiMapelModel.fromJson(Map<String, dynamic> json) {
    return ListNilaiMapelModel(
      kodeMengajar: json['kode_mengajar'],
      namaPljrn: json['nama_pljrn'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'kode_mengajar': kodeMengajar,
      'nama_pljrn': namaPljrn,
    };
  }
}
