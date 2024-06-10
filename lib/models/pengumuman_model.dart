class PengumumanModel {
  String? kode;
  String? tgl;
  String? judul;
  String? isi;
  String? untuk;
  String? terbaca;
  String? pembuat;
  String? penginput;
  List<String>? images;
  String? image;
  String? post;
  PengumumanModel(
      {this.kode,
      this.tgl,
      this.judul,
      this.isi,
      this.untuk,
      this.terbaca,
      this.pembuat,
      this.penginput,
      this.images,
      this.image,
      this.post});

  factory PengumumanModel.fromJson(Map<String, dynamic> json) {
    String cleanString(String input) {
      final RegExp pattern = RegExp('[\'\\"\\\\/]');
      return input.replaceAll(pattern, '');
    }

    return PengumumanModel(
      kode: json['kode'],
      tgl: json['tgl'],
      judul: cleanString(json['judul']),
      isi: json['isi'],
      untuk: json['untuk'],
      terbaca: json['terbaca'],
      pembuat: json['pembuat'],
      penginput: json['penginput'],
      images: List<String>.from(json['images']),
      image: json['image'],
      post: cleanString(json['post']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'kode': kode,
      'tgl': tgl,
      'isi': isi,
      'untuk': untuk,
      'terbaca': terbaca,
      'pembuat': pembuat,
      'penginput': penginput,
      'images': images,
      'image': image,
      'post': post,
    };
  }
}
