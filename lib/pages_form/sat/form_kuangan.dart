import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app5/database/sqlite_helper.dart';
import 'package:app5/models/keuangan_model.dart';
import 'package:app5/models/sqlite_user_model.dart';
import 'package:app5/providers/keuangan_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:app5/services/keuangan_service.dart';

class KueanganInvoice extends StatefulWidget {
  const KueanganInvoice({super.key});

  @override
  State<KueanganInvoice> createState() => _KueanganInvoiceState();
}

class _KueanganInvoiceState extends State<KueanganInvoice> {
  final Map<String, bool> _checkboxStates = {};
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, int> _values = {};
  final Map<String, String> _bulananVal = {};
  final Map<String, String> _paymentvias = {};
  late SqLiteHelper _sqLiteHelper;
  late List<SqliteUserModel> _users = [];
  int ppn = 11;

  int totalTerbatas = 0;
  double totalBulanan = 0;
  dynamic totalPembayaran = 0;
  dynamic biayaAdm = 0;
  bool isInputValid = false;
  bool isLoading = false;
  bool isDataLoading = false;
  String? _selectedPaymentVia;

  @override
  void initState() {
    super.initState();
    _sqLiteHelper = SqLiteHelper();
    _initData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _loadUsers() async {
    try {
      final users = await _sqLiteHelper.getusers();
      setState(() {
        _users = users;
      });
    } catch (e) {
      return;
    }
  }

  Future<void> _initData() async {
    await _loadUsers();
    await _loadData();
  }

  void _updateTotalTerbatas() {
    setState(() {
      totalTerbatas =
          _values.values.fold(0.0, (sum, value) => sum + value).ceil();
      _recalculate();
    });
  }

  void _recalculate() {
    _updateBiayaAdm();
    _updateTotalPembayaran();
  }

  void _updateBiayaAdm() {
    if (_selectedPaymentVia != null) {
      final keuanganProvider =
          Provider.of<KeuanganProvider>(context, listen: false);
      final selectedPayment = keuanganProvider.listPaymentVias.firstWhere(
        (element) => element.title == _selectedPaymentVia,
      );
      if (selectedPayment.paymentadm?.fixed == true) {
        dynamic adm = selectedPayment.paymentadm?.price ?? 0;
        biayaAdm = double.parse(adm.toString());
        biayaAdm = biayaAdm.ceil();
      } else {
        var sumbulananterbatas = totalBulanan + totalTerbatas;
        dynamic adm = selectedPayment.paymentadm?.price ?? 0;
        biayaAdm = (adm / 100) * sumbulananterbatas;
        biayaAdm += (ppn / 100) * biayaAdm;
        biayaAdm = biayaAdm.ceil();
      }
    } else {
      biayaAdm = 0;
    }
  }

  void _updateTotalPembayaran() {
    setState(() {
      totalPembayaran = totalBulanan + totalTerbatas + biayaAdm;
      totalPembayaran = totalPembayaran.ceil();
    });
  }

  Future<void> _loadData() async {
    final currentUser = _users.isNotEmpty ? _users.first : null;
    String? id = currentUser?.siskonpsn;
    String? tokenss = currentUser?.tokenss;
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final ListKeuanganTagihanModel tagihan = ModalRoute.of(context)!
          .settings
          .arguments as ListKeuanganTagihanModel;
      var param = tagihan.thnPljrn;
      if (id != null && tokenss != null && param != null) {
        setState(() {
          isDataLoading = true;
        });
        await context
            .read<KeuanganProvider>()
            .getFormDetail(id: id, tokenss: tokenss, param: param);

        setState(() {
          isDataLoading = false;
        });
      }
    }
  }

  Future<void> refresh() async {
    try {
      _values.clear();
      _bulananVal.clear();
      _paymentvias.clear();
      _controllers.clear();
      _checkboxStates.clear();
      setState(() {
        biayaAdm = 0;
        totalBulanan = 0;
        totalTerbatas = 0;
        totalPembayaran = 0;
        _selectedPaymentVia = null;
      });
      await _loadData();
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Keuangan'),
      ),
      body: isDataLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : RefreshIndicator(
              onRefresh: refresh,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _groupList(),
                    const Divider(
                      thickness: 0.1,
                    ),
                    _groupListTerbatas(),
                    const Divider(
                      thickness: 0.1,
                    ),
                    _groupPaymentVias(),
                    const Divider(
                      thickness: 0.1,
                    ),
                    getTotalPembayaran(),
                  ],
                ),
              ),
            ),
    );
  }

  _groupList() {
    return Consumer<KeuanganProvider>(
      builder: (context, bln, child) {
        final now = DateTime.now();
        String getNamaBulan(int angkabulan) {
          DateTime date = DateTime(now.year, angkabulan);
          return DateFormat.MMMM('id_ID').format(date);
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: GroupedListView(
            elements: bln.listBulanan,
            groupBy: (element) => '[${element.kodeadm}]${element.namaadm}',
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            groupSeparatorBuilder: (String value) => Padding(
              padding: const EdgeInsets.all(8),
              child: Text(value),
            ),
            itemBuilder: (context, element) {
              double data = double.parse(element.tagihan.toString());
              int angkabulan = int.parse(element.bln.toString());
              String namaBulan = getNamaBulan(angkabulan);
              bool isPending = false;
              bool lunas = false;
              var biaya = NumberFormat.currency(locale: 'id', symbol: 'Rp.');
              var belumbayar = Colors.red.shade500;
              var dibayar = double.parse(element.dibayar!);
              var sisa = double.parse(element.sisa!);
              var pending = element.pending;
              if (dibayar >= sisa) {
                belumbayar = Colors.grey.shade200;
                _checkboxStates[element.kodeinv!] = true;
                lunas = true;
              }
              if (pending != false) {
                belumbayar = Colors.grey.shade200;
                isPending = true;
                lunas = false;
              }

              return Container(
                color: belumbayar,
                child: ListTile(
                  leading: isPending
                      ? const Icon(Icons.timer_outlined)
                      : Checkbox(
                          value: _checkboxStates[element.kodeinv] ?? false,
                          activeColor: lunas
                              ? Theme.of(context).colorScheme.tertiary
                              : Theme.of(context).colorScheme.primary,
                          onChanged: (value) {
                            setState(() {
                              _checkboxStates[element.kodeinv!] = value!;

                              String key =
                                  'bulanan[${element.nis}][${element.tahunaj}][${element.kodeadm}][${element.bln}]';

                              if (value) {
                                totalBulanan += double.parse(element.tagihan!);
                                _bulananVal[key] = element.tagihan!;
                              } else {
                                if (!lunas) {
                                  totalBulanan -=
                                      double.parse(element.tagihan!);
                                }
                                _bulananVal.remove(key);
                              }

                              _recalculate();
                            });
                          },
                        ),
                  title: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        namaBulan,
                        style: TextStyle(
                            fontSize: 12,
                            color: isPending
                                ? Theme.of(context).colorScheme.tertiary
                                : lunas
                                    ? Theme.of(context).colorScheme.tertiary
                                    : Theme.of(context).colorScheme.onPrimary),
                      ),
                      Text(
                        biaya.format(data),
                        style: TextStyle(
                            fontSize: 16,
                            color: isPending
                                ? Theme.of(context).colorScheme.tertiary
                                : lunas
                                    ? Theme.of(context).colorScheme.tertiary
                                    : Theme.of(context).colorScheme.onPrimary),
                      ),
                    ],
                  ),
                  trailing: isPending
                      ? Card(
                          color: Colors.amber,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            child: const Text(
                              'WAIT',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 11),
                            ),
                          ),
                        )
                      : lunas
                          ? Card(
                              color: Colors.green.shade200,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                child: const Text(
                                  'PAID',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 11),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                ),
              );
            },
          ),
        );
      },
    );
  }

  _groupListTerbatas() {
    return Consumer<KeuanganProvider>(
      builder: (context, terbatas, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: GroupedListView(
            elements: terbatas.listTerbatas,
            groupBy: (element) => '[${element.kodeadm}]${element.namaadm}',
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            groupSeparatorBuilder: (String value) => Padding(
              padding: const EdgeInsets.all(8),
              child: Text(value),
            ),
            itemBuilder: (context, element) {
              var biaya = NumberFormat.currency(locale: 'id', symbol: 'Rp.');
              double data = double.parse(element.tagihan.toString());
              final key = element.kodeadm.toString();
              _controllers[key] ??= TextEditingController();
              var pending = element.pending;
              bool isPending = false;
              bool lunas = false;
              if (pending != false) {
                isPending = true;
                lunas = false;
              }
              if (element.dibayar == element.tagihan) {
                lunas = true;
              }

              String keys =
                  'lain[${element.nis}][${element.tahunaj}][${element.kodeadm}]';
              return ListTile(
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      biaya.format(data),
                      style: TextStyle(
                          fontSize: 14,
                          color: isPending
                              ? Theme.of(context).colorScheme.tertiary
                              : lunas
                                  ? Theme.of(context).colorScheme.tertiary
                                  : Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
                trailing: isPending
                    ? Card(
                        color: Colors.amber,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          child: const Text(
                            'WAIT',
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        ),
                      )
                    : lunas
                        ? Card(
                            color: Colors.green.shade200,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              child: const Text(
                                'PAID',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 11),
                              ),
                            ),
                          )
                        : SizedBox(
                            width: 100,
                            child: TextFormField(
                              controller: _controllers[key],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.right,
                              decoration: const InputDecoration.collapsed(
                                  hintText: '0'),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                ThousandsFormatter()
                              ],
                              onChanged: (value) {
                                setState(() {
                                  int? inputValue =
                                      int.tryParse(value.replaceAll('.', ''));
                                  if (inputValue != null) {
                                    if (inputValue > data) {
                                      isInputValid = false;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              // ignore: use_build_context_synchronously
                                              Text(
                                            'Nominal berlebih dari ${element.tagihan}',
                                            style: TextStyle(
                                                // ignore: use_build_context_synchronously
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary),
                                          ),
                                          // ignore: use_build_context_synchronously
                                          backgroundColor:
                                              // ignore: use_build_context_synchronously
                                              Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                        ),
                                      );
                                    } else {
                                      isInputValid = true;
                                      _values[keys] = inputValue;
                                    }
                                    _updateTotalTerbatas();
                                  } else {
                                    _values[keys] = 0;
                                    _updateTotalTerbatas();
                                  }
                                });
                              },
                            ),
                          ),
              );
            },
          ),
        );
      },
    );
  }

  _groupPaymentVias() {
    return Consumer<KeuanganProvider>(
      builder: (context, pay, child) {
        return GroupedListView(
          elements: pay.listPaymentVias,
          groupBy: (element) => '${element.title}',
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          groupSeparatorBuilder: (String value) => const Padding(
            padding: EdgeInsets.all(8),
            child: SizedBox.shrink(),
          ),
          itemBuilder: (context, element) {
            return ListTile(
              leading: Radio<String>(
                value: element.title!,
                groupValue: _selectedPaymentVia,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentVia = value;
                    _paymentvias['payment_via'] = element.paymentvia!;
                    _recalculate();
                  });
                },
              ),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${element.title}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    '${element.description}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  Row(
                    children: element.logos?.logos?.map<Widget>((logo) {
                          return Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: SvgPicture.network(
                                logo,
                                height: 12,
                                width: 12,
                              ));
                        }).toList() ??
                        [],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget getTotalPembayaran() {
    var totalformat = NumberFormat.currency(locale: 'id', symbol: 'Rp.');
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Biaya Administrasi'),
                Text(totalformat.format(biayaAdm))
              ],
            ),
          ),
          const Divider(
            thickness: 0.1,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total Pembayaran'),
                Text(totalformat.format(totalPembayaran))
              ],
            ),
          ),
          const Divider(
            thickness: 0.1,
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: TextButton(
              onPressed: () async {
                try {
                  final scaffold = ScaffoldMessenger.of(context);

                  if (_paymentvias.isEmpty) {
                    scaffold.showSnackBar(
                      SnackBar(
                        content: Text(
                          'Anda belum memilih metode pembayaran',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  } else if (_selectedPaymentVia!.isNotEmpty) {
                    bool isValid = true;
                    String errorMessage = '';
                    //Validartor minimum and maximum payment method @ando
                    switch (_selectedPaymentVia) {
                      case 'Virtual Account':
                        if (totalBulanan + totalTerbatas < 10000) {
                          isValid = false;
                          errorMessage =
                              'Minimal Pembayaran Virtual Account Adalah Rp. 10.000';
                        }
                        break;
                      case 'Outlet / Merchant':
                        if (totalBulanan + totalTerbatas < 10000) {
                          isValid = false;
                          errorMessage =
                              'Minimal Pembayaran Melalui Outlet / Merchant Adalah Rp. 10.000';
                        } else if (totalBulanan + totalTerbatas > 2500000) {
                          isValid = false;
                          errorMessage =
                              'Maksimal Pembayaran Melalui Outlet / Merchant Adalah Rp. 2.500.000';
                        }
                        break;
                      case 'QRis':
                        if (totalBulanan + totalTerbatas < 1500) {
                          isValid = false;
                          errorMessage =
                              'Minimal Pembayaran QRis Adalah Rp. 1.500';
                        } else if (totalBulanan + totalTerbatas > 2000000) {
                          isValid = false;
                          errorMessage =
                              'Maksimal Pembayaran QRis Adalah Rp. 2.000.000';
                        }
                        break;
                    }

                    if (!isValid) {
                      scaffold.showSnackBar(
                        SnackBar(
                          content: Text(
                            errorMessage,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                      );
                    } else {
                      setState(() {
                        isLoading = true;
                      });

                      final user = Provider.of<SqliteUserProvider>(context,
                          listen: false);
                      var id = user.currentuser.siskonpsn;
                      var tokenss = user.currentuser.tokenss;
                      Map<String, String> selectedTagihan = {
                        for (var entry in _bulananVal.entries)
                          entry.key: entry.value,
                        for (var entry in _values.entries)
                          entry.key: entry.value.toString(),
                        for (var entry in _paymentvias.entries)
                          entry.key: entry.value.toString(),
                      };
                      await KeuanganService().kuanganAdd(
                        id: id!,
                        tokenss: tokenss!,
                        data: selectedTagihan,
                        biayaAdm: biayaAdm.toString(),
                      );

                      setState(() {
                        isLoading = false;
                      });

                      scaffold.showSnackBar(
                        SnackBar(
                          content: Text(
                            'Silahkan selesaikan pembayaran',
                            style: TextStyle(
                                // ignore: use_build_context_synchronously
                                color: Theme.of(context).colorScheme.onPrimary),
                          ),
                          backgroundColor:
                              // ignore: use_build_context_synchronously
                              Theme.of(context).colorScheme.primary,
                        ),
                      );
                      await refresh();
                    }
                  }
                } catch (e) {
                  return;
                }
              },
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.circular(8)),
                backgroundColor: const Color.fromARGB(255, 73, 72, 72),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text(
                      'Lanjutkan Pembayaran',
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

class ThousandsFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat('#,##0', 'id_ID');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    final int value = int.parse(newValue.text.replaceAll('.', ''));
    final String newText = _formatter.format(value);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
