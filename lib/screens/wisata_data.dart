import 'package:flutter/material.dart';

class WisataItem {
  final String title;
  final String location;
  final String fullAddress;
  final String openHours;
  final String priceText;
  final String category;
  final double rating;
  final int reviewsCount;
  final String distanceText;
  final String imagePath;
  final String mapImagePath;
  final String description;

  const WisataItem({
    required this.title,
    required this.location,
    required this.fullAddress,
    required this.openHours,
    required this.priceText,
    required this.category,
    required this.rating,
    required this.reviewsCount,
    required this.distanceText,
    required this.imagePath,
    required this.mapImagePath,
    required this.description,
  });
}

const List<String> kategoriWisata = [
  'Semua',
  'Kuliner',
  'Sejarah',
  'Alam',
  'Religi',
  'Seni',
];

final List<WisataItem> daftarWisata = [
  const WisataItem(
    title: 'Dunia Fantasi (DUFAN)',
    location: 'Ancol, Jakarta Utara',
    fullAddress:
        'Jl. Lodan Timur No.7, Ancol, Kec. Pademangan, Jkt Utara, Daerah Khusus Ibukota Jakarta 14430',
    openHours: '10:00 - 22:00',
    priceText: 'Rp. 190.000 - Rp. 400.000',
    category: 'Semua',
    rating: 4.75,
    reviewsCount: 24543,
    distanceText: '1.68 KM dari lokasimu saat ini',
    imagePath: 'lib/images/dufan_detail.png',
    mapImagePath: 'lib/images/map_dufan.png',
    description:
        'Dufan (Dunia Fantasi) adalah taman hiburan yang terletak di kawasan Taman Impian Ancol, Jakarta Utara. Dufan merupakan salah satu taman hiburan terbesar dan terpopuler di Indonesia.',
  ),
  const WisataItem(
    title: 'Taman Mini Indonesia Indah (TMII)',
    location: 'Jakarta Timur',
    fullAddress:
        'Jl. Taman Mini Indonesia Indah, Ceger, Kec. Cipayung, Jakarta Timur',
    openHours: '08:00 - 21:00',
    priceText: 'Mulai dari Rp. 35.000',
    category: 'Sejarah',
    rating: 4.70,
    reviewsCount: 12031,
    distanceText: '3.68 KM dari lokasimu saat ini',
    imagePath: 'lib/images/tmii.png',
    mapImagePath: 'lib/images/map_tmii.png',
    description:
        'TMII adalah kawasan wisata budaya Indonesia yang menampilkan anjungan daerah, museum, taman tematik, serta berbagai wahana rekreasi dan edukasi.',
  ),
  const WisataItem(
    title: 'Museum Nasional',
    location: 'Jakarta Pusat',
    fullAddress:
        'Jl. Medan Merdeka Barat No.12, Gambir, Jakarta Pusat',
    openHours: '08:00 - 16:00',
    priceText: 'Mulai dari Rp. 25.000',
    category: 'Sejarah',
    rating: 4.65,
    reviewsCount: 8421,
    distanceText: '2.05 KM dari lokasimu saat ini',
    imagePath: 'lib/images/museum_nasional.png',
    mapImagePath: 'lib/images/map_museum.png',
    description:
        'Museum Nasional menyimpan beragam koleksi sejarah, budaya, arkeologi, dan etnografi dari seluruh Indonesia.',
  ),
  const WisataItem(
    title: 'Masjid Istiqlal',
    location: 'Jakarta Pusat',
    fullAddress:
        'Jl. Taman Wijaya Kusuma, Ps. Baru, Sawah Besar, Jakarta Pusat',
    openHours: '09:00 - 17:00',
    priceText: 'Gratis',
    category: 'Religi',
    rating: 4.80,
    reviewsCount: 15234,
    distanceText: '2.40 KM dari lokasimu saat ini',
    imagePath: 'lib/images/istiqlal.png',
    mapImagePath: 'lib/images/map_istiqlal.png',
    description:
        'Masjid Istiqlal merupakan masjid nasional Indonesia yang menjadi ikon wisata religi dan arsitektur di Jakarta.',
  ),
];