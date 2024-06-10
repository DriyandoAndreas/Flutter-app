import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:sisko_v5/providers/kelas_provider.dart';
import 'package:sisko_v5/providers/sqlite_user_provider.dart';
import 'package:sisko_v5/services/kelas_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ListKelas extends StatefulWidget {
  const ListKelas({super.key});

  @override
  State<ListKelas> createState() => _ListKelasState();
}

class _ListKelasState extends State<ListKelas> {
  final _scrollController = ScrollController();
  TextEditingController group = TextEditingController();
  bool isloading = false;
  bool iswagroups = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMoreItems);
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
      context.read<KelasProvider>().initList(
          id: user.currentuser.siskoid ?? '',
          tokenss: user.currentuser.tokenss ?? '');
    } catch (e) {
      throw Exception(e);
    }
  }

  void _loadMoreItems() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadKelas();
    }
  }

  Future<void> _refreshList() async {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    context.read<KelasProvider>().refresh(
          id: user.currentuser.siskoid ?? '',
          tokenss: user.currentuser.tokenss ?? '',
        );
  }

  _urlLuncer(String urls) async {
    final Uri url = Uri.parse(urls);
    if (!await launchUrl(url)) {
      throw Exception('could not launch the $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final kelas = Provider.of<KelasProvider>(context);
    final thn = kelas.infiniteList.isNotEmpty ? kelas.infiniteList.first : null;
    String? thnAj = thn?.tahunAjaran;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Kelas'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshList,
        child: Column(children: [
          const Divider(
            thickness: 0.1,
          ),
          SizedBox(
            height: 50,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
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
                    'TA ${thnAj ?? ''}',
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
        ]),
      ),
    );
  }

  Widget buildList() {
    return Consumer<KelasProvider>(
      builder: (context, kelas, child) {
        if (kelas.infiniteList.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: kelas.hasMore
                ? kelas.infiniteList.length + 1
                : kelas.infiniteList.length,
            controller: _scrollController,
            itemBuilder: (context, index) {
              if (index < kelas.infiniteList.length) {
                final kelass = kelas.infiniteList[index];

                final user =
                    Provider.of<SqliteUserProvider>(context, listen: false);
                final isAuthorized =
                    user.currentuser.siskokode == kelass.kodePegawai;
                return Column(
                  children: [
                    isAuthorized
                        ? Slidable(
                            endActionPane: ActionPane(
                              motion: const BehindMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    showModalGroup(kelass);
                                  },
                                  icon: Icons.edit,
                                  backgroundColor: Colors.green.shade400,
                                ),
                              ],
                            ),
                            child: buildListTile(kelass))
                        : buildListTile(kelass),
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

  Widget buildListTile(kelass) {
    final wa = kelass.waGroup;
    bool hasWaGroup = wa != null;
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, '/view-kelas', arguments: kelass);
      },
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasWaGroup)
            GestureDetector(
                onTap: () {
                  _urlLuncer('${kelass.waGroup}');
                },
                child: const Icon(Icons.chat_bubble_outline)),
          SizedBox(
            width: hasWaGroup ? 12 : 0,
          ),
          const Icon(Icons.arrow_forward_ios),
        ],
      ),
      title: Text(kelass.namaKelas ?? ''),
      subtitle: Text(
        kelass.namaLengkap ?? '',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontStyle: FontStyle.italic),
      ),
    );
  }

  void showModalGroup(kelass) {
    final user = Provider.of<SqliteUserProvider>(context);
    String id = user.currentuser.siskoid ?? '';
    String tokenss = user.currentuser.tokenss ?? '';
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text('Link Group'),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                height: 50,
                child: TextFormField(
                  controller: group,
                  decoration: const InputDecoration.collapsed(
                      hintText: 'Link',
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: TextButton(
                  onPressed: () async {
                    try {
                      // ignore: use_build_context_synchronously
                      final scaffold = ScaffoldMessenger.of(context);
                      if (id != '' && tokenss != '') {
                        await KelasService().addGroup(
                            id: id,
                            tokenss: tokenss,
                            kodeKelas: kelass.kodeKelas,
                            kodePegawai: kelass.kodePegawai,
                            action: 'wa',
                            linkGroup: group.text);
                      }
                      scaffold.showSnackBar(
                        const SnackBar(
                          content: Text('Link Group berhasil di tambahkan'),
                          duration: Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      Future.delayed(const Duration(seconds: 2), () {
                        Navigator.of(context).pop();
                      });
                    } catch (e) {
                      throw Exception('$e');
                    }
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.circular(8)),
                    backgroundColor: const Color.fromARGB(255, 73, 72, 72),
                  ),
                  child: isloading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Simpan',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
