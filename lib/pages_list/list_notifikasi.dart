import 'package:flutter/material.dart';
import 'package:sisko_v5/models/notifikasi_model.dart';

class ListNotifikasi extends StatelessWidget {
  const ListNotifikasi({super.key});

  @override
  Widget build(BuildContext context) {
    List<NotifikasiModel> lists = [
      NotifikasiModel(
          id: 1,
          judul: "Lomba Pantun",
          isi:
              "Siapkan diri untuk murid yang berbakat dalam berpantun, karena lomba akan segera diselengarakan",
          imgUrl:
              "https://img.freepik.com/free-vector/team-happy-employees-winning-award-celebrating-success-business-people-enjoying-victory-getting-gold-cup-trophy-vector-illustration-reward-prize-champions-s_74855-8601.jpg?t=st=1709713602~exp=1709717202~hmac=5d2d9b31930b6fdaa0494d7ba8af3ce10bea7bbbac57671a826463fd8c8ffa43&w=740"),
      NotifikasiModel(
          id: 2,
          judul: "Lomba Puisi",
          isi:
              "Siapkan diri untuk murid yang berbakat dalam berpantun, karena lomba akan segera diselengarakan",
          imgUrl:
              "https://img.freepik.com/free-vector/team-happy-employees-winning-award-celebrating-success-business-people-enjoying-victory-getting-gold-cup-trophy-vector-illustration-reward-prize-champions-s_74855-8601.jpg?t=st=1709713602~exp=1709717202~hmac=5d2d9b31930b6fdaa0494d7ba8af3ce10bea7bbbac57671a826463fd8c8ffa43&w=740"),
      NotifikasiModel(
          id: 3,
          judul: "Class Meeting",
          isi:
              "Siapkan diri untuk murid yang berbakat dalam berpantun, karena lomba akan segera diselengarakan",
          imgUrl:
              "https://img.freepik.com/free-vector/team-happy-employees-winning-award-celebrating-success-business-people-enjoying-victory-getting-gold-cup-trophy-vector-illustration-reward-prize-champions-s_74855-8601.jpg?t=st=1709713602~exp=1709717202~hmac=5d2d9b31930b6fdaa0494d7ba8af3ce10bea7bbbac57671a826463fd8c8ffa43&w=740"),
      NotifikasiModel(
          id: 4,
          judul: "Libur",
          isi:
              "Siapkan diri untuk murid yang berbakat dalam berpantun, karena lomba akan segera diselengarakan",
          imgUrl:
              "https://img.freepik.com/free-vector/team-happy-employees-winning-award-celebrating-success-business-people-enjoying-victory-getting-gold-cup-trophy-vector-illustration-reward-prize-champions-s_74855-8601.jpg?t=st=1709713602~exp=1709717202~hmac=5d2d9b31930b6fdaa0494d7ba8af3ce10bea7bbbac57671a826463fd8c8ffa43&w=740"),
      NotifikasiModel(
          id: 5,
          judul: "Study Tour",
          isi:
              "Siapkan diri untuk murid yang berbakat dalam berpantun, karena lomba akan segera diselengarakan",
          imgUrl:
              "https://img.freepik.com/free-vector/team-happy-employees-winning-award-celebrating-success-business-people-enjoying-victory-getting-gold-cup-trophy-vector-illustration-reward-prize-champions-s_74855-8601.jpg?t=st=1709713602~exp=1709717202~hmac=5d2d9b31930b6fdaa0494d7ba8af3ce10bea7bbbac57671a826463fd8c8ffa43&w=740"),
    ];
    return Scaffold(
      // backgroundColor: backgroundcolor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text("Notifications"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(
              thickness: 0.1,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: lists.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final notifikasi = lists[index];
                return Column(
                  children: [
                    ListTile(
                      onTap: () {},
                      title: Text(notifikasi.judul),
                      subtitle: Text(
                        notifikasi.isi,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      leading: Image.network(
                        notifikasi.imgUrl,
                      ),
                    ),
                    const Divider(
                      thickness: 0.1,
                    ),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
