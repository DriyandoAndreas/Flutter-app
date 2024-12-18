///********Gac komunikasi model */
class KomunikasiUmumModel {
  String? idUmum;
  String? nis;
  String? namaSiswa;
  String? mapel;
  String? tanggal;
  String? jmlKomen;
  String? bahasan;
  String? namaPembimbing;
  String? kodePegawai;
  String? tahunAjaran;
  String? semester;
  String? catatanKel;

  KomunikasiUmumModel({
    this.idUmum,
    this.nis,
    this.namaSiswa,
    this.mapel,
    this.tanggal,
    this.jmlKomen,
    this.bahasan,
    this.namaPembimbing,
    this.kodePegawai,
    this.tahunAjaran,
    this.semester,
    this.catatanKel,
  });

  factory KomunikasiUmumModel.fromJson(Map<String, dynamic> json) {
    return KomunikasiUmumModel(
      idUmum: json['id_umum'] ?? '',
      nis: json['nis'] ?? '',
      namaSiswa: json['nama_siswa'] ?? '',
      mapel: json['mapel'] ?? '',
      tanggal: json['tanggal'] ?? '',
      jmlKomen: json['jml_komen'] ?? '',
      bahasan: json['bahasan'] ?? '',
      namaPembimbing: json['nama_pembimbing'] ?? '',
      kodePegawai: json['kode_pegawai'] ?? '',
      tahunAjaran: json['thn_aj'] ?? '',
      semester: json['semester'] ?? '',
      catatanKel: json['catatan_kel'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id_umum': idUmum,
      'nis': nis,
      'nama_siswa': namaSiswa,
      'mapel': mapel,
      'tanggal': tanggal,
      'jml_komen': jmlKomen,
      'bahasan': bahasan,
      'nama_pembimbing': namaPembimbing,
      'kode_pegawai': kodePegawai,
      'thn_aj': tahunAjaran,
      'semester': semester,
      'catatan_kel': catatanKel,
    };
  }
}

class KomunikasiTahfidzModel {
  String? idTahfidz;
  String? tanggal;
  String? nis;
  String? namaSiswa;
  String? jenisHafalan;
  String? namaPembimbing;
  String? kodePegawai;
  String? catatan;

  KomunikasiTahfidzModel({
    this.idTahfidz,
    this.nis,
    this.tanggal,
    this.namaSiswa,
    this.jenisHafalan,
    this.namaPembimbing,
    this.kodePegawai,
    this.catatan,
  });

  factory KomunikasiTahfidzModel.fromJson(Map<String, dynamic> json) {
    return KomunikasiTahfidzModel(
      idTahfidz: json['id_tahfidz'] ?? '',
      nis: json['nis'] ?? '',
      namaSiswa: json['nama_siswa'] ?? '',
      jenisHafalan: json['jenis_hafalan'] ?? '',
      tanggal: json['tanggal'] ?? '',
      catatan: json['catatan'] ?? '',
      namaPembimbing: json['nama_pembimbing'] ?? '',
      kodePegawai: json['kode_pegawai'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id_tahfidz': idTahfidz,
      'nis': nis,
      'nama_siswa': namaSiswa,
      'jenis_hafalan': jenisHafalan,
      'tanggal': tanggal,
      'nama_pembimbing': namaPembimbing,
      'kode_pegawai': kodePegawai,
      'catatan': catatan,
    };
  }
}

class ListKomunikasiMapelModel {
  String? namaMapel;
  String? kodeMapel;

  ListKomunikasiMapelModel({
    this.namaMapel,
    this.kodeMapel,
  });
  factory ListKomunikasiMapelModel.fromJson(Map<String, dynamic> json) {
    return ListKomunikasiMapelModel(
      namaMapel: json['nama_pljrn'] ?? '',
      kodeMapel: json['kode_pljrn'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'nama_pljrn': namaMapel,
      'kode_pljrn': kodeMapel,
    };
  }
}

class ListKomunikasiEkskulModel {
  String? kodeEkskul;
  String? ekskul;

  ListKomunikasiEkskulModel({
    this.kodeEkskul,
    this.ekskul,
  });
  factory ListKomunikasiEkskulModel.fromJson(Map<String, dynamic> json) {
    return ListKomunikasiEkskulModel(
      kodeEkskul: json['kode_ekskul'] ?? '',
      ekskul: json['ekstrakurikuler'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'kode_ekskul': kodeEkskul,
      'ekstrakurikuler': ekskul,
    };
  }
}

class ListKomunikasiKelasModel {
  String? kodeKelas;
  String? namaKelas;

  ListKomunikasiKelasModel({
    this.kodeKelas,
    this.namaKelas,
  });
  factory ListKomunikasiKelasModel.fromJson(Map<String, dynamic> json) {
    return ListKomunikasiKelasModel(
      kodeKelas: json['kode_kelas'] ?? '',
      namaKelas: json['nama_kelas'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'kode_kelas': kodeKelas,
      'nama_kelas': namaKelas,
    };
  }
}

class ListKomunikasiKelompokModel {
  String? idKelompok;
  String? namaKelompok;

  ListKomunikasiKelompokModel({
    this.idKelompok,
    this.namaKelompok,
  });
  factory ListKomunikasiKelompokModel.fromJson(Map<String, dynamic> json) {
    return ListKomunikasiKelompokModel(
      idKelompok: json['id_kelompok'] ?? '',
      namaKelompok: json['nama_kelompok'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id_kelompok': idKelompok,
      'nama_kelompok': namaKelompok,
    };
  }
}

class ListKomunikasiSiswaModel {
  String? nis;
  String? namaSiswa;

  ListKomunikasiSiswaModel({
    this.nis,
    this.namaSiswa,
  });
  factory ListKomunikasiSiswaModel.fromJson(Map<String, dynamic> json) {
    return ListKomunikasiSiswaModel(
      nis: json['nis'] ?? '',
      namaSiswa: json['nama_lengkap'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'nis': nis,
      'nama_lengkap': namaSiswa,
    };
  }
}

class ListKomunikasiCommentModel {
  String? idKomen;
  String? tabel;
  String? idTabel;
  String? kodePegawai;
  String? nis;
  String? sebagai;
  String? komentar;
  String? tanggalWaktu;
  String? namaLengkap;

  ListKomunikasiCommentModel({
    this.idKomen,
    this.tabel,
    this.idTabel,
    this.kodePegawai,
    this.nis,
    this.sebagai,
    this.komentar,
    this.tanggalWaktu,
    this.namaLengkap,
  });
  factory ListKomunikasiCommentModel.fromJson(Map<String, dynamic> json) {
    return ListKomunikasiCommentModel(
      idKomen: json['id_comment'] ?? '',
      tabel: json['tabel'] ?? '',
      idTabel: json['id_tabel'] ?? '',
      kodePegawai: json['kode_pegawai'] ?? '',
      nis: json['nis'] ?? '',
      sebagai: json['sebagai'] ?? '',
      komentar: json['komentar'] ?? '',
      tanggalWaktu: json['datetime'] ?? '',
      namaLengkap: json['nama_lengkap'] ?? '',
    );
  }
}

class ViewKomunikasiTahfidzModel {
  String? idTahfidz;
  String? created;
  String? timestamp;
  String? thnAj;
  String? semester;
  String? jenis;
  String? nis;
  String? tanggal;
  String? jenisHafalan;
  String? metode;
  String? juz;
  String? surat;
  String? ayat;
  String? ayatTo;
  String? jumlah;
  String? nilai;
  String? catatan;
  String? catatanKel;
  String? kodePegawai;
  String? namaSiswa;
  String? namaPembimbing;
  String? jmlKomen;

  ViewKomunikasiTahfidzModel({
    this.ayat,
    this.ayatTo,
    this.catatan,
    this.catatanKel,
    this.created,
    this.idTahfidz,
    this.jenis,
    this.jenisHafalan,
    this.jmlKomen,
    this.jumlah,
    this.juz,
    this.kodePegawai,
    this.metode,
    this.namaPembimbing,
    this.namaSiswa,
    this.nilai,
    this.nis,
    this.semester,
    this.surat,
    this.tanggal,
    this.thnAj,
    this.timestamp,
  });
  factory ViewKomunikasiTahfidzModel.fromJson(Map<String, dynamic> json) {
    return ViewKomunikasiTahfidzModel(
      ayat: json['ayat'] ?? '',
      ayatTo: json['ayat_to'] ?? '',
      catatan: json['catatan'] ?? '',
      catatanKel: json['catatan_kel'] ?? '',
      created: json['created'] ?? '',
      idTahfidz: json['id_tahfidz'] ?? '',
      jenis: json['jenis'] ?? '',
      jenisHafalan: json['jenis_hafalan'] ?? '',
      jmlKomen: json['jml_komen'] ?? '',
      jumlah: json['jumlah'] ?? '',
      juz: json['juz'] ?? '',
      kodePegawai: json['kode_pegawai'] ?? '',
      metode: json['metode'] ?? '',
      namaPembimbing: json['nama_pembimbing'] ?? '',
      namaSiswa: json['nama_siswa'] ?? '',
      nilai: json['nilai'] ?? '',
      nis: json['nis'] ?? '',
      semester: json['semester'] ?? '',
      surat: json['surat'] ?? '',
      tanggal: json['tanggal'] ?? '',
      thnAj: json['thn_aj'] ?? '',
      timestamp: json['timestamp'] ?? '',
    );
  }
}

//////////////////////////////////
///**********Sat komunikasi model */
class SatKomunikasiModel {
  String? tanggal;
  String? nis;
  String? namasiswa;
  String? mapel;
  String? bahasan;
  String? namapembimbing;
  String? idumum;

  SatKomunikasiModel({
    this.tanggal,
    this.nis,
    this.namasiswa,
    this.mapel,
    this.bahasan,
    this.namapembimbing,
    this.idumum,
  });

  factory SatKomunikasiModel.fromJson(Map<String, dynamic> json) {
    return SatKomunikasiModel(
      tanggal: json['tanggal'] ?? '',
      nis: json['nis'] ?? '',
      namasiswa: json['nama_siswa'] ?? '',
      mapel: json['mapel'] ?? '',
      bahasan: json['bahasan'] ?? '',
      namapembimbing: json['nama_pembimbing'] ?? '',
      idumum: json['id_umum'] ?? '',
    );
  }
}

class SatKomunikasiTahfidzModel {
  String? tanggal;
  String? nis;
  String? namasiswa;
  String? jenishafalan;
  String? catatan;
  String? namapembimbing;
  String? idtahfidz;

  SatKomunikasiTahfidzModel({
    this.tanggal,
    this.nis,
    this.namasiswa,
    this.jenishafalan,
    this.catatan,
    this.namapembimbing,
    this.idtahfidz,
  });

  factory SatKomunikasiTahfidzModel.fromJson(Map<String, dynamic> json) {
    return SatKomunikasiTahfidzModel(
      tanggal: json['tanggal'] ?? '',
      nis: json['nis'] ?? '',
      namasiswa: json['nama_siswa'] ?? '',
      jenishafalan: json['jenis_hafalan'] ?? '',
      catatan: json['catatan'] ?? '',
      namapembimbing: json['nama_pembimbing'] ?? '',
      idtahfidz: json['id_tahfidz'] ?? '',
    );
  }
}

//model view komunikasi umum
class ViewKomunikasiUmumModel {
  String? idumum;
  String? semester;
  String? tahunajaran;
  String? namapelajaran;
  String? namapembimbing;
  String? bahasan;
  String? catatankelompok;

  ViewKomunikasiUmumModel({
    this.idumum,
    this.semester,
    this.tahunajaran,
    this.namapelajaran,
    this.namapembimbing,
    this.bahasan,
    this.catatankelompok,
  });

  factory ViewKomunikasiUmumModel.fromJson(Map<String, dynamic> json) {
    return ViewKomunikasiUmumModel(
      idumum: json['id_umum'] ?? '',
      semester: json['semester'] ?? '',
      tahunajaran: json['thn_aj'] ?? '',
      bahasan: json['bahasan'] ?? '',
      namapembimbing: json['nama_pembimbing'] ?? '',
      namapelajaran: json['nama_pljrn'] ?? '',
      catatankelompok: json['catatan_kel'] ?? '',
    );
  }
}

//view tahfidz model
class SatViewKomunikasiTahfidzModel {
  String? idumum;
  String? semester;
  String? tahunajaran;
  String? jenishafalan;
  String? namapembimbing;
  String? juz;
  String? surat;
  String? ayat;
  String? catatan;
  String? metode;
  String? ayato;

  SatViewKomunikasiTahfidzModel({
    this.idumum,
    this.semester,
    this.tahunajaran,
    this.jenishafalan,
    this.namapembimbing,
    this.juz,
    this.catatan,
    this.ayat,
    this.surat,
    this.metode,
    this.ayato,
  });

  factory SatViewKomunikasiTahfidzModel.fromJson(Map<String, dynamic> json) {
    return SatViewKomunikasiTahfidzModel(
      idumum: json['id_umum'] ?? '',
      semester: json['semester'] ?? '',
      tahunajaran: json['thn_aj'] ?? '',
      juz: json['juz'] ?? '',
      namapembimbing: json['nama_pembimbing'] ?? '',
      jenishafalan: json['jenis_hafalan'] ?? '',
      catatan: json['catatan'] ?? '',
      surat: json['surat'] ?? '',
      ayat: json['ayat'] ?? '',
      metode: json['metode'] ?? '',
      ayato: json['ayat_to'] ?? '',
    );
  }
}

//comment model
class SatKomentarModel {
  String? namalengkap;
  String? komentar;
  String? tanggal;

  SatKomentarModel({this.namalengkap, this.komentar, this.tanggal});
  factory SatKomentarModel.fromJson(Map<String, dynamic> json) {
    return SatKomentarModel(
      namalengkap: json['nama_lengkap'] ?? '',
      komentar: json['komentar'] ?? '',
      tanggal: json['datetime'] ?? '',
    );
  }
}
