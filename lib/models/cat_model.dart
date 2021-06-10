class Cat {
  dynamic id;
  String image;
  String fact;
  bool favorite;

  Cat({
    required this.id,
    required this.image,
    required this.fact,
    this.favorite = false,
  });
}
