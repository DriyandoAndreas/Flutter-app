import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/school_rating_provider.dart';
import 'package:app5/providers/sekolahinfo_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:app5/services/school_rating_service.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class FormRatingSat extends StatefulWidget {
  const FormRatingSat({super.key});

  @override
  State<FormRatingSat> createState() => _FormRatingSatState();
}

class _FormRatingSatState extends State<FormRatingSat> {
  bool isLoading = false;
  Map<String, dynamic> rateMap = {};
  TextEditingController komentar = TextEditingController();
  TextEditingController commented = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var npsn = user.currentuser.siskonpsn;
    var token = user.currentuser.token;

    if (npsn != null && token != null) {
      context.read<SchoolRatingProvider>().getRate(token: token, npsn: npsn);
      context.read<SekolahInfoProvider>().getInfoTop(token: token, npsn: npsn);
      context
          .read<SchoolRatingProvider>()
          .getReviewer(token: token, npsn: npsn);
    }
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Consumer<SekolahInfoProvider>(
          builder: (context, provider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(provider.infotop.sekolah ?? ''),
                Text(
                  provider.infotop.npsn ?? '',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Consumer<SchoolRatingProvider>(
            builder: (context, value, child) {
              var fasilitas =
                  double.parse(value.rating?.review?.fasilitas ?? '0') / 2;
              var pelayanan =
                  double.parse(value.rating?.review?.pelayanan ?? '0') / 2;
              var lokasi =
                  double.parse(value.rating?.review?.lokasi ?? '0') / 2;
              var konidsibangunan =
                  double.parse(value.rating?.review?.kondisibangunan ?? '0') /
                      2;
              var pengajaran =
                  double.parse(value.rating?.review?.pengajaran ?? '0') / 2;

              return Column(
                children: [
                  Center(
                    child: buildGauge(),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  buildRate('Fasilitas', fasilitas, 'fasilitas'),
                  const SizedBox(
                    height: 12,
                  ),
                  buildRate('Pelayanan', pelayanan, 'pelayanan'),
                  const SizedBox(
                    height: 12,
                  ),
                  buildRate('Lokasi', lokasi, 'lokasi'),
                  const SizedBox(
                    height: 12,
                  ),
                  buildRate(
                      'Kondisi Bangunan', konidsibangunan, 'kondisi_bangunan'),
                  const SizedBox(
                    height: 12,
                  ),
                  buildRate('Pengajaran', pengajaran, 'pengajaran'),
                  const SizedBox(
                    height: 12,
                  ),
                  comments(),
                  const SizedBox(
                    height: 32,
                  ),
                  submit(),
                  const SizedBox(
                    height: 32,
                  ),
                  buildListReviewer()
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildGauge() {
    return Consumer<SchoolRatingProvider>(
      builder: (context, provider, child) {
        if (provider.rating == null) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        var ratedata = provider.rating?.data?.rate ?? '0';
        var rate = double.parse(ratedata);
        return Column(
          children: [
            SizedBox(
              width: 160,
              height: 160,
              child: SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                    showLabels: false,
                    showTicks: false,
                    startAngle: 270,
                    endAngle: 270,
                    radiusFactor: 0.8,
                    minimum: 0,
                    maximum: 100,
                    axisLineStyle: const AxisLineStyle(
                      thicknessUnit: GaugeSizeUnit.factor,
                      thickness: 0.15,
                    ),
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                        angle: 180,
                        widget: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  rate.toStringAsFixed(0),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                    pointers: <GaugePointer>[
                      RangePointer(
                        value: rate,
                        cornerStyle: CornerStyle.bothCurve,
                        enableAnimation: true,
                        animationDuration: 1200,
                        sizeUnit: GaugeSizeUnit.factor,
                        gradient: SweepGradient(
                          colors: <Color>[
                            Colors.amber,
                            Colors.amber.shade800,
                          ],
                          stops: const <double>[0.25, 0.75],
                        ),
                        color: const Color(0xFF00A8B5),
                        width: 0.15,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              '${provider.rating?.keterangan}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
                'berdasarkan dari ${provider.rating?.data?.komentar} comments dan ${provider.rating?.data?.reviewer} reviews'),
          ],
        );
      },
    );
  }

  Widget buildRate(String label, double initialrate, String param) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label),
          const SizedBox(
            height: 12,
          ),
          RatingBar.builder(
            itemSize: 40,
            initialRating: initialrate,
            itemCount: 5,
            itemBuilder: (context, index) {
              return const Icon(
                Icons.star,
                color: Colors.amber,
              );
            },
            onRatingUpdate: (value) {
              setState(() {
                rateMap[param] = value * 2;
              });
            },
          )
        ],
      ),
    );
  }

  Widget comments() {
    return Consumer<SchoolRatingProvider>(
      builder: (context, value, child) {
        var iscommented = false;
        if (value.rating?.review?.komentar != null &&
            value.rating?.review?.komentar != '') {
          commented.text = value.rating?.review?.komentar ?? '';
          iscommented = true;
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Komentar'),
              SizedBox(
                height: 50,
                child: TextFormField(
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.tertiary),
                  controller: iscommented ? commented : komentar,
                  decoration: const InputDecoration(
                      hintText: 'Tuliskan komentar anda',
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget submit() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: TextButton(
          onPressed: () async {
            final scaffold = ScaffoldMessenger.of(context);
            SchoolRatingService service = SchoolRatingService();
            final user =
                Provider.of<SqliteUserProvider>(context, listen: false);
            var npsn = user.currentuser.siskonpsn;
            var token = user.currentuser.token;
            var iduser = user.currentuser.iduser;
            setState(() {
              isLoading = true;
            });
            if (npsn != null && token != null && iduser != null) {
              await service.addComments(
                action: 'add-review',
                token: token,
                npsn: npsn,
                data: rateMap,
                komentar: komentar.text,
              );

              scaffold.showSnackBar(
                SnackBar(
                  // ignore: use_build_context_synchronously
                  backgroundColor:
                      // ignore: use_build_context_synchronously
                      Theme.of(context).colorScheme.primary,
                  content: Text('Berhasil ditambahkan',
                      style: TextStyle(
                          // ignore: use_build_context_synchronously
                          color: Theme.of(context).colorScheme.onPrimary)),
                ),
              );
              // ignore: use_build_context_synchronously
              context
                  .read<SchoolRatingProvider>()
                  .getRate(token: token, npsn: npsn);
              // ignore: use_build_context_synchronously
              context
                  .read<SekolahInfoProvider>()
                  .getInfoTop(token: token, npsn: npsn);
              // ignore: use_build_context_synchronously
              context
                  .read<SchoolRatingProvider>()
                  .getReviewer(token: token, npsn: npsn);
            }
            setState(() {
              isLoading = false;
            });
          },
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(8)),
            backgroundColor: const Color.fromARGB(255, 73, 72, 72),
          ),
          child: isLoading
              ? const CircularProgressIndicator.adaptive()
              : const Text(
                  'POST REVIEW',
                  style: TextStyle(color: Colors.white),
                ),
        ),
      ),
    );
  }

  Widget buildListReviewer() {
    return Consumer<SchoolRatingProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Reviewer',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 12,
              ),
              ListView.separated(
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 12,
                  );
                },
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.reviewer.length,
                itemBuilder: (context, index) {
                  var data = provider.reviewer[index];
                  var skor = double.parse(data.skor ?? '0');
                  var tanggal = DateTime.parse(data.tanggal ?? '2024-01-01');
                  var formatedtanggal =
                      DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(tanggal);
                  return Card(
                    color: Theme.of(context).colorScheme.onPrimary,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                color: const Color.fromARGB(255, 82, 82, 82),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      formatedtanggal,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          fontSize: 16),
                                    ),
                                    Card(
                                      color: Colors.blue.shade400,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 4),
                                        child: Text(skor.toStringAsFixed(1),
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                                fontSize: 14)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  data.komentar ?? 'Hanya memberi rating',
                                ),
                              ),
                              const Divider(
                                thickness: 0.1,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Text(data.nama ?? '',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary)),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
