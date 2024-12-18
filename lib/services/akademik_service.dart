import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:app5/models/akademik_model.dart';

class AkademikService {
  var apiUrl = dotenv.env['API_URL_SISKO_DEV'];
  var apiUrlPalapa = dotenv.env['API_URL_PAPALA'];

  Future<AkademikModel> getAkademik(
      {required String id, required String tokenss}) async {
    var url =
        Uri.parse('$apiUrl/client_api/modul/akademik/_menu/_caltimeline.php');
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
        final jsonData = json.decode(response.body);
        return AkademikModel.fromJson(jsonData);
      } else {
        throw Exception('error gagal parsing data api');
      }
    } catch (e) {
      return AkademikModel();
    }
  }

  Future<void> addAkademik({
    required String id,
    required String tokenss,
    required String action,
    required String kodemengajar,
    required String kodepelajaran,
    required String kodekelas,
    required String tanggal,
    required String mulai,
    required String selesai,
    required String jamke,
    required String jumlahjam,
    required String menitjam,
    required String komputer,
    required String proyektor,
    required String idlokasi,
    required String faslitiaslain,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/akademik/jadwal/exe.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    var body = {
      'action': action,
      'kode_mengajar': kodemengajar,
      'kode_pljrn': kodepelajaran,
      'kode_kelas': kodekelas,
      'tanggal': tanggal,
      'mulai': mulai,
      'selesai': selesai,
      'jam_ke': jamke,
      'jml_jam': jumlahjam,
      'id_lokasi': idlokasi,
      'menit_perjam': menitjam,
      'kebutuhan_proyektor': proyektor,
      'kebutuhan_komputer': komputer,
      'fasilitas_lain': faslitiaslain,
    };
    try {
      await http.post(url, headers: headers, body: body);
    } catch (e) {
      return;
    }
  }

  Future<void> delAkademik({
    required String id,
    required String tokenss,
    required String action,
    required String idakademik,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/akademik/persiapan/exe.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    var body = {
      'action': action,
      'param3': idakademik,
    };
    try {
      await http.post(url, headers: headers, body: body);
    } catch (e) {
      return;
    }
  }

  Future<AkademikFormPersiapan> persiapan({
    required String id,
    required String tokenss,
    required String action,
    required String idakademik,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul/akademik/persiapan/form_2.php?action=$action?id_akademik=$idakademik');
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
        Map<String, dynamic> responseData =
            json.decode(response.body)['data']['akademik'];

        return AkademikFormPersiapan.fromJson(responseData);
      } else {
        throw Exception('error gagal parsing data api');
      }
    } catch (e) {
      return AkademikFormPersiapan();
    }
  }

  Future<List<AkademikFormPersiapanPresensi>> persiapanPresensi({
    required String id,
    required String tokenss,
    required String action,
    required String idakademik,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul/akademik/persiapan/form_4.php?action=$action?id_akademik=$idakademik');
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
        final List<dynamic> responseData =
            json.decode(response.body)['data']['siswa'];
        List<AkademikFormPersiapanPresensi> datas = responseData
            .map((data) => AkademikFormPersiapanPresensi.fromJson(data))
            .toList();
        return datas;
      } else {
        throw Exception('error gagal parsing data api');
      }
    } catch (e) {
      return [];
    }
  }

  Future<AkademikFormPersiapanLaporan> persiapanLaporan({
    required String id,
    required String tokenss,
    required String action,
    required String idakademik,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul/akademik/persiapan/form_5.php?action=$action?id_akademik=$idakademik');
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
        Map<String, dynamic> responseData =
            json.decode(response.body)['data']['akademik'];

        return AkademikFormPersiapanLaporan.fromJson(responseData);
      } else {
        throw Exception('error gagal parsing data api');
      }
    } catch (e) {
      return AkademikFormPersiapanLaporan();
    }
  }

  Future<void> updatePresensi({
    required String id,
    required String tokenss,
    required String action,
    required String kodeakademik,
    required Map<String, String> absen, // Map of NIS and status
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/akademik/persiapan/exe.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    var body = {
      'action': action,
      'kode_akademik': kodeakademik,
    };

    // Loop through the map and add absen data to the body
    absen.forEach((nis, status) {
      body['absen[$nis]'] = status;
    });
    try {
      await http.post(url, headers: headers, body: body);
    } catch (e) {
      return;
    }
  }

  Future<void> updateLaporan({
    required String id,
    required String tokenss,
    required String action,
    required String kodeakademik,
    required String idakademik,
    required String materi,
    required String media,
    required String tugas,
    required String kegiatan,
    required String hambatan,
    required String persiapan,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/akademik/persiapan/exe.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    var body = {
      'action': action,
      'param3': idakademik,
      'kode_akademik': kodeakademik,
      'materi_yang_diberikan': materi,
      'media_alat': media,
      'kegiatan_kbm': kegiatan,
      'tugas_pr': tugas,
      'hambatan_kendala': hambatan,
      'persiapan_pertemuan_berikutnya': persiapan,
    };
    try {
      await http.post(url, headers: headers, body: body);
    } catch (e) {
      return;
    }
  }

  Future<void> updatePersiapan({
    required String id,
    required String tokenss,
    required String action,
    required String kodeakademik,
    required String idakademik,
    required String halpersiapan,
    required String tugassiswa,
    required String konfirmasiguru,
    required String zoomlink,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/akademik/persiapan/exe.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    var body = {
      'action': action,
      'param3': idakademik,
      'kode_akademik': kodeakademik,
      'hal_persiapan': halpersiapan,
      'tugas_siswa': tugassiswa,
      'konfirmasi_pengajar': konfirmasiguru,
      'zoom_link': zoomlink,
    };
    try {
      await http.post(url, headers: headers, body: body);
    } catch (e) {
      return;
    }
  }

  Future<List<MainPalapaMateri>> getMateri({
    required String token,
  }) async {
    var url = Uri.parse('$apiUrlPalapa/lesson/select_smart');
    var headers = {
      'token': token,
    };
    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> responseData =
            json.decode(response.body)['data']['datas'];
        List<MainPalapaMateri> datas = responseData
            .map((data) => MainPalapaMateri.fromJson(data))
            .toList();

        return datas;
      } else {
        throw Exception('error gagal parsing data api');
      }
    } catch (e) {
      return [];
    }
  }

  // * Sat
  Future<List<AkademikKelas>> fetchAkademikData({
    required String id,
    required String tokenss,
    required String date,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul_sat/akademik/akademik-tanggal/lists_show.php?date=$date&myclass=1');
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

        List<AkademikKelas> datakelas = [];
        if (jsonDatakelas is List) {
          for (var kelas in jsonDatakelas) {
            try {
              AkademikKelas newKelas = AkademikKelas.fromJson(kelas);
              // Tambahkan listData jika ada untuk setiap kelas
              if (listDataJson is Map &&
                  listDataJson.containsKey(newKelas.kodeKelas)) {
                newKelas.listData = (listDataJson[newKelas.kodeKelas] as List)
                    .map((item) => AkademikListData.fromJson(item))
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
      throw Exception(e);
    }
  }
}
