class CategoriesModel{

  late final String name;
  late final String url;

  CategoriesModel({ required this.url,  required this.name});


}
List<CategoriesModel> categories = [
  CategoriesModel(url: "assets/images/bakery_product.jpg", name: "Bakery"),
  CategoriesModel(url: "assets/images/dairy_product.jpg", name: "Dairy Products"),
  CategoriesModel(url: "assets/images/frozen_food.jpg", name: "Frozen Food"),
  CategoriesModel(url: "assets/images/dried_legums.jpg", name: "Dried Legums"),
  CategoriesModel(url: "assets/images/snacks.jpg", name: "Snacks"),
  CategoriesModel(url: "assets/images/oils.jpg", name: "Oil"),
  CategoriesModel(url: "assets/images/nuts.jpg", name: "Nuts"),
  CategoriesModel(url: "assets/images/drinks.jpg", name: "Drinks"),
  CategoriesModel(url: "assets/images/meat products.jpg", name: "Delicatessen"),
  CategoriesModel(url: "assets/images/grains.jpg", name: "Grains"),
  CategoriesModel(url: "assets/images/canned_food.jpg", name: "Canned Food"),
  CategoriesModel(url: "assets/images/confectionery.jpg", name: "Confectionery"),

];