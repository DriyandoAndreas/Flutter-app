import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:app5/providers/uks_provider.dart';

class UksListKelas extends StatefulWidget {
  const UksListKelas({super.key});

  @override
  State<UksListKelas> createState() => _UksListKelasState();
}

class _UksListKelasState extends State<UksListKelas> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMoreItems);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initData() async {
    await _loadList();
  }

  Future<void> _loadList() async {
    try {
      final user = Provider.of<SqliteUserProvider>(context, listen: false);
      var id = user.currentuser.siskonpsn;
      var tokenss = user.currentuser.tokenss;
      if (id != null && tokenss != null) {
        context.read<UksProvider>().initListKelas(id: id, tokenss: tokenss);
      }
    } catch (e) {
      return;
    }
  }

  void _loadMoreItems() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadList();
    }
  }

  Future<void> _refreshList() async {
    try {
      await _loadList();
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
        title: const Text('Kesehatan (UKS)'),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: _refreshList,
        child: Column(
          children: [
            Expanded(child: buildList()),
            grkrList(),
          ],
        ),
      ),
    );
  }

  Widget buildList() {
    return Consumer<UksProvider>(
      builder: (context, ukslisKelas, child) {
        if (ukslisKelas.listKelas.isEmpty) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: ukslisKelas.hasMore
                ? ukslisKelas.listKelas.length + 1
                : ukslisKelas.listKelas.length,
            controller: _scrollController,
            itemBuilder: (context, index) {
              if (index < ukslisKelas.listKelas.length) {
                final uks = ukslisKelas.listKelas[index];
                return Column(
                  children: [
                    ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, '/form-uks',
                              arguments: uks);
                        },
                        title: Text(uks.namaKelas ?? ''),
                        trailing: const Icon(Icons.arrow_forward_ios)),
                    const Divider(
                      thickness: 0.1,
                    ),
                  ],
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.all(15),
                  child: Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                );
              }
            },
          );
        }
      },
    );
  }

  Widget grkrList() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: 1,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, '/form-uks-gr',
                        arguments: <String, dynamic>{'kode_kelas': 'gr'});
                  },
                  title: const Text('Guru/Karyawan'),
                  trailing: const Icon(Icons.arrow_forward_ios)),
              const Divider(
                thickness: 0.1,
              ),
            ],
          );
        });
  }
}
