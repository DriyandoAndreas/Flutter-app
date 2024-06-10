import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:sisko_v5/models/komunikasi_model.dart';

class KomunikasiService {
  var apiUrl = dotenv.env['API_URL_SISKO_DEV'];
  Future<List<KomunikasiUmumModel>> getList({
    required String id,
    required String tokenss,
    required int limit,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul/komunikasi/lists-umum.php?limit=$limit');
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
        List<KomunikasiUmumModel> list = responseData
            .map((data) => KomunikasiUmumModel.fromJson(data))
            .toList();
        return list;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<ListKomunikasiMapelModel>> getMapel({
    required String id,
    required String tokenss,
    required int limit,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul/komunikasi/lists-mapel.php?limit=$limit');
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
        List<ListKomunikasiMapelModel> list = responseData
            .map((data) => ListKomunikasiMapelModel.fromJson(data))
            .toList();
        return list;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<ListKomunikasiEkskulModel>> getEkskul({
    required String id,
    required String tokenss,
    required int limit,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul/komunikasi/lists-ekskul.php?limit=$limit');
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
        List<ListKomunikasiEkskulModel> list = responseData
            .map((data) => ListKomunikasiEkskulModel.fromJson(data))
            .toList();
        return list;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<ListKomunikasiKelasModel>> getKelas({
    required String id,
    required String tokenss,
    required int limit,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul/komunikasi/lists-kelas.php?limit=$limit');
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
        List<ListKomunikasiKelasModel> list = responseData
            .map((data) => ListKomunikasiKelasModel.fromJson(data))
            .toList();
        return list;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<ListKomunikasiKelompokModel>> getKelompok({
    required String id,
    required String tokenss,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul/komunikasi/lists-kelompok.php');
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
        List<ListKomunikasiKelompokModel> list = responseData
            .map((data) => ListKomunikasiKelompokModel.fromJson(data))
            .toList();
        return list;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<ListKomunikasiSiswaModel>> getSiswaKelompok({
    required String id,
    required String tokenss,
    required String idKelompok,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul/komunikasi/lists-siswa-kelompok.php?id_kelompok=$idKelompok');
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
        List<ListKomunikasiSiswaModel> list = responseData
            .map((data) => ListKomunikasiSiswaModel.fromJson(data))
            .toList();
        return list;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<ListKomunikasiSiswaModel>> getSiswa({
    required String id,
    required String tokenss,
    required String kodeKelas,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul/komunikasi/lists-siswa.php?kode_kelas=$kodeKelas');
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
        List<ListKomunikasiSiswaModel> list = responseData
            .map((data) => ListKomunikasiSiswaModel.fromJson(data))
            .toList();
        return list;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<ListKomunikasiSiswaModel>> getAllSiswa({
    required String id,
    required String tokenss,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul/komunikasi/lists-siswa.php');
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
        List<ListKomunikasiSiswaModel> list = responseData
            .map((data) => ListKomunikasiSiswaModel.fromJson(data))
            .toList();
        return list;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<KomunikasiTahfidzModel>> getTahfidz({
    required String id,
    required String tokenss,
    required int limit,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul/komunikasi/lists-tahfidz.php?limit=$limit');
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
        List<KomunikasiTahfidzModel> list = responseData
            .map((data) => KomunikasiTahfidzModel.fromJson(data))
            .toList();
        return list;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> addKomunikasiUmum({
    required String id,
    required String tokenss,
    required String action,
    required String tab,
    required List<String> nis,
    required String jenis,
    required String kodeP,
    required String kodeE,
    required String tanggal,
    required String bahasan,
    required String catatanKel,
    required String kodePegawai,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul/komunikasi/exe.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };

    var body = {
      'action': action,
      'tab': tab,
    };
    body.remove('nis[]');
    for (int i = 0; i < nis.length; i++) {
      body['nis[$i]'] = nis[i];
    }
    body['jenis'] = jenis;
    body['kode_pljrn'] = kodeP;
    body['tanggal'] = tanggal;
    body['bahasan'] = bahasan;
    body['catatan_kel'] = catatanKel;
    body['kode_pegawai'] = kodePegawai;
    try {
      await http.post(url, headers: headers, body: body);
    } catch (e) {
      throw Exception('Error, Gagal menambahkan data: $e');
    }
  }

  Future<void> editKomunikasiUmum({
    required String id,
    required String tokenss,
    required String action,
    required String tab,
    required List<String> nis,
    required String jenis,
    required String kodeP,
    required String kodeE,
    required String tanggal,
    required String bahasan,
    required String catatanKel,
    required String kodePegawai,
    required String idUmum,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul/komunikasi/exe.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };

    var body = {
      'action': action,
      'tab': tab,
    };

    for (int i = 0; i < nis.length; i++) {
      body['nis[$i]'] = nis[i];
    }
    body['jenis'] = jenis;
    body['kode_pljrn'] = kodeP;
    body['tanggal'] = tanggal;
    body['bahasan'] = bahasan;
    body['catatan_kel'] = catatanKel;
    body['_kode'] = kodePegawai;
    body['idc'] = idUmum;
    try {
      await http.post(url, headers: headers, body: body);
    } catch (e) {
      throw Exception('Error, Gagal menambahkan data: $e');
    }
  }

  Future<void> deleteKomunikasi({
    required String id,
    required String tokenss,
    required String action,
    required String tab,
    required String idc,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul/komunikasi/exe.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    var body = {
      'action': action,
      'tab': tab,
      'idc': idc,
    };
    try {
      await http.post(url, headers: headers, body: body);
    } catch (e) {
      throw Exception('Error, Gagal menghapus data: $e');
    }
  }
}
