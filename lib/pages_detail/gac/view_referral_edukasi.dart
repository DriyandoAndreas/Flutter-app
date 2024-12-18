import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ViewReferralEdukasi extends StatefulWidget {
  const ViewReferralEdukasi({super.key});

  @override
  State<ViewReferralEdukasi> createState() => _ViewReferralEdukasiState();
}

class _ViewReferralEdukasiState extends State<ViewReferralEdukasi> {
  final CarouselSliderController _controller = CarouselSliderController();
  @override
  Widget build(BuildContext context) {
    List<String> images = [
      'https://aff.kamadeva.com/images/edu2/1.png',
      'https://aff.kamadeva.com/images/edu2/2.png',
      'https://aff.kamadeva.com/images/edu2/3.png',
      'https://aff.kamadeva.com/images/edu2/4.png',
      'https://aff.kamadeva.com/images/edu2/5.png',
      'https://aff.kamadeva.com/images/edu2/6.png',
      'https://aff.kamadeva.com/images/edu2/7.png',
      'https://aff.kamadeva.com/images/edu2/8.png',
      'https://aff.kamadeva.com/images/edu2/9.png',
      'https://aff.kamadeva.com/images/edu2/10.png',
      'https://aff.kamadeva.com/images/edu2/11.png',
      'https://aff.kamadeva.com/images/edu2/12.png?&_=001',
      'https://aff.kamadeva.com/images/edu2/13.png'
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Edukasi Referral'),
      ),
      body: CarouselSlider.builder(
        carouselController: _controller,
        itemCount: images.length,
        itemBuilder: (BuildContext context, int index, int realIndex) {
          return Image.network(
            images[index],
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
          );
        },
        options: CarouselOptions(
          height:
              MediaQuery.of(context).size.height, // Full height of the screen
          viewportFraction: 1.0, // Display only one image at a time
          enlargeCenterPage: false,
          autoPlay: false,
        ),
      ),
    );
  }
}
