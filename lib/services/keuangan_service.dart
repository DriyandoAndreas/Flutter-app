import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app5/models/keuangan_model.dart';
import 'package:http/http.dart' as http;

class KeuanganService {
  var apiUrl = dotenv.env['API_URL_SISKO_DEV'];

  Future<List<ListKeuanganTagihanModel>> getListTagihan(
      {required String id, required String tokenss}) async {
    var url = Uri.parse('$apiUrl/client_api/modul_sat/spp/list-ta.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    try {
      var response = await http.get(
        url,
        headers: headers,
      );
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body)['datas'];
        List<ListKeuanganTagihanModel> listTagihan = responseData
            .map((data) => ListKeuanganTagihanModel.fromJson(data))
            .toList();
        return listTagihan;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<ListKeuanganTransaksiModel>> getListTransaksi(
      {required String id, required String tokenss}) async {
    var url = Uri.parse('$apiUrl/client_api/modul_sat/spp/list-trx.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    try {
      var response = await http.get(
        url,
        headers: headers,
      );
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body)['datas'];
        List<ListKeuanganTransaksiModel> listTransaksi = responseData
            .map((data) => ListKeuanganTransaksiModel.fromJson(data))
            .toList();
        return listTransaksi;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return [];
    }
  }

  Future<DetailKeuanganModel> getInvoice({
    required String id,
    required String tokenss,
    required String param,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul_sat/spp/list-detail.php?param=$param');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };

    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        List<InvoiceBulanan> dataBulanan = [];
        List<InvoiceBulanan> dataTerbatas = [];
        List<InvoiceBulanan> dataBebas = [];
        final Map<String, dynamic> responseData =
            json.decode(response.body)['data'];
        final data = responseData['invoice'];
        if (data.containsKey('bulanan')) {
          if (data['bulanan'] is bool || data['bulanan'] == false) {
            dataBulanan = [];
          } else if (data['bulanan'] is Map<String, dynamic>) {
            InvoiceModel datas = InvoiceModel.fromJson(data);
            Map<String, Map<String, InvoiceBulanan>>? bulananData =
                datas.dataBulanan;
            bulananData?.forEach((key, innerMap) {
              innerMap.forEach((innerKey, value) {
                dataBulanan.add(value);
              });
            });
          }
        }
        if (data.containsKey('terbatas')) {
          if (data['terbatas'] is bool || data['terbatas'] == false) {
            dataTerbatas = [];
          } else if (data['terbatas'] is Map<String, dynamic>) {
            data['terbatas'].forEach((key, value) {
              InvoiceBulanan invoice = InvoiceBulanan.fromJson(value);
              dataTerbatas.add(invoice);
            });
          }
        }

        // Handle bebas data
        if (data.containsKey('bebas')) {
          if (data['bebas'] is bool || data['bebas'] == false) {
            dataBebas = [];
          } else if (data['bebas'] is Map<String, dynamic>) {
            data['bebas'].forEach((key, value) {
              InvoiceBulanan invoice = InvoiceBulanan.fromJson(value);
              dataBebas.add(invoice);
            });
          }
        }

        List<dynamic> paymentvia = responseData['payment_vias'];
        List<PaymentViaModel> payments =
            paymentvia.map((data) => PaymentViaModel.fromJson(data)).toList();

        return DetailKeuanganModel(
            dataBulanan: dataBulanan,
            dataTerbatas: dataTerbatas,
            dataBebas: dataBebas,
            paymentvias: payments);
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> kuanganAdd({
    required String id,
    required String tokenss,
    required Map<String, String> data,
    required String biayaAdm,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul_sat/spp/exe.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };

    data.addAll({
      'action': 'payment',
      'biaya_adm': biayaAdm,
    });
    try {
      await http.post(
        url,
        headers: headers,
        body: data,
      );
    } catch (e) {
      return;
    }
  }

  Future<List<KeuangaKwintansiModel>> getKwitansi({
    required String id,
    required String tokenss,
    required String param,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul_sat/spp/kw.php?param=$param');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };

    try {
      var response = await http.get(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData =
            json.decode(response.body)['data'];
        List<KeuangaKwintansiModel> listKwitansi = [];
        listKwitansi.add(KeuangaKwintansiModel.fromJson(responseData));
        return listKwitansi;
      } else {
        throw Exception(
            'Failed to get data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return [];
    }
  }

  Future<MainDataKwitansiModel> getDataTransaksi({
    required String id,
    required String tokenss,
    required String param,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul_sat/spp/kw.php?param=$param');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };

    try {
      var response = await http.get(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final Map<String, dynamic> respons = responseData['data'];
        final Map<String, dynamic> innerrespons = respons['data'];
        final Map<String, dynamic> datas = innerrespons['payment'];
        List<DataKwitansiModel> parseJsonToListBulanan(
            Map<String, dynamic> json) {
          List<DataKwitansiModel> listinnerdatabulanan = [];
          if (json['bulanan'].isEmpty) {
            return listinnerdatabulanan = [];
          } else {
            json['bulanan'].forEach((nis, datatahunaj) {
              datatahunaj.forEach((tahunaj, datakodeadm) {
                if (datakodeadm.isEmpty) {
                  return listinnerdatabulanan = [];
                } else {
                  datakodeadm.forEach((kodeadm, databulan) {
                    databulan.forEach((bulan, amount) {
                      listinnerdatabulanan.add(DataKwitansiModel.fromJson(
                          nis, tahunaj, kodeadm, bulan, amount));
                    });
                  });
                }
              });
            });

            return listinnerdatabulanan;
          }
        }

        List<DataKwitansiLainModel> parseJsonToListLain(
            Map<String, dynamic> json) {
          List<DataKwitansiLainModel> listinnerdatalain = [];
          if (json['lain'].isEmpty) {
            return listinnerdatalain = [];
          } else {
            json['lain'].forEach((nis, datatahunaj) {
              datatahunaj.forEach((tahunaj, datakodeadm) {
                if (datakodeadm.isEmpty) {
                  return listinnerdatalain = [];
                } else {
                  datakodeadm.forEach((kodeadm, datanamaadm) {
                    datanamaadm.forEach((namaadm, amount) {
                      listinnerdatalain.add(DataKwitansiLainModel.fromJson(
                          nis, tahunaj, kodeadm, namaadm, amount));
                    });
                  });
                }
              });
            });
            return listinnerdatalain;
          }
        }

        List<DataKwitansiModel> listdatabln = parseJsonToListBulanan(datas);
        List<DataKwitansiLainModel> listdataln = parseJsonToListLain(datas);
        return MainDataKwitansiModel(
            listDataKwitansiBulanan: listdatabln,
            listDataKwitansiLain: listdataln);
      } else {
        throw Exception(
            'Failed to get data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return MainDataKwitansiModel();
    }
  }

  Future<CardTagihanModel> getTagihan({
    required String id,
    required String tokenss,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul_sat/implementasi/_menu/card-tagihan.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };

    try {
      var response = await http.get(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData =
            json.decode(response.body)['data'];
        return CardTagihanModel.fromJson(responseData);
      } else {
        throw Exception(
            'Failed to get data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return CardTagihanModel();
    }
  }
}
