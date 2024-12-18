//////////////////////////////////////
///********Gac uks model */
class UksModel {
  String? kdPeriksa;
  String? nis;
  String? tglPeriksa;
  String? diagnosa;
  String? paraf;
  String? ket;
  String? namaLengkap;
  String? nip;
  String? kodePegawai;
  String? kodeKelas;

  UksModel({
    this.kdPeriksa,
    this.nis,
    this.tglPeriksa,
    this.diagnosa,
    this.paraf,
    this.ket,
    this.namaLengkap,
    this.nip,
    this.kodePegawai,
    this.kodeKelas,
  });
  factory UksModel.fromJson(Map<String, dynamic> json) {
    return UksModel(
      kdPeriksa: json['kd_periksa'] ?? '',
      nis: json['nis'] ?? '',
      tglPeriksa: json['tgl_periksa'] ?? '',
      diagnosa: json['diagnosa'] ?? '',
      paraf: json['paraf'] ?? '',
      ket: json['ket'] ?? '',
      namaLengkap: json['nama_lengkap'] ?? '',
      nip: json['nip'] ?? '',
      kodePegawai: json['kode_pegawai'] ?? '',
      kodeKelas: json['kode_kelas'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'kd_periksa': kdPeriksa,
      'nis': nis,
      'tgl_periksa': tglPeriksa,
      'diagnosa': diagnosa,
      'paraf': paraf,
      'ket': ket,
      'nama_lengkap': namaLengkap,
      'nip': nip,
      'kode_pegawai': kodePegawai,
      'kode_kelas': kodeKelas,
    };
  }
}

class UksListKelasModel {
  String? kodeKelas;
  String? namaKelas;

  UksListKelasModel({
    this.kodeKelas,
    this.namaKelas,
  });
  factory UksListKelasModel.fromJson(Map<String, dynamic> json) {
    return UksListKelasModel(
      kodeKelas: json['kode_kelas'] ?? '',
      namaKelas: json['nama_kelas'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'kode_kelas': kodeKelas,
      'nama_kelas': namaKelas,
    };
  }
}

class UksListSiswaModel {
  String? nis;
  String? nama;

  UksListSiswaModel({
    this.nis,
    this.nama,
  });
  factory UksListSiswaModel.fromJson(Map<String, dynamic> json) {
    return UksListSiswaModel(
      nis: json['nis'] ?? '',
      nama: json['nama_lengkap'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'nis': nis,
      'nama_lengkap': nama,
    };
  }
}

class UksListGrModel {
  String? nis;
  String? nama;

  UksListGrModel({
    this.nis,
    this.nama,
  });
  factory UksListGrModel.fromJson(Map<String, dynamic> json) {
    return UksListGrModel(
      nis: json['nis'] ?? '',
      nama: json['nama_lengkap'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'nis': nis,
      'nama_lengkap': nama,
    };
  }
}

class UksViewObatModel {
  String? namaObat;
  String? jumobat;
  String? kodeObat;

  UksViewObatModel({
    this.namaObat,
    this.jumobat,
    this.kodeObat
  });
  factory UksViewObatModel.fromJson(Map<String, dynamic> json) {
    return UksViewObatModel(
      namaObat: json['nama_obat'] ?? '',
      jumobat: json['jum_obat'] ?? '',
      kodeObat: json['kd_obat'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'nama_obat': namaObat,
      'jum_obat': jumobat,
    };
  }
}

class UksListObatModel {
  String? kdObat;
  String? namaObat;
  String? stock;
  String? expdate;

  UksListObatModel({
    this.kdObat,
    this.namaObat,
    this.stock,
    this.expdate,
  });
  factory UksListObatModel.fromJson(Map<String, dynamic> json) {
    return UksListObatModel(
      kdObat: json['kd_obat'] ?? '',
      namaObat: json['nama_obat'] ?? '',
      stock: json['stock'] ?? '',
      expdate: json['exp_date'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'kd_obat': kdObat,
      'nama_obat': namaObat,
      'stock': stock,
      'exp_date': expdate,
    };
  }
}

///////////////////////////////////
///************Sat uks model */
class SatUksModel {
  String? kdperiksa;
  String? nis;
  String? tanggalperiksa;
  String? diagnosa;
  String? paraf;
  String? keterangan;

  SatUksModel({
    this.kdperiksa,
    this.nis,
    this.tanggalperiksa,
    this.diagnosa,
    this.paraf,
    this.keterangan,
  });
  factory SatUksModel.fromJson(Map<String, dynamic> json) {
    return SatUksModel(
      kdperiksa: json['kd_periksa'] ?? '',
      nis: json['nis'] ?? '',
      tanggalperiksa: json['tgl_periksa'] ?? '',
      diagnosa: json['diagnosa'] ?? '',
      paraf: json['paraf'] ?? '',
      keterangan: json['ket'] ?? '',
    );
  }
}
