import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/referral_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:app5/providers/user_connection_provider.dart';
import 'package:app5/widgets/card_tagihan.dart';
import 'package:app5/widgets/pengumuman.dart';
import 'package:app5/widgets/playlist_belajar.dart';
import 'package:app5/widgets/playlist_mengajar.dart';
import 'package:app5/widgets/referral.dart';
import 'package:app5/widgets/referral_dashboard.dart';
import 'package:app5/widgets/teras_sekolah.dart';
import 'package:app5/widgets/today_pengumuman_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      fetchData();
      _isInit = false;
    }
  }

  Future<void> fetchData() async {
    await context.read<SqliteUserProvider>().fetchUser();
    // ignore: use_build_context_synchronously
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var id = user.currentuser.siskonpsn;
    var tokenss = user.currentuser.tokenss;
    final referraldashboard =
        // ignore: use_build_context_synchronously
        Provider.of<ReferralProvider>(context, listen: false);
    if (id != null && tokenss != null) {
      referraldashboard.getDashboard(id: id, tokenss: tokenss);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context);
    final referral = Provider.of<ReferralProvider>(context);
    final referraldashboard = Provider.of<ReferralProvider>(context);
    referral.getReferral();

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
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
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
      body: Consumer<UserConnectionProvider>(
        builder: (context, provider, child) {
          return RefreshIndicator(
            onRefresh: fetchData,
            child: provider.disconnected == true
                ? Center(
                    child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusDirectional.circular(24)),
                        backgroundColor: Colors.grey.shade800,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/join');
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'CONNNECT TO SCHOOL',
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                      ),
                    ),
                  ))
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 12,
                        ),
                        user.currentuser.siskostatuslogin == 's' ||
                                user.currentuser.siskostatuslogin == 'a' ||
                                user.currentuser.siskostatuslogin == 'i'
                            ? const CardTagihan()
                            : const SizedBox.shrink(),
                        const SizedBox(
                          height: 12,
                        ),
                        user.currentuser.siskostatuslogin == 's' ||
                                user.currentuser.siskostatuslogin == 'a' ||
                                user.currentuser.siskostatuslogin == 'i'
                            ? const SatPlayListBelajar()
                            : const PlaylistMengajar(),
                        const TodayPengumumanSlider(),
                        const Pengumuman(),
                        const TerasSekolah(),
                        referral.referral
                            ? referraldashboard.referraldashboard.status == '1'
                                ? const ReferralDashboard()
                                : const Referral()
                            : const SizedBox.shrink(),
                        const SizedBox(
                          height: 12,
                        )
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}
