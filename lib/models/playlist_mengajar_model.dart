class TodayTimeLine {
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
  String? zoomlink;

  TodayTimeLine({
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
    this.zoomlink,
  });
  factory TodayTimeLine.fromJson(Map<String, dynamic> json) {
    return TodayTimeLine(
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
      zoomlink: json['zoom_link'] ?? '',
    );
  }
}

class TommorowTimeLine {
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
  String? zoomlink;

  TommorowTimeLine({
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
    this.zoomlink,
  });
  factory TommorowTimeLine.fromJson(Map<String, dynamic> json) {
    return TommorowTimeLine(
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
      zoomlink: json['zoom_link'] ?? '',
    );
  }
}

class TommorowAfterTimeLine {
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
  String? zoomlink;

  TommorowAfterTimeLine({
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
    this.zoomlink,
  });
  factory TommorowAfterTimeLine.fromJson(Map<String, dynamic> json) {
    return TommorowAfterTimeLine(
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
      zoomlink: json['zoom_link'] ?? '',
    );
  }
}
