class Home {
  final String title;
  final String description;
  final String image;
  final String price;
  final String location;

  Home({
    required this.title,
    required this.description,
    required this.image,
    required this.price,
    required this.location,
  });

  String get getTitle => title;
  String get getDescription => description;
  String get getImage => image;
  String get getPrice => price;
  String get getLocation => location;
}
