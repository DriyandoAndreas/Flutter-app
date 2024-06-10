import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sisko_v5/providers/konseling_provider.dart';
import 'package:sisko_v5/providers/sqlite_user_provider.dart';

class FormKonseling extends StatefulWidget {
  const FormKonseling({super.key});

  @override
  State<FormKonseling> createState() => _FormKonselingState();
}

class _FormKonselingState extends State<FormKonseling> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMore);
    initdata();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> initdata() async {
    try {
      await _loadKelas();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> _loadKelas() async {
    try {
      final user = Provider.of<SqliteUserProvider>(context, listen: false);
      String? id = user.currentuser.siskoid;
      String? tokenss = user.currentuser.tokenss;
      if (id != null && tokenss != null) {
        context
            .read<KonselingProvider>()
            .initKelas(id: id, tokenss: tokenss.substring(0, 30));
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  void _loadMore() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadKelas();
    }
  }

  Future<void> _refreshList() async {
    try {
      final user = Provider.of<SqliteUserProvider>(context, listen: false);
      String id = user.currentuser.siskoid ?? '';
      String tokenss = user.currentuser.tokenss ?? '';
      if (id != '' && tokenss != '') {
        context
            .read<KonselingProvider>()
            .refreshKelas(id: id, tokenss: tokenss.substring(0, 30));
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
          title: const Text("Konseling"),
        ),
        body: RefreshIndicator(
          onRefresh: _refreshList,
          child: Column(
            children: [
              const Divider(
                thickness: 0.1,
              ),
              Expanded(
                child: buildList(),
              ),
            ],
          ),
        ));
  }

  Widget buildList() {
    return Consumer<KonselingProvider>(
      builder: (context, kelas, child) {
        if (kelas.listKelas.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: kelas.hasMore
                ? kelas.listKelas.length + 1
                : kelas.listKelas.length,
            controller: _scrollController,
            itemBuilder: (context, index) {
              final showKelas = kelas.listKelas[index];
              return Column(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, '/form-konseling-add',
                          arguments: showKelas);
                    },
                    title: Text(showKelas.namaKelas!),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                  const Divider(
                    thickness: 0.1,
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }
}
