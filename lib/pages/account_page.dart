import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/database/sqlite_helper.dart';
import 'package:app5/pages/login_page.dart';
import 'package:app5/providers/referral_provider.dart';
import 'package:app5/providers/sekolahinfo_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:app5/providers/theme_switch_provider.dart';
import 'package:app5/providers/theme_provider.dart';
import 'package:app5/providers/user_connection_provider.dart';
import 'package:app5/widgets/version_app.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context);
    final dbhelper = SqLiteHelper();

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        automaticallyImplyLeading: false,
        title: const Text('Account'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/form-biodata');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage('${user.currentuser.photo}'),
                    onBackgroundImageError: (exception, stackTrace) {
                      const Icon(Icons.person);
                    },
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${user.currentuser.email}'),
                        Text('${user.currentuser.nama}'),
                        Text('${user.currentuser.hp}'),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 0.1,
            ),
            const AccessSchool(),
            const Divider(
              thickness: 0.1,
            ),
            const SizedBox(
              height: 16,
            ),
            const Text('Akun'),
            const Divider(
              thickness: 0.1,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/form-photo-profile');
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.person_rounded,
                    size: 30,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ubah Foto Profile'),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 0.1,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/form-ubah-password');
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.password,
                    size: 30,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ubah Password'),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 0.1,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/form-ubah-no-hp');
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.phone_android,
                    size: 30,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ubah Nomor HP'),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 0.1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.light_mode,
                  size: 30,
                ),
                const SizedBox(
                  width: 16,
                ),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Theme dark'),
                    ],
                  ),
                ),
                Switch(
                  value: context.watch<ThemeSwitchProvider>().isDark,
                  activeColor: context.watch<ThemeSwitchProvider>().isDark
                      ? Colors.white
                      : Colors.black,
                  onChanged: (bool value) {
                    context.read<ThemeSwitchProvider>().toggle(value);
                    context.read<ThemeProvider>().toggleTheme();
                  },
                ),
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.group,
                  size: 30,
                ),
                const SizedBox(
                  width: 16,
                ),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Referral'),
                    ],
                  ),
                ),
                Switch(
                  value: context.watch<ReferralProvider>().referral,
                  activeColor: context.watch<ThemeSwitchProvider>().isDark
                      ? Colors.white
                      : Colors.black,
                  onChanged: (bool value) {
                    context.read<ReferralProvider>().toggle(value);
                  },
                ),
              ],
            ),
            const Divider(
              thickness: 0.1,
            ),
            const SizedBox(
              height: 16,
            ),
            const Text('Info'),
            const Divider(
              thickness: 0.1,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/news');
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.newspaper,
                    size: 30,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('News'),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 0.1,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/blog');
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.rss_feed,
                    size: 30,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Blog'),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 0.1,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/kebijakan-privasi');
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.verified_user,
                    size: 30,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Kebijakan Privasi'),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 0.1,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/pusat-bantuan');
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.info,
                    size: 30,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pusat Bantuan'),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 0.1,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/about');
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.rocket_launch,
                    size: 30,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tentang Aplikasi'),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 0.1,
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                  });
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Kamu yakin ingin logout?'),
                        content: const Text('Apakah anda yakin ingin keluar?'),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              dbhelper.deletedb();
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const Login()));
                            },
                            child: const Text('Ya'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Tidak'),
                          )
                        ],
                      );
                    },
                  );
                  setState(() {
                    isLoading = false;
                  });
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.circular(8)),
                  backgroundColor: const Color.fromARGB(255, 216, 24, 24),
                ),
                child: isLoading
                    ? const CircularProgressIndicator.adaptive()
                    : const Text(
                        'Logout',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                child: const VersionApp()),
          ],
        ),
      ),
    );
  }
}

class AccessSchool extends StatelessWidget {
  const AccessSchool({super.key});

  @override
  Widget build(BuildContext context) {
    final dbhelper = SqLiteHelper();
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var token = user.currentuser.token;
    var npsn = user.currentuser.siskonpsn;
    if (token != null && npsn != null) {
      context.read<SekolahInfoProvider>().getInfoTop(token: token, npsn: npsn);
    }
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                padding: const EdgeInsets.all(16),
                height: 200,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.close))
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 150,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/landingpage');
                            },
                            style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadiusDirectional.circular(8)),
                                backgroundColor: Colors.grey.shade400),
                            child: const Text(
                              "Info",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                        'Kamu yakin ingin disconnect?'),
                                    content: const Text('Disconnect sekarang?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          dbhelper.disconnectUser();
                                          context
                                              .read<UserConnectionProvider>()
                                              .setDisconnect(true);

                                          Navigator.pushReplacementNamed(
                                              context, '/main');
                                        },
                                        child: const Text('Ya'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Tidak'),
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                            style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadiusDirectional.circular(8)),
                                backgroundColor: Colors.red.shade400),
                            child: const Text(
                              "Disconnect",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              );
            });
      },
      child: Consumer<SekolahInfoProvider>(
        builder: (context, provider, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.cloud_queue,
                size: 50,
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Access to school system'),
                    Text('${provider.infotop.sekolah}'),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),
            ],
          );
        },
      ),
    );
  }
}
