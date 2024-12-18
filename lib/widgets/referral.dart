import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';

class Referral extends StatelessWidget {
  const Referral({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context);
    var img = '';
    switch (user.currentuser.siskostatuslogin) {
      case 'g':
        img = 'https://aff.kamadeva.com/images/aff-teacher.png';
        break;
      case 's':
        img = 'https://aff.kamadeva.com/images/aff-students.png';
        break;
      case 'a':
        img = 'https://aff.kamadeva.com/images/aff-parents.png';
        break;
      case 'i':
        img = 'https://aff.kamadeva.com/images/aff-parents.png';
        break;
      default:
        img = 'https://aff.kamadeva.com/images/aff-teacher.png';
        break;
    }
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: Colors.amber.shade800,
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Referral Digitalisasi Sekolah',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'FREE JOIN!',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/form-referral');
                    },
                    child: Image.network(
                      img,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
