import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/school_landingpage_provider.dart';
import 'package:app5/providers/sekolahinfo_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';

class SchoolLandingPage extends StatelessWidget {
  const SchoolLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var npsn = user.currentuser.siskonpsn;
    if (npsn != null) {
      context.read<SchoolLandingpageProvider>().getSchoolHeader(npsn: npsn);
    }

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
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: PhotoViewComputedScale.covered * 2,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image);
                      },
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
                    mainAxisSize: MainAxisSize.min,
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
                                  : '', // Gambar default
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                    'assets/Latar$i-bw.png'); // Gambar default jika error
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
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
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
                                                itemBuilder: (context, index) =>
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
                                          Text(provider.infotop.waktukbm ?? '',
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
                                        onTap: () {
                                          user.currentuser.siskostatuslogin ==
                                                  'g'
                                              ? Navigator.pushNamed(
                                                  context, '/form-rating')
                                              : Navigator.pushNamed(
                                                  context, '/form-rating-sat');
                                        },
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
                )
              ],
            );
          }
        },
      ),
    );
  }
}
