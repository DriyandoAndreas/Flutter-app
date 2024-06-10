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
    required this.idUmum,
    required this.nis,
    required this.namaSiswa,
    required this.mapel,
    required this.tanggal,
    required this.jmlKomen,
    required this.bahasan,
    required this.namaPembimbing,
    required this.kodePegawai,
    required this.tahunAjaran,
    required this.semester,
    required this.catatanKel,
  });

  factory KomunikasiUmumModel.fromJson(Map<String, dynamic> json) {
    return KomunikasiUmumModel(
      idUmum: json['id_umum'],
      nis: json['nis'],
      namaSiswa: json['nama_siswa'],
      mapel: json['mapel'],
      tanggal: json['tanggal'],
      jmlKomen: json['jml_komen'],
      bahasan: json['bahasan'],
      namaPembimbing: json['nama_pembimbing'],
      kodePegawai: json['kode_pegawai'],
      tahunAjaran: json['thn_aj'],
      semester: json['semester'],
      catatanKel: json['catatan_kel'],
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
    required this.idTahfidz,
    required this.nis,
    required this.tanggal,
    required this.namaSiswa,
    required this.jenisHafalan,
    required this.namaPembimbing,
    required this.kodePegawai,
    required this.catatan,
  });

  factory KomunikasiTahfidzModel.fromJson(Map<String, dynamic> json) {
    return KomunikasiTahfidzModel(
      idTahfidz: json['id_tahfidz'],
      nis: json['nis'],
      namaSiswa: json['nama_siswa'],
      jenisHafalan: json['jenis_hafalan'],
      tanggal: json['tanggal'],
      catatan: json['catatan'],
      namaPembimbing: json['nama_pembimbing'],
      kodePegawai: json['kode_pegawai'],
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
    required this.namaMapel,
    required this.kodeMapel,
  });
  factory ListKomunikasiMapelModel.fromJson(Map<String, dynamic> json) {
    return ListKomunikasiMapelModel(
      namaMapel: json['nama_pljrn'],
      kodeMapel: json['kode_pljrn'],
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
    required this.kodeEkskul,
    required this.ekskul,
  });
  factory ListKomunikasiEkskulModel.fromJson(Map<String, dynamic> json) {
    return ListKomunikasiEkskulModel(
      kodeEkskul: json['kode_ekskul'],
      ekskul: json['ekstrakurikuler'],
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
    required this.kodeKelas,
    required this.namaKelas,
  });
  factory ListKomunikasiKelasModel.fromJson(Map<String, dynamic> json) {
    return ListKomunikasiKelasModel(
      kodeKelas: json['kode_kelas'],
      namaKelas: json['nama_kelas'],
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
    required this.idKelompok,
    required this.namaKelompok,
  });
  factory ListKomunikasiKelompokModel.fromJson(Map<String, dynamic> json) {
    return ListKomunikasiKelompokModel(
      idKelompok: json['id_kelompok'],
      namaKelompok: json['nama_kelompok'],
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
    required this.nis,
    required this.namaSiswa,
  });
  factory ListKomunikasiSiswaModel.fromJson(Map<String, dynamic> json) {
    return ListKomunikasiSiswaModel(
      nis: json['nis'],
      namaSiswa: json['nama_lengkap'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'nis': nis,
      'nama_lengkap': namaSiswa,
    };
  }
}
