class SchoolRatingModel {
  String? keterangan;
  SchoolRatingDataModel? data;
  SchoolRatingReviewModel? review;
  SchoolRatingModel({
    this.data,
    this.keterangan,
    this.review,
  });

  factory SchoolRatingModel.fromJson(Map<String, dynamic> json) {
    return SchoolRatingModel(
        data: SchoolRatingDataModel.fromJson(json['data']),
        keterangan: json['keterangan'] ?? '',
        review: SchoolRatingReviewModel.fromJson(json['reviewed']));
  }
}

class SchoolRatingDataModel {
  String? rate;
  String? komentar;
  String? reviewer;

  SchoolRatingDataModel({
    this.komentar,
    this.rate,
    this.reviewer,
  });

  factory SchoolRatingDataModel.fromJson(Map<String, dynamic> json) {
    return SchoolRatingDataModel(
      komentar: json['komentar'] ?? '',
      rate: json['rate'] ?? '',
      reviewer: json['reviewer'] ?? '',
    );
  }
}

class SchoolRatingReviewModel {
  String? fasilitas;
  String? pelayanan;
  String? lokasi;
  String? kondisibangunan;
  String? pengajaran;
  String? komentar;

  SchoolRatingReviewModel({
    this.fasilitas,
    this.komentar,
    this.kondisibangunan,
    this.lokasi,
    this.pelayanan,
    this.pengajaran,
  });
  factory SchoolRatingReviewModel.fromJson(Map<String, dynamic> json) {
    return SchoolRatingReviewModel(
      fasilitas: json['fasilitas'] ?? '',
      pelayanan: json['pelayanan'] ?? '',
      lokasi: json['lokasi'] ?? '',
      kondisibangunan: json['kondisi_bangunan'] ?? '',
      pengajaran: json['pengajaran'] ?? '',
      komentar: json['komentar'] ?? '',
    );
  }
}

class SchoolReviewerModel {
  String? nama;
  String? komentar;
  String? tanggal;
  String? skor;

  SchoolReviewerModel({
    this.nama,
    this.komentar,
    this.skor,
    this.tanggal,
  });

  factory SchoolReviewerModel.fromJson(Map<String, dynamic> json) {
    return SchoolReviewerModel(
      nama: json['nama'] ?? '',
      tanggal: json['datetime'] ?? '',
      komentar: json['komentar'] ?? '',
      skor: json['skor'] ?? '',
    );
  }
}
