import 'dart:io';
import 'package:app5/pages_detail/gac/view_monitoring_akademik_presensi_detail.dart';
import 'package:app5/pages_detail/gac/view_surat_sakit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app5/database/sqlite_helper.dart';
import 'package:app5/pages/biodata_page.dart';
import 'package:app5/pages/join_page.dart';
import 'package:app5/pages/school_connect.dart';
import 'package:app5/pages/school_landing_page.dart';
import 'package:app5/pages_detail/gac/view_detail_kelas.dart';
import 'package:app5/pages_detail/gac/view_komunikasi_tahfidz.dart';
import 'package:app5/pages_detail/gac/view_komunikasi_umum.dart';
import 'package:app5/pages_detail/gac/view_koneksi_phone.dart';
import 'package:app5/pages_detail/gac/view_konseling.dart';
import 'package:app5/pages_detail/gac/view_monitoring_30day.dart';
import 'package:app5/pages_detail/gac/view_monitoring_activity_summary.dart';
import 'package:app5/pages_detail/gac/view_monitoring_akademik.dart';
import 'package:app5/pages_detail/gac/view_monitoring_aktifitas.dart';
import 'package:app5/pages_detail/gac/view_monitoring_presensi_karyawan.dart';
import 'package:app5/pages_detail/gac/view_monitoring_presensi_siswa.dart';
import 'package:app5/pages_detail/gac/view_pengumuman.dart';
import 'package:app5/pages_detail/gac/view_detail_presensi_kelas.dart';
import 'package:app5/pages_detail/gac/view_polling.dart';
import 'package:app5/pages_detail/gac/view_progress_implementasi.dart';
import 'package:app5/pages_detail/gac/view_referral_edukasi.dart';
import 'package:app5/pages_detail/gac/view_referral_sekolah_aktif.dart';
import 'package:app5/pages_detail/gac/view_referral_sekolah_belum_aktif.dart';
import 'package:app5/pages_detail/gac/view_referral_withdraw_komisi.dart';
import 'package:app5/pages_detail/gac/view_teras_sekolah.dart';
import 'package:app5/pages_detail/gac/view_uks.dart';
import 'package:app5/pages_detail/sat/view_kelas.dart';
import 'package:app5/pages_detail/sat/view_komunikasi_tahfidz.dart';
import 'package:app5/pages_detail/sat/view_komunikasi_umum.dart';
import 'package:app5/pages_detail/sat/view_kwitansi.dart';
import 'package:app5/pages_detail/sat/view_nilai.dart';
import 'package:app5/pages_detail/sat/view_polling.dart';
import 'package:app5/pages_form/gac/form_add_komunikasi_tahfidz.dart';
import 'package:app5/pages_form/gac/form_add_polling.dart';
import 'package:app5/pages_form/gac/form_edit_komunikasi_tahfidz.dart';
import 'package:app5/pages_form/gac/form_add_nilai.dart';
import 'package:app5/pages_form/gac/form_biodata.dart';
import 'package:app5/pages_form/gac/form_edit_komunikasi_umum.dart';
import 'package:app5/pages_form/gac/form_edit_pengumuman.dart';
import 'package:app5/pages_form/gac/form_edit_polling.dart';
import 'package:app5/pages_form/gac/form_edit_teras_sekolah.dart';
import 'package:app5/pages_form/gac/form_edit_uks.dart';
import 'package:app5/pages_form/gac/form_edit_uks_gr.dart';
import 'package:app5/pages_form/gac/form_komunikasi_umum_add.dart';
import 'package:app5/pages_form/gac/form_konseling.dart';
import 'package:app5/pages_form/gac/form_konseling_kelas_add.dart';
import 'package:app5/pages_form/gac/form_konseling_kelas_edit.dart';
import 'package:app5/pages_form/gac/form_peminjaman.dart';
import 'package:app5/pages_form/gac/form_pengembalian.dart';
import 'package:app5/pages_form/gac/form_pengumuman_add.dart';
import 'package:app5/pages_form/gac/form_persiapan_akademik.dart';
import 'package:app5/pages_form/gac/form_photo_profile.dart';
import 'package:app5/pages_form/gac/form_rating.dart';
import 'package:app5/pages_form/gac/form_teras_sekolah_add.dart';
import 'package:app5/pages_form/gac/form_ubah_no_hp.dart';
import 'package:app5/pages_form/gac/form_ubah_password.dart';
import 'package:app5/pages_form/gac/form_uks_gr.dart';
import 'package:app5/pages_form/gac/form_uks.dart';
import 'package:app5/pages_form/sat/form_kuangan.dart';
import 'package:app5/pages_form/sat/form_rating.dart';
import 'package:app5/pages_list/gac/list_akademik.dart';
import 'package:app5/pages_list/gac/list_jadwal.dart';
import 'package:app5/pages_list/gac/list_jenis_nilai.dart';
import 'package:app5/pages_list/gac/list_kelas.dart';
import 'package:app5/pages_list/sat/list_akademik.dart';
import 'package:app5/pages_list/sat/list_berita.dart';
import 'package:app5/pages_list/sat/list_jadwal.dart';
import 'package:app5/pages_list/sat/list_kelas.dart';
import 'package:app5/pages_list/sat/list_keuangan.dart';
import 'package:app5/pages_list/gac/list_komunikasi.dart';
import 'package:app5/pages_list/gac/list_konseling.dart';
import 'package:app5/pages_list/gac/list_monitoring.dart';
import 'package:app5/pages_list/gac/list_nilai.dart';
import 'package:app5/pages_list/gac/list_nilai_mapel.dart';
import 'package:app5/pages_list/gac/list_pengumuman.dart';
import 'package:app5/pages_list/gac/list_perpustakaan.dart';
import 'package:app5/pages_list/gac/list_polling.dart';
import 'package:app5/pages_list/gac/list_presensi.dart';
import 'package:app5/pages_list/gac/list_show_jam_pelajaran.dart';
import 'package:app5/pages_list/gac/list_teras_sekolah.dart';
import 'package:app5/pages_list/gac/list_uks.dart';
import 'package:app5/pages/account_page.dart';
import 'package:app5/pages/forget_password_page.dart';
import 'package:app5/pages/home_page.dart';
import 'package:app5/pages/main_page.dart';
import 'package:app5/pages/login_page.dart';
import 'package:app5/pages/myschool_page.dart';
import 'package:app5/pages/signup_page.dart';
import 'package:app5/pages_list/gac/list_uks_kelas.dart';
import 'package:app5/pages_list/sat/list_komunikasi.dart';
import 'package:app5/pages_list/sat/list_konseling.dart';
import 'package:app5/pages_list/sat/list_nilai.dart';
import 'package:app5/pages_list/sat/list_nilai_menu.dart';
import 'package:app5/pages_list/sat/list_pengumuman.dart';
import 'package:app5/pages_list/sat/list_perpus.dart';
import 'package:app5/pages_list/sat/list_polling.dart';
import 'package:app5/pages_list/sat/list_presensi.dart';
import 'package:app5/pages_list/sat/list_uks.dart';
import 'package:app5/providers/akademik_provider.dart';
import 'package:app5/providers/auth_provider.dart';
import 'package:app5/providers/berita_provider.dart';
import 'package:app5/providers/biodata_provider.dart';
import 'package:app5/providers/card_tagihan_provider.dart';
import 'package:app5/providers/jadwal_provider.dart';
import 'package:app5/providers/kelas_provider.dart';
import 'package:app5/providers/keuangan_proivder_widget.dart';
import 'package:app5/providers/keuangan_provider.dart';
import 'package:app5/providers/komunikasi_provider.dart';
import 'package:app5/providers/konseling_provider.dart';
import 'package:app5/providers/monitoring_provider.dart';
import 'package:app5/providers/nilai_provider.dart';
import 'package:app5/providers/pengumuman_provider.dart';
import 'package:app5/providers/perpus_provider.dart';
import 'package:app5/providers/playlist_belajar_provider.dart';
import 'package:app5/providers/playlist_mengajar_provider_today.dart';
import 'package:app5/providers/playlist_mengajar_provider_tomorrow.dart';
import 'package:app5/providers/playlist_mengajar_provider_tomorrow_after.dart';
import 'package:app5/providers/polling_provider.dart';
import 'package:app5/providers/presensi_provider.dart';
import 'package:app5/providers/referral_provider.dart';
import 'package:app5/providers/referral_view_provider.dart';
import 'package:app5/providers/school_landingpage_provider.dart';
import 'package:app5/providers/school_rating_provider.dart';
import 'package:app5/providers/sekolahinfo_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:app5/providers/theme_switch_provider.dart';
import 'package:app5/providers/theme_provider.dart';
import 'package:app5/providers/uks_provider.dart';
import 'package:app5/providers/user_connection_provider.dart';
import 'package:app5/providers/user_info_provider.dart';
import 'package:app5/providers/user_provider.dart';
import 'package:app5/utils/theme.dart';
import 'package:app5/webview/webview_blog.dart';
import 'package:app5/webview/webview_invoice.dart';
import 'package:app5/webview/webview_kebijakan_privasi.dart';
import 'package:app5/webview/webview_news.dart';
import 'package:app5/webview/webview_pusat_bantuan.dart';
import 'package:app5/widgets/about_app.dart';
import 'package:app5/widgets/form_referral.dart';
import 'package:app5/widgets/qr_scanner.dart';
import 'package:app5/widgets/referral_link.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  //load .evn file
  await dotenv.load(fileName: "lib/.env");
  WidgetsFlutterBinding.ensureInitialized();
  //initialize sqlherlper
  SqLiteHelper dbhelper = SqLiteHelper();
  // sqfliteFfiInit();
  // check the platform it's not mobile device
  if (!kIsWeb && (Platform.isLinux || Platform.isMacOS || Platform.isWindows)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
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
  // Check if permission has already been requested
  bool hasRequestedPermission =
      prefs.getBool('hasRequestedPermission') ?? false;
  if (!hasRequestedPermission) {
    // Request notification permission
    var status = await Permission.notification.status;
    if (status.isDenied) {
      // Request permission from the user
      await Permission.notification.request();
    }

    // Mark that permission has been requested
    await prefs.setBool('hasRequestedPermission', true);
  }
//multi provider
  await initializeDateFormatting('id_ID', null)
      .then((_) => runApp(MultiProvider(
            providers: [
              ///*****Gac Provider */
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
              ChangeNotifierProvider(
                create: (context) => JadwalProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => NilaiProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => PerpusProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => UksProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => KomunikasiProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => PollingProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => MonitoringProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => AkademikProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => SekolahInfoProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => ReferralProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => ReferralViewProvider(),
              ),

              ChangeNotifierProvider(
                create: (context) => PlaylistMengajarProviderToday(),
              ),
              ChangeNotifierProvider(
                create: (context) => PlaylistMengajarProviderTomorrow(),
              ),
              ChangeNotifierProvider(
                create: (context) => PlaylistMengajarProviderTomorrowAfter(),
              ),

              ChangeNotifierProvider(
                create: (context) => BoidataProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => SchoolRatingProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => SchoolLandingpageProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => UserConnectionProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => UserProvider(),
              ),

              ///*****Sat Provider */
              ChangeNotifierProvider(
                create: (context) => KeuanganProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => SatKeuanganWidgetProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => KelasSatProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => SatPresensiProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => SatKonselingProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => SatJadwalProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => SatNilaiProivder(),
              ),
              ChangeNotifierProvider(
                create: (context) => SatPerpusProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => SatUksProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => SatKomunikasiProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => SatPollingProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => CardTagihanProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => SatPlayListBelajarProvider(),
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
          // *root route */
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
          '/join': (context) => const JoinPage(),
          '/school-connect': (context) => const SchoolConnect(),

          ///***** route Gac*/
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
          '/form-edit-komunikasi-tahfidz': (context) =>
              const FormEditKomunikasiTahfidz(),
          '/form-komunikasi-umum': (context) => const FormKomunikasiUmumAdd(),
          '/form-komunikasi-tahfidz': (context) =>
              const FormAddKomunikasiTahfidz(),
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
          '/list-polling': (context) => const ListPolling(),
          '/list-monitoring': (context) => const ListMonitoring(),
          '/list-show-jam-pelajaran': (context) => const ListShowJamPelajaran(),
          '/list-jenis-nilai': (context) => const ListJenisNilai(),
          '/view-pengumuman': (context) => const DetailPengumuman(),
          '/view-teras-sekolah': (context) => const DetailTerasSekolah(),
          '/view-kelas': (context) => const DetailKelas(),
          '/view-presensi-kelas-open': (context) => const DetailPresensiOpen(),
          '/view-konseling': (context) => const DetailKonseling(),
          '/view-uks': (context) => const DetailUks(),
          '/view-komunikasi-umum': (context) => const DetailKomunikasiUmum(),
          '/view-komunikasi-tahfidz': (context) =>
              const DetailKomunikasiTahfidz(),
          '/jenis-mapel': (context) => const ListNilaiMapel(),
          '/uks-list-kelas': (context) => const UksListKelas(),
          '/view-monitoring-aktifitas': (context) =>
              const ViewMonitoringAktifitas(),
          '/view-progress-implementasi': (context) =>
              const ViewProgressImplementasi(),
          '/view-koneksi-phone': (context) => const ViewMonitoringConnected(),
          '/view-monitoring-30day': (context) => const ViewMonitoring30Day(),
          '/view-activity-summary': (context) =>
              const ViewMonitoringActivitySummary(),
          '/view-monitoring-presensi-siswa': (context) =>
              const ViewMonitoringPresensiSiswa(),
          '/view-monitoring-presensi-karaywan': (context) =>
              const ViewMonitoringPresensiKaryawan(),
          '/view-monitoring-akademik': (context) =>
              const ViewMonitoringAkademik(),
          '/form-persiapan-akademik': (context) =>
              const FormPersiapanAkademik(),
          '/form-rating': (context) => const FormRatingGac(),
          '/form-referral': (context) => const FormReferral(),
          '/referral-link': (context) => const ReferralLink(),
          '/referral-view-sekolah-aktif': (context) =>
              const ViewReferralSekolahAktif(),
          '/referral-view-sekolah-belum-aktif': (context) =>
              const ViewReferralSekolahBelumAktif(),
          '/referral-view-withdraw-komisi': (context) =>
              const ViewReferralWithdrawKomisi(),
          '/view-edukasi-referral': (context) => const ViewReferralEdukasi(),
          '/view-surat-sakit': (context) => const ViewSuratSakit(),
          '/view-monitoring-akademik-presensi-detail': (context) => const ViewMonitoringAkademikPresensiDetail(),

          //* route Sat*/
          '/list-keuangan': (context) => const ListKuangan(),
          '/form-invoice': (context) => const KueanganInvoice(),
          '/keuangan-kwitansi': (context) => const VIewKwitansi(),
          '/webview-kwitansi': (context) => const WebViewInvoice(),
          '/list-kelas-sat': (context) => const SatListKelas(),
          '/view-kelas-sat': (context) => const ViewSatKelas(),
          '/list-presensi-sat': (context) => const SatListPresensi(),
          '/list-konseling-sat': (context) => const SatListKonseling(),
          '/list-teras-sekolah-sat': (context) => const SatListBerita(),
          '/list-pengumuman-sat': (context) => const SatListPengumuman(),
          '/list-jadwal-sat': (context) => const SatListJadwal(),
          '/list-nilai-sat': (context) => const SatListNilai(),
          '/list-nilai-menu-sat': (context) => const SatNilaiMenu(),
          '/view-nilai': (context) => const SatViewNilai(),
          '/list-perpustakaan-sat': (context) => const SatListPerpus(),
          '/list-uks-sat': (context) => const SatListUks(),
          '/list-komunikasi-sat': (context) => const SatListKomunikasi(),
          '/list-polling-sat': (context) => const SatListPolling(),
          '/view-komunikasi-sat': (context) => const SatViewKomunikasiUmum(),
          '/view-polling-sat': (context) => const SatViewPolling(),
          '/view-tahfidz-sat': (context) => const SatViewKomunikasiTahfidz(),
          '/view-polling': (context) => const ViewPolling(),
          '/form-polling': (context) => const FormAddPolling(),
          '/form-edit-polling': (context) => const FormEditPolling(),
          '/sat-list-akademik': (context) => const SatListAkademik(),
          '/form-rating-sat': (context) => const FormRatingSat(),
        },
      );
    });
  }
}
