class PresensiModel {
  String? kodeKelas;
  String? namaKelas;
  String? H;
  String? S;
  String? I;
  String? A;
  String? T;

  PresensiModel({
    this.kodeKelas,
    this.namaKelas,
    this.H,
    this.S,
    this.I,
    this.A,
    this.T,
  });
  factory PresensiModel.fromJson(Map<String, dynamic> json) {
    return PresensiModel(
      kodeKelas: json['kode_kelas'] ?? '',
      namaKelas: json['nama_kelas'] ?? '',
      H: json['H'] ?? '',
      S: json['S'] ?? '',
      I: json['I'] ?? '',
      A: json['A'] ?? '',
      T: json['T'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'kode_kelas': kodeKelas,
      'nama_kelas': namaKelas,
      'H': H,
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
  String? keterangan;
  String? statusLogin;
  String? file;

  PresensiKelasOpenModel({
    this.nis,
    this.namaLengkap,
    this.absen,
    this.shortAbsen,
    this.keterangan,
    this.statusLogin,
    this.file,
  });
  factory PresensiKelasOpenModel.fromJson(Map<String, dynamic> json) {
    return PresensiKelasOpenModel(
      nis: json['nis'] ?? '',
      namaLengkap: json['nama_lengkap'] ?? '',
      absen: json['absen'] ?? 'H',
      shortAbsen: json['short_absen'] ?? 'H',
      keterangan: json['keterangan'] ?? '',
      statusLogin: json['status_login'] ?? '',
      file: json['file'] ?? '',
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

///***********Sat Presensi Model */

class SatPresensiBulananModel {
  Map<String, dynamic>? data;
  SatPresensiBulananModel({
    this.data,
  });
  factory SatPresensiBulananModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> parsedData = {};
    json.forEach((key, value) {
      parsedData[key] = value;
    });
    return SatPresensiBulananModel(data: parsedData);
  }
}

class SatPresensiSumModel {
  String? H;
  String? S;
  String? I;
  String? A;
  String? T;
  String? B;
  String? D;

  SatPresensiSumModel({
    this.H,
    this.A,
    this.S,
    this.I,
    this.T,
    this.B,
    this.D,
  });

  factory SatPresensiSumModel.fromJson(Map<String, dynamic> json) {
    return SatPresensiSumModel(
      H: json['H'] ?? '',
      S: json['S'] ?? '',
      I: json['I'] ?? '',
      A: json['A'] ?? '',
      T: json['T'] ?? '',
      B: json['B'] ?? '',
      D: json['D'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'H': H,
      'S': S,
      'I': A,
      'A': I,
      'T': T,
      'B': B,
      'D': D,
    };
  }
}

class SatPresensiHistoryModel {
  String? tanggal;
  String? time1;
  String? time2;
  String? detikselisih;
  String? sf;

  SatPresensiHistoryModel({
    this.tanggal,
    this.time1,
    this.time2,
    this.detikselisih,
    this.sf,
  });

  factory SatPresensiHistoryModel.fromJson(Map<String, dynamic> json) {
    return SatPresensiHistoryModel(
      tanggal: json['tanggal'],
      time1: json['time1'] ?? '',
      time2: json['time2'] ?? '',
      detikselisih: json['detikselisih'] ?? '',
      sf: json['sf'] ?? '',
    );
  }
}
