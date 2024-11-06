import 'package:wisata_app/core/app_asset.dart';
import 'package:wisata_app/src/data/model/wisata.dart';
import 'package:wisata_app/src/data/model/wisata_category.dart';

class Repository {
  get getWisataList {
    const dummyText =
        "Lorem Ipsum is simply dummy text of the printing and typesetting "
        "industry. Lorem Ipsum has been the industry's standard dummy text ever "
        "since the 1500s, when an unknown printer took a galley of type and "
        "scrambled it to make a type specimen book. It has survived not only five "
        "centuries, but also the leap into electronic typesetting, remaining "
        "essentially unchanged. It was popularised in the 1960s with the release "
        "of Letraset sheets containing Lorem Ipsum passages, and more recently "
        "with desktop publishing software like Aldus PageMaker including versions "
        "of Lorem Ipsum.";

    const List<Wisata> wisataItems = [
      Wisata(
          id: 1,
          image: AppAsset.ciremai1,
          carouselImages: [AppAsset.ciremai1, AppAsset.ciremai2, AppAsset.ciremai3, AppAsset.ciremai4, AppAsset.ciremai5],
          name: "Gunung Ciremai",
          price: 500000.0,
          description: dummyText,
          score: 5.0,
          type: WisataType.tertinggi,
          voter: 150),
      Wisata(
          id: 2,
          image: AppAsset.slamet1,
          carouselImages: [AppAsset.slamet1, AppAsset.slamet2, AppAsset.slamet3, AppAsset.slamet4, AppAsset.slamet5],
          name: "Gunung Slamet",
          price: 2000000.0,
          description: dummyText,
          score: 3.5,
          type: WisataType.tertinggi,
          voter: 652),
      Wisata(
          id: 3,
          image: AppAsset.semeru1,
          carouselImages: [AppAsset.semeru1, AppAsset.semeru2, AppAsset.semeru3, AppAsset.semeru4, AppAsset.semeru5],
          name: "Gunung Semeru",
          price: 20.0,
          description: dummyText,
          score: 4.0,
          type: WisataType.tertinggi,
          voter: 723),
      Wisata(
          id: 4,
          image: AppAsset.pangrango1,
          carouselImages: [AppAsset.pangrango1, AppAsset.pangrango2, AppAsset.pangrango3, AppAsset.pangrango4, AppAsset.pangrango5],
          name: "Gunung Parngrango",
          price: 100000.0,
          description: dummyText,
          score: 2.5,
          type: WisataType.jawabarat,
          voter: 456),
      Wisata(
          id: 5,
          image: AppAsset.cikuray1,
          carouselImages: [AppAsset.cikuray1, AppAsset.cikuray2, AppAsset.cikuray3, AppAsset.cikuray4, AppAsset.cikuray5],
          name: "Gunung Cikuray",
          price: 150000.0,
          description: dummyText,
          score: 4.5,
          type: WisataType.jawabarat,
          voter: 650),
      Wisata(
          id: 6,
          image: AppAsset.papandayan1,
          carouselImages: [AppAsset.papandayan1, AppAsset.papandayan2, AppAsset.papandayan3, AppAsset.papandayan4, AppAsset.papandayan5],
          name: "Gunung Papandayan",
          price: 150000.0,
          description: dummyText,
          score: 4.5,
          type: WisataType.jawabarat,
          voter: 650),
      Wisata(
          id: 7,
          image: AppAsset.gede1,
          carouselImages: [AppAsset.gede1, AppAsset.gede2, AppAsset.gede3, AppAsset.gede4, AppAsset.gede5],
          name: "Gunung Gede",
          price: 180000.0,
          description: dummyText,
          score: 4.5,
          type: WisataType.jawabarat,
          voter: 650),
      Wisata(
          id: 8,
          image: AppAsset.merbabu1,
          carouselImages: [AppAsset.merbabu1, AppAsset.merbabu2, AppAsset.merbabu3, AppAsset.merbabu4, AppAsset.merbabu5],
          name: "Gunung Merbabu",
          price: 200000.0,
          description: dummyText,
          score: 4.5,
          type: WisataType.jawatengah,
          voter: 350),
      Wisata(
          id: 9,
          image: AppAsset.sumbing1,
          carouselImages: [AppAsset.sumbing1, AppAsset.sumbing2, AppAsset.sumbing3, AppAsset.sumbing4, AppAsset.sumbing5],
          name: "Gunung Sumbing",
          price: 120000.0,
          description: dummyText,
          score: 3.5,
          type: WisataType.jawatengah,
          voter: 265),
      Wisata(
          id: 10,
          image: AppAsset.sindoro1,
          carouselImages: [AppAsset.sindoro1, AppAsset.sindoro2, AppAsset.sindoro3, AppAsset.sindoro4, AppAsset.sindoro5],
          name: "Gunung Sindoro",
          price: 125000.0,
          description: dummyText,
          score: 3.9,
          type: WisataType.jawatengah,
          voter: 789),
      Wisata(
          id: 11,
          image: AppAsset.arjuno1,
          carouselImages: [AppAsset.arjuno1, AppAsset.arjuno2, AppAsset.arjuno3, AppAsset.arjuno4, AppAsset.arjuno5],
          name: "Gunung Arjuno",
          price: 320000.0,
          description: dummyText,
          score: 4.0,
          type: WisataType.jawatimur,
          voter: 890),
      Wisata(
          id: 12,
          image: AppAsset.lawu1,
          carouselImages: [AppAsset.lawu1, AppAsset.lawu2, AppAsset.lawu3, AppAsset.lawu4, AppAsset.lawu5],
          name: "Gunung Lawu",
          price: 170000.0,
          description: dummyText,
          score: 5.0,
          type: WisataType.jawatimur,
          voter: 900),
      Wisata(
          id: 13,
          image: AppAsset.welirang1,
          carouselImages: [AppAsset.welirang1, AppAsset.welirang2, AppAsset.welirang3, AppAsset.welirang4, AppAsset.welirang5],
          name: "Gunung Welirang",
          price: 150000.0,
          description: dummyText,
          score: 3.5,
          type: WisataType.jawatimur,
          voter: 420),
      Wisata(
          id: 14,
          image: AppAsset.prau1,
          carouselImages: [AppAsset.prau1, AppAsset.prau2, AppAsset.prau3, AppAsset.prau4, AppAsset.prau5],
          name: "Gunung Prau",
          price: 270000.0,
          description: dummyText,
          score: 5.0,
          type: WisataType.best,
          voter: 263),
      Wisata(
          id: 15,
          image: AppAsset.bromo1,
          carouselImages: [AppAsset.bromo1, AppAsset.bromo2, AppAsset.bromo3, AppAsset.bromo4, AppAsset.bromo5],
          name: "Gunung Bromo",
          price: 770000.0,
          description: dummyText,
          score: 5.0,
          type: WisataType.best,
          voter: 560),
    ];

    return wisataItems;
  }

  get getCategories {
    const List<WisataCategory> categories = [
      WisataCategory(type: WisataType.all, isSelected: true),
      WisataCategory(type: WisataType.tertinggi, isSelected: false),
      WisataCategory(type: WisataType.jawabarat, isSelected: false),
      WisataCategory(type: WisataType.best, isSelected: false),
      WisataCategory(type: WisataType.jawatimur, isSelected: false),
      WisataCategory(type: WisataType.jawatengah, isSelected: false),
    ];

    return categories;
  }
}
