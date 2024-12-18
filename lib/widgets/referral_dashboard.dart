import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/referral_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:share_plus/share_plus.dart';

class ReferralDashboard extends StatefulWidget {
  const ReferralDashboard({super.key});

  @override
  State<ReferralDashboard> createState() => _ReferralDashboardState();
}

class _ReferralDashboardState extends State<ReferralDashboard> {
  void showLink(String? refid) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 200,
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Close'))
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'https://register.sisko-online.com/aff_/$refid',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                        onPressed: () {
                          Share.share(
                              'https://register.sisko-online.com/aff_/$refid');
                        },
                        child: const Text(
                          'Bagikan',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showSekolah(String? reg, String? unreg) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 200,
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Close'))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            context, '/referral-view-sekolah-aktif');
                      },
                      child: SizedBox(
                        height: 100,
                        child: Card(
                          color: Colors.green,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                const Text(
                                  'Sudah aktif',
                                  style: TextStyle(color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  '$reg',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            context, '/referral-view-sekolah-belum-aktif');
                      },
                      child: SizedBox(
                        height: 100,
                        child: Card(
                          color: Colors.red,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                const Text(
                                  'Belum aktif',
                                  style: TextStyle(color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  '$unreg',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void showSiswa(String? reg, String? req) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 200,
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Close'))
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text('$reg/$req Siswa'),
              ),
            ],
          ),
        );
      },
    );
  }

  void showKomisi(String? komisi) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 200,
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Close'))
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Text('Rp. $komisi'),
                    const SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextButton(
                        style:
                            TextButton.styleFrom(backgroundColor: Colors.grey),
                        onPressed: () {
                          Navigator.pushNamed(
                              context, '/referral-view-withdraw-komisi');
                        },
                        child: const Text(
                          'WITHDRAW',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var id = user.currentuser.siskonpsn;
    var tokenss = user.currentuser.tokenss;
    if (id != null && tokenss != null) {
      context.read<ReferralProvider>().getDashboard(id: id, tokenss: tokenss);
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Consumer<ReferralProvider>(
          builder: (context, value, child) {
            var refid = value.referraldashboard.refid;
            var link = value.referraldashboard.link;
            var sekolah = value.referraldashboard.sekolah;
            var sekolahreq = value.referraldashboard.sudahregis;
            var sekolahunreg = value.referraldashboard.belumregis;
            var jumlahsiswa = value.referraldashboard.siswa ?? '0';
            var siswarequest = value.referraldashboard.siswareq ?? '0';
            var komisi = value.referraldashboard.komisi;
            int jumlahreq = int.parse(siswarequest);
            var members = '';
            Color memberstat = Colors.grey.shade400;
            if (jumlahreq < 7000) {
              members = 'Bronze Member';
              memberstat = Colors.grey.shade400;
            } else if (jumlahreq >= 7000 && jumlahreq <= 10000) {
              members = 'Silver Member';
              memberstat = Colors.white;
            } else {
              members = 'Gold Member';
              memberstat = Colors.amber.shade600;
            }
            return Column(
              children: [
                const Text(
                  'Referral Area',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          showLink(refid);
                        },
                        child: Card(
                          color: Theme.of(context).colorScheme.onPrimary,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                const Icon(Icons.link),
                                Text(
                                  '$link Click',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const Text('Link'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8), // Beri jarak antar card
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          showSekolah(sekolahreq, sekolahunreg);
                        },
                        child: Card(
                          color: Theme.of(context).colorScheme.onPrimary,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                const Icon(Icons.apartment),
                                Text(
                                  '$sekolahreq/$sekolah',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const Text('Sekolah Register'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8), // Jarak antar rows
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          showSiswa(siswarequest, jumlahsiswa);
                        },
                        child: Card(
                          color: Theme.of(context).colorScheme.onPrimary,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                const Icon(Icons.group),
                                Text(
                                  '$siswarequest/$jumlahsiswa',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const Text('Siswa'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8), // Beri jarak antar card
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          showKomisi(komisi);
                        },
                        child: Card(
                          color: Theme.of(context).colorScheme.onPrimary,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                Icon(Icons.star, color: memberstat),
                                Text(
                                  'Rp. $komisi',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                Text(members),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                    height: 8), // Jarak antar cards dan edukasi referral
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/view-edukasi-referral');
                  },
                  child: Card(
                    color: Theme.of(context).colorScheme.onPrimary,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Text('Edukasi Referral'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
