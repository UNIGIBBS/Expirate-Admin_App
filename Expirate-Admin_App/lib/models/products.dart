import 'package:comp_part1_2/models/product_model.dart';
import 'package:flutter/cupertino.dart';

class Products with ChangeNotifier{

  bool filtered = false;
  bool sorted = false;

  List<ProductModel> filteredItems = [];
  //filteredItems.add(items);
  List<ProductModel> sortedItems = [];
  List<ProductModel> items = [
    ProductModel(
        name: "Milk",
        url: "assets/images/süt.jpg",
        category: "Dairy Products",
        brand: "Icim",
        marketBrand:"A101",
        price: 10.99,
        date: DateTime(2022,10,9),),

    ProductModel(
        name: "Coke",
        url: "assets/images/kola.jpg",
        category: "Drinks",
        brand: "CocaCola",
        marketBrand:"BIM",
        price: 10.99,
        date: DateTime(2022,10,9)),

    ProductModel(
        name: "Cheese",
        url: "assets/images/peynir.jpg",
        category: "Dairy Products",
        brand: "Icim",
        marketBrand:"A101",
        price: 10.99,
        date: DateTime(2022,10,9)),
    ProductModel(
        name: "Yogurt",
        url: "assets/images/yogurt.jpg",
        category: "Dairy Products",
        brand: "Icim",
        marketBrand:"A101",
        price: 10.99,
        date: DateTime(2022,10,9)),
  ];
  filterList(filteredProduct) {
    filtered = true;
    filteredItems = items;
    filteredItems.retainWhere((element) {
      return element.category!.contains(filteredProduct);
    });
    print(filteredItems);
    notifyListeners();
  }
  filterSorted(filteredProduct) {
    sorted = true;
    sortedItems = [...items];
    sortedItems.retainWhere((element) {
      return element.category!.contains(filteredProduct);
    });

    notifyListeners();
  }


  updateList(product) {
    items.add(product);
    notifyListeners();
  }
}