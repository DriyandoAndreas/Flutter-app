class SqliteUserModel {
  String? iduser;
  String? username;
  String? password;
  String? nomor;
  String? nomorsc;
  String? position;
  String? cpos;
  String? photopp;
  String? nama;
  String? kelamin;
  String? email;
  String? joinsisko;
  String? lastlogin;
  String? siskonpsn;
  String? siskoid;
  String? siskokode;
  String? siskostatuslogin;
  String? verified;
  String? active;
  String? activekey;
  String? uploadphoto;
  String? photodefault;
  String? photodefaultthumb;
  String? photo;
  String? photothumb;
  String? ip;
  String? token;
  String? tokenss;
  String? tokenpp;
  String? siskoHakAkses;
  int? islogin;
  String? hp;
  String? tanggallahir;
  String? namalengkap;
  String? kelas;

  SqliteUserModel({
    this.iduser,
    this.username,
    this.password,
    this.nomor,
    this.nomorsc,
    this.position,
    this.cpos,
    this.photopp,
    this.nama,
    this.kelamin,
    this.email,
    this.joinsisko,
    this.lastlogin,
    this.siskonpsn,
    this.siskoid,
    this.siskokode,
    this.siskoHakAkses,
    this.siskostatuslogin,
    this.verified,
    this.active,
    this.activekey,
    this.uploadphoto,
    this.photodefault,
    this.photodefaultthumb,
    this.photo,
    this.photothumb,
    this.ip,
    this.token,
    this.tokenpp,
    this.tokenss,
    this.islogin,
    this.hp,
    this.tanggallahir,
    this.namalengkap,
    this.kelas,
  });
  Map<String, Object?> toMap() {
    return {
      'id_user': iduser,
      'user_name': username,
      'password': password,
      'nomor': nomor,
      'nomor_sc': nomorsc,
      'position': position,
      'cpos': cpos,
      'nama': nama,
      'kelamin': kelamin,
      'email': email,
      'photopp': photopp,
      'join_sisko': joinsisko,
      'last_login': lastlogin,
      'sisko_npsn': siskonpsn,
      'sisko_id': siskoid,
      'sisko_kode': siskokode,
      'sisko_kode_hakakses': siskoHakAkses,
      'sisko_status_login': siskostatuslogin,
      'verified': verified,
      'active': active,
      'active_key': activekey,
      'upload_photo': uploadphoto,
      'photo_default': photodefault,
      'photo_default_thumb': photodefaultthumb,
      'photo': photo,
      'photo_thumb': photothumb,
      'ip': ip,
      'token': token,
      'tokenss': token,
      'tokenpp': tokenpp,
      'islogin': islogin,
      'hp': hp,
      'tgl_lahir': tanggallahir,
      'nama_lengkap': namalengkap,
      'kelas' : kelas,
    };
  }
}
