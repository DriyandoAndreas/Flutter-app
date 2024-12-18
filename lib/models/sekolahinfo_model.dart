class SekolahInfoTop {
  String? npsn;
  String? sekolah;
  String? bentuk;
  String? waktukbm;
  String? akreditasi;
  String? rate;
  String? reviewer;
  String? status;

  SekolahInfoTop(
      {this.akreditasi,
      this.bentuk,
      this.npsn,
      this.rate,
      this.reviewer,
      this.sekolah,
      this.waktukbm,
      this.status});
  factory SekolahInfoTop.fromJson(Map<String, dynamic> json) {
    return SekolahInfoTop(
      npsn: json['npsn'] ?? '',
      sekolah: json['sekolah'] ?? '',
      bentuk: json['bentuk'] ?? '',
      waktukbm: json['waktu_kbm'] ?? '',
      akreditasi: json['akreditasi'] ?? '',
      rate: json['rate'] ?? '0',
      reviewer: json['reviewer'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
