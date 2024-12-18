class BiodataGacModel {
  String? kodepegawai;
  String? nip;
  String? namalengkap;
  String? jeniskelamin;
  String? tempatlahir;
  String? tanggallahir;
  String? nohp;

  BiodataGacModel({
    this.jeniskelamin,
    this.kodepegawai,
    this.namalengkap,
    this.nip,
    this.nohp,
    this.tanggallahir,
    this.tempatlahir,
  });

  factory BiodataGacModel.fromJson(Map<String, dynamic> json) {
    return BiodataGacModel(
      kodepegawai: json['kode_pegawai'] ?? '',
      jeniskelamin: json['jkelamin'] ?? '',
      namalengkap: json['nama_lengkap'] ?? '',
      nip: json['nip'] ?? '',
      nohp: json['no_hp'] ?? '',
      tanggallahir: json['tgl_lhr'] ?? '',
      tempatlahir: json['tmp_lhr'] ?? '',
    );
  }
}

// * SAT
class BiodataSatModel {
  String? nis;
  String? namalengkap;
  String? jeniskelamin;
  String? tempatlahir;
  String? tanggallahir;
  String? nohp;

  BiodataSatModel({
    this.jeniskelamin,
    this.nis,
    this.namalengkap,
    this.nohp,
    this.tanggallahir,
    this.tempatlahir,
  });

  factory BiodataSatModel.fromJson(Map<String, dynamic> json) {
    return BiodataSatModel(
      nis: json['nis'],
      jeniskelamin: json['jkelamin'] ?? '',
      namalengkap: json['nama_lengkap'] ?? '',
      nohp: json['siswa_hp'] ?? '',
      tanggallahir: json['tgl_lhr'] ?? '',
      tempatlahir: json['tmp_lhr'] ?? '',
    );
  }
}
