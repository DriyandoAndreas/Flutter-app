class JadwalModel {
  String? kodePelajaran;
  String? namaPelajaran;
  String? singkatanPelajaran;
  String? urutan;
  String? kdGroup;
  String? kodeMengajar;
  String? sudahMengajar;

  JadwalModel({
    required this.kodePelajaran,
    required this.namaPelajaran,
    required this.singkatanPelajaran,
    required this.urutan,
    required this.kdGroup,
    required this.kodeMengajar,
    required this.sudahMengajar,
  });

  factory JadwalModel.fromJson(Map<String, dynamic> json) {
    return JadwalModel(
      kodePelajaran: json['kode_pljrn'],
      namaPelajaran: json['nama_pljrn'],
      singkatanPelajaran: json['singk_pljrn'],
      urutan: json['urutan'],
      kdGroup: json['kd_group'],
      kodeMengajar: json['kode_mengajar'],
      sudahMengajar: json['sudahmengajar'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'kode_pljrn': kodePelajaran,
      'nama_pljrn': namaPelajaran,
      'singk_pljrn': singkatanPelajaran,
      'urutan': urutan,
      'kd_group': kdGroup,
      'kode_mengajar': kodeMengajar,
      'sudahmengajar': sudahMengajar,
    };
  }
}

class JadwalKelaslModel {
  String? kodeKelas;
  String? namaKelas;
  String? kodePegawai;
  String? active;
  String? jumlahJam;

  JadwalKelaslModel({
    required this.kodeKelas,
    required this.namaKelas,
    required this.kodePegawai,
    required this.active,
    required this.jumlahJam,
  });

  factory JadwalKelaslModel.fromJson(Map<String, dynamic> json) {
    return JadwalKelaslModel(
      kodeKelas: json['kode_kelas'],
      namaKelas: json['nama_kelas'],
      kodePegawai: json['kode_pegawai'],
      active: json['active'],
      jumlahJam: json['jmlJam'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'kode_kelas': kodeKelas,
      'nama_kelas': namaKelas,
      'kode_pegawai': kodePegawai,
      'active': active,
      'jmlJam': jumlahJam,
    };
  }
}

class DetailJadwalHarian {
  String? kodePljrn;
  String? kodeMengajar;
  String? thnAj;
  String? semester;
  String? kodeHariJam;
  String? kodeKelas;
  String? namaPljrn;
  String? namaPengajar;
  String? kodePegawai;

  DetailJadwalHarian({
    this.kodePljrn,
    this.kodeMengajar,
    this.thnAj,
    this.semester,
    this.kodeHariJam,
    this.kodeKelas,
    this.namaPljrn,
    this.namaPengajar,
    this.kodePegawai,
  });

  factory DetailJadwalHarian.fromJson(Map<String, dynamic> json) {
    return DetailJadwalHarian(
      kodePljrn: json['kode_pljrn'],
      kodeMengajar: json['kode_mengajar'],
      thnAj: json['thn_aj'],
      semester: json['semester'],
      kodeHariJam: json['kode_hari_jam'],
      kodeKelas: json['kode_kelas'],
      namaPljrn: json['nama_pljrn'],
      namaPengajar: json['nama_pengajar'],
      kodePegawai: json['kode_pegawai'],
    );
  }
}

class ListMengajarModel {
  String? kodeKelas;
  String? hari;
  String? jam;
  String? kodeMengajar;
  String? namaPelajaran;

  ListMengajarModel({
    this.kodeKelas,
    this.hari,
    this.jam,
    this.kodeMengajar,
    this.namaPelajaran,
  });

  factory ListMengajarModel.fromJson(Map<String, dynamic> json) {
    return ListMengajarModel(
      kodeKelas: json['kode_kelas'],
      hari: json['kode_kelas'],
      jam: json['kode_kelas'],
      kodeMengajar: json['kode_mengajar'],
      namaPelajaran: json['nama_pljrn'],
    );
  }
}
