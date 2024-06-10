import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sisko_v5/providers/sqlite_user_provider.dart';
import 'package:sisko_v5/widgets/palapa_button.dart';
import 'package:sisko_v5/widgets/pengumuman.dart';
import 'package:sisko_v5/widgets/playlist_mengajar.dart';
import 'package:sisko_v5/widgets/teras_sekolah.dart';
import 'package:sisko_v5/widgets/today_pengumuman_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      loadUser();
      _isInit = false;
    }
  }

  // Inisialisasi data dari sqlite
  void loadUser() async {
    context.read<SqliteUserProvider>().fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context);
    getstatus(String? status) {
      switch (status) {
        case 'g':
          return 'Guru';

        case 's':
          return 'Siswa';

        case 'a':
          return 'Ayah';

        case 'i':
          return 'Ibu';

        default:
          return '';
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/form-photo-profile');
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage('${user.currentuser.photo}'),
                onBackgroundImageError: (exception, stackTrace) {
                  const Icon(Icons.person);
                },
              ),
            ),
          ],
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${user.currentuser.nama}'),
            Text(
              '${user.currentuser.hp} (${getstatus(user.currentuser.siskostatuslogin)})',
              style: const TextStyle(fontSize: 10),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/list-notifikasi');
            },
            child: const Icon(
              Icons.notifications_active_rounded,
              size: 30,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/qr-scanner');
            },
            child: const Icon(
              Icons.qr_code,
              size: 30,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            PalapaButton(),
            PlaylistMengajar(),
            TodayPengumumanSlider(),
            Pengumuman(),
            TerasSekolah(),
          ],
        ),
      ),
    );
  }
}
