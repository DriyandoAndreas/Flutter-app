import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/models/jadwal_model.dart';
import 'package:app5/providers/jadwal_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';

class ListJamPelajaran extends StatefulWidget {
  const ListJamPelajaran({super.key});

  @override
  State<ListJamPelajaran> createState() => _ListJamPelajaranState();
}

class _ListJamPelajaranState extends State<ListJamPelajaran> {
  final _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMoreItems);
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
      String? id = user.currentuser.siskonpsn;
      String? tokenss = user.currentuser.tokenss;
      if (id!=null &&  tokenss != null) {
        context.read<JadwalProvider>().initListKelas(
              id: id,
              tokenss: tokenss.substring(0, 30),
            );
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
      final user = Provider.of<SqliteUserProvider>(context, listen: false);
      String? id = user.currentuser.siskonpsn;
      String? tokenss = user.currentuser.tokenss;
      if ( id!=null && tokenss != null) {
        context.read<JadwalProvider>().refreshKelas(
              id: id,
              tokenss: tokenss.substring(0, 30),
            );
      }
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator.adaptive(
      onRefresh: _refreshList,
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(
                    Icons.timer_sharp,
                    size: 30,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Consumer<JadwalProvider>(
                    builder: (context, jam, child) {
                      List<JadwalKelaslModel> respon = jam.listKelas;
                      int totalJam = 0;
                      for (var element in respon) {
                        totalJam += int.tryParse(element.jumlahJam ?? '0') ?? 0;
                      }
                      return Text(
                        'Total Mengajar : $totalJam Jam',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: buildList()),
        ],
      ),
    ));
  }

  Widget buildList() {
    return Consumer<JadwalProvider>(
      builder: (context, kelas, child) {
        if (kelas.listKelas.isEmpty) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: kelas.hasMore
                ? kelas.listKelas.length + 1
                : kelas.listKelas.length,
            controller: _scrollController,
            itemBuilder: (context, index) {
              final kelass = kelas.listKelas[index];
              return Column(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, '/list-show-jam-pelajaran',
                          arguments: kelass);
                    },
                    title: Text(kelass.namaKelas!),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        kelass.jumlahJam != '0'
                            ? Card(
                                color: Colors.blue,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  child: Text(
                                    '${kelass.jumlahJam} jam',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 11),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        const Icon(Icons.arrow_forward_ios),
                      ],
                    ),
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
