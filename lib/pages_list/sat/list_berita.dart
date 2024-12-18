import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/berita_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';

class SatListBerita extends StatefulWidget {
  const SatListBerita({super.key});

  @override
  State<SatListBerita> createState() => _SatListBeritaState();
}

class _SatListBeritaState extends State<SatListBerita> {
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
        context.read<BeritaProvider>().initInfinite(
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
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var id = user.currentuser.siskonpsn;
    var tokenss = user.currentuser.tokenss;
    if (id != null && tokenss != null) {
      context.read<BeritaProvider>().refresh(
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
        title: const Text('Teras Sekolah'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshList,
        child: _buildList(),
      ),
    );
  }

  Widget _buildList() {
    return Consumer<BeritaProvider>(
      builder: (context, berita, child) {
        if (berita.infinitelist.isEmpty) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: berita.hasMore
                ? berita.infinitelist.length + 1
                : berita.infinitelist.length,
            controller: _scrollController,
            itemBuilder: (context, index) {
              if (index < berita.infinitelist.length) {
                final terasSekolah =
                    berita.infinitelist[index]; // Perubahan di sini

                return Column(
                  children: [
                    buildListTile(terasSekolah),
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

  Widget buildListTile(terasSekolah) {
    DateTime date = DateTime.parse(terasSekolah.tgl ?? '');
    String dateFormat = DateFormat.yMMMMd('id_ID').format(date);

    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, '/view-teras-sekolah',
            arguments: terasSekolah);
      },
      title: Text(
        terasSekolah.judul ?? '',
        maxLines: 1,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            terasSekolah.post ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
          ),
          Text(
            terasSekolah.pembuat ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Theme.of(context).colorScheme.tertiary),
          ),
        ],
      ),
      leading: Image.network(
        terasSekolah.image,
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
