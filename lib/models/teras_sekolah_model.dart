class TerasSekolahModel {
  String? kode;
  String? tgl;
  String? tglKadaluarsa;
  String? judul;
  String? isi;
  String? untuk;
  String? terbaca;
  String? pembuat;
  String? penginput;
  List<String>? images;
  String? image;
  String? post;

  TerasSekolahModel(
      {this.kode,
      this.tglKadaluarsa,
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

  factory TerasSekolahModel.fromJson(Map<String, dynamic> json) {
    return TerasSekolahModel(
      kode: json['kode'] ?? '',
      tgl: json['tgl'] ?? '',
      tglKadaluarsa: json['tgl_kadaluarsa'] ?? '',
      judul: json['judul'] ?? '',
      isi: json['isi'] ?? '',
      untuk: json['untuk'] ?? '',
      terbaca: json['terbaca'] ?? '',
      pembuat: json['pembuat'] ?? '',
      penginput: json['penginput'] ?? '',
      images: List<String>.from(json['images']),
      image: json['image'] ?? '',
      post: json['post'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kode': kode,
      'tgl': tgl,
      'tgl_kadaluarsa': tglKadaluarsa,
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
