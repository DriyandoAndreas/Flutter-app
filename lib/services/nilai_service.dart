import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:app5/models/nilai_model.dart';

///***********Gac Nilai Service */
class NilaiService {
  var apiUrl = dotenv.env['API_URL_SISKO_DEV'];
  Future<List<NilaiKelasModel>> getList({
    required String id,
    required String tokenss,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/nilai/lists-kelas.php');
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
        List<NilaiKelasModel> getKelas =
            responseData.map((data) => NilaiKelasModel.fromJson(data)).toList();
        return getKelas;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<NilaiJenisModel>> getJenisNilai({
    required String id,
    required String tokenss,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/nilai/lists-jenis-nilai.php');
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
        List<NilaiJenisModel> getNilai =
            responseData.map((data) => NilaiJenisModel.fromJson(data)).toList();
        return getNilai;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<ListNilaiMapelModel>> getListMapel({
    required String id,
    required String tokenss,
    required String kodeKelas,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul/nilai/lists-mapel.php?kode_kelas=$kodeKelas');
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
        List<ListNilaiMapelModel> getNilai = responseData
            .map((data) => ListNilaiMapelModel.fromJson(data))
            .toList();
        return getNilai;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<ListShowNilaiModel>> getShowNilai({
    required String id,
    required String tokenss,
    required String kodeKelas,
    required String jp,
    required String kodeMengajar,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul/nilai/lists-show-nilai.php?kode_kelas=$kodeKelas&jp=$jp&kode_mengajar=$kodeMengajar');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    try {
      var respon = await http.get(url, headers: headers);
      if (respon.statusCode == 200) {
        final responData = json.decode(respon.body) as Map<String, dynamic>;
        final data = responData['data'] as Map<String, dynamic>;
        List<ListShowNilaiModel> showNilai = [];
        data.forEach((key, value) {
          final currentData = value as Map<String, dynamic>;
          showNilai.add(ListShowNilaiModel.fromJson(key, currentData));
        });

        return showNilai;
      } else {
        throw Exception('Error to Load');
      }
    } catch (e) {
      return [];
    }
  }

  Future<void> addNilai({
    required String id,
    required String tokenss,
    required String action,
    required String jp,
    required String kodePelajaran,
    required String kodePegawai,
    required List<String> nis,
    required List<String> jenisNilai,
    required List<String> nilai,
    required String tahunAjaran,
    required String semester,
    bool? branding,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/nilai/exe.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    var body = {
      'action': action,
      'kode_pljrn': kodePelajaran,
      'kode': kodePegawai,
      'jp': jp,
      'thn_aj': tahunAjaran,
      'sem': semester
    };
    if (branding == true) {
      for (var i = 0; i < nis.length; i++) {
        body['text[${nis[i]}][praktik]'] = nilai[2 * i]; // Nilai untuk ppk
        body['text[${nis[i]}][notes]'] =
            nilai[2 * i + 1]; // Nilai untuk praktik
        // body['text[${nis[i]}][notes]'] = nilai[2 * i + 2]; // Nilai untuk notes
      }
    } else {
      for (var i = 0; i < nis.length; i++) {
        body['text[${nis[i]}][ppk]'] = nilai[2 * i]; // Nilai untuk ppk
        body['text[${nis[i]}][praktik]'] =
            nilai[2 * i + 1]; // Nilai untuk praktik
        // body['text[${nis[i]}][notes]'] = nilai[2 * i + 2]; // Nilai untuk notes
      }
    }
    try {
       await http.post(url, headers: headers, body: body);
    } catch (e) {
      return;
    }
  }
}

///***Sat Nilai Service */
class SatNilaiService {
  var apiUrl = dotenv.env['API_URL_SISKO_DEV'];
  //get jenis penilaian
  Future<SatMenuNilaiModel> getMenuNilai({
    required String id,
    required String tokenss,
  }) async {
    var url =
        Uri.parse('$apiUrl/client_api/modul_sat/nilai/list-menu-nilai.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body)['data'];
        List<SatNilaiMenuModel> parseJson(Map<String, dynamic> json) {
          List<SatNilaiMenuModel> listmenu = [];
          if (json['UH'].isEmpty && json['TG'].isEmpty) {
            return listmenu = [];
          } else {
            json['UH'].forEach((key, value) {
              listmenu.add(SatNilaiMenuModel.fromJson(key, value));
            });
            json['TG'].forEach((key, value) {
              listmenu.add(SatNilaiMenuModel.fromJson(key, value));
            });
            return listmenu;
          }
        }

        List<SatNilaiMenuModel> listmenudata = parseJson(data);
        return SatMenuNilaiModel(
          listmenu: listmenudata,
        );
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  //get nilai
  Future<List<SatNilaiModel>> getNilai({
    required String id,
    required String tokenss,
    required String jenispenilaian,
    required String semester,
    required String tahunajaran,
    required String kodepenilaian,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul_sat/nilai/list_nilai_siswa.php?sem=$semester&thn_ajaran=$tahunajaran&kode_penilaian=$kodepenilaian&jenis_penilaian=$jenispenilaian');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };

    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body)['datas'];
        List<SatNilaiModel> getNilai =
            responseData.map((data) => SatNilaiModel.fromJson(data)).toList();
        return getNilai;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  //get mapel
  Future<List<SatNilaiMapelModel>> getMapel({
    required String id,
    required String tokenss,
    required String tahunajaran,
    required String semester,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul_sat/nilai/list-nilai-mapel.php?semesters=$semester&tahun_ajaran=$tahunajaran');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };

    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body)['datas'];

        List<SatNilaiMapelModel> getMapel = responseData
            .map((data) => SatNilaiMapelModel.fromJson(data))
            .toList();
        return getMapel;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  //get nilai ekskul
  Future<List<SatNilaiEkskulModel>> getEkskul({
    required String id,
    required String tokenss,
    required String semester,
    required String tahunajaran,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul_sat/nilai/list-ekskul.php?sem_e=$semester&thn_aj_e=$tahunajaran');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body)['datas'];

        List<SatNilaiEkskulModel> getEkskul = responseData
            .map((data) => SatNilaiEkskulModel.fromJson(data))
            .toList();
        return getEkskul;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return [];
    }
  }
}
