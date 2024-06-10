import 'package:flutter/material.dart';
import 'package:sisko_v5/database/sqlite_helper.dart';
import 'package:sisko_v5/models/sqlite_user_model.dart';
import 'package:sisko_v5/models/uks_model.dart';
import 'package:sisko_v5/services/uks_service.dart';

class UksListKelas extends StatefulWidget {
  const UksListKelas({super.key});

  @override
  State<UksListKelas> createState() => _UksListKelasState();
}

class _UksListKelasState extends State<UksListKelas>
    with WidgetsBindingObserver {
  final _scrollController = ScrollController();
  late SqLiteHelper _sqLiteHelper;
  late List<SqliteUserModel> _users = [];
  late List<UksListKelasModel> _uksListKelas = [];
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
        final paginatedList = await UksService().getListKelas(
          id: id,
          tokenss: tokenss.substring(0, 30),
          limit: limit,
        );
        setState(() {
          _uksListKelas = paginatedList;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Kesehatan (UKS)'),
      ),
      body: RefreshIndicator(
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
    if (_isLoading && _uksListKelas.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    } else if (_uksListKelas.isEmpty) {
      return const Center(
        child: Text('No data available'),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: _uksListKelas.length + 1,
        controller: _scrollController,
        itemBuilder: (context, index) {
          if (index < _uksListKelas.length) {
            final uks = _uksListKelas[index];
            return Column(
              children: [
                ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, '/form-uks', arguments: uks);
                    },
                    title: Text(uks.namaKelas ?? ''),
                    trailing: const Icon(Icons.arrow_forward_ios)),
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

  Widget grkrList() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: 1,
        itemBuilder: (context, index) {
          return Column(
            children: [
              const Divider(
                thickness: 0.1,
              ),
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
