class InfoModel {
  String? iduser;
  String? username;
  String? password;
  String? nomorsc;
  String? position;
  String? cpos;
  String? photopp;
  String? nama;
  String? kelamin;
  String? email;
  String? join;
  String? lastlogin;
  String? siskonpsn;
  String? siskoid;
  String? siskokode;
  String? siskostatuslogin;
  String? verified;
  String? active;
  String? activekey;
  bool? uploadphoto;
  String? photo;
  String? photothumb;
  PhotoPP? photoPP;
  String? ip;

  InfoModel({
    this.iduser,
    this.username,
    this.password,
    this.nomorsc,
    this.position,
    this.cpos,
    this.photopp,
    this.nama,
    this.kelamin,
    this.email,
    this.join,
    this.lastlogin,
    this.siskonpsn,
    this.siskoid,
    this.siskokode,
    this.siskostatuslogin,
    this.verified,
    this.active,
    this.activekey,
    this.uploadphoto,
    this.photo,
    this.photothumb,
    this.photoPP,
    this.ip,
  });

  InfoModel.fromJson(Map<String, dynamic> json) {
    InfoModel(
      iduser: json['id_user'],
      username: json['username'],
      password: json['password'],
      nomorsc: json['nomor_sc'],
      position: json['position'],
      cpos: json['cpos'],
      photopp: json['photopp'],
      nama: json['nama'],
      kelamin: json['kelamin'],
      email: json['email'],
      join: json['join'],
      lastlogin: json['last_login'],
      siskonpsn: json['sisko_npsn'],
      siskoid: json['sisko_id'],
      siskokode: json['sisko_kode'],
      siskostatuslogin: json['sisko_status_login'],
      verified: json['verified'],
      active: json['active'],
      activekey: json['active_key'],
      uploadphoto: json['upload_photo'],
      photo: json['photo'],
      photothumb: json['photo_thumb'],
      photoPP: PhotoPP.fromJson(json['photo_pp']),
      ip: json['ip'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id_user': iduser,
      'username': username,
      'password': password,
      'nomor_sc': nomorsc,
      'position': position,
      'cpos': cpos,
      'photopp': photopp,
      'nama': nama,
      'kelamin': kelamin,
      'email': email,
      'join': join,
      'last_login': lastlogin,
      'sisko_npsn': siskonpsn,
      'sisko_id': siskoid,
      'sisko_kode': siskokode,
      'sisko_status_login': siskostatuslogin,
      'verified': verified,
      'active': active,
      'active_key': activekey,
      'upload_photo': uploadphoto,
      'photo': photo,
      'photo_thumb': photothumb,
      'photo_pp': photoPP?.toJson(),
      'ip': ip,
    };
  }
}

class PhotoPP {
  String? photodefault;
  String? photodefaultthumb;

  PhotoPP({
    this.photodefault,
    this.photodefaultthumb,
  });
  PhotoPP.fromJson(Map<String, dynamic> json) {
    PhotoPP(
      photodefault: json['photo_default'],
      photodefaultthumb: json['photo_default_thumb'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'photo_default': photodefault,
      'photo_default_thumb': photodefaultthumb,
    };
  }
}
