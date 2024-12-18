import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:app5/services/referral_service.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FormReferral extends StatefulWidget {
  const FormReferral({super.key});

  @override
  State<FormReferral> createState() => _FormReferralState();
}

class _FormReferralState extends State<FormReferral> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context);
    var statuslogin = user.currentuser.siskostatuslogin;
    var ids = '';
    var desc = '';
    switch (statuslogin) {
      case 'g':
        ids = '5WM7fLy6W0s';
        desc =
            'Halo bapak-ibu yang kami hormati,kami menawarkan peluang pasif income buat Anda. Pasif income ini sangat mudah dilakukan yaitu bergabung jadi Referral Digitalisasi Sekolah. Anda akan dapatkan komisi yang menarik dan Life Time (selama sekolah yang bersangkutan memakai sistem ini).  Jangan sia-siakan kesempatan LUAR BIASA ini untuk mendapatkan pasif income secara mudah. Bergabung segera dan kami pandu caranya. Gratis!';
        break;
      case 's':
        ids = 'Ww-kaM5nr-4';
        desc =
            'Hai kalian pejuang masa depan, ingin dapat tambahan uang jajan? ingin segera update HP terbaru ingin beli laptop dengan uang sendiri? Pasti itu bisa kamu lakukan, asal kamu mau join Referral Sekolah Digital. Dan tinggal sebar link kamu supaya banyak sekolah pakai aplikasi ini. Ikuti caranya dan dapatkan komisinya.  Komisinya juga Life Time lho, jangan sia-siakan. Ayooo join sekarang. Gratis!';
        break;
      case 'a':
        ids = 'qakQO39hnOE';
        desc =
            'Halo bapak-ibu orang tua murid yang bahagia, apakah Anda ingin tambahan uang belanja? apakah Anda ingin tambahan uang bensin? atau apakah Anda ingin memberikan uang saku anak-aanda tanpa mengeluarkan uang dari pos lain?  Kami mengundang Anda semua untuk bergabung menjadi Referral Digitalisasi Sekolah.Dapatkan komisi yang menarik dan potensi pasif income 5 Juta/Bulan. Segera daftarkan diri Anda dan akan kami pandu caranya. Gratis!';
        break;
      case 'i':
        ids = 'qakQO39hnOE';
        desc =
            'Halo bapak-ibu orang tua murid yang bahagia, apakah Anda ingin tambahan uang belanja? apakah Anda ingin tambahan uang bensin? atau apakah Anda ingin memberikan uang saku anak-aanda tanpa mengeluarkan uang dari pos lain?  Kami mengundang Anda semua untuk bergabung menjadi Referral Digitalisasi Sekolah.Dapatkan komisi yang menarik dan potensi pasif income 5 Juta/Bulan. Segera daftarkan diri Anda dan akan kami pandu caranya. Gratis!';
        break;
      default:
        ids = '5WM7fLy6W0s';
        desc =
            'Halo bapak-ibu yang kami hormati,kami menawarkan peluang pasif income buat Anda. Pasif income ini sangat mudah dilakukan yaitu bergabung jadi Referral Digitalisasi Sekolah. Anda akan dapatkan komisi yang menarik dan Life Time (selama sekolah yang bersangkutan memakai sistem ini).  Jangan sia-siakan kesempatan LUAR BIASA ini untuk mendapatkan pasif income secara mudah. Bergabung segera dan kami pandu caranya. Gratis!';
        break;
    }
    YoutubePlayerController controller = YoutubePlayerController(
        initialVideoId: ids,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
        ));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Referral'),
      ),
      body: Column(
        children: [
          YoutubePlayer(
            controller: controller,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              desc,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.amber.shade600),
                  onPressed: () async {
                    final user =
                        Provider.of<SqliteUserProvider>(context, listen: false);
                    ReferralService service = ReferralService();
                    var id = user.currentuser.siskonpsn;
                    var tokenss = user.currentuser.tokenss;
                    try {
                      setState(() {
                        isLoading = true;
                      });
                      if (id != null && tokenss != null) {
                        await service.add(
                            id: id, tokenss: tokenss, action: 'add');
                      }
                      setState(() {
                        isLoading = false;
                      });
                      // ignore: use_build_context_synchronously
                      Navigator.pushNamed(context, '/referral-link');
                    } catch (e) {
                      return;
                    }
                  },
                  child: isLoading
                      ? const CircularProgressIndicator.adaptive()
                      : const Text(
                          'BERGABUNG SEKARANG!',
                          style: TextStyle(color: Colors.white),
                        )),
            ),
          ),
        ],
      ),
    );
  }
}
