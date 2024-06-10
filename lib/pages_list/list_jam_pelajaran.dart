import 'package:flutter/material.dart';
import 'package:sisko_v5/database/sqlite_helper.dart';
import 'package:sisko_v5/models/jadwal_model.dart';
import 'package:sisko_v5/models/sqlite_user_model.dart';
import 'package:sisko_v5/services/jadwal_service.dart';

class ListJamPelajaran extends StatefulWidget {
  const ListJamPelajaran({super.key});

  @override
  State<ListJamPelajaran> createState() => _ListJamPelajaranState();
}

class _ListJamPelajaranState extends State<ListJamPelajaran>
    with WidgetsBindingObserver {
  final _scrollController = ScrollController();
  late SqLiteHelper _sqLiteHelper;
  late List<SqliteUserModel> _users = [];
  late List<JadwalKelaslModel> _listKelas = [];
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
        final paginatedList = await JadwalService().getListKelas(
          id: id,
          tokenss: tokenss.substring(0, 30),
          limit: limit,
        );
        setState(() {
          _listKelas = paginatedList;
          _isLoading = false;
        });
      } else {
        throw Exception('Invalid ID or token');
      }
    } catch (e) {
      throw Exception('Failed to load list $e');
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

  int getTotalJamPelajaran() {
    int totalJam = 0;
    for (var kelas in _listKelas) {
      totalJam += int.tryParse(kelas.jumlahJam ?? '0') ?? 0;
    }
    return totalJam;
  }

  @override
  Widget build(BuildContext context) {
    int totaljam = getTotalJamPelajaran();
    return Scaffold(
        body: RefreshIndicator(
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
                  Text(
                    'Total Mengajar : $totaljam Jam',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
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
    if (_isLoading && _listKelas.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    } else if (_listKelas.isEmpty) {
      return const Center(
        child: Text('No data available'),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: _listKelas.length + 1,
        controller: _scrollController,
        itemBuilder: (context, index) {
          if (index < _listKelas.length) {
            final kelas = _listKelas[index];
            return Column(
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, '/list-show-jam-pelajaran',
                        arguments: kelas);
                  },
                  title: Text(kelas.namaKelas!),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      kelas.jumlahJam != '0'
                          ? Card(
                              color: Colors.blue,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                child: Text(
                                  '${kelas.jumlahJam} jam',
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
