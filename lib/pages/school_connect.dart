import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:app5/database/sqlite_helper.dart';
import 'package:app5/providers/school_landingpage_provider.dart';
import 'package:app5/providers/sekolahinfo_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:app5/providers/user_connection_provider.dart';
import 'package:app5/providers/user_provider.dart';

class SchoolConnect extends StatefulWidget {
  const SchoolConnect({super.key});

  @override
  State<SchoolConnect> createState() => _SchoolConnectState();
}

class _SchoolConnectState extends State<SchoolConnect> {
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadData();
  }

  Future<void> loadData() async {
    final Map<String, dynamic> arguments =
        // ignore: use_build_context_synchronously
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    var token = arguments['token'];
    var npsn = arguments['npsn'];
    if (npsn != null && token != null) {
      await context
          .read<SchoolLandingpageProvider>()
          .getSchoolHeader(npsn: npsn);
      if (!mounted) return;
      // ignore: use_build_context_synchronously
      await context
          .read<SekolahInfoProvider>()
          .getInfoTop(token: token, npsn: npsn);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dbhelper = SqLiteHelper();
    void showImageGallery(
        BuildContext context, int initialIndex, List<String?> imageUrls) {
      List<String> nonNullableUrls = imageUrls.whereType<String>().toList();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Stack(
            alignment: Alignment.topRight,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: PhotoViewGallery.builder(
                  itemCount: nonNullableUrls.length,
                  builder: (context, index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider: NetworkImage(nonNullableUrls[index]),
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image);
                      },
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: PhotoViewComputedScale.covered * 2,
                    );
                  },
                  backgroundDecoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                  ),
                  pageController: PageController(initialPage: initialIndex),
                ),
              ),
              // Close button
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Consumer<SchoolLandingpageProvider>(
        builder: (context, provider, child) {
          if (provider.data.isEmpty) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else {
            return Column(
              children: [
                if (provider.data.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      provider.data.first.url!.startsWith('https')
                          ? showImageGallery(
                              context,
                              0,
                              provider.data
                                  .map((imageData) => imageData.url)
                                  .toList(),
                            )
                          : null;
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Image.network(
                        provider.data.isNotEmpty &&
                                provider.data[0].url!.startsWith('https')
                            ? '${provider.data[0].url}'
                            : '', // Gambar default
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset('assets/Latar0-bw.png');
                        },
                      ),
                    ),
                  ),
                if (provider.data.length > 1)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (int i = 1; i < 4 && i < provider.data.length; i++)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              provider.data.first.url!.startsWith('https')
                                  ? showImageGallery(
                                      context,
                                      i,
                                      provider.data
                                          .map((imageData) => imageData.url)
                                          .toList(),
                                    )
                                  : null;
                            },
                            child: Image.network(
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                              provider.data.isNotEmpty &&
                                      provider.data[0].url!.startsWith('https')
                                  ? '${provider.data[i].url}'
                                  : '',
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset('assets/Latar$i-bw.png');
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                const SizedBox(
                  height: 8,
                ),
                Center(
                  child: Card(
                    color: Theme.of(context).colorScheme.onPrimary,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Consumer<SekolahInfoProvider>(
                      builder: (context, provider, child) {
                        String ratedata = provider.infotop.rate ?? '0';
                        double rate = double.parse(ratedata);
                        double ratingInStars = rate / 20.0;
                        var status = provider.infotop.status;
                        var bentuk = provider.infotop.bentuk;
                        if (status == 'S') {
                          status = 'Swasta';
                        } else {
                          status = 'Negeri';
                        }
                        return SizedBox(
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(12)),
                                child: Container(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 200,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              overflow: TextOverflow.ellipsis,
                                              provider.infotop.sekolah ?? '',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(height: 12),
                                            Row(
                                              children: [
                                                RatingBar.builder(
                                                  itemSize: 16,
                                                  initialRating: ratingInStars,
                                                  allowHalfRating: true,
                                                  minRating: 0,
                                                  maxRating: 100,
                                                  itemCount: 5,
                                                  itemBuilder:
                                                      (context, index) =>
                                                          const Icon(
                                                    Icons.star,
                                                    color: Colors.white,
                                                  ),
                                                  onRatingUpdate: (value) {
                                                    //
                                                  },
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  rate.toStringAsFixed(1),
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Card(
                                            color: Colors.blue,
                                            child: Padding(
                                              padding: const EdgeInsets.all(4),
                                              child: Text(
                                                  '${bentuk ?? ''} $status',
                                                  style: const TextStyle(
                                                      color: Colors.white)),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                              overflow: TextOverflow.ellipsis,
                                              provider.infotop.waktukbm ?? '',
                                              style: const TextStyle(
                                                  color: Colors.white)),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                        onTap: () {},
                                        child: Text(
                                            'Komentar ${provider.infotop.reviewer ?? ''}')),
                                    const Text('|'),
                                    const Text('|'),
                                    Text(
                                        'Akreditasi ${provider.infotop.akreditasi ?? ''}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadiusDirectional.circular(24)),
                          backgroundColor: Colors.amber.shade800,
                        ),
                        onPressed: () async {
                          final user = Provider.of<SqliteUserProvider>(context,
                              listen: false);

                          final Map<String, dynamic> arguments =
                              // ignore: use_build_context_synchronously
                              ModalRoute.of(context)!.settings.arguments
                                  as Map<String, dynamic>;
                          var token = arguments['token'];
                          var npsn = arguments['npsn'];
                          var hp = user.currentuser.hp;
                          var nomor = user.currentuser.nomorsc;
                          var emailuser = user.currentuser.email;

                          try {
                            setState(() {
                              isLoading = true;
                            });
                            if (token != null &&
                                npsn != null &&
                                hp != null &&
                                nomor != null &&
                                emailuser != null) {
                              await context.read<UserProvider>().getJoinData(
                                    token: token,
                                    action: 'connect',
                                    npsn: npsn,
                                    hp: hp,
                                    nomor: nomor,
                                    emailuser: emailuser,
                                  );
                              if (!mounted) return;
                              final joindata =
                                  // ignore: use_build_context_synchronously
                                  Provider.of<UserProvider>(context,
                                      listen: false);
                              var iduser = joindata.join?.siskoid;
                              var siskonpsn = joindata.join?.siskonpsn;
                              var siskokode = joindata.join?.siskokode;
                              var siskostatuslogin =
                                  joindata.join?.siskostatuslogin;
                              var siskonamalengkap =
                                  joindata.join?.siskonamalengkap;
                              var siskokelas = joindata.join?.kelas;
                              if (iduser != null &&
                                  siskonpsn != null &&
                                  siskokode != null &&
                                  siskostatuslogin != null) {
                                await dbhelper.reconnectUser(
                                  iduser: iduser,
                                  siskonpsn: siskonpsn,
                                  siskokode: siskokode,
                                  siskostatuslogin: siskostatuslogin,
                                  siskonamalengkap: siskonamalengkap ?? '',
                                  siskokelas: siskokelas ?? ''
                                );
                              }
                            }
                            final userConnection =
                                // ignore: use_build_context_synchronously
                                context.read<UserConnectionProvider>();
                            userConnection.setDisconnect(false);
                            Restart.restartApp();
                            setState(() {
                              isLoading = false;
                            });
                            if (!mounted) return;
                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacementNamed(context, '/');
                          } catch (e) {
                            return;
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: isLoading
                              ? const CircularProgressIndicator.adaptive()
                              : const Text(
                                  'CONNNECT',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
