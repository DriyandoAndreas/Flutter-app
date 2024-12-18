///////////////////////////////////
///****Gac perpus model */
class PerpusModel {
  String? noInventaris;
  String? kodePegawai;
  String? nis;
  String? tgl;
  String? mode;
  String? kodePeminjam;
  String? namaPeminjam;
  String? shortCallNumber;
  String? judul;

  PerpusModel({
    this.noInventaris,
    this.kodePegawai,
    this.nis,
    this.tgl,
    this.mode,
    this.kodePeminjam,
    this.namaPeminjam,
    this.shortCallNumber,
    this.judul,
  });
  factory PerpusModel.fromJson(Map<String, dynamic> json) {
    return PerpusModel(
      noInventaris: json['no_inventaris'] ?? '',
      kodePegawai: json['kode_pegawai'] ?? '',
      nis: json['nis'] ?? '',
      tgl: json['tgl'] ?? '',
      mode: json['mode'] ?? '',
      kodePeminjam: json['kode_peminjam'] ?? '',
      namaPeminjam: json['nama_peminjam'] ?? '',
      shortCallNumber: json['short_call_number'] ?? '',
      judul: json['judul'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'no_inventaris': noInventaris,
      'kode_pegawai': kodePegawai,
      'nis': nis,
      'tgl': tgl,
      'mode': mode,
      'kode_peminjam': kodePeminjam,
      'nama_peminjam': namaPeminjam,
      'short_call_number': shortCallNumber,
      'judul': judul,
    };
  }
}

///////////////////////////////////
///****Sat perpus model */
class SatPerpusModel {
  String? noInventaris;
  String? callnumber;
  String? judul;
  String? tglpinjam;
  String? tglkembali;
  String? selesihtgl;

  SatPerpusModel({
   this.noInventaris,
   this.callnumber,
   this.judul,
   this.tglpinjam,
   this.tglkembali,
   this.selesihtgl,
  });
  factory SatPerpusModel.fromJson(Map<String, dynamic> json) {
    return SatPerpusModel(
      noInventaris: json['no_inventaris'] ?? '',
      callnumber: json['call_number'] ?? '',
      judul: json['judul'] ?? '',
      tglpinjam: json['tgl_pinjam'] ?? '',
      selesihtgl: json['int_selisih_tgl'] ?? '',
      tglkembali: json['tgl_kembali'] ?? '',
    );
  }
}
