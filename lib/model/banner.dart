class BannerSlide {
  String text, title;
  String image;
  String btn;
  int categoryId;
  BannerSlide({
    required this.categoryId,
    required this.title,
    required this.text,
    required this.image,
    required this.btn,
  });
  static List<BannerSlide> listBanner() {
    return [
      BannerSlide(
        text: "New Brand\nhas Arrived ",
        image: "images/slide1.png",
        categoryId: 8,
        title: 'Bag',
        btn: "View Product",
      ),
      BannerSlide(
        text: "Hot New Swage Shirt",
        image: "images/slide2.png",
        categoryId: 5,
        title: 'Man',
        btn: "View Product",
      ),
      BannerSlide(
        text: "Van Old School Still hit",
        image: "images/slide3.png",
        categoryId: 7,
        title: 'Shoes',
        btn: "View Product",
      ),
    ];
  }
}
