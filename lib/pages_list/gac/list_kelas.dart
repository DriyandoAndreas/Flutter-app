import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/kelas_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:app5/services/kelas_service.dart';
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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
      return;
    }
  }

  Future<void> _loadKelas() async {
    try {
      final user = Provider.of<SqliteUserProvider>(context, listen: false);
      var id = user.currentuser.siskonpsn;
      var tokenss = user.currentuser.tokenss;

      if (id != null && tokenss != null) {
        context
            .read<KelasProvider>()
            .initList(id: id, tokenss: tokenss.substring(0, 30));
      }
    } catch (e) {
      return;
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
    var id = user.currentuser.siskonpsn;
    var tokenss = user.currentuser.tokenss;
    if (id != null && tokenss != null) {
      context.read<KelasProvider>().refresh(
            id: id,
            tokenss: tokenss.substring(0, 30),
          );
    }
  }

  _urlLuncer(String urls) async {
    final Uri url = Uri.parse(urls);
    if (!await launchUrl(url)) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<KelasProvider>(context);
    final kelas =
        provider.infiniteList.isNotEmpty ? provider.infiniteList.first : null;
    String? thnAj = kelas?.tahunAjaran;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Kelas'),
      ),
      body: RefreshIndicator.adaptive(
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
            child: CircularProgressIndicator.adaptive(),
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

  Widget buildListTile(kelass) {
    final wa = kelass.waGroup;
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    final isAuthorized = user.currentuser.siskokode == kelass.kodePegawai;
    bool hasWaGroup = wa != '';
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, '/view-kelas', arguments: kelass);
      },
      title: Text(kelass.namaKelas ?? ''),
      subtitle: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            kelass.namaLengkap ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
          isAuthorized
              ? Card(
                  color: Colors.blue.shade400,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'My Class',
                      style: TextStyle(color: Colors.white),
                    ),
                  ))
              : const SizedBox.shrink()
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasWaGroup)
            GestureDetector(
                onTap: () {
                  _urlLuncer('${kelass.waGroup}');
                },
                child: const Icon(Icons.forum_outlined)),
          SizedBox(
            width: hasWaGroup ? 12 : 0,
          ),
          const Icon(Icons.arrow_forward_ios),
        ],
      ),
    );
  }

  void showModalGroup(kelass) {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var id = user.currentuser.siskonpsn;
    var tokenss = user.currentuser.tokenss;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
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
                      if (id != null && tokenss != null) {
                        await KelasService().addGroup(
                            id: id,
                            tokenss: tokenss,
                            kodeKelas: kelass.kodeKelas,
                            kodePegawai: kelass.kodePegawai,
                            action: 'wa',
                            linkGroup: group.text);
                      }
                      scaffold.showSnackBar(
                        SnackBar(
                          backgroundColor:
                              // ignore: use_build_context_synchronously
                              Theme.of(context).colorScheme.primary,
                          content: Text('Link Group berhasil di tambahkan',
                              style: TextStyle(
                                  // ignore: use_build_context_synchronously
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary)),
                          duration: const Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      Future.delayed(const Duration(seconds: 1), () {
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
                      });
                    } catch (e) {
                      return;
                    }
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.circular(8)),
                    backgroundColor: const Color.fromARGB(255, 73, 72, 72),
                  ),
                  child: isloading
                      ? const CircularProgressIndicator.adaptive(
                          backgroundColor: Colors.white,
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
