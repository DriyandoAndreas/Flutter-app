import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:app5/models/jadwal_model.dart';

/////////////////////////////////////////////////
///*****************Gac jadwal service */
class JadwalService {
  var apiUrl = dotenv.env['API_URL_SISKO_DEV'];
  Future<List<JadwalModel>> getListMapel({
    required String id,
    required String tokenss,
    required int limit,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul/jadwal/lists-mapel.php?limit=$limit');
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
        List<JadwalModel> getKelas =
            responseData.map((data) => JadwalModel.fromJson(data)).toList();
        return getKelas;
      } else {
        throw Exception(
            'Failed to get  list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<JadwalKelaslModel>> getListKelas({
    required String id,
    required String tokenss,
    required int limit,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul/jadwal/lists-kelas.php?limit=$limit');
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
        List<JadwalKelaslModel> getKelas = responseData
            .map((data) => JadwalKelaslModel.fromJson(data))
            .toList();
        return getKelas;
      } else {
        throw Exception(
            'Failed to get  list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<DetailJadwalHarian>> getListJadwalHarian({
    required String id,
    required String tokenss,
    required String param3,
  }) async {
    var url = Uri.parse(
      '$apiUrl/client_api/modul/jadwal/lists-show-jadwal-harian.php?param3=$param3',
    );
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
        final responseData = json.decode(response.body) as Map<String, dynamic>;
        final data = responseData['data'];

        List<DetailJadwalHarian> getJadwal = [];

        if (data['Detail'] is List) {
          return [];
        } else if (data['Detail'] is Map<String, dynamic>) {
          final detailData = data['Detail'] as Map<String, dynamic>;

          detailData.forEach((key, value) {
            final detailValues = value as Map<String, dynamic>;
            getJadwal.addAll(detailValues.entries.map((entry) {
              final value = entry.value as Map<String, dynamic>;
              return DetailJadwalHarian.fromJson(value);
            }));
          });

          return getJadwal;
        } else {
          throw Exception('Unexpected data format for Detail');
        }
      } else {
        throw Exception(
          'Failed to get list. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<ListMengajarModel>> getListMengajar({
    required String id,
    required String tokenss,
    required String param3,
  }) async {
    var url = Uri.parse(
      '$apiUrl/client_api/modul/jadwal/lists-show-jadwal-harian.php?param3=$param3',
    );
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
        List data = json.decode(response.body)['data']['listMengajar'];
        return data.map((item) => ListMengajarModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load listMengajar');
      }
    } catch (e) {
      return [];
    }
  }

  Future<void> addMengajar({
    required String id,
    required String tokenss,
    required String action,
    required String tab,
    required String kodePelajaran,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/jadwal/exe.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    var body = {
      'action': action,
      'tab': tab,
      'kode_pljrn': kodePelajaran,
    };
    try {
      await http.post(url, headers: headers, body: body);
    } catch (e) {
      return;
    }
  }

  Future<void> addJadwal({
    required String id,
    required String tokenss,
    required String action,
    required String jdwl,
    required String kodeMengajar,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/jadwal/exe.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };

    var body = {
      'action': action,
      'jdwl[$jdwl]': kodeMengajar,
    };
    try {
      await http.post(url, headers: headers, body: body);
    } catch (e) {
      return;
    }
  }

  Future<void> deleteMengajar({
    required String id,
    required String tokenss,
    required String action,
    required String tab,
    required String kodePelajaran,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/jadwal/exe.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    var body = {
      'action': action,
      'tab': tab,
      'kode_pljrn': kodePelajaran,
    };
    try {
      await http.post(url, headers: headers, body: body);
    } catch (e) {
      return;
    }
  }
}

////////////////////////////////////////////////
///***************Sat jadwal service */
class SatJadwalService {
  var apiUrl = dotenv.env['API_URL_SISKO_DEV'];
  Future<List<SatJadwalModel>> getJadwal({
    required String id,
    required String tokenss,
  }) async {
    var url =
        Uri.parse('$apiUrl/client_api/modul_sat/jadwal/list-pelajaran.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body)['data'];

        List<SatJadwalModel> parseJson(Map<String, dynamic> json) {
          List<SatJadwalModel> jdwl = [];
          if (json['databyday'].isEmpty) {
            return jdwl = [];
          } else {
            json['databyday'].forEach((key, value) {
              value.forEach((jam, namapelajaran) {
                if (namapelajaran.isNotEmpty) {
                  jdwl.add(SatJadwalModel.fromJson(jam, namapelajaran));
                }
              });
            });
            return jdwl;
          }
        }

        List<SatJadwalModel> jadwal = parseJson(data);
        return jadwal;
      } else {
        throw Exception('error');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<SatJadwalUjianModel>> getJadwalUjian({
    required String id,
    required String tokenss,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul_sat/jadwal/list-ujian.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body)['datas'];
        List<SatJadwalUjianModel> getJadwalUjian = responseData
            .map((data) => SatJadwalUjianModel.fromJson(data))
            .toList();
        return getJadwalUjian;
      } else {
        throw Exception('error');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<SatListJadwalKerjaPraktikModel>> getJadwalKP({
    required String id,
    required String tokenss,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul_sat/jadwal/list-kp.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body)['datas'];
        List<SatListJadwalKerjaPraktikModel> getJadwalKP = responseData
            .map((data) => SatListJadwalKerjaPraktikModel.fromJson(data))
            .toList();
        return getJadwalKP;
      } else {
        throw Exception('error');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
