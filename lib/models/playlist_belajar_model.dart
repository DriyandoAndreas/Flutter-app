class SatTodayTimeLine {
  String? mulai;
  String? selesai;
  String? namakelas;
  String? namapelajaran;
  String? kodeakademik;
  String? tanggal;
  String? status;
  String? mulaipukul;
  String? selesaipukul;
  String? halpersiapan;
  String? tugassiswa;
  String? materi;
  String? tugaspr;
  String? hambatankendala;
  String? persiapanberikutnya;
  String? idakademik;
  String? tahunajaran;
  String? semester;
  String? namalengkap;
  String? wagroup;
  String? absen;
  String? absenht;

  SatTodayTimeLine({
    this.kodeakademik,
    this.mulai,
    this.mulaipukul,
    this.namakelas,
    this.namapelajaran,
    this.selesai,
    this.selesaipukul,
    this.status,
    this.tanggal,
    this.halpersiapan,
    this.tugassiswa,
    this.hambatankendala,
    this.materi,
    this.persiapanberikutnya,
    this.tugaspr,
    this.idakademik,
    this.semester,
    this.tahunajaran,
    this.namalengkap,
    this.wagroup,
    this.absen,
    this.absenht,
  });
  factory SatTodayTimeLine.fromJson(Map<String, dynamic> json) {
    return SatTodayTimeLine(
      kodeakademik: json['kode_akademik'] ?? '',
      mulai: json['mulai'] ?? '',
      selesai: json['selesai'] ?? '',
      mulaipukul: json['mulai_pukul'] ?? '',
      selesaipukul: json['selesai_pukul'] ?? '',
      namakelas: json['nama_kelas'] ?? '',
      namapelajaran: json['nama_pljrn'] ?? '',
      status: json['status'] ?? '',
      tanggal: json['tanggal'] ?? '',
      halpersiapan: json['hal_persiapan'] ?? '',
      tugassiswa: json['tugas_siswa'] ?? '',
      hambatankendala: json['hambatan_kendala'] ?? '',
      materi: json['materi_yang_diberikan'] ?? '',
      persiapanberikutnya: json['persiapan_pertemuan_berikutnya'] ?? '',
      tugaspr: json['tugas_pr'] ?? '',
      idakademik: json['id_akademik'] ?? '',
      tahunajaran: json['tahun_ajaran'] ?? '',
      semester: json['semester'] ?? '',
      namalengkap: json['nama_lengkap'] ?? '',
      wagroup: json['wagroup'] ?? '',
      absen: json['absen'] ?? '',
      absenht: json['absen_ht'] ?? '',
    );
  }
}

class SatTommorowTimeLine {
  String? mulai;
  String? selesai;
  String? namakelas;
  String? namapelajaran;
  String? kodeakademik;
  String? tanggal;
  String? status;
  String? mulaipukul;
  String? selesaipukul;
  String? halpersiapan;
  String? tugassiswa;
  String? materi;
  String? tugaspr;
  String? hambatankendala;
  String? persiapanberikutnya;
  String? idakademik;
  String? tahunajaran;
  String? semester;
  String? namalengkap;
  String? wagroup;
  String? absen;
  String? absenht;

  SatTommorowTimeLine({
    this.kodeakademik,
    this.mulai,
    this.mulaipukul,
    this.namakelas,
    this.namapelajaran,
    this.selesai,
    this.selesaipukul,
    this.status,
    this.tanggal,
    this.halpersiapan,
    this.tugassiswa,
    this.hambatankendala,
    this.materi,
    this.persiapanberikutnya,
    this.tugaspr,
    this.idakademik,
    this.semester,
    this.tahunajaran,
    this.namalengkap,
    this.wagroup,
    this.absen,
    this.absenht,
  });
  factory SatTommorowTimeLine.fromJson(Map<String, dynamic> json) {
    return SatTommorowTimeLine(
      kodeakademik: json['kode_akademik'] ?? '',
      mulai: json['mulai'] ?? '',
      selesai: json['selesai'] ?? '',
      mulaipukul: json['mulai_pukul'] ?? '',
      selesaipukul: json['selesai_pukul'] ?? '',
      namakelas: json['nama_kelas'] ?? '',
      namapelajaran: json['nama_pljrn'] ?? '',
      status: json['status'] ?? '',
      tanggal: json['tanggal'] ?? '',
      halpersiapan: json['hal_persiapan'] ?? '',
      tugassiswa: json['tugas_siswa'] ?? '',
      hambatankendala: json['hambatan_kendala'] ?? '',
      materi: json['materi_yang_diberikan'] ?? '',
      persiapanberikutnya: json['persiapan_pertemuan_berikutnya'] ?? '',
      tugaspr: json['tugas_pr'] ?? '',
      idakademik: json['id_akademik'] ?? '',
      tahunajaran: json['tahun_ajaran'] ?? '',
      semester: json['semester'] ?? '',
      namalengkap: json['nama_lengkap'] ?? '',
      wagroup: json['wagroup'] ?? '',
      absen: json['absen'] ?? '',
      absenht: json['absen_ht'] ?? '',
    );
  }
}

class SatTommorowAfterTimeLine {
  String? mulai;
  String? selesai;
  String? namakelas;
  String? namapelajaran;
  String? kodeakademik;
  String? tanggal;
  String? status;
  String? mulaipukul;
  String? selesaipukul;
  String? halpersiapan;
  String? tugassiswa;
  String? materi;
  String? tugaspr;
  String? hambatankendala;
  String? persiapanberikutnya;
  String? idakademik;
  String? tahunajaran;
  String? semester;
  String? namalengkap;
  String? wagroup;
  String? absen;
  String? absenht;

  SatTommorowAfterTimeLine({
    this.kodeakademik,
    this.mulai,
    this.mulaipukul,
    this.namakelas,
    this.namapelajaran,
    this.selesai,
    this.selesaipukul,
    this.status,
    this.tanggal,
    this.halpersiapan,
    this.tugassiswa,
    this.hambatankendala,
    this.materi,
    this.persiapanberikutnya,
    this.tugaspr,
    this.idakademik,
    this.semester,
    this.tahunajaran,
    this.namalengkap,
    this.wagroup,
    this.absen,
    this.absenht,
  });
  factory SatTommorowAfterTimeLine.fromJson(Map<String, dynamic> json) {
    return SatTommorowAfterTimeLine(
      kodeakademik: json['kode_akademik'] ?? '',
      mulai: json['mulai'] ?? '',
      selesai: json['selesai'] ?? '',
      mulaipukul: json['mulai_pukul'] ?? '',
      selesaipukul: json['selesai_pukul'] ?? '',
      namakelas: json['nama_kelas'] ?? '',
      namapelajaran: json['nama_pljrn'] ?? '',
      status: json['status'] ?? '',
      tanggal: json['tanggal'] ?? '',
      halpersiapan: json['hal_persiapan'] ?? '',
      tugassiswa: json['tugas_siswa'] ?? '',
      hambatankendala: json['hambatan_kendala'] ?? '',
      materi: json['materi_yang_diberikan'] ?? '',
      persiapanberikutnya: json['persiapan_pertemuan_berikutnya'] ?? '',
      tugaspr: json['tugas_pr'] ?? '',
      idakademik: json['id_akademik'] ?? '',
      tahunajaran: json['tahun_ajaran'] ?? '',
      semester: json['semester'] ?? '',
      namalengkap: json['nama_lengkap'] ?? '',
      wagroup: json['wagroup'] ?? '',
      absen: json['absen'] ?? '',
      absenht: json['absen_ht'] ?? '',
    );
  }
}
