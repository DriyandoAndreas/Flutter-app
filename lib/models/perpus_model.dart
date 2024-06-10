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
    required this.noInventaris,
    required this.kodePegawai,
    required this.nis,
    required this.tgl,
    required this.mode,
    required this.kodePeminjam,
    required this.namaPeminjam,
    required this.shortCallNumber,
    required this.judul,
  });
  factory PerpusModel.fromJson(Map<String, dynamic> json) {
    return PerpusModel(
     noInventaris: json['no_inventaris'],
     kodePegawai: json['kode_pegawai'],
     nis: json['nis'],
     tgl: json['tgl'],
     mode: json['mode'],
     kodePeminjam: json['kode_peminjam'],
     namaPeminjam: json['nama_peminjam'],
     shortCallNumber: json['short_call_number'],
     judul: json['judul'],
    );
    
  }
  Map<String, dynamic> toJson() {
    return {
     'no_inventaris' : noInventaris,
     'kode_pegawai' : kodePegawai,
     'nis' : nis,
     'tgl' : tgl,
     'mode' : mode,
     'kode_peminjam' : kodePeminjam,
     'nama_peminjam' : namaPeminjam,
     'short_call_number' : shortCallNumber,
     'judul' : judul,
    };
  }
}
