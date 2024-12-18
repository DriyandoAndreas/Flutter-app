class ListMonitoringAktifitasModel {
  String? kodepegawai;
  String? namalengkap;
  String? logincounter;
  String? lastaccess;
  String? lastip;
  ListMonitoringAktifitasModel({
    this.kodepegawai,
    this.namalengkap,
    this.logincounter,
    this.lastaccess,
    this.lastip,
  });
  factory ListMonitoringAktifitasModel.fromJson(Map<String, dynamic> json) {
    return ListMonitoringAktifitasModel(
      kodepegawai: json['kode_pegawai'] ?? '',
      namalengkap: json['nama_lengkap'] ?? '',
      logincounter: json['login_counter'] ?? '',
      lastaccess: json['last_access'] ?? '',
      lastip: json['last_ip'] ?? '',
    );
  }
}

class UserMonitoringAktifitasModel {
  String? jumlah;

  UserMonitoringAktifitasModel({this.jumlah});

  factory UserMonitoringAktifitasModel.fromJson(Map<String, dynamic> json) {
    return UserMonitoringAktifitasModel(
      jumlah: json['jumlah'],
    );
  }
}

class MainUserMonitoringModel {
  List<UserMonitoringAktifitasModel>? getGrAll;
  List<UserMonitoringAktifitasModel>? getGr;
  List<UserMonitoringAktifitasModel>? getKrAll;
  List<UserMonitoringAktifitasModel>? getKr;
  List<UserMonitoringAktifitasModel>? getXtAll;
  List<UserMonitoringAktifitasModel>? getXt;

  MainUserMonitoringModel({
    this.getGr,
    this.getGrAll,
    this.getKr,
    this.getKrAll,
    this.getXt,
    this.getXtAll,
  });

  factory MainUserMonitoringModel.fromJson(Map<String, dynamic> json) {
    return MainUserMonitoringModel(
      getGrAll: [UserMonitoringAktifitasModel.fromJson(json['guru_all'])],
      getGr: [UserMonitoringAktifitasModel.fromJson(json['guru'])],
      getKrAll: [UserMonitoringAktifitasModel.fromJson(json['karyawan_all'])],
      getKr: [UserMonitoringAktifitasModel.fromJson(json['karyawan'])],
      getXtAll: [UserMonitoringAktifitasModel.fromJson(json['extra_all'])],
      getXt: [UserMonitoringAktifitasModel.fromJson(json['extra'])],
    );
  }
}

class MainListAktifitasModel {
  List<ListMonitoringAktifitasModel>? guru;
  List<ListMonitoringAktifitasModel>? karyawan;
  List<ListMonitoringAktifitasModel>? extra;

  MainListAktifitasModel({this.guru, this.karyawan, this.extra});
}

class MonitoringProgressImpelementasi {
  String? nama;
  String? query;

  MonitoringProgressImpelementasi({
    this.nama,
    this.query,
  });
  factory MonitoringProgressImpelementasi.fromJson(Map<String, dynamic> json) {
    return MonitoringProgressImpelementasi(
      nama: json['name'] ?? '',
      query: json['query'] ?? '',
    );
  }
}

class MonitoringProgressGrouped {
  String? group;
  List<MonitoringProgressImpelementasi>? list;

  MonitoringProgressGrouped({this.group, this.list});
  factory MonitoringProgressGrouped.fromJson(Map<String, dynamic> json) {
    return MonitoringProgressGrouped(
      group: json['GroupName'] ?? '',
      list: (json['List'] as List)
          .map((item) => MonitoringProgressImpelementasi.fromJson(item))
          .toList(),
    );
  }
}

class MonitoringKoneksiPhone {
  int? r;
  int? g;
  int? k;
  int? x;
  int? s;
  int? o;
  int? a;
  int? i;
  int? connectionUpto;
  int? connectionUsed;
  int? connectionExpdate;
  int? connectionExpday;
  String? totalConnectionssiswa;
  String? totalConnectionsguru;
  String? totalConnectionskaryawan;
  String? totalConnectionsayah;
  String? totalConnectionsibu;
  String? totalConnectionxtra;

  MonitoringKoneksiPhone({
    this.r,
    this.g,
    this.k,
    this.x,
    this.s,
    this.o,
    this.a,
    this.i,
    this.connectionUpto,
    this.connectionUsed,
    this.connectionExpdate,
    this.connectionExpday,
    this.totalConnectionssiswa,
    this.totalConnectionsguru,
    this.totalConnectionskaryawan,
    this.totalConnectionsayah,
    this.totalConnectionsibu,
    this.totalConnectionxtra,
  });

  factory MonitoringKoneksiPhone.fromJson(Map<String, dynamic> json) {
    return MonitoringKoneksiPhone(
      r: json['connected']['r'] ?? '',
      g: json['connected']['g'] ?? '',
      k: json['connected']['k'] ?? '',
      x: json['connected']['x'] ?? '',
      s: json['connected']['s'] ?? '',
      o: json['connected']['o'] ?? '',
      a: json['connected']['a'] ?? '',
      i: json['connected']['i'] ?? '',
      connectionUpto: json['connected']['connection_upto'] ?? '',
      connectionUsed: json['connected']['connection_used'] ?? '',
      connectionExpdate: json['connected']['connection_expdate'] ?? '',
      connectionExpday: json['connected']['connection_expday'] ?? '',
      totalConnectionsguru: json['connections']['g'] ?? '',
      totalConnectionskaryawan: json['connections']['k'] ?? '',
      totalConnectionsayah: json['connections']['r'] ?? '',
      totalConnectionsibu: json['connections']['u'] ?? '',
      totalConnectionxtra: json['connections']['x'] ?? '',
      totalConnectionssiswa: json['connections']['s'] ?? '',
    );
  }
}

class MonitoringAktifitas30Day {
  String? ip;
  String? datetime;
  String? namalengkap;
  String? url;
  String? action;

  MonitoringAktifitas30Day({
    this.ip,
    this.datetime,
    this.namalengkap,
    this.url,
    this.action,
  });
  factory MonitoringAktifitas30Day.fromJson(Map<String, dynamic> json) {
    return MonitoringAktifitas30Day(
      ip: json['ip'] ?? '',
      datetime: json['datetime'] ?? '',
      namalengkap: json['nama_lengkap'] ?? '',
      url: json['url'] ?? '',
      action: json['action'] ?? '',
    );
  }
}

class Monitoring30DayGrouped {
  int? jumlahhari;
  List<MonitoringAktifitas30Day>? data;

  Monitoring30DayGrouped({this.jumlahhari, this.data});

  factory Monitoring30DayGrouped.fromJson(Map<String, dynamic> json) {
    return Monitoring30DayGrouped(
      jumlahhari: json['jumlah_hari'] ?? '',
      data: (json['List'] as List)
          .map((item) => MonitoringAktifitas30Day.fromJson(item))
          .toList(),
    );
  }
}

class MonitoringActivitySummaryModel {
  String? thnbln;
  String? iduser;
  String? jumlahaksi;
  String? namalengkap;

  MonitoringActivitySummaryModel({
    this.thnbln,
    this.iduser,
    this.jumlahaksi,
    this.namalengkap,
  });

  factory MonitoringActivitySummaryModel.fromJson(Map<String, dynamic> json) {
    return MonitoringActivitySummaryModel(
      thnbln: json['thn_bln'] ?? '',
      iduser: json['id_user'] ?? '',
      jumlahaksi: json['jml_aksi'] ?? '',
      namalengkap: json['nama_lengkap'] ?? '',
    );
  }
}

class MonitoriActivitySummaryTotal {
  String? total;
  String? thnbln;

  MonitoriActivitySummaryTotal({this.total, this.thnbln});
  factory MonitoriActivitySummaryTotal.fromJson(Map<String, dynamic> json) {
    return MonitoriActivitySummaryTotal(
      total: json['total'] ?? '',
      thnbln: json['thn_bln'] ?? '',
    );
  }
}

class MonitoringPresensiSiswaModel {
  int? jumlahall;
  int? jumlahtapping;
  String? jumlahhadir;
  String? jumlahsakit;
  String? jumlahijin;
  String? jumlahalpha;
  String? jumlahterlambat;
  String? jumlahdipulangkan;
  String? jumlahtbolos;
  int? jumlahtanpaketerangan;

  MonitoringPresensiSiswaModel({
    this.jumlahall,
    this.jumlahalpha,
    this.jumlahdipulangkan,
    this.jumlahhadir,
    this.jumlahijin,
    this.jumlahsakit,
    this.jumlahtanpaketerangan,
    this.jumlahtapping,
    this.jumlahtbolos,
    this.jumlahterlambat,
  });
  factory MonitoringPresensiSiswaModel.fromJson(Map<String, dynamic> json) {
    return MonitoringPresensiSiswaModel(
      jumlahall: json['jumlah_all'] ?? 0,
      jumlahtapping: json['jumlah_tapping'] ?? 0,
      jumlahtanpaketerangan: json['jumlah_tanpa_keterangan'] ?? 0,
      jumlahhadir: json['jumlah_hadir'] ?? '0',
      jumlahterlambat: json['jml_terlambat'] ?? '0',
      jumlahsakit: json['jml_sakit'] ?? '0',
      jumlahijin: json['jml_ijin'] ?? '0',
      jumlahalpha: json['jml_alpha'] ?? '0',
      jumlahdipulangkan: json['jml_dipulangkan'] ?? '0',
      jumlahtbolos: json['jml_bolos'] ?? '0',
    );
  }
}

class MonitoringPresensiKaryawanModel {
  String? jumlahall;
  int? jumlahtapping;
  int? jumlahtanpaketerangan;
  int? jumlahhadir;
  int? jumlahterlambat;
  int? jumlahsakit;
  int? jumlahijin;
  int? jumlahalpha;
  int? jumlahdidinasluar;
  int? jumlahtbolos;
  int? jumlahtcuti;

  MonitoringPresensiKaryawanModel({
    this.jumlahall,
    this.jumlahalpha,
    this.jumlahdidinasluar,
    this.jumlahhadir,
    this.jumlahijin,
    this.jumlahsakit,
    this.jumlahtanpaketerangan,
    this.jumlahtapping,
    this.jumlahtbolos,
    this.jumlahtcuti,
    this.jumlahterlambat,
  });
  factory MonitoringPresensiKaryawanModel.fromJson(Map<String, dynamic> json) {
    return MonitoringPresensiKaryawanModel(
      jumlahall: json['jumlah_all'] ?? "0",
      jumlahtapping: json['jumlah_tapping'] ?? 0,
      jumlahtanpaketerangan: json['jumlah_tanpa_keterangan'] ?? 0,
      jumlahhadir: json['jumlah_hadir'] ?? 0,
      jumlahterlambat: json['jml_terlambat'] ?? 0,
      jumlahsakit: json['jml_sakit'] ?? 0,
      jumlahijin: json['jml_ijin'] ?? 0,
      jumlahalpha: json['jml_alpha'] ?? 0,
      jumlahdidinasluar: json['jml_dinasluar'] ?? 0,
      jumlahtbolos: json['jml_bolos'] ?? 0,
      jumlahtcuti: json['jml_cuti'] ?? 0,
    );
  }
}

class ListData {
  String? idakademik;
  String? mulai;
  String? selesai;
  String? namaPljrn;
  String? namalengkap;
  String? mulaipukul;
  String? selesaipukul;
  String? status;
  String? materi;
  String? pr;
  String? hambatan;
  String? persiapan;
  String? presensi;
  String? presensitotal;
  String? tanggal;
  String? nohp;

  ListData({
    this.idakademik,
    this.mulai,
    this.selesai,
    this.namaPljrn,
    this.namalengkap,
    this.mulaipukul,
    this.selesaipukul,
    this.status,
    this.hambatan,
    this.materi,
    this.persiapan,
    this.pr,
    this.presensi,
    this.presensitotal,
    this.tanggal,
    this.nohp,
  });

  factory ListData.fromJson(Map<String, dynamic> json) {
    return ListData(
      idakademik: json['id_akademik'] ?? '',
      mulai: json['mulai'] ?? '',
      selesai: json['selesai'] ?? '',
      namaPljrn: json['nama_pljrn'] ?? '',
      namalengkap: json['nama_lengkap'] ?? '',
      mulaipukul: json['mulai_pukul'] ?? '',
      selesaipukul: json['selesai_pukul'] ?? '',
      status: json['status'] ?? '',
      hambatan: json['hambatan_kendala'] ?? '',
      materi: json['materi_yang_diberikan'] ?? '',
      persiapan: json['persiapan_pertemuan_berikutnya'] ?? '',
      pr: json['tugas_pr'] ?? '',
      presensi: json['presensi'] ?? '',
      presensitotal: json['presensi_total'] ?? '',
      tanggal: json['tanggal'] ?? '',
      nohp: json['no_hp'] ?? '',
    );
  }
}

class Kelas {
  String? kodeKelas;
  String? namaKelas;
  List<ListData>? listData;

  Kelas({
    this.kodeKelas,
    this.namaKelas,
    this.listData,
  });

  factory Kelas.fromJson(Map<String, dynamic> json) {
    return Kelas(
      kodeKelas: json['kode_kelas'] ?? '',
      namaKelas: json['nama_kelas'] ?? '',
    );
  }
}
