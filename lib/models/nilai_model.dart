///////////////////////////////
///*****Gac nilai model****** */
class NilaiKelasModel {
  String? kodeKelas;
  String? namaKelas;
  String? thnAj;
  String? semester;

  NilaiKelasModel({this.kodeKelas, this.namaKelas, this.thnAj, this.semester});

  factory NilaiKelasModel.fromJson(Map<String, dynamic> json) {
    return NilaiKelasModel(
      kodeKelas: json['kode_kelas'] ?? '',
      namaKelas: json['nama_kelas'] ?? '',
      thnAj: json['thn_aj'] ?? '',
      semester: json['sem'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'kode_kelas': kodeKelas,
      'nama_kelas': namaKelas,
      'thn_aj': thnAj,
      'sem': semester,
    };
  }
}

class NilaiJenisModel {
  String? kodeTes;
  String? namaTes;
  String? kodeKelas;

  NilaiJenisModel({
    this.kodeTes,
    this.namaTes,
    this.kodeKelas,
  });
  factory NilaiJenisModel.fromJson(Map<String, dynamic> json) {
    return NilaiJenisModel(
      kodeTes: json['kode_tes'] ?? '',
      namaTes: json['nama_tes'] ?? '',
      kodeKelas: json['kode_kelas'] ?? '',
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
  String? kodePelajaran;
  String? kodeKelas;
  String? namaPljrn;

  ListNilaiMapelModel(
      {this.kodeMengajar, this.namaPljrn, this.kodeKelas, this.kodePelajaran});
  factory ListNilaiMapelModel.fromJson(Map<String, dynamic> json) {
    return ListNilaiMapelModel(
      kodeMengajar: json['kode_mengajar'] ?? '',
      namaPljrn: json['nama_pljrn'] ?? '',
      kodeKelas: json['kode_kelas'] ?? '',
      kodePelajaran: json['kode_pljrn'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'kode_mengajar': kodeMengajar,
      'nama_pljrn': namaPljrn,
      'kode_kelas': kodeKelas,
      'kode_pljrn': kodePelajaran,
    };
  }
}

class ListShowNilaiModel {
  String? nis;
  String? namaLengkap;
  Map<String, Map<String, String?>>? nilaiTes;

  ListShowNilaiModel({
    this.nis,
    this.namaLengkap,
    this.nilaiTes,
  });

  factory ListShowNilaiModel.fromJson(String nis, Map<String, dynamic> json) {
    Map<String, Map<String, String?>> nilaiTes = {};

    json.forEach((key, value) {
      if (key != 'nama_lengkap') {
        final tesValues = value as Map<String, dynamic>;
        Map<String, String?> values = {};
        tesValues.forEach((k, v) {
          values[k] = v?.toString();
        });
        nilaiTes[key] = values;
      }
    });
    return ListShowNilaiModel(
      nis: nis,
      namaLengkap: json['nama_lengkap'],
      nilaiTes: nilaiTes,
    );
  }
}

///*****Sat nilai model****** */
class SatNilaiMenuModel {
  String? kodemenu;
  String? namamenu;
  SatNilaiMenuModel({this.kodemenu, this.namamenu});
  factory SatNilaiMenuModel.fromJson(String kodemenu, String namamenu) {
    return SatNilaiMenuModel(
      kodemenu: kodemenu,
      namamenu: namamenu,
    );
  }
}

class SatMenuNilaiModel {
  List<SatNilaiMenuModel>? listmenu;
  SatMenuNilaiModel({this.listmenu});
}

//nilai model
class SatNilaiModel {
  String? teori;
  String? praktik;
  SatNilaiModel({
    this.teori,
    this.praktik,
  });
  factory SatNilaiModel.fromJson(Map<String, dynamic> json) {
    return SatNilaiModel(
      teori: json['teori'] ?? '', // untuk nama pelajaran
      praktik: json['praktik'] ?? '', // untuk nama pelajaran
      // untuk nilai dinamis
    );
  }
}

//nilai mapel model
class SatNilaiMapelModel {
  String? namapelajaran;
  String? kodekelas;
  String? kodepelajaran;
  SatNilaiMapelModel({this.namapelajaran, this.kodekelas, this.kodepelajaran});
  factory SatNilaiMapelModel.fromJson(Map<String, dynamic> json) {
    return SatNilaiMapelModel(
      namapelajaran: json['nama_pljrn'] ?? '',
      kodekelas: json['kode_kelas'] ?? '',
      kodepelajaran: json['kode_pljrn'] ?? '',
    );
  }
}

//nilai ekskul model
class SatNilaiEkskulModel {
  String? namapelajaran;
  String? angka;
  String? deskripsi;
  String? nilai;

  SatNilaiEkskulModel(
      {this.namapelajaran, this.angka, this.deskripsi, this.nilai});

  factory SatNilaiEkskulModel.fromJson(Map<String, dynamic> json) {
    return SatNilaiEkskulModel(
      namapelajaran: json['ekstrakurikuler'] ?? '',
      angka: json['angka'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      nilai: json['nilai'] ?? '',
    );
  }
}
