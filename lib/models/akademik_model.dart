class AkademikTanggalDataModel {
  String? kodepelajaran;
  String? kodemengajar;
  String? namapelajaran;
  String? namakelas;
  String? kodekelas;
  String? tanggal;
  String? mulai;
  String? selesai;
  String? jamke;
  String? jumlahjam;
  String? idlokasi;
  String? menitperjam;
  String? kebutuhanproyektor;
  String? kebutuhankomputer;
  String? faslitiaslain;
  String? isactive;
  String? color;
  String? idakademik;
  String? warna;
  String? tahunajaran;
  String? semester;
  String? namalengkap;
  String? kodeakademik;
  String? status;
  String? mulaipukul;
  String? selesaipukul;
  String? absen;
  String? absenht;
  String? materi;
  String? tugas;
  String? hambatan;
  String? media;
  String? kegiatan;
  String? persiapanselanjutnya;
  String? deskripsimenarik;
  String? halpersiapan;
  String? konfirmasiguru;
  String? zoomlink;

  AkademikTanggalDataModel({
    this.namapelajaran,
    this.namakelas,
    this.mulai,
    this.selesai,
    this.jamke,
    this.kodekelas,
    this.kodepelajaran,
    this.tanggal,
    this.kodemengajar,
    this.jumlahjam,
    this.faslitiaslain,
    this.idlokasi,
    this.kebutuhankomputer,
    this.kebutuhanproyektor,
    this.menitperjam,
    this.isactive,
    this.color,
    this.idakademik,
    this.warna,
    this.tahunajaran,
    this.semester,
    this.namalengkap,
    this.kodeakademik,
    this.status,
    this.mulaipukul,
    this.selesaipukul,
    this.absen,
    this.absenht,
    this.materi,
    this.hambatan,
    this.kegiatan,
    this.media,
    this.persiapanselanjutnya,
    this.tugas,
    this.deskripsimenarik,
    this.halpersiapan,
    this.zoomlink,
  });
  factory AkademikTanggalDataModel.fromJson(Map<String, dynamic> json) {
    return AkademikTanggalDataModel(
      mulai: json['mulai'] ?? '',
      selesai: json['selesai'] ?? '',
      namakelas: json['nama_kelas'] ?? '',
      namapelajaran: json['nama_pljrn'] ?? '',
      jamke: json['jam_ke'] ?? '',
      kodekelas: json['kode_kelas'] ?? '',
      kodepelajaran: json['kode_pljrn'] ?? '',
      tanggal: json['tanggal'] ?? '',
      kodemengajar: json['kode_mengajar'] ?? '',
      jumlahjam: json['jml_jam'] ?? '',
      faslitiaslain: json['fasilitas_lain'] ?? '',
      kebutuhankomputer: json['kebutuhan_komputer'] ?? '',
      kebutuhanproyektor: json['kebutuhan_proyektor'] ?? '',
      idlokasi: json['id_lokasi'] ?? '',
      menitperjam: json['menit_perjam'] ?? '',
      isactive: json['is_active'] ?? '',
      color: json['colors'] ?? '',
      idakademik: json['id_akademik'] ?? '',
      warna: json['warna'] ?? '',
      tahunajaran: json['tahun_ajaran'] ?? '',
      semester: json['semester'] ?? '',
      namalengkap: json['nama_lengkap'] ?? '',
      kodeakademik: json['kode_akademik'] ?? '',
      status: json['status'] ?? '',
      mulaipukul: json['mulai_pukul'] ?? '',
      selesaipukul: json['selesai_pukul'] ?? '',
      absen: json['absen'] ?? '0',
      absenht: json['absen_ht'] ?? '0',
      materi: json['materi_yang_diberikan'] ?? '',
      media: json['media_alat'] ?? '',
      tugas: json['tugas_pr'] ?? '',
      hambatan: json['hambatan_kendala'] ?? '',
      kegiatan: json['kegiatan_kbm'] ?? '',
      persiapanselanjutnya: json['persiapan_pertemuan_berikutnya'] ?? '',
      deskripsimenarik: json['hal_persiapan'] ?? '',
      halpersiapan: json['tugas_siswa'] ?? '',
      zoomlink: json['zoom_link'] ?? '',
    );
  }
}

class AkademikTanggalModel {
  String? tanggal;
  List<AkademikTanggalDataModel>? data;

  AkademikTanggalModel({this.tanggal, this.data});
  factory AkademikTanggalModel.fromJson(Map<String, dynamic> json) {
    var databulan = (json['data'] as List)
        .map((e) => AkademikTanggalDataModel.fromJson(e))
        .toList();
    return AkademikTanggalModel(
      tanggal: json['tgl'],
      data: databulan,
    );
  }
}

class AkademikBulanModel {
  String? bulan;
  List<AkademikTanggalModel>? data;

  AkademikBulanModel({this.bulan, this.data});
  factory AkademikBulanModel.fromJson(Map<String, dynamic> json) {
    var tanggallist = (json['data'] as List)
        .map((e) => AkademikTanggalModel.fromJson(e))
        .toList();
    return AkademikBulanModel(
      bulan: json['bulan'],
      data: tanggallist,
    );
  }
}

class AkademikTahunModel {
  String? tahun;
  List<AkademikBulanModel>? data;

  AkademikTahunModel({this.tahun, this.data});
  factory AkademikTahunModel.fromJson(Map<String, dynamic> json) {
    var bulanlist = (json['data'] as List)
        .map((e) => AkademikBulanModel.fromJson(e))
        .toList();
    return AkademikTahunModel(
      tahun: json['tahun'],
      data: bulanlist,
    );
  }
}

class AkademikModel {
  List<AkademikTahunModel>? data;

  AkademikModel({this.data});
  factory AkademikModel.fromJson(Map<String, dynamic> json) {
    var datas = (json['datas'] as List)
        .map((e) => AkademikTahunModel.fromJson(e))
        .toList();
    return AkademikModel(
      data: datas,
    );
  }
}

class AkademikFormPersiapanPresensi {
  String? nis;
  String? namasiswa;
  String? keterangan;

  AkademikFormPersiapanPresensi({this.nis, this.namasiswa, this.keterangan});
  factory AkademikFormPersiapanPresensi.fromJson(Map<String, dynamic> json) {
    return AkademikFormPersiapanPresensi(
      nis: json['nis'],
      namasiswa: json['nama_siswa'],
      keterangan: json['ket'],
    );
  }
}

class AkademikFormPersiapanLaporan {
  String? materi;
  String? tugas;
  String? hambatan;
  String? media;
  String? kegiatan;
  String? persiapanselanjutnya;

  AkademikFormPersiapanLaporan(
      {this.materi,
      this.hambatan,
      this.kegiatan,
      this.media,
      this.persiapanselanjutnya,
      this.tugas});
  factory AkademikFormPersiapanLaporan.fromJson(Map<String, dynamic> json) {
    return AkademikFormPersiapanLaporan(
      materi: json['materi_yang_diberikan'] ?? '',
      media: json['media_alat'] ?? '',
      tugas: json['tugas_pr'] ?? '',
      hambatan: json['hambatan_kendala'] ?? '',
      kegiatan: json['kegiatan_kbm'] ?? '',
      persiapanselanjutnya: json['persiapan_pertemuan_berikutnya'] ?? '',
    );
  }
}

class AkademikFormPersiapan {
  String? deskripsimenarik;
  String? halpersiapan;
  String? konfirmasiguru;
  String? zoomlink;

  AkademikFormPersiapan(
      {this.deskripsimenarik,
      this.halpersiapan,
      this.konfirmasiguru,
      this.zoomlink});

  factory AkademikFormPersiapan.fromJson(Map<String, dynamic> json) {
    return AkademikFormPersiapan(
      deskripsimenarik: json['hal_persiapan'] ?? '',
      halpersiapan: json['tugas_siswa'] ?? '',
      konfirmasiguru: json['konfirmasi_pengajar'] ?? '',
      zoomlink: json['zoom_link'] ?? '',
    );
  }
}

class MainPalapaMateri {
  String? namagroup;
  String? jenjang;
  String? kelas;
  List<PalapaMateri>? pesan;

  MainPalapaMateri({this.namagroup, this.pesan, this.jenjang, this.kelas});
  factory MainPalapaMateri.fromJson(Map<String, dynamic> json) {
    return MainPalapaMateri(
      namagroup: json['nama_group'] ?? '',
      jenjang: json['nama_jenjang'] ?? '',
      kelas: json['kelas'] ?? '',
      pesan: json['pesan'] != null
          ? List<PalapaMateri>.from(
              json['pesan'].map((e) => PalapaMateri.fromJson(e)))
          : [],
    );
  }
}

class PalapaMateri {
  String? idactivity;
  PalapaPesanAcivity? pesan;

  PalapaMateri({this.idactivity, this.pesan});
  factory PalapaMateri.fromJson(Map<String, dynamic> json) {
    return PalapaMateri(
      idactivity: json['id_activity'] ?? '',
      pesan: PalapaPesanAcivity.fromJson(json['pesan']),
    );
  }
}

class PalapaPesanAcivity {
  String? namatopik;
  List<dynamic>? pages;

  PalapaPesanAcivity({this.namatopik, this.pages});
  factory PalapaPesanAcivity.fromJson(Map<String, dynamic> json) {
    return PalapaPesanAcivity(
      namatopik: json['nama_topik'] ?? '',
      pages: json['pages'] != null ? List<dynamic>.from(json['pages']) : null,
    );
  }
}

class AkademikTodayTimeline {
  String? kodeakademik;
  String? mulai;
  String? mulaipukul;
  String? selesai;
  String? selesaipukul;
  String? status;
  String? zoomlink;

  AkademikTodayTimeline({
    this.kodeakademik,
    this.mulai,
    this.mulaipukul,
    this.selesai,
    this.selesaipukul,
    this.status,
    this.zoomlink,
  });
  factory AkademikTodayTimeline.fromJson(Map<String, dynamic> json) {
    return AkademikTodayTimeline(
      kodeakademik: json['kode_akademik'] ?? '',
      mulai: json['mulai'] ?? '',
      mulaipukul: json['mulai_pukul'] ?? '',
      selesai: json['selesai'] ?? '',
      selesaipukul: json['selesai_pukul'] ?? '',
      status: json['status'] ?? '',
      zoomlink: json['zoom_link'] ?? '',
    );
  }
}

// *SAT

class AkademikListData {
  String? mulai;
  String? selesai;
  String? namaPljrn;
  String? namalengkap;
  String? status;
  String? halpersiapan;
  String? tugassiswa;
  String? mulaipukul;
  String? selesaipukul;
  String? absen;
  String? absenht;
  String? materiyangdiberikan;
  String? tugaspr;
  String? hambatankendala;
  String? persiapanberikutnya;

  AkademikListData({
    this.mulai,
    this.selesai,
    this.namaPljrn,
    this.namalengkap,
    this.status,
    this.halpersiapan,
    this.tugassiswa,
    this.mulaipukul,
    this.selesaipukul,
    this.absen,
    this.absenht,
    this.hambatankendala,
    this.materiyangdiberikan,
    this.persiapanberikutnya,
    this.tugaspr,
  });

  factory AkademikListData.fromJson(Map<String, dynamic> json) {
    return AkademikListData(
      mulai: json['mulai'] ?? '',
      selesai: json['selesai'] ?? '',
      namaPljrn: json['nama_pljrn'] ?? '',
      namalengkap: json['nama_lengkap'] ?? '',
      status: json['status'] ?? '',
      halpersiapan: json['hal_persiapan'] ?? '',
      tugassiswa: json['tugas_siswa'] ?? '',
      mulaipukul: json['mulai_pukul'] ?? '',
      selesaipukul: json['selesai_pukul'] ?? '',
      absen: json['absen'] ?? '0',
      absenht: json['absenht'] ?? '0',
      materiyangdiberikan: json['materi_yang_diberikan'] ?? '',
      hambatankendala: json['hambatan_kendala'] ?? '',
      tugaspr: json['tugas_pr'] ?? '',
      persiapanberikutnya: json['persiapan_pertemuan_berikutnya'] ?? '',
    );
  }
}

class AkademikKelas {
  String? kodeKelas;
  String? namaKelas;
  List<AkademikListData>? listData;

  AkademikKelas({
    this.kodeKelas,
    this.namaKelas,
    this.listData,
  });

  factory AkademikKelas.fromJson(Map<String, dynamic> json) {
    return AkademikKelas(
      kodeKelas: json['kode_kelas'] ?? '',
      namaKelas: json['nama_kelas'] ?? '',
    );
  }
}
