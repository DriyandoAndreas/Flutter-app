import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/perpus_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';

class ListPerpustakaan extends StatefulWidget {
  const ListPerpustakaan({super.key});

  @override
  State<ListPerpustakaan> createState() => _ListPerpustakaanState();
}

class _ListPerpustakaanState extends State<ListPerpustakaan> {
  final _scrollController = ScrollController();
  bool _isInit = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMoreItems);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _initData();
      _isInit = false;
    }
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
        context.read<PerpusProvider>().initList(id: id, tokenss: tokenss);
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
      var id = user.currentuser.siskonpsn;
      var tokenss = user.currentuser.tokenss;
      if (id != null && tokenss != null) {
        context.read<PerpusProvider>().refresh(id: id, tokenss: tokenss);
      }
    } catch (e) {
      return;
    }
  }

  bool isOpen = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Perpustakaan'),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: _refreshList,
        child: buildList(),
      ),
      floatingActionButton: SpeedDial(
        backgroundColor: Colors.grey.shade600,
        renderOverlay: false,
        animatedIcon: null,
        animatedIconTheme: const IconThemeData(size: 22),
        onOpen: () => setState(() => isOpen = true),
        onClose: () => setState(() => isOpen = false),
        children: [
          SpeedDialChild(
            child: const Icon(Icons.inventory),
            label: 'Peminjaman',
            onTap: () {
              Navigator.pushNamed(context, '/form-peminjaman');
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.unarchive),
            label: 'Pengembalian',
            onTap: () {
              Navigator.pushNamed(context, '/form-pengembalian');
            },
          ),
        ],
        child: isOpen
            ? const Icon(
                Icons.close,
                color: Colors.white,
              )
            : const Icon(
                Icons.add,
                color: Colors.white,
              ),
      ),
    );
  }

  Widget buildList() {
    return Consumer<PerpusProvider>(
      builder: (context, perpus, child) {
        if (perpus.list.isEmpty) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount:
                perpus.hasMore ? perpus.list.length + 1 : perpus.list.length,
            controller: _scrollController,
            itemBuilder: (context, index) {
              if (index < perpus.list.length) {
                final data = perpus.list[index];
                var ispinjam = false;
                if (data.mode == 'p') {
                  ispinjam = true;
                }
                return Column(
                  children: [
                    ListTile(
                      onTap: null,
                      title: Text('[${data.nis}] ${data.namaPeminjam ?? ''}'),
                      subtitle: Text(
                        '[${data.noInventaris}] ${data.judul}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ispinjam ? Colors.green : Colors.yellow),
                        child: Center(
                            child: Text(
                          '${data.mode?.toUpperCase()}',
                          style: const TextStyle(color: Colors.white),
                        )),
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
}
