import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:app5/models/monitoring_model.dart';

class MonitoringService {
  var apiUrl = dotenv.env['API_URL_SISKO_DEV'];
  Future<MainUserMonitoringModel> getUser({
    required String id,
    required String tokenss,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul_rpt/aktifitas/view.php');
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

        return MainUserMonitoringModel.fromJson(responseData);
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return MainUserMonitoringModel();
    }
  }

  Future<MainListAktifitasModel> getList({
    required String id,
    required String tokenss,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul_rpt/aktifitas/view.php');
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
        final List<dynamic> dataListgr = responseData['list_aktifitas_guru'];
        final List<dynamic> dataListkr =
            responseData['list_aktifitas_karyawan'];
        final List<dynamic> dataListxt = responseData['list_aktifitas_extra'];

        List<ListMonitoringAktifitasModel> getListgr = dataListgr
            .map((data) => ListMonitoringAktifitasModel.fromJson(data))
            .toList();
        List<ListMonitoringAktifitasModel> getListKr = dataListkr
            .map((data) => ListMonitoringAktifitasModel.fromJson(data))
            .toList();
        List<ListMonitoringAktifitasModel> getListXt = dataListxt
            .map((data) => ListMonitoringAktifitasModel.fromJson(data))
            .toList();

        return MainListAktifitasModel(
          guru: getListgr,
          karyawan: getListKr,
          extra: getListXt,
        );
      } else {
        return MainListAktifitasModel(
          guru: [],
          karyawan: [],
          extra: [],
        );
      }
    } catch (e) {
      return MainListAktifitasModel();
    }
  }

  Future<List<MonitoringProgressGrouped>> getImplementasi(
      {required String id, required String tokenss}) async {
    var url = Uri.parse('$apiUrl/client_api/modul_rpt/progress/view.php');
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
        List<MonitoringProgressGrouped> data =
            (json.decode(response.body)['data']['content'] as List)
                .map((item) => MonitoringProgressGrouped.fromJson(item))
                .toList();
        return data;
      } else {
        throw Exception('error');
      }
    } catch (e) {
      return [];
    }
  }

  Future<MonitoringKoneksiPhone> getKoneksi(
      {required String id, required String tokenss}) async {
    var url = Uri.parse('$apiUrl/client_api/modul_rpt/koneksi/view.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        return MonitoringKoneksiPhone.fromJson(data);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      return MonitoringKoneksiPhone();
    }
  }

  Future<Monitoring30DayGrouped> getList30day({
    required String id,
    required String tokenss,
    required int limit,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul_rpt/logactivity/view.php?limit=$limit');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body)['data'];
        Monitoring30DayGrouped data =
            Monitoring30DayGrouped.fromJson(responseData);
        return data;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      return Monitoring30DayGrouped();
    }
  }

  Future<List<MonitoringActivitySummaryModel>> getActivityGuru(
      {required String id, required String tokenss, required int limit}) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul_rpt/rekapaktifitas/list-guru.php?limit=$limit');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        List<MonitoringActivitySummaryModel> data =
            (json.decode(response.body)['datas'] as List)
                .map((item) => MonitoringActivitySummaryModel.fromJson(item))
                .toList();
        return data;
      } else {
        throw Exception('error');
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<MonitoringActivitySummaryModel>> getActivityKaryawan(
      {required String id, required String tokenss}) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul_rpt/rekapaktifitas/list-karyawan.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        List<MonitoringActivitySummaryModel> data =
            (json.decode(response.body)['datas'] as List)
                .map((item) => MonitoringActivitySummaryModel.fromJson(item))
                .toList();
        return data;
      } else {
        throw Exception('error');
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<MonitoriActivitySummaryTotal>> getTotalActivityGuru(
      {required String id, required String tokenss, required int limit}) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul_rpt/rekapaktifitas/list-guru.php?limit=$limit');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        List<MonitoriActivitySummaryTotal> data =
            (json.decode(response.body)['data'] as List)
                .map((item) => MonitoriActivitySummaryTotal.fromJson(item))
                .toList();
        return data;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<MonitoriActivitySummaryTotal>> getTotalActivityKaryawan(
      {required String id, required String tokenss}) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul_rpt/rekapaktifitas/list-karyawan.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        List<MonitoriActivitySummaryTotal> data =
            (json.decode(response.body)['data'] as List)
                .map((item) => MonitoriActivitySummaryTotal.fromJson(item))
                .toList();
        return data;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      return [];
    }
  }

  Future<MonitoringPresensiSiswaModel> getPresensiSiswa({
    required String id,
    required String tokenss,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul_rpt/presensi-siswa/view.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    try {
      //
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body)['data'];
        MonitoringPresensiSiswaModel data =
            MonitoringPresensiSiswaModel.fromJson(responseData);
        return data;
      } else {
        throw Exception('error');
      }
    } catch (e) {
      // return MonitoringPresensiSiswaModel();
      throw Exception(e);
    }
  }

  Future<MonitoringPresensiKaryawanModel> getPresensiKaryawan({
    required String id,
    required String tokenss,
  }) async {
    var url =
        Uri.parse('$apiUrl/client_api/modul_rpt/presensi-pegawai/view.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    try {
      //
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body)['data'];
        MonitoringPresensiKaryawanModel data =
            MonitoringPresensiKaryawanModel.fromJson(responseData);
        return data;
      } else {
        throw Exception('error');
      }
    } catch (e) {
      return MonitoringPresensiKaryawanModel();
    }
  }

  Future<List<Kelas>> fetchAkademikData({
    required String id,
    required String tokenss,
    required String date,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul_rpt/akademik-tanggal/lists_show.php?date=$date');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body)['data'];

        // Mengambil data kelas
        final jsonDatakelas = jsonData['kelas'];

        // Mengambil list_data dan memastikan bahwa itu adalah Map
        final listDataJson = jsonData['list_data'] is Map
            ? jsonData['list_data']
            : {}; // Jika tidak ada, gunakan map kosong

        List<Kelas> datakelas = [];
        if (jsonDatakelas is List) {
          for (var kelas in jsonDatakelas) {
            try {
              Kelas newKelas = Kelas.fromJson(kelas);
              // Tambahkan listData jika ada untuk setiap kelas
              if (listDataJson is Map &&
                  listDataJson.containsKey(newKelas.kodeKelas)) {
                newKelas.listData = (listDataJson[newKelas.kodeKelas] as List)
                    .map((item) => ListData.fromJson(item))
                    .toList();
              }
              datakelas.add(newKelas);
            } catch (e) {
              throw Exception('Error saat parsing kelas: $kelas. Error: $e');
            }
          }
        } else {
          throw Exception('jsonDatakelas bukan List!');
        }
        return datakelas;
      } else {
        throw Exception('Failed to load akademik data');
      }
    } catch (e) {
      return [];
    }
  }
}
