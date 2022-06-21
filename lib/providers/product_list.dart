import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductList with ChangeNotifier{
  List productList = [

  ];

  updateList(var list){
    productList = list;
    notifyListeners();
  }

  emptyList(){
    productList = [];
  }
}