///****************Gac jadwal model */
class JadwalModel {
  String? kodePelajaran;
  String? namaPelajaran;
  String? singkatanPelajaran;
  String? urutan;
  String? kdGroup;
  String? kodeMengajar;
  String? sudahMengajar;

  JadwalModel({
    this.kodePelajaran,
    this.namaPelajaran,
    this.singkatanPelajaran,
    this.urutan,
    this.kdGroup,
    this.kodeMengajar,
    this.sudahMengajar,
  });

  factory JadwalModel.fromJson(Map<String, dynamic> json) {
    return JadwalModel(
      kodePelajaran: json['kode_pljrn'] ?? '',
      namaPelajaran: json['nama_pljrn'] ?? '',
      singkatanPelajaran: json['singk_pljrn'] ?? '',
      urutan: json['urutan'] ?? '',
      kdGroup: json['kd_group'] ?? '',
      kodeMengajar: json['kode_mengajar'] ?? '',
      sudahMengajar: json['sudahmengajar'] ?? '',
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
  String? tahunjaran;
  String? semester;

  JadwalKelaslModel({
    this.kodeKelas,
    this.namaKelas,
    this.kodePegawai,
    this.active,
    this.jumlahJam,
    this.tahunjaran,
    this.semester,
  });

  factory JadwalKelaslModel.fromJson(Map<String, dynamic> json) {
    return JadwalKelaslModel(
      kodeKelas: json['kode_kelas'] ?? '',
      namaKelas: json['nama_kelas'] ?? '',
      kodePegawai: json['kode_pegawai'] ?? '',
      active: json['active'] ?? '',
      jumlahJam: json['jmlJam'] ?? '',
      tahunjaran: json['tahun_ajaran'] ?? '',
      semester: json['semester'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'kode_kelas': kodeKelas,
      'nama_kelas': namaKelas,
      'kode_pegawai': kodePegawai,
      'active': active,
      'jmlJam': jumlahJam,
      'tahun_ajaran': tahunjaran,
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
      kodePljrn: json['kode_pljrn'] ?? '',
      kodeMengajar: json['kode_mengajar'] ?? '',
      thnAj: json['thn_aj'] ?? '',
      semester: json['semester'] ?? '',
      kodeHariJam: json['kode_hari_jam'] ?? '',
      kodeKelas: json['kode_kelas'] ?? '',
      namaPljrn: json['nama_pljrn'] ?? '',
      namaPengajar: json['nama_pengajar'] ?? '',
      kodePegawai: json['kode_pegawai'] ?? '',
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
      kodeKelas: json['kode_kelas'] ?? '',
      hari: json['kode_kelas'] ?? '',
      jam: json['kode_kelas'] ?? '',
      kodeMengajar: json['kode_mengajar'] ?? '',
      namaPelajaran: json['nama_pljrn'] ?? '',
    );
  }
}

///**************Sat jadwal model */
class SatJadwalModel {
  String? jam;
  String? namapelajaran;

  SatJadwalModel({
    this.jam,
    this.namapelajaran,
  });

  factory SatJadwalModel.fromJson(String jam, String namapelajaran) {
    return SatJadwalModel(
      jam: jam,
      namapelajaran: namapelajaran,
    );
  }
}

class SatJadwalUjianModel {
  String? kodekelaas;
  String? idkurjadwal;
  String? kodepegawai;
  String? tanggal;
  String? keterangan;
  String? namakelas;
  String? kodepelajaran;
  String? namapelajaran;
  String? hari;

  SatJadwalUjianModel({
    this.kodekelaas,
    this.idkurjadwal,
    this.kodepegawai,
    this.tanggal,
    this.keterangan,
    this.namakelas,
    this.kodepelajaran,
    this.namapelajaran,
    this.hari,
  });

  factory SatJadwalUjianModel.fromJson(Map<String, dynamic> json) {
    return SatJadwalUjianModel(
      kodekelaas: json['kode_kelas'] ?? '',
      idkurjadwal: json['id_kur_jadwal'] ?? '',
      kodepegawai: json['kode_pegawai'] ?? '',
      tanggal: json['tanggal'] ?? '',
      keterangan: json['keterangan'] ?? '',
      namakelas: json['nama_kelas'] ?? '',
      kodepelajaran: json['kode_pljrn'] ?? '',
      namapelajaran: json['nama_pljrn'] ?? '',
      hari: json['hari'] ?? '',
    );
  }
}

class SatListJadwalKerjaPraktikModel {
  String? idkurnilaikp;
  String? nis;
  String? thnaj;
  String? semester;
  String? mitra;
  String? instansi;
  String? kodepegawai;
  String? keterangam;
  String? alamat;
  String? tglmulai;
  String? tglselesai;

  SatListJadwalKerjaPraktikModel({
    this.idkurnilaikp,
    this.nis,
    this.thnaj,
    this.semester,
    this.mitra,
    this.instansi,
    this.kodepegawai,
    this.keterangam,
    this.alamat,
    this.tglmulai,
    this.tglselesai,
  });

  factory SatListJadwalKerjaPraktikModel.fromJson(Map<String, dynamic> json) {
    return SatListJadwalKerjaPraktikModel(
      idkurnilaikp: json['id_kur_nilai_kp'] ?? '',
      nis: json['nis'] ?? '',
      thnaj: json['thn_aj'] ?? '',
      semester: json['semester'] ?? '',
      mitra: json['mitra'] ?? '',
      instansi: json['instansi'] ?? '',
      kodepegawai: json['kode_pegawai'] ?? '',
      keterangam: json['keterangan'] ?? '',
      alamat: json['alamat'] ?? '',
      tglmulai: json['tgl_mulai'] ?? '',
      tglselesai: json['tgl_selesai'] ?? '',
    );
  }
}
