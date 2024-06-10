import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sisko_v5/models/kelas_model.dart';
import 'package:sisko_v5/providers/kelas_provider.dart';
import 'package:sisko_v5/providers/sqlite_user_provider.dart';

class DetailKelas extends StatefulWidget {
  const DetailKelas({super.key});

  @override
  State<DetailKelas> createState() => _DetailKelasState();
}

class _DetailKelasState extends State<DetailKelas> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMoreItems);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> initdata() async {
    try {
      await loadListkelas();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initdata();
  }

  Future<void> loadListkelas() async {
    try {
      final user = Provider.of<SqliteUserProvider>(context, listen: false);
      if (ModalRoute.of(context)!.settings.arguments != null) {
        KelasModel kelas =
            // ignore: use_build_context_synchronously
            ModalRoute.of(context)!.settings.arguments as KelasModel;
        var kodeKelas = kelas.kodeKelas;
        context.read<KelasProvider>().infiniteLoadKelasOpens(
              id: user.currentuser.siskoid ?? '',
              tokenss: user.currentuser.tokenss ?? '',
              kodeKelas: kodeKelas ?? '',
            );
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  void _loadMoreItems() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      loadListkelas();
    }
  }

  Future<void> _refreshList() async {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    if (ModalRoute.of(context)!.settings.arguments != null) {
      KelasModel kelas =
          // ignore: use_build_context_synchronously
          ModalRoute.of(context)!.settings.arguments as KelasModel;
      var kodeKelas = kelas.kodeKelas;
      context.read<KelasProvider>().refreshKelasOpen(
          id: user.currentuser.siskoid ?? '',
          tokenss: user.currentuser.tokenss ?? '',
          kodeKelas: kodeKelas ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    final KelasModel kelas =
        ModalRoute.of(context)!.settings.arguments as KelasModel;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(kelas.namaKelas!),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshList,
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_outlined,
                      size: 30,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      'TA ${kelas.tahunAjaran ?? ''}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              thickness: 0.1,
            ),
            Expanded(child: buildList())
          ],
        ),
      ),
    );
  }

  Widget buildList() {
    return Consumer<KelasProvider>(
      builder: (context, kelasOpen, child) {
        if (kelasOpen.infiniteListKelasOpen.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: kelasOpen.hasMore
                ? kelasOpen.infiniteListKelasOpen.length + 1
                : kelasOpen.infiniteListKelasOpen.length,
            controller: _scrollController,
            itemBuilder: (context, index) {
              if (index < kelasOpen.infiniteListKelasOpen.length) {
                final kelas = kelasOpen.infiniteListKelasOpen[index];
                return Column(
                  children: [
                    ListTile(
                      onTap: () {},
                      title: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(kelas.nis),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              kelas.namaLengkap,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 0.1,
                    ),
                  ],
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.all(15),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          );
        }
      },
    );
  }
}
