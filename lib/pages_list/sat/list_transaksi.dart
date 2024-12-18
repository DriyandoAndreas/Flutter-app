import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/keuangan_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';

class ListTransaksi extends StatelessWidget {
  const ListTransaksi({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var id = user.currentuser.siskoid;
    var tokenss = user.currentuser.tokenss;
    if (id != null && tokenss != null) {
      context
          .watch<KeuanganProvider>()
          .getListTransaksi(id: id, tokenss: tokenss);
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: buildList(),
      ),
    );
  }

  Widget buildList() {
    return Consumer<KeuanganProvider>(builder: (context, trx, child) {
      if (trx.listTrx.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Keterangan'),
              Row(
                children: [
                  Card(
                    color: Colors.amber,
                    child: SizedBox(
                      width: 100,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Center(
                            child: Text('WAIT',
                                style: TextStyle(color: Colors.white))),
                      ),
                    ),
                  ),
                  Text('Menunggu di bayar'),
                ],
              ),
              Row(
                children: [
                  Card(
                    color: Colors.green,
                    child: SizedBox(
                      width: 100,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Center(
                            child: Text('PAID',
                                style: TextStyle(color: Colors.white))),
                      ),
                    ),
                  ),
                  Text('Terbayar'),
                ],
              ),
              Row(
                children: [
                  Card(
                    color: Colors.red,
                    child: SizedBox(
                      width: 100,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Center(
                          child: Text('EXPIRED',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                  Text('Kadaluarsa'),
                ],
              ),
              Row(
                children: [
                  Card(
                    color: Colors.grey,
                    child: SizedBox(
                      width: 100,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Center(
                          child: Text('FAILED',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                  Text('Gagal'),
                ],
              ),
            ],
          ),
        );
      }
      return ListView.builder(
        itemCount: trx.listTrx.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final transaksi = trx.listTrx[index];
          double data = double.parse(transaksi.biaya!);
          var biaya = NumberFormat.currency(locale: 'id', symbol: 'Rp.');
          return Column(
            children: [
              ListTile(
                onTap: () {
                  Navigator.pushNamed(context, '/keuangan-kwitansi',
                      arguments: transaksi);
                },
                leading: transaksi.bookingSts == null
                    ? const Icon(Icons.timer_outlined)
                    : const Icon(Icons.check),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    transaksi.bookingSts == null
                        ? Text(
                            transaksi.waktuexpired ?? '',
                            style: const TextStyle(
                                color: Colors.red, fontSize: 10),
                          )
                        : const SizedBox.shrink(),
                    Text(biaya.format(data)),
                    Text(
                      transaksi.bookingdatetime ?? '',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: 12),
                    ),
                  ],
                ),
                trailing: Container(
                  width: 60,
                  height: 30,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(12),
                      color: transaksi.bookingstatus == 'FAILED'
                          ? Colors.amber
                          : transaksi.bookingstatus == 'PAID'
                              ? Colors.green
                              : Colors.red),
                  child: Center(
                      child: Text(
                          transaksi.bookingstatus == 'FAILED'
                              ? 'WAIT'
                              : '${transaksi.bookingstatus}',
                          style: const TextStyle(color: Colors.white))),
                ),
              )
            ],
          );
        },
      );
    });
  }
}
