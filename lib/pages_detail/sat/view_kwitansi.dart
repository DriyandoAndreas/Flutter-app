import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app5/models/keuangan_model.dart';
import 'package:app5/providers/keuangan_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

class VIewKwitansi extends StatefulWidget {
  const VIewKwitansi({super.key});

  @override
  State<VIewKwitansi> createState() => _VIewKwitansiState();
}

class _VIewKwitansiState extends State<VIewKwitansi> {
  var waktuexpired = '';
  var invoiceurl = '';
  var bookingstatus = '';
  var qrString = '';
  int biayaadmins = 0;
  int total = 0;
  bool isLoading = false;
  final now = DateTime.now();
  String getNamaBulan(int angkabulan) {
    DateTime date = DateTime(now.year, angkabulan);
    return DateFormat.MMMM('id_ID').format(date);
  }

  var currencyformatter = NumberFormat.currency(locale: 'id', symbol: 'Rp.');

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initdata();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initdata() async {
    await _loadData();
  }

  Future<void> _loadData() async {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var id = user.currentuser.siskonpsn;
    var tokenss = user.currentuser.tokenss;

    if (ModalRoute.of(context)!.settings.arguments != null) {
      ListKeuanganTransaksiModel kwitansi = ModalRoute.of(context)!
          .settings
          .arguments as ListKeuanganTransaksiModel;
      var param = kwitansi.trxid;

      if (id != null && tokenss != null && param != null) {
        setState(() {
          isLoading = true;
        });
        await context
            .read<KeuanganProvider>()
            .getKwitansi(id: id, tokenss: tokenss, param: param);
        if (!mounted) return;

        // ignore: use_build_context_synchronously
        var datas = context.read<KeuanganProvider>().listKwitansi.firstWhere(
              (element) => element.trxid == param,
            );
        var bookingStatus = datas.bookingstatus;
        var statusexpired = datas.waktuexpired;
        var invoiceurls = datas.invoiceurl;
        var qrstring = datas.qrstring;
        double biayaadmin = double.parse(datas.biayaadm!);
        double doubletotal = double.parse(datas.biaya!);
        int biayaadminint = 0;
        int totalint = 0;
        biayaadminint = biayaadmin.ceil();
        totalint = doubletotal.ceil();
        setState(() {
          waktuexpired = statusexpired!;
          biayaadmins = biayaadminint;
          total = totalint;
          invoiceurl = invoiceurls!;
          bookingstatus = bookingStatus!;
          if (qrstring != null) {
            qrString = qrstring;
          } else {
            qrString = '';
          }
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Payment Gateway'),
      ),
      body: isLoading
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: Skeletonizer(
                enabled: true,
                child: Center(
                  child: Card(
                    color: Theme.of(context).colorScheme.onPrimary,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12)),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                color: Theme.of(context).colorScheme.secondary,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Detail Transaksi',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Card(
                                      color: Colors.grey[300],
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        child: const Text(
                                          'LOADING',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              const Text('Lakukan pembayaran sebelum'),
                              const SizedBox(
                                height: 8,
                              ),
                              Container(
                                width: 100,
                                height: 20,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Column(
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: 3,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Container(
                                          width: 150,
                                          height: 20,
                                          color: Colors.grey[300],
                                        ),
                                        trailing: Container(
                                          width: 50,
                                          height: 20,
                                          color: Colors.grey[300],
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Text('Biaya Admin'),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 22),
                                        child: Container(
                                          width: 50,
                                          height: 20,
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Text('Total Biaya'),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 22),
                                        child: Container(
                                          width: 50,
                                          height: 20,
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    height: 50,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      'Powered by Xendit',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Center(
                      child: Card(
                        color: Theme.of(context).colorScheme.onPrimary,
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12)),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Detail Transaksi',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Card(
                                          color: bookingstatus == 'FAILED'
                                              ? Colors.amber
                                              : bookingstatus == 'PAID'
                                                  ? Colors.green.shade400
                                                  : Colors.red,
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            child: Text(
                                              bookingstatus == 'FAILED'
                                                  ? 'WAIT'
                                                  : bookingstatus,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  const Text('Lakukan pembayaran sebelum'),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    waktuexpired,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Consumer<KeuanganProvider>(
                                    builder: (context, kwt, child) {
                                      return Column(
                                        children: [
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: kwt
                                                .listInnerDataKwitansibulanan
                                                .length,
                                            itemBuilder: (context, index) {
                                              if (kwt
                                                  .listInnerDataKwitansibulanan
                                                  .isEmpty) {
                                                return const SizedBox.shrink();
                                              } else {
                                                final dataKwt =
                                                    kwt.listInnerDataKwitansibulanan[
                                                        index];
                                                int angkabulan =
                                                    int.parse(dataKwt.bulan!);
                                                String namaBulan =
                                                    getNamaBulan(angkabulan);
                                                double amount = double.parse(
                                                    dataKwt.amount!);

                                                return ListTile(
                                                  title: Text(
                                                      '[${dataKwt.kodeadm}] $namaBulan'),
                                                  trailing: Text(
                                                    currencyformatter
                                                        .format(amount),
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: kwt
                                                .listInnerDataKwitansilain
                                                .length,
                                            itemBuilder: (context, index) {
                                              if (kwt.listInnerDataKwitansilain
                                                  .isEmpty) {
                                                return const SizedBox.shrink();
                                              } else {
                                                final dataKwt =
                                                    kwt.listInnerDataKwitansilain[
                                                        index];
                                                double amount = double.parse(
                                                    dataKwt.amount!);
                                                return ListTile(
                                                  title: Text(
                                                      '[${dataKwt.kodeadm}] ${dataKwt.namaadm}'),
                                                  trailing: Text(
                                                    currencyformatter
                                                        .format(amount),
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16),
                                                child: Text('Biaya Admin'),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 22),
                                                child: Text(currencyformatter
                                                    .format(biayaadmins)),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16),
                                                child: Text('Total Biaya'),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 22),
                                                child: Text(
                                                  currencyformatter
                                                      .format(total),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  invoiceurl.isEmpty
                                      ? Center(
                                          child: QrImageView(data: qrString),
                                        )
                                      : const SizedBox.shrink(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      invoiceurl.isNotEmpty
                                          ? Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: TextButton(
                                                  style: TextButton.styleFrom(
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .primary,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      )),
                                                  onPressed: () {
                                                    Navigator.pushNamed(context,
                                                        '/webview-kwitansi',
                                                        arguments: <String,
                                                            dynamic>{
                                                          'invoiceurl':
                                                              invoiceurl
                                                        });
                                                  },
                                                  child: Text(
                                                      'PETUNJUK PEMBAYARAN',
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onPrimary,
                                                      ))),
                                            )
                                          : const SizedBox(
                                              width: 100,
                                              height: 50,
                                            ),
                                      const Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text(
                                          'Powered by Xendit',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
