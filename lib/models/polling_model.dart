///****Gac model polling */
class ListPollingModel {
  String? kodepolling;
  String? namapolling;
  String? tanggalmulai;
  String? tanggalselesai;
  String? pertanyaan;
  String? kodepollpeserta;
  String? peserta;

  ListPollingModel({
    this.kodepolling,
    this.kodepollpeserta,
    this.namapolling,
    this.pertanyaan,
    this.peserta,
    this.tanggalmulai,
    this.tanggalselesai,
  });
  factory ListPollingModel.fromJson(Map<String, dynamic> json) {
    return ListPollingModel(
      kodepolling: json['kd_polling'] ?? '',
      namapolling: json['nama_polling'] ?? '',
      tanggalmulai: json['tgl_mulai'] ?? '',
      tanggalselesai: json['tgl_selesai'] ?? '',
      pertanyaan: json['pertanyaan'] ?? '',
      kodepollpeserta: json['kd_pol_peserta'] ?? '',
      peserta: json['peserta'] ?? '',
    );
  }
}

class ViewPollingModel {
  String? kodepolling;
  String? namapolling;
  String? tanggalmulai;
  String? tanggalselesai;
  String? pertanyaan;
  String? kodepollpeserta;
  String? peserta;
  ViewTerpilihModel? viewTerpilihModel;

  ViewPollingModel({
    this.kodepolling,
    this.kodepollpeserta,
    this.namapolling,
    this.pertanyaan,
    this.peserta,
    this.tanggalmulai,
    this.tanggalselesai,
    this.viewTerpilihModel,
  });
  factory ViewPollingModel.fromJson(Map<String, dynamic> json) {
    return ViewPollingModel(
      kodepolling: json['kd_polling'] ?? '',
      kodepollpeserta: json['kd_pol_peserta'] ?? '',
      namapolling: json['nama_polling'] ?? '',
      pertanyaan: json['pertanyaan'] ?? '',
      peserta: json['peserta'] ?? '',
      tanggalmulai: json['tgl_mulai'] ?? '',
      tanggalselesai: json['tgl_selesai'] ?? '',
      viewTerpilihModel: json['terpilih'] is bool
          ? json['']
          : ViewTerpilihModel.fromJson(json['terpilih']),
    );
  }
}

//model terpilih
class ViewTerpilihModel {
  String? kdpolling;
  String? kdpollpeserta;
  String? kdjawaban;
  String? idpeserta;

  ViewTerpilihModel(
      {this.idpeserta, this.kdjawaban, this.kdpolling, this.kdpollpeserta});
  factory ViewTerpilihModel.fromJson(Map<dynamic, dynamic> json) {
    return ViewTerpilihModel(
      kdpolling: json['kd_polling'] ?? '',
      kdpollpeserta: json['kd_pol_peserta'] ?? '',
      kdjawaban: json['kd_jawaban'] ?? '',
      idpeserta: json['id_peserta'] ?? '',
    );
  }
}

class ViewPollingJawabanModel {
  String? kdjawaban;
  String? kdpolling;
  String? jawaban;

  ViewPollingJawabanModel({this.kdjawaban, this.kdpolling, this.jawaban});
  factory ViewPollingJawabanModel.fromJson(Map<String, dynamic> json) {
    return ViewPollingJawabanModel(
      kdjawaban: json['kd_jawaban'] ?? '',
      kdpolling: json['kd_polling'] ?? '',
      jawaban: json['jawaban'] ?? '',
    );
  }
}

class PollingPosertaModel {
  Map<String, dynamic>? data;
  PollingPosertaModel({this.data});
  factory PollingPosertaModel.fromJson(Map<String, dynamic> json) {
    return PollingPosertaModel(
      data: Map<String, dynamic>.from(json),
    );
  }
}

///////////////////////////////////////////////////
///*****Sat polling jawaban */
class SatListPollingModel {
  //model list polling
  String? kodepolling;
  String? namapolling;
  String? tanggalmulai;
  String? tanggalselesai;
  String? pertanyaan;
  String? kodepollpeserta;
  String? peserta;

  SatListPollingModel({
    this.kodepolling,
    this.kodepollpeserta,
    this.namapolling,
    this.pertanyaan,
    this.peserta,
    this.tanggalmulai,
    this.tanggalselesai,
  });
  factory SatListPollingModel.fromJson(Map<String, dynamic> json) {
    return SatListPollingModel(
      kodepolling: json['kd_polling'] ?? '',
      namapolling: json['nama_polling'] ?? '',
      tanggalmulai: json['tgl_mulai'] ?? '',
      tanggalselesai: json['tgl_selesai'] ?? '',
      pertanyaan: json['pertanyaan'] ?? '',
      kodepollpeserta: json['kd_pol_peserta'] ?? '',
      peserta: json['peserta'] ?? '',
    );
  }
}

//model pollin view
class SatViewPollingModel {
  String? kodepolling;
  String? namapolling;
  String? tanggalmulai;
  String? tanggalselesai;
  String? pertanyaan;
  String? kodepollpeserta;
  String? peserta;
  SatViewTerpilihModel? satViewTerpilihModel;

  SatViewPollingModel(
      {this.kodepolling,
      this.kodepollpeserta,
      this.namapolling,
      this.pertanyaan,
      this.peserta,
      this.tanggalmulai,
      this.tanggalselesai,
      this.satViewTerpilihModel});
  factory SatViewPollingModel.fromJson(Map<String, dynamic> json) {
    return SatViewPollingModel(
        kodepolling: json['kd_polling'] ?? '',
        kodepollpeserta: json['kd_pol_peserta'] ?? '',
        namapolling: json['nama_polling'] ?? '',
        pertanyaan: json['pertanyaan'] ?? '',
        peserta: json['pserta'] ?? '',
        tanggalmulai: json['tgl_mulai'] ?? '',
        tanggalselesai: json['tgl_selesai'] ?? '',
        satViewTerpilihModel: SatViewTerpilihModel.fromJson(
          json['terpilih'],
        ));
  }
}

//model terpilih
class SatViewTerpilihModel {
  String? kdpolling;
  String? kdpollpeserta;
  String? kdjawaban;
  String? idpeserta;

  SatViewTerpilihModel(
      {this.idpeserta, this.kdjawaban, this.kdpolling, this.kdpollpeserta});
  factory SatViewTerpilihModel.fromJson(Map<dynamic, dynamic> json) {
    return SatViewTerpilihModel(
      kdpolling: json['kd_polling'] ?? '',
      kdpollpeserta: json['kd_pol_peserta'] ?? '',
      kdjawaban: json['kd_jawaban'] ?? '',
      idpeserta: json['id_peserta'] ?? '',
    );
  }
}

//view polling model
class SatViewPollingJawabanModel {
  String? kdjawaban;
  String? kdpolling;
  String? jawaban;

  SatViewPollingJawabanModel({this.kdjawaban, this.kdpolling, this.jawaban});
  factory SatViewPollingJawabanModel.fromJson(Map<String, dynamic> json) {
    return SatViewPollingJawabanModel(
      kdjawaban: json['kd_jawaban']?? '',
      kdpolling: json['kd_polling']?? '',
      jawaban: json['jawaban']?? '',
    );
  }
}
