class ListKeuanganTagihanModel {
  String? thnPljrn;
  int? jmlTempoInv;

  ListKeuanganTagihanModel({this.thnPljrn, this.jmlTempoInv});

  factory ListKeuanganTagihanModel.fromJson(Map<dynamic, dynamic> json) {
    return ListKeuanganTagihanModel(
      thnPljrn: json['thn_pljrn'] ?? '',
      jmlTempoInv: json['jmlTempoInv'] ?? '',
    );
  }
}

class ListKeuanganTransaksiModel {
  String? trxid;
  String? via;
  String? token;
  String? timestamp;
  String? nis;
  String? jumlah;
  String? biayaAdm;
  String? data;
  String? finish;
  String? bookingid;
  String? bookingdatetime;
  String? bookingexpired;
  String? bookingstatus;
  String? fcmid;
  String? biaya;
  String? waktuexpired;
  String? bookingSts;

  ListKeuanganTransaksiModel({
    this.trxid,
    this.via,
    this.token,
    this.timestamp,
    this.nis,
    this.jumlah,
    this.biayaAdm,
    this.data,
    this.finish,
    this.bookingid,
    this.bookingdatetime,
    this.bookingexpired,
    this.bookingstatus,
    this.fcmid,
    this.biaya,
    this.waktuexpired,
    this.bookingSts,
  });
  factory ListKeuanganTransaksiModel.fromJson(Map<dynamic, dynamic> json) {
    return ListKeuanganTransaksiModel(
      trxid: json['trxid'] ?? '',
      via: json['via'] ?? '',
      token: json['token'] ?? '',
      timestamp: json['timestamp'] ?? '',
      nis: json['nis'] ?? '',
      jumlah: json['jumlah'] ?? '',
      biayaAdm: json['biaya_adm'] ?? '',
      data: json['data'] ?? '',
      finish: json['finish'] ?? '',
      bookingid: json['bookingid'] ?? '',
      bookingdatetime: json['booking_datetime'] ?? '',
      bookingexpired: json['booking_expired'] ?? '',
      bookingstatus: json['booking_status'] ?? '',
      fcmid: json['fcm_id'] ?? '',
      biaya: json['biaya'] ?? '',
      waktuexpired: json['waktu_expired'] ?? '',
      bookingSts: json['_booking_status'] ?? '',
    );
  }
}

class InvoiceBulanan {
  String? kodeadm;
  String? kodeinv;
  String? nis;
  String? tahunaj;
  String? semester;
  String? bln;
  String? tagihan;
  String? tempo;
  String? namaadm;
  String? dibayar;
  String? sisa;
  dynamic pending;

  InvoiceBulanan({
    this.kodeadm,
    this.kodeinv,
    this.nis,
    this.tahunaj,
    this.semester,
    this.bln,
    this.tagihan,
    this.tempo,
    this.namaadm,
    this.dibayar,
    this.sisa,
    this.pending,
  });

  factory InvoiceBulanan.fromJson(Map<String, dynamic> json) {
    return InvoiceBulanan(
      kodeadm: json['kode_adm'] ?? '',
      kodeinv: json['kode_inv'] ?? '',
      nis: json['nis'] ?? '',
      tahunaj: json['tahun_aj'] ?? '',
      semester: json['semester'] ?? '',
      bln: json['bln'] ?? '',
      tagihan: json['tagihan'] ?? '',
      tempo: json['tempo'] ?? '',
      namaadm: json['nama_adm'] ?? '',
      dibayar: json['dibayar'] ?? '',
      sisa: json['sisa'] ?? '',
      pending: json['pending'] ?? '',
    );
  }
}

class InvoiceModel {
  final Map<String, Map<String, InvoiceBulanan>>? dataBulanan;
  final Map<String, InvoiceBulanan>? terbatas;
  final Map<String, InvoiceBulanan>? bebas;

  InvoiceModel({
    this.dataBulanan,
    this.terbatas,
    this.bebas,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    Map<String, Map<String, InvoiceBulanan>>? bulanan = {};
    if (json['bulanan'] != null && json['bulanan'] is! bool) {
      (json['bulanan'] as Map<String, dynamic>).forEach((key, value) {
        if (value is Map<String, dynamic>) {
          Map<String, InvoiceBulanan> innerMap = {};
          value.forEach((innerKey, innerValue) {
            innerMap[innerKey] = InvoiceBulanan.fromJson(innerValue);
          });
          bulanan[key] = innerMap;
        }
      });
    }

    Map<String, InvoiceBulanan>? terbatas = {};
    if (json['terbatas'] != null && json['terbatas'] is! bool) {
      (json['terbatas'] as Map<String, dynamic>).forEach((key, value) {
        terbatas[key] = InvoiceBulanan.fromJson(value);
      });
    }
    Map<String, InvoiceBulanan>? bebas = {};
    if (json['bebas'] != null && json['bebas'] is! bool) {
      (json['bebas'] as Map<String, dynamic>).forEach((key, value) {
        bebas[key] = InvoiceBulanan.fromJson(value);
      });
    }

    return InvoiceModel(
      dataBulanan: bulanan,
      terbatas: terbatas,
      bebas: bebas,
    );
  }

  Map<String, InvoiceBulanan>? getItems(String key) {
    if (key == 'terbatas') {
      return terbatas;
    }
    return null;
  }
}

class DetailKeuanganModel {
  List<InvoiceBulanan>? dataBulanan;
  List<InvoiceBulanan>? dataTerbatas;
  List<InvoiceBulanan>? dataBebas;
  List<PaymentViaModel>? paymentvias;

  DetailKeuanganModel(
      {this.dataBulanan, this.dataTerbatas, this.dataBebas, this.paymentvias});
}

class PaymentViaModel {
  String? paymentvia;
  String? title;
  String? description;
  PaymentLogos? logos;
  PaymentAdms? paymentadm;

  PaymentViaModel(
      {this.paymentvia,
      this.title,
      this.description,
      this.logos,
      this.paymentadm});
  factory PaymentViaModel.fromJson(Map<String, dynamic> json) {
    return PaymentViaModel(
      paymentvia: json['payment_via'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      logos: PaymentLogos.fromJson(json['logos']),
      paymentadm: PaymentAdms.fromJson(json['payment_adm']),
    );
  }
}

class PaymentLogos {
  List<dynamic>? logos;

  PaymentLogos({
    this.logos,
  });
  factory PaymentLogos.fromJson(List<dynamic> json) {
    return PaymentLogos(
      logos: json,
    );
  }
}

class PaymentAdms {
  dynamic fixed;
  dynamic price;

  PaymentAdms({
    this.fixed,
    this.price,
  });
  factory PaymentAdms.fromJson(Map<dynamic, dynamic> json) {
    return PaymentAdms(
      fixed: json['fixed'] ?? '',
      price: json['price'] ?? '',
    );
  }
}

class KeuangaKwintansiModel {
  String? trxid;
  String? via;
  String? token;
  String? timestamp;
  String? biaya;
  String? biayaadm;
  String? invoiceurl;
  String? waktuexpired;
  String? bookingstatus;
  String? qrstring;

  KeuangaKwintansiModel({
    this.trxid,
    this.via,
    this.token,
    this.timestamp,
    this.biaya,
    this.biayaadm,
    this.invoiceurl,
    this.waktuexpired,
    this.bookingstatus,
    this.qrstring,
  });

  factory KeuangaKwintansiModel.fromJson(Map<String, dynamic> json) {
    return KeuangaKwintansiModel(
      trxid: json['trxid'] ?? '',
      via: json['via'] ?? '',
      token: json['token'] ?? '',
      timestamp: json['timestamp'] ?? '',
      biaya: json['biaya'] ?? '',
      biayaadm: json['biaya_adm'] ?? '',
      invoiceurl: json['invoice_url'] ?? '',
      waktuexpired: json['waktu_expired'] ?? '',
      bookingstatus: json['booking_status'] ?? '',
      qrstring: json['qr_string'] ?? '',
    );
  }
}

class DataKwitansiModel {
  String? nis;
  String? tahunaj;
  String? kodeadm;
  String? bulan;
  String? amount;

  DataKwitansiModel({
    this.nis,
    this.tahunaj,
    this.kodeadm,
    this.bulan,
    this.amount,
  });

  factory DataKwitansiModel.fromJson(
      String nis, String tahunaj, String kodeadm, String bulan, dynamic json) {
    return DataKwitansiModel(
      nis: nis,
      tahunaj: tahunaj,
      kodeadm: kodeadm,
      bulan: bulan,
      amount: json as String,
    );
  }
}

class DataKwitansiLainModel {
  String? nis;
  String? tahunaj;
  String? kodeadm;
  String? namaadm;
  String? amount;

  DataKwitansiLainModel({
    this.nis,
    this.tahunaj,
    this.kodeadm,
    this.namaadm,
    this.amount,
  });

  factory DataKwitansiLainModel.fromJson(String nis, String tahunaj,
      String kodeadm, String namaadm, dynamic json) {
    return DataKwitansiLainModel(
      nis: nis,
      tahunaj: tahunaj,
      kodeadm: kodeadm,
      namaadm: namaadm,
      amount: json,
    );
  }
}

class MainDataKwitansiModel {
  List<DataKwitansiModel>? listDataKwitansiBulanan;
  List<DataKwitansiLainModel>? listDataKwitansiLain;

  MainDataKwitansiModel(
      {this.listDataKwitansiBulanan, this.listDataKwitansiLain});
}

class CardTagihanModel {
  String? tagihan;

  CardTagihanModel({this.tagihan});

  factory CardTagihanModel.fromJson(Map<String, dynamic> json) {
    return CardTagihanModel(
      tagihan: json['tagihan'] ?? '',
    );
  }
}
