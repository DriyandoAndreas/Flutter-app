import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/pengumuman_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';

class SatListPengumuman extends StatefulWidget {
  const SatListPengumuman({super.key});

  @override
  State<SatListPengumuman> createState() => _SatListPengumumanState();
}

class _SatListPengumumanState extends State<SatListPengumuman> {
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
    await _loadUsers();
    await _loadList();
  }

  Future<void> _loadUsers() async {
    try {
      final user = Provider.of<SqliteUserProvider>(context, listen: false);
      user.fetchUser();
    } catch (e) {
      return;
    }
  }

  Future<void> _loadList() async {
    try {
      final user = Provider.of<SqliteUserProvider>(context, listen: false);
      var id = user.currentuser.siskonpsn;
      var tokenss = user.currentuser.tokenss;
      if (id != null && tokenss != null) {
        context
            .read<PengumumanProvider>()
            .initInfinite(id: id, tokenss: tokenss.substring(0, 30));
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
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var id = user.currentuser.siskonpsn;
    var tokenss = user.currentuser.tokenss;
    if (id != null && tokenss != null) {
      context.read<PengumumanProvider>().refresh(
            id: id,
            tokenss: tokenss.substring(0, 30),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Pengumuman'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshList,
        child: _buildList(),
      ),
    );
  }

  Widget _buildList() {
    return Consumer<PengumumanProvider>(
      builder: (context, pengumuman, child) {
        if (pengumuman.infinitelist.isEmpty) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: pengumuman.hasMore
                ? pengumuman.infinitelist.length + 1
                : pengumuman.infinitelist.length,
            controller: _scrollController,
            itemBuilder: (context, index) {
              if (index < pengumuman.infinitelist.length) {
                final pengumumans = pengumuman.infinitelist[index];

                return Column(
                  children: [
                    buildListTile(pengumumans),
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

  Widget buildListTile(pengumumans) {
    DateTime date = DateTime.parse(pengumumans.tgl ?? '');
    String dateFormat = DateFormat.yMMMMd('id_ID').format(date);

    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, '/view-pengumuman',
            arguments: pengumumans);
      },
      title: Text(
        pengumumans.judul ?? '',
        maxLines: 1,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            pengumumans.post ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
          ),
          Text(
            pengumumans.pembuat ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Theme.of(context).colorScheme.tertiary),
          ),
        ],
      ),
      leading: Image.network(
        pengumumans.image,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.image, size: 60);
        },
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            dateFormat,
            style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
          ),
          const SizedBox(
            width: 8,
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ],
      ),
    );
  }
}
