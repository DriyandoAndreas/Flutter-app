class ReferralModel {
  String? nama;
  String? sekolah;
  String? username;
  String? csfid;

  ReferralModel({
    this.nama,
    this.csfid,
    this.sekolah,
    this.username,
  });
  factory ReferralModel.fromJson(Map<String, dynamic> json) {
    return ReferralModel(
      nama: json['nama'],
      sekolah: json['instansi'],
      username: json['uname'],
      csfid: json['cfsessid'],
    );
  }
}

class ReferralDashboardModel {
  String? status;
  String? refid;
  String? link;
  String? sekolah;
  String? komisi;
  String? siswa;
  String? sudahregis;
  String? belumregis;
  String? siswareq;

  ReferralDashboardModel({
    this.belumregis,
    this.komisi,
    this.link,
    this.refid,
    this.sekolah,
    this.siswa,
    this.siswareq,
    this.status,
    this.sudahregis,
  });
  factory ReferralDashboardModel.fromJson(Map<String, dynamic> json) {
    return ReferralDashboardModel(
      belumregis: json['data_skl_reg'] ?? '0',
      komisi: json['data_komisi_sekolah'] ?? '0',
      link: json['data_link'] ?? '0',
      refid: json['affid'] ?? '0',
      sekolah: json['data_sekolah'] ?? '0',
      siswa: json['data_jum_sis'] ?? '0',
      siswareq: json['data_jum_sis_req'] ?? '0',
      status: json['status'] ?? '0',
      sudahregis: json['data_skl_reg'] ?? '0',
    );
  }
}

class ReferralSekolahAktifModel {
  String? namasekolah;

  ReferralSekolahAktifModel({this.namasekolah});
  factory ReferralSekolahAktifModel.fromJson(Map<String, dynamic> json) {
    return ReferralSekolahAktifModel(
      namasekolah: json['sekolah_regis'] ?? ''
    );
  }
}

class ReferralSekolahBelumAktifModel {
  String? namasekolah;

  ReferralSekolahBelumAktifModel({this.namasekolah});
  factory ReferralSekolahBelumAktifModel.fromJson(Map<String, dynamic> json) {
    return ReferralSekolahBelumAktifModel(
      namasekolah: json['sekolah_belum_registrasi'] ?? ''
    );
  }
}
