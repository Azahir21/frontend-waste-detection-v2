class OnBoardModel {
  final String image, title, description;

  OnBoardModel({
    required this.image,
    required this.title,
    required this.description,
  });
}

final List<OnBoardModel> onBoardingList = [
  OnBoardModel(
    image: "assets/images/onboarding1.png",
    title: "Mari Sayangi Bumi Kita",
    description:
        "Buat kata-kata emosional unik yang menggambarkan hal yang baik",
  ),
  OnBoardModel(
    image: "assets/images/onboarding2.png",
    title: "Yuk Peduli Dengan Lingkungan",
    description:
        "Buat kata-kata emosional unik yang menggambarkan hal yang baik",
  ),
  OnBoardModel(
    image: "assets/images/onboarding3.png",
    title: "Jadikan Sampah Barang Bermakna",
    description:
        "Buat kata-kata emosional unik yang menggambarkan hal yang baik",
  ),
];
