import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sisko_v5/database/sqlite_helper.dart';
import 'package:sisko_v5/pages/biodata_page.dart';
import 'package:sisko_v5/pages/school_landing_page.dart';
import 'package:sisko_v5/pages_detail/gac/view_detail_kelas.dart';
import 'package:sisko_v5/pages_detail/gac/view_komunikasi_umum.dart';
import 'package:sisko_v5/pages_detail/gac/view_konseling.dart';
import 'package:sisko_v5/pages_detail/gac/view_pengumuman.dart';
import 'package:sisko_v5/pages_detail/gac/view_detail_presensi_kelas.dart';
import 'package:sisko_v5/pages_detail/gac/view_teras_sekolah.dart';
import 'package:sisko_v5/pages_detail/gac/view_uks.dart';
import 'package:sisko_v5/pages_form/form_add_nilai.dart';
import 'package:sisko_v5/pages_form/form_biodata.dart';
import 'package:sisko_v5/pages_form/form_edit_komunikasi_umum.dart';
import 'package:sisko_v5/pages_form/gac/form_edit_pengumuman.dart';
import 'package:sisko_v5/pages_form/gac/form_edit_teras_sekolah.dart';
import 'package:sisko_v5/pages_form/form_edit_uks.dart';
import 'package:sisko_v5/pages_form/form_edit_uks_gr.dart';
import 'package:sisko_v5/pages_form/form_komunikasi_umum_add.dart';
import 'package:sisko_v5/pages_form/gac/form_konseling.dart';
import 'package:sisko_v5/pages_form/gac/form_konseling_kelas_add.dart';
import 'package:sisko_v5/pages_form/gac/form_konseling_kelas_edit.dart';
import 'package:sisko_v5/pages_form/form_peminjaman.dart';
import 'package:sisko_v5/pages_form/form_pengembalian.dart';
import 'package:sisko_v5/pages_form/gac/form_pengumuman_add.dart';
import 'package:sisko_v5/pages_form/form_photo_profile.dart';
import 'package:sisko_v5/pages_form/gac/form_teras_sekolah_add.dart';
import 'package:sisko_v5/pages_form/form_ubah_no_hp.dart';
import 'package:sisko_v5/pages_form/form_ubah_password.dart';
import 'package:sisko_v5/pages_form/form_uks_gr.dart';
import 'package:sisko_v5/pages_form/form_uks.dart';
import 'package:sisko_v5/pages_list/list_akademik.dart';
import 'package:sisko_v5/pages_list/list_cctv.dart';
import 'package:sisko_v5/pages_list/list_jadwal.dart';
import 'package:sisko_v5/pages_list/list_jenis_nilai.dart';
import 'package:sisko_v5/pages_list/gac/list_kelas.dart';
import 'package:sisko_v5/pages_list/list_keuangan.dart';
import 'package:sisko_v5/pages_list/list_komunikasi.dart';
import 'package:sisko_v5/pages_list/gac/list_konseling.dart';
import 'package:sisko_v5/pages_list/list_monitoring.dart';
import 'package:sisko_v5/pages_list/list_nilai.dart';
import 'package:sisko_v5/pages_list/list_nilai_mapel.dart';
import 'package:sisko_v5/pages_list/list_notifikasi.dart';
import 'package:sisko_v5/pages_list/gac/list_pengumuman.dart';
import 'package:sisko_v5/pages_list/list_perpustakaan.dart';
import 'package:sisko_v5/pages_list/list_polling.dart';
import 'package:sisko_v5/pages_list/gac/list_presensi.dart';
import 'package:sisko_v5/pages_list/list_show_jam_pelajaran.dart';
import 'package:sisko_v5/pages_list/gac/list_teras_sekolah.dart';
import 'package:sisko_v5/pages_list/list_uks.dart';
import 'package:sisko_v5/pages/account_page.dart';
import 'package:sisko_v5/pages/forget_password_page.dart';
import 'package:sisko_v5/pages/home_page.dart';
import 'package:sisko_v5/pages/main_page.dart';
import 'package:sisko_v5/pages/login_page.dart';
import 'package:sisko_v5/pages/myschool_page.dart';
import 'package:sisko_v5/pages/signup_page.dart';
import 'package:sisko_v5/pages_list/list_uks_kelas.dart';
import 'package:sisko_v5/providers/auth_provider.dart';
import 'package:sisko_v5/providers/berita_provider.dart';
import 'package:sisko_v5/providers/kelas_provider.dart';
import 'package:sisko_v5/providers/konseling_provider.dart';
import 'package:sisko_v5/providers/pengumuman_provider.dart';
import 'package:sisko_v5/providers/presensi_provider.dart';
import 'package:sisko_v5/providers/sqlite_user_provider.dart';
import 'package:sisko_v5/providers/theme_switch_provider.dart';
import 'package:sisko_v5/providers/theme_provider.dart';
import 'package:sisko_v5/providers/user_info_provider.dart';
import 'package:sisko_v5/utils/theme.dart';
import 'package:sisko_v5/webview/webview_blog.dart';
import 'package:sisko_v5/webview/webview_kebijakan_privasi.dart';
import 'package:sisko_v5/webview/webview_news.dart';
import 'package:sisko_v5/webview/webview_pusat_bantuan.dart';
import 'package:sisko_v5/widgets/about_app.dart';
import 'package:sisko_v5/widgets/qr_scanner.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  //load .evn file
  await dotenv.load(fileName: "lib/.env");
  WidgetsFlutterBinding.ensureInitialized();
  //initialize sqlherlper
  SqLiteHelper dbhelper = SqLiteHelper();
  sqfliteFfiInit();
  await dbhelper.initDB();
  //check login
  bool islogin = await dbhelper.islogin();
  //Get shared preferences theme
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Initialize theme provider
  ThemeProvider themeProvider = ThemeProvider();
  //check dark theme
  bool isDarkTheme = prefs.getBool('isDark') ?? false;
  if (isDarkTheme) {
    themeProvider.themeData = darkMode;
  }
//multi provider
  await initializeDateFormatting('id_ID', null)
      .then((_) => runApp(MultiProvider(
            providers: [
              ChangeNotifierProvider<ThemeProvider>.value(
                value: themeProvider,
              ),
              ChangeNotifierProvider(
                create: (context) => ThemeSwitchProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => AuthProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => UserInfoProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => SqliteUserProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => BeritaProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => PengumumanProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => KelasProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => PresensiProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => KonselingProvider(),
              ),
            ],
            child: MyApp(
              islogedin: islogin,
            ),
          )));
}

class MyApp extends StatelessWidget {
  final bool islogedin;
  const MyApp({super.key, required this.islogedin});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, _) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeProvider.themeData,
        routes: {
          '/': (context) => islogedin ? const MainPage() : const Login(),
          '/signup': (context) => const SignUp(),
          '/forget-password': (context) => const ForgetPassword(),
          '/main': (context) => const MainPage(),
          '/home': (context) => const HomePage(),
          '/myschool': (context) => const MyschoolPage(),
          '/account': (context) => const AccountPage(),
          '/biodata': (context) => const BiodataPage(),
          '/qr-scanner': (context) => const QrScanner(),
          '/news': (context) => const News(),
          '/blog': (context) => const Blog(),
          '/about': (context) => const About(),
          '/kebijakan-privasi': (context) => const KebijakanPrivasi(),
          '/pusat-bantuan': (context) => const PusatBantuan(),
          '/landingpage': (context) => const SchoolLandingPage(),
          '/form-pengumuman': (context) => const FormPengumuman(),
          '/form-teras-sekolah': (context) => const FormTerasSekolah(),
          '/form-edit-berita': (context) => const FormEditTerasSekolah(),
          '/form-edit-pengumuman': (context) => const FormEditPengumuman(),
          '/form-pengembalian': (context) => const FormPengembalian(),
          '/form-peminjaman': (context) => const FormPeminjaman(),
          '/form-photo-profile': (context) => const FormPhotoProfile(),
          '/form-ubah-password': (context) => const FormUbahPassword(),
          '/form-ubah-no-hp': (context) => const FormUbahNoHp(),
          '/form-biodata': (context) => const FormBiodata(),
          '/form-konseling': (context) => const FormKonseling(),
          '/form-konseling-add': (context) => const FormKonselingAdd(),
          '/form-edit-konseling': (context) => const FormKonselingEdit(),
          '/form-uks': (context) => const FormUks(),
          '/form-uks-gr': (context) => const FormUksGr(),
          '/form-uks-edit': (context) => const FormEditUks(),
          '/form-uks-edit-gr': (context) => const FormEditUksGr(),
          '/form-add-nilai': (context) => const FormAddNilai(),
          '/form-edit-komunikasi-umum': (context) =>
              const FormEditKomunikasiUmum(),
          '/form-komunikasi-umum': (context) => const FormKomunikasiUmumAdd(),
          '/list-pengumuman': (context) => const ListPengumuman(),
          '/list-teras-sekolah': (context) => const ListTerasSekolah(),
          '/list-kelas': (context) => const ListKelas(),
          '/list-presensi': (context) => const ListPresensi(),
          '/list-konseling': (context) => const ListKonseling(),
          '/list-jadwal': (context) => const ListJadwal(),
          '/list-nilai': (context) => const ListNilai(),
          '/list-perpustakaan': (context) => const ListPerpustakaan(),
          '/list-akademik': (context) => const ListAkademik(),
          '/list-uks': (context) => const ListUks(),
          '/list-komunikasi': (context) => const ListKomunikasi(),
          '/list-keuangan': (context) => const ListKuangan(),
          '/list-polling': (context) => const ListPolling(),
          '/list-cctv': (context) => const ListCCTV(),
          '/list-monitoring': (context) => const ListMonitoring(),
          '/list-notifikasi': (context) => const ListNotifikasi(),
          '/list-show-jam-pelajaran': (context) => const ListShowJamPelajaran(),
          '/list-jenis-nilai': (context) => const ListJenisNilai(),
          '/view-pengumuman': (context) => const DetailPengumuman(),
          '/view-teras-sekolah': (context) => const DetailTerasSekolah(),
          '/view-kelas': (context) => const DetailKelas(),
          '/view-presensi-kelas-open': (context) => const DetailPresensiOpen(),
          '/view-konseling': (context) => const DetailKonseling(),
          '/view-uks': (context) => const DetailUks(),
          '/view-komunikasi-umum': (context) => const DetailKomunikasiUmum(),
          '/jenis-mapel': (context) => const ListNilaiMapel(),
          '/uks-list-kelas': (context) => const UksListKelas(),
        },
      );
    });
  }
}
