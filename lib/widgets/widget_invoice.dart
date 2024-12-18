import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:app5/providers/keuangan_proivder_widget.dart';
import 'package:app5/providers/sqlite_user_provider.dart';

class WidgetInvoice extends StatelessWidget {
  const WidgetInvoice({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var id = user.currentuser.siskonpsn;
    var tokenss = user.currentuser.tokenss;
    if (id != null && tokenss != null) {
      context
          .watch<SatKeuanganWidgetProvider>()
          .getDetialPembayaran(id: id, tokenss: tokenss);
    }
    final now = DateTime.now();
    String getNamaBulan(int angkabulan) {
      DateTime date = DateTime(now.year, angkabulan);
      return DateFormat.MMMM('id_ID').format(date);
    }

    var currencyformatter = NumberFormat.currency(locale: 'id', symbol: 'Rp.');
    return Center(child: Consumer<SatKeuanganWidgetProvider>(
      builder: (context, dtltrx, child) {
        if (dtltrx.listDetialKwitansi.isEmpty) {
          return const SizedBox.shrink();
        } else {
          bool isExpired = false;
          var data = dtltrx.listDetialKwitansi.first;
          var biayaadmins = (double.parse(data.biayaadm ?? '0')).ceil();
          var biaya = (double.parse(data.biaya ?? '0')).ceil();
          DateTime datenow = DateTime.now();
          DateTime dateexpired = DateTime.parse(data.waktuexpired!);
          if (datenow.isAfter(dateexpired)) {
            isExpired = true;
          }
          return Center(
            child: isExpired
                ? const SizedBox.shrink()
                : Card(
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
                                      color: data.bookingstatus == 'FAILED'
                                          ? Colors.amber
                                          : data.bookingstatus == 'PAID'
                                              ? Colors.green.shade400
                                              : Colors.red,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        child: Text(
                                          data.bookingstatus == 'FAILED'
                                              ? 'WAIT'
                                              : data.bookingstatus ?? '',
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
                                data.waktuexpired ?? '',
                                style: const TextStyle(color: Colors.red),
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
                                    itemCount:
                                        dtltrx.listInnerKwtbulanan.length,
                                    itemBuilder: (context, index) {
                                      if (dtltrx.listInnerKwtbulanan.isEmpty) {
                                        return const SizedBox.shrink();
                                      } else {
                                        final dataKwt =
                                            dtltrx.listInnerKwtbulanan[index];
                                        int angkabulan =
                                            int.parse(dataKwt.bulan!);
                                        String namaBulan =
                                            getNamaBulan(angkabulan);
                                        double amount =
                                            double.parse(dataKwt.amount!);
                                        return ListTile(
                                          title: Text(
                                              '[${dataKwt.kodeadm}] $namaBulan'),
                                          trailing: Text(
                                            currencyformatter.format(amount),
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: dtltrx.listInnerKwtlain.length,
                                    itemBuilder: (context, index) {
                                      if (dtltrx.listInnerKwtlain.isEmpty) {
                                        return const SizedBox.shrink();
                                      } else {
                                        final dataKwt =
                                            dtltrx.listInnerKwtlain[index];
                                        double amount =
                                            double.parse(dataKwt.amount!);
                                        return ListTile(
                                          title: Text(
                                              '[${dataKwt.kodeadm}] ${dataKwt.namaadm}'),
                                          trailing: Text(
                                            currencyformatter.format(amount),
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal),
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
                                        padding: const EdgeInsets.symmetric(
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 22),
                                        child: Text(
                                          currencyformatter.format(biaya),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              data.invoiceurl!.isEmpty
                                  ? Center(
                                      child: QrImageView(
                                          data: data.qrstring ?? ''),
                                    )
                                  : const SizedBox.shrink(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  data.invoiceurl!.isNotEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: TextButton(
                                              style: TextButton.styleFrom(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  )),
                                              onPressed: () {
                                                Navigator.pushNamed(context,
                                                    '/webview-kwitansi',
                                                    arguments: <String,
                                                        dynamic>{
                                                      'invoiceurl':
                                                          data.invoiceurl
                                                    });
                                              },
                                              child: Text('PETUNJUK PEMBAYARAN',
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
          );
        }
      },
    ));
  }
}
