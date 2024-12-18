import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:app5/models/komunikasi_model.dart';

//////////////////////////////////////////
///*******Gac komunikasi service */
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
    var url =
        Uri.parse('$apiUrl/client_api/modul/komunikasi/lists-kelompok.php');
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
    var url = Uri.parse('$apiUrl/client_api/modul/komunikasi/lists-siswa.php');
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

  Future<List<ListKomunikasiCommentModel>> getComment(
      {required String id,
      required String tokenss,
      required String param2,
      required String param3}) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul/komunikasi/lists-comment.php?param2=$param2&param3=$param3');
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
        List<ListKomunikasiCommentModel> list = responseData
            .map((data) => ListKomunikasiCommentModel.fromJson(data))
            .toList();
        return list;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return [];
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

  Future<List<ViewKomunikasiTahfidzModel>> getViewTahfidz({
    required String id,
    required String tokenss,
    required String param2,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul/komunikasi/view-tahfidz.php?param2=$param2');
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
        List<ViewKomunikasiTahfidzModel> list = responseData
            .map((data) => ViewKomunikasiTahfidzModel.fromJson(data))
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
    var url = Uri.parse('$apiUrl/client_api/modul/komunikasi/exe.php');
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

  Future<void> addKomunikasiTahfidz({
    required String id,
    required String tokenss,
    required String action,
    required String tab,
    required List<String> nis,
    required String jenis,
    required String jenisHafalan,
    required String metode,
    required String juz,
    required String surat,
    required String ayat,
    required String ayatTo,
    required String jumlah,
    required String nilai,
    required String tanggal,
    required String catatan,
    required String catatanKel,
    required String kodePegawai,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/komunikasi/exe.php');
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
    body['jenis_hafalan'] = jenisHafalan;
    body['metode'] = metode;
    body['juz'] = juz;
    body['surat'] = surat;
    body['ayat'] = ayat;
    body['ayat_to'] = ayatTo;
    body['jumlah'] = jumlah;
    body['nilai'] = nilai;
    body['tanggal'] = tanggal;
    body['catatan'] = catatan;
    body['catatan_kel'] = catatanKel;
    body['kode_pegawai'] = kodePegawai;
    try {
      await http.post(url, headers: headers, body: body);
    } catch (e) {
      return;
    }
  }

  Future<void> editKomunikasiTahfidz({
    required String id,
    required String tokenss,
    required String action,
    required String tab,
    required List<String> nis,
    required String jenis,
    required String jenisHafalan,
    required String metode,
    required String juz,
    required String surat,
    required String ayat,
    required String ayatTo,
    required String jumlah,
    required String nilai,
    required String tanggal,
    required String catatan,
    required String catatanKel,
    required String kodePegawai,
    required String idc,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/komunikasi/exe.php');
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
    body['jenis_hafalan'] = jenisHafalan;
    body['metode'] = metode;
    body['juz'] = juz;
    body['surat'] = surat;
    body['ayat'] = ayat;
    body['ayat_to'] = ayatTo;
    body['jumlah'] = jumlah;
    body['nilai'] = nilai;
    body['tanggal'] = tanggal;
    body['catatan'] = catatan;
    body['catatan_kel'] = catatanKel;
    body['kode_pegawai'] = kodePegawai;
    body['idc'] = idc;
    try {
      await http.post(url, headers: headers, body: body);
    } catch (e) {
      return;
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
    var url = Uri.parse('$apiUrl/client_api/modul/komunikasi/exe.php');
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
    var url = Uri.parse('$apiUrl/client_api/modul/komunikasi/exe.php');
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

  Future<void> deleteTahfidz({
    required String id,
    required String tokenss,
    required String action,
    required String tab,
    required String idc,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/komunikasi/exe.php');
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

  Future<void> addComment({
    required String id,
    required String tokenss,
    required String action,
    required String idc,
    required String tabel,
    required String komentar,
    required String kodePegawai,
    required String nis,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/komunikasi/exe.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    var body = {
      'action': action,
      'tabel': tabel,
      'idc': idc,
      'komentar': komentar,
      'kode_pegawai': kodePegawai,
      'nis': nis,
    };
    try {
      await http.post(url, headers: headers, body: body);
    } catch (e) {
      return;
    }
  }
}

//////////////////////////////////////////
///*********Sat komunikasi service */
class SatKomunikasiService {
  var apiUrl = dotenv.env['API_URL_SISKO_DEV'];
  Future<List<SatKomunikasiModel>> getList({
    required String id,
    required String tokenss,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul_sat/komunikasi/lists_show_umum.php');
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
        List<SatKomunikasiModel> list = responseData
            .map((data) => SatKomunikasiModel.fromJson(data))
            .toList();
        return list;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<SatKomunikasiTahfidzModel>> getListTahfidz({
    required String id,
    required String tokenss,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul_sat/komunikasi/lists_show_tahfidz.php');
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
        List<SatKomunikasiTahfidzModel> list = responseData
            .map((data) => SatKomunikasiTahfidzModel.fromJson(data))
            .toList();
        return list;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<ViewKomunikasiUmumModel>> getViewUmum({
    required String id,
    required String tokenss,
    required String param,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul_sat/komunikasi/view_umum.php?param2=$param');
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
        List<ViewKomunikasiUmumModel> getView = responseData
            .map((data) => ViewKomunikasiUmumModel.fromJson(data))
            .toList();
        return getView;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<SatViewKomunikasiTahfidzModel>> getViewTahfidz({
    required String id,
    required String tokenss,
    required String param,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul_sat/komunikasi/view_tahfidz.php?param2=$param');
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
        List<SatViewKomunikasiTahfidzModel> getViewTahfidz = responseData
            .map((data) => SatViewKomunikasiTahfidzModel.fromJson(data))
            .toList();
        return getViewTahfidz;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<SatKomentarModel>> getListKomentarUmum({
    required String id,
    required String tokenss,
    required String param,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul_sat/komunikasi/lists_comment.php?param2=$param');
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
        List<SatKomentarModel> getKomentar = responseData
            .map((data) => SatKomentarModel.fromJson(data))
            .toList();
        return getKomentar;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<SatKomentarModel>> getListKomentarTahfidz({
    required String id,
    required String tokenss,
    required String param,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul_sat/komunikasi/lists_comment_tahfidz.php?param2=$param');
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
        List<SatKomentarModel> getKomentar = responseData
            .map((data) => SatKomentarModel.fromJson(data))
            .toList();
        return getKomentar;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return [];
    }
  }
}
