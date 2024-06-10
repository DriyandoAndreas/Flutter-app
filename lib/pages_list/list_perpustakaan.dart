import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:sisko_v5/database/sqlite_helper.dart';
import 'package:sisko_v5/models/perpus_model.dart';
import 'package:sisko_v5/models/sqlite_user_model.dart';
import 'package:sisko_v5/services/perpus_service.dart';

class ListPerpustakaan extends StatefulWidget {
  const ListPerpustakaan({super.key});

  @override
  State<ListPerpustakaan> createState() => _ListPerpustakaanState();
}

class _ListPerpustakaanState extends State<ListPerpustakaan>
    with WidgetsBindingObserver {
  final _scrollController = ScrollController();
  late SqLiteHelper _sqLiteHelper;
  late List<SqliteUserModel> _users = [];
  late List<PerpusModel> _perpus = [];
  int _limit = 20;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _sqLiteHelper = SqLiteHelper();
    _scrollController.addListener(_loadMoreItems);
    _initData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initData() async {
    await _loadUsers();
    await _loadList(_limit);
  }

  Future<void> _loadUsers() async {
    try {
      final users = await _sqLiteHelper.getusers();
      setState(() {
        _users = users;
      });
    } catch (e) {
      throw Exception('Failed to fetch data from SQLite');
    }
  }

  Future<void> _loadList(int limit) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final currentUser = _users.isNotEmpty ? _users.first : null;
      String? id = currentUser?.siskoid;
      String? tokenss = currentUser?.tokenss;
      if (id != null && tokenss != null) {
        final paginatedList = await PerpusService().getList(
          id: id,
          tokenss: tokenss.substring(0, 30),
          limit: limit,
        );
        setState(() {
          _perpus = paginatedList;
          _isLoading = false;
        });
      } else {
        throw Exception('Invalid ID or token');
      }
    } catch (e) {
      throw Exception('Failed to load news');
    }
  }

  void _loadMoreItems() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      setState(() {
        _isLoading = true;
      });
      _limit += 10;
      _loadList(_limit).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  Future<void> _refreshList() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _loadList(_limit);
    } catch (e) {
      throw Exception('Failed to reload');
    } finally {
      setState(() {
        _isLoading = false;
      });
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
      body: RefreshIndicator(
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
              )
            : const Icon(
                Icons.add,
              ),
      ),
    );
  }

  Widget buildList() {
    if (_isLoading && _perpus.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    } else if (_perpus.isEmpty) {
      return const Center(
        child: Text('No data available'),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: _perpus.length + 1,
        controller: _scrollController,
        itemBuilder: (context, index) {
          if (index < _perpus.length) {
            final perpus = _perpus[index];
            var ispinjam = false;
            if (perpus.mode == 'p') {
              ispinjam = true;
            }
            return Column(
              children: [
                ListTile(
                  onTap: null,
                  title: Text('[${perpus.nis}] ${perpus.namaPeminjam ?? ''}'),
                  subtitle: Text(
                    '[${perpus.noInventaris}] ${perpus.judul}',
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
                      '${perpus.mode?.toUpperCase()}',
                      style: const TextStyle(color: Colors.white),
                    )),
                  ),
                ),
                const Divider(
                  thickness: 0.1,
                ),
              ],
            );
          } else if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Container();
          }
        },
      );
    }
  }
}
