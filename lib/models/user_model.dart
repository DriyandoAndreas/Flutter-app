class UserModel {
  String? idUser;
  String? nomor;
  String? username;
  String? password;
  String? nomorSc;
  String? position;
  String? cpos;
  String? photopp;
  String? nama;
  String? kelamin;
  String? email;
  String? join;
  String? lastLogin;
  String? siskoNpsn;
  String? siskoId;
  String? siskoKode;
  String? siskoStatusLogin;
  String? siskoSiteName;
  String? verified;
  String? activate;
  String? jsonReturn;
  String? aktif;
  String? publish;
  String? dec;
  String? hex;
  String? encrypted;
  String? pwd;
  String? pwdChanged;
  String? cpwd;
  String? pin;
  String? cpin;
  String? pinHide;
  dynamic parent;
  String? time;
  String? timestamp;
  String? reqId;
  String? cuid;
  String? cuname;
  String? cmerchant;
  String? emailUser;
  String? hp;
  String? isOrtu;
  String? npsn;
  String? id;
  String? kode;
  String? statusLogin;
  String? jkelamin;
  String? datetimeReg;
  String? tglLahir;
  String? alamat;
  String? idKota;
  String? kodePos;
  String? telp;
  String? idSekolah;
  String? kelas;
  String? noInduk;
  String? web;
  ImgUrl? imgUrl;
  bool? siskodomainssl;
  bool? siskodomainpmt;
  String? siskodomain;
  bool? siskoclaim;
  String? siskosite;
  String? siskoentity;
  String? siskojjg;
  String? siskoversi;
  bool? siskoexpired;
  String? siskotgllahir;
  String? siskonamalengkap;
  String? siskohakakses;
  String? ip;
  String? token;
  String? tokenss;
  String? tokenpp;
  String? sscode;
  String? sstoken;

  UserModel({
    this.idUser,
    this.nomor,
    this.username,
    this.password,
    this.nomorSc,
    this.position,
    this.cpos,
    this.photopp,
    this.nama,
    this.kelamin,
    this.email,
    this.join,
    this.lastLogin,
    this.siskoNpsn,
    this.siskoId,
    this.siskoKode,
    this.siskoStatusLogin,
    this.siskoSiteName,
    this.verified,
    this.activate,
    this.jsonReturn,
    this.aktif,
    this.publish,
    this.dec,
    this.hex,
    this.encrypted,
    this.pwd,
    this.pwdChanged,
    this.cpwd,
    this.pin,
    this.cpin,
    this.pinHide,
    this.parent,
    this.time,
    this.timestamp,
    this.reqId,
    this.cuid,
    this.cuname,
    this.cmerchant,
    this.emailUser,
    this.hp,
    this.isOrtu,
    this.npsn,
    this.id,
    this.kode,
    this.statusLogin,
    this.jkelamin,
    this.datetimeReg,
    this.sscode,
    this.sstoken,
    this.tglLahir,
    this.alamat,
    this.idKota,
    this.kodePos,
    this.telp,
    this.idSekolah,
    this.kelas,
    this.noInduk,
    this.web,
    this.imgUrl,
    this.siskodomainssl,
    this.siskodomainpmt,
    this.siskodomain,
    this.siskoclaim,
    this.siskosite,
    this.siskoentity,
    this.siskojjg,
    this.siskoversi,
    this.siskoexpired,
    this.siskotgllahir,
    this.siskonamalengkap,
    this.siskohakakses,
    this.ip,
    this.token,
    this.tokenss,
    this.tokenpp,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    UserModel(
      idUser: json['id_user'],
      nomor: json['nomor'],
      username: json['username'],
      password: json['password'],
      nomorSc: json['nomor_sc'],
      position: json['position'],
      cpos: json['cpos'],
      photopp: json['photopp'],
      nama: json['nama'],
      kelamin: json['kelamin'],
      email: json['email'],
      join: json['join'],
      lastLogin: json['last_login'],
      siskoNpsn: json['sisko_npsn'],
      siskoId: json['sisko_id'],
      siskoKode: json['sisko_kode'],
      siskoStatusLogin: json['sisko_status_login'],
      siskoSiteName: json['sisko_site_name'],
      verified: json['verified'],
      activate: json['activate'],
      jsonReturn: json['json_return'],
      aktif: json['aktif'],
      publish: json['publish'],
      dec: json['dec'],
      hex: json['hex'],
      encrypted: json['encrypted'],
      pwd: json['pwd'],
      pwdChanged: json['pwd_changed'],
      cpwd: json['cpwd'],
      pin: json['pin'],
      cpin: json['cpin'],
      pinHide: json['pin_hide'],
      parent: json['parent'],
      time: json['time'],
      timestamp: json['timestamp'],
      reqId: json['req_id'],
      cuid: json['cuid'],
      cuname: json['cuname'],
      cmerchant: json['cmerchant'],
      emailUser: json['email_user'],
      hp: json['hp'],
      isOrtu: json['is_ortu'],
      npsn: json['npsn'],
      id: json['id'],
      kode: json['kode'],
      statusLogin: json['status_login'],
      jkelamin: json['jkelamin'],
      datetimeReg: json['datetime_reg'],
      sscode: json['sscode'],
      sstoken: json['sstoken'],
      tglLahir: json['tgl_lahir'],
      alamat: json['alamat'],
      idKota: json['id_kota'],
      kodePos: json['kode_pos'],
      telp: json['telp'],
      idSekolah: json['id_sekolah'],
      kelas: json['kelas'],
      noInduk: json['no_induk'],
      web: json['web'],
      imgUrl: ImgUrl.fromJson(json['img_url']),
      siskodomainssl: json['sisko_domain_ssl'],
      siskodomainpmt: json['sisko_domain_pmt'],
      siskodomain: json['sisko_dimain'],
      siskoclaim: json['sisko_klaim'],
      siskosite: json['sisko_site'],
      siskoentity: json['sisko_entity'],
      siskojjg: json['sisko_jjg'],
      siskoversi: json['sisko_versi'],
      siskoexpired: json['siski_expired'],
      siskotgllahir: json['sisko_tgl_lhr'],
      siskonamalengkap: json['sisko_nama_lengkap'],
      siskohakakses: json['sisko_kode_hakakses'],
      ip: json['ip'],
      token: json['token'],
      tokenss: json['tokenss'],
      tokenpp: json['tokenpp'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id_user': idUser,
      'nomor': nomor,
      'username': username,
      'password': password,
      'nomor_sc': nomorSc,
      'position': position,
      'cpos': cpos,
      'photopp': photopp,
      'nama': nama,
      'kelamin': kelamin,
      'email': email,
      'join': join,
      'last_login': lastLogin,
      'sisko_npsn': siskoNpsn,
      'sisko_id': siskoId,
      'sisko_kode': siskoKode,
      'sisko_status_login': siskoStatusLogin,
      'sisko_site_name': siskoSiteName,
      'verified': verified,
      'activate': activate,
      'json_return': jsonReturn,
      'aktif': aktif,
      'publish': publish,
      'dec': dec,
      'hex': hex,
      'encrypted': encrypted,
      'pwd': pwd,
      'pwd_changed': pwdChanged,
      'cpwd': cpwd,
      'pin': pin,
      'cpin': cpin,
      'pin_hide': pinHide,
      'parent': parent,
      'time': time,
      'timestamp': timestamp,
      'req_id': reqId,
      'cuid': cuid,
      'cuname': cuname,
      'cmerchant': cmerchant,
      'email_user': emailUser,
      'hp': hp,
      'is_ortu': isOrtu,
      'npsn': npsn,
      'id': id,
      'kode': kode,
      'status_login': statusLogin,
      'jkelamin': jkelamin,
      'datetime_reg': datetimeReg,
      'tgl_lahir': tglLahir,
      'alamat': alamat,
      'id_kota': idKota,
      'kode_pos': kodePos,
      'telp': telp,
      'id_sekolah': idSekolah,
      'kelas': kelas,
      'no_induk': noInduk,
      'web': web,
      'img_url': imgUrl?.toJson(),
      'sisko_domain_ssl': siskodomainssl,
      'sisko_domain_pmt': siskodomainpmt,
      'sisko_dimain': siskodomain,
      'sisko_klaim': siskoclaim,
      'sisko_site': siskosite,
      'sisko_entity': siskoentity,
      'sisko_jjg': siskojjg,
      'sisko_versi': siskoversi,
      'siski_expired': siskoexpired,
      'sisko_tgl_lhr': siskotgllahir,
      'sisko_nama_lengkap': siskonamalengkap,
      'sisko_kode_hakakses': siskohakakses,
      'ip': ip,
      'token': token,
      'tokenss': tokenss,
      'tokenpp': tokenpp,
    };
  }
}

class ImgUrl {
  late String photoThumb;
  late String photo;
  // String? realPath;
  // String? realUrl;
  late PhotoPp photoPp;

  ImgUrl({
    required this.photoThumb,
    required this.photo,
    // this.realPath,
    // this.realUrl,
    required this.photoPp,
  });

  ImgUrl.fromJson(Map<String, dynamic> json) {
    ImgUrl(
      photoThumb: json['photo_thumb'],
      photo: json['photo'],
      // realPath: json['real_path'],
      // realUrl: json['real_url'],
      photoPp: PhotoPp.fromJson(json['photo_pp']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'photo_thumb': photoThumb,
      'photo': photo,
      // 'real_path': realPath,
      // 'real_url': realUrl,
      'photo_pp': photoPp.toJson(),
    };
  }
}

class PhotoPp {
  String? photoDefault;
  String? photoDefaultThumb;

  PhotoPp({
    this.photoDefault,
    this.photoDefaultThumb,
  });

  PhotoPp.fromJson(Map<String, dynamic> json) {
    PhotoPp(
      photoDefault: json['photo_default'],
      photoDefaultThumb: json['photo_default_thumb'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'photo_default': photoDefault,
      'photo_default_thumb': photoDefaultThumb
    };
  }
}
