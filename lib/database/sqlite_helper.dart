import 'package:path/path.dart';
import 'package:app5/models/sqlite_user_model.dart';
import 'package:sqflite/sqflite.dart';

class SqLiteHelper {
  final dbName = "users.db";
  String createTableVars =
      '''CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
      id_user TEXT,
      user_name TEXT,
      password TEXT, 
      nomor TEXT, 
      nomor_sc TEXT, 
      position TEXT, 
      cpos TEXT, 
      photopp TEXT,
      nama TEXT, 
      nama_lengkap TEXT, 
      kelas TEXT, 
      kelamin TEXT, 
      email TEXT,
      join_sisko TEXT, 
      last_login TEXT, 
      sisko_npsn TEXT, 
      sisko_id TEXT,
      sisko_kode TEXT,
      sisko_kode_hakakses TEXT,
      sisko_status_login TEXT,
      verified TEXT,
      active TEXT,
      active_key TEXT,
      upload_photo TEXT,
      photo_default TEXT,
      photo_default_thumb TEXT,
      photo TEXT,
      photo_thumb TEXT,
      ip TEXT,
      token TEXT,
      tokenss TEXT,
      tokenpp TEXT,
      islogin INTEGER,
      hp TEXT,
      tgl_lahir TEXT
      )''';
//init db
  Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    return openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        await db.execute(createTableVars);
      },
    );
  }

//method check user login
  Future<bool> islogin() async {
    final db = await initDB();
    final result = await db.query(
      columns: ['id_user'],
      'users',
      where: 'id = ?',
      whereArgs: [1],
    );
    return result.isNotEmpty;
  }

//get user data
  Future<List<SqliteUserModel>> getusers() async {
    final db = await initDB();
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (index) {
      return SqliteUserModel(
        iduser: maps[index]['id_user'],
        username: maps[index]['user_name'],
        password: maps[index]['password'],
        nomor: maps[index]['nomor'],
        nomorsc: maps[index]['nomor_sc'],
        position: maps[index]['position'],
        cpos: maps[index]['cpos'],
        photopp: maps[index]['photopp'],
        kelamin: maps[index]['kelamin'],
        joinsisko: maps[index]['join_sisko'],
        lastlogin: maps[index]['last_login'],
        siskonpsn: maps[index]['sisko_npsn'],
        siskoid: maps[index]['sisko_id'],
        siskokode: maps[index]['sisko_kode'],
        siskoHakAkses: maps[index]['sisko_kode_hakakses'],
        verified: maps[index]['verified'],
        active: maps[index]['active'],
        activekey: maps[index]['active_key'],
        uploadphoto: maps[index]['upload_photo'],
        photodefault: maps[index]['photo_default'],
        photodefaultthumb: maps[index]['photo_default_thumb'],
        photothumb: maps[index]['photo_thumb'],
        ip: maps[index]['ip'],
        islogin: maps[index]['islogin'],
        tokenpp: maps[index]['tokenpp'],
        nama: maps[index]['nama'],
        photo: maps[index]['photo'],
        siskostatuslogin: maps[index]['sisko_status_login'],
        hp: maps[index]['hp'],
        email: maps[index]['email'],
        token: maps[index]['token'],
        tokenss: maps[index]['tokenss'],
        tanggallahir: maps[index]['tgl_lahir'],
        namalengkap: maps[index]['nama_lengkap'],
        kelas: maps[index]['kelas'],
      );
    });
  }

//insert data
  Future<void> insertUser(SqliteUserModel infomodel) async {
    final db = await initDB();
    await db.insert('users', infomodel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

//update data
  Future<void> updateUser(SqliteUserModel infomodel) async {
    final db = await initDB();
    await db.update('users', infomodel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

//delete data
  Future<void> deleteUser(int id) async {
    final db = await initDB();
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

//delete database
  Future<void> deletedb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "users.db");
    await deleteDatabase(path);
  }

  Future<void> disconnectUser() async {
    final db = await initDB();
    await db.rawUpdate(
        'UPDATE users SET id_user =  ? , sisko_npsn = ? , sisko_kode = ? , sisko_status_login  = ?,nama_lengkap  = ? , kelas = ?',
        ['', '', '', '', '', '']);
  }

  Future<void> reconnectUser({
    required String iduser,
    required String siskonpsn,
    required String siskokode,
    required String siskostatuslogin,
    required String siskonamalengkap,
    required String siskokelas,
  }) async {
    final db = await initDB();
    await db.rawUpdate(
        'UPDATE users SET id_user =  ? , sisko_npsn = ? , sisko_kode = ? , sisko_status_login  = ?, nama_lengkap  = ? , kelas = ?',
        [
          iduser,
          siskonpsn,
          siskokode,
          siskostatuslogin,
          siskonamalengkap,
          siskokelas
        ]);
  }
}
