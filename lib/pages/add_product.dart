import 'package:comp_part1_2/modules/http.dart';
import 'package:flutter/material.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}


class _AddProductState extends State<AddProduct> {
  TextEditingController nameController = TextEditingController();


  String response = "";

  createProduct() async{
    var result = await http_post("create-product", {
      "product_name": nameController.text,

    });
    if(result.ok){
      setState(() {
        response = result.data['status'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Product"),),
      body: Column(
        children: <Widget>[
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: "Product Name"
            ),
          ),
          RaisedButton(
            child: Text("Create"),
            onPressed: createProduct
          ),
          Text(response, style: TextStyle(color: Colors.black),),
        ],
      ),
    );
  }
}
