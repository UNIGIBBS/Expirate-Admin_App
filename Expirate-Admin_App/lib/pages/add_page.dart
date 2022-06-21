import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comp_part1_2/modules/http.dart';
//import 'package:comp_part1_2/widgets/drop_down.dart';
import 'package:comp_part1_2/widgets/location_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'edit_page.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:path/path.dart';

enum Discounts { discountBy25, discountBy50, userChoice }

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {

  String? text = "";
  TextEditingController controller = TextEditingController();
  String? selectedType;
  SharedPreferences? prefs;
  bool isSwitched = false;
  static const String SELECTED_TYPE = "SELECTED_TYPE";
  static const String TEXT = "TEXT";

  var amount = 1.0;
  var quantity = 1.0;
  var price = 0.0;

  var _picker = ImagePicker();

  TextEditingController brandController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  int x = 19;

  Discounts? discounts = Discounts.discountBy25;

  var expiryDate;

  var _imageUrl;

  var submitButtonColor = Colors.grey;

  bool openTypeSelector = false;

  bool hasDiscount = false;

  String discountAmount = "0";

  late FocusNode myFocusNode;

  var username;
  var image;
  var city;
  var village;
  var lat;
  var lng;

  @override
  void initState() {
    // prefs = await SharedPreferences.getInstance();
    getSharedPrefs();
    getData();
    super.initState();
  }
  getSharedPrefs() async{
    prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedType = prefs!.getString(SELECTED_TYPE);
      text = prefs!.getString(TEXT) ?? "";
    });

  }

  getData()async {
    await FirebaseFirestore.instance.collection("Markets").doc(
        FirebaseAuth.instance.currentUser?.uid).get().then((value) {
      print(value["username"]);
      username = value["username"];
      image = value["image"];
      city = value["city"];
      village = value["village"];
      lat = value["lat"];
      lng = value["lng"];
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    var currentDate = DateTime.now();

    int currentDay = currentDate.day;
    int currentMonth = currentDate.month;
    int currentYear = currentDate.year;

    int currentMin = currentDate.minute;
    int currentHour = currentDate.hour;

    List<String> brands = ['pınar', 'sütaş', 'uno', 'banvit', 'damak', 'ekici'];
    List<String> titles = [
      'süt',
      'yoğurt',
      'ekmek',
      'tavuk',
      'çikolata',
      'peynir'
    ];
    List<String> types = [
      'breakfast',
      'milk & dairy',
      'baked goods',
      'meat',
      'snacks',
      'food'
    ];
    brands.sort((a, b) {
      return a.compareTo(b);
    });
    types.sort((a, b) {
      return a.compareTo(b);
    });
    titles.sort((a, b) {
      return a.compareTo(b);
    });

    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
              "Add New Product",
              style: TextStyle(color: Colors.black54),
            )),
        elevation: 0,
        backgroundColor: Colors.transparent,
        //backgroundColor: Colors.redAccent,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentScope = FocusScope.of(context);

          if (!currentScope.hasPrimaryFocus) {
            currentScope.unfocus();
          }
        },
        child: SafeArea(
          child: ListView(
            children: [
              FutureBuilder(
                future: getData(),
                builder: (context, snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator());
                  }else{
                    return Location(city: city, village: village, lat: lat, lng: lng, username: username);
                  }
                },
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 8, 15, 8),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap:() async{
                        return await showDialog(
                            context: context,
                            builder: (BuildContext context) => SimpleDialog(
                              title: Text("Change profile picture"),
                              children: [
                                SimpleDialogOption(
                                  onPressed: ()async{
                                    print("presssed");

                                    Navigator.pop(context);

                                    final pickedFile = await _picker.pickImage(
                                        source: ImageSource.camera,
                                        imageQuality: 10,
                                    );

                                    print("worked 1");

                                    File file = File(pickedFile!.path);

                                    print("worked 2");

                                    print(file.toString());

                                    String videoId = "${Uuid().v1()}";

                                    print(videoId);

                                    final ref = FirebaseStorage.instance
                                        .ref()
                                        .child("Product pictures")
                                        .child(videoId);

                                    print("worked 3");

                                    await ref.putFile(file);
                                    print("worked 4");

                                    String link = await ref.getDownloadURL();
                                    print("worked 5");

                                    setState(() {
                                      _imageUrl = link;
                                    });

                                    print(_imageUrl);
                                  },
                                  child: ListTile(
                                    leading: Icon(Icons.camera_alt_outlined, size: 30,),
                                    title: Text("From Camera", style: TextStyle(fontSize: 20),),
                                  ),
                                ),
                                SimpleDialogOption(
                                  onPressed: ()async{
                                    print("presssed");
                                    Navigator.pop(context);
                                    final pickedFile = await _picker.pickImage(
                                        source: ImageSource.gallery,
                                        imageQuality: 10);
                                    File file = File(pickedFile!.path);
                                    final ref = FirebaseStorage.instance
                                        .ref()
                                        .child("Product pictures")
                                        .child("${Uuid().v1()}");
                                    await ref.putFile(file);
                                    String link = await ref.getDownloadURL();
                                    print(link);
                                  },
                                  child: ListTile(
                                    leading: Icon(Icons.image_outlined, size: 30,),
                                    title: Text("From gallery", style: TextStyle(fontSize: 20)),
                                  ),
                                )
                              ],
                            )
                        );
                      },
                      child: Container(
                        height: width * 0.35,
                        width: width * 0.35,
                        decoration: _imageUrl == null ? BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey[300],
                        ) : BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey[300],
                          image: DecorationImage(
                            image: NetworkImage(_imageUrl),
                            fit: BoxFit.cover
                          )
                        ),
                        child: _imageUrl == null ? Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: width / 7,
                        ) : Container(),
                      ),
                    ),
                    Spacer(),
                    SizedBox(
                      width: width-width * 0.35-45,
                      child: Column(
                        children: [
                          TextField(
                            controller: brandController,
                            decoration: InputDecoration(
                              label: Text("Brand f.e. Milla"),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.grey, width: 1, style: BorderStyle.solid)
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height*0.03,
                          ),
                          TextField(
                            controller: titleController,
                            decoration: InputDecoration(
                              label: Text("Title f.e. Milk"),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.grey, width: 1, style: BorderStyle.solid)
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 8, 15, 8),
                child: DropdownButton(
                  hint: Text("Please select a type"),
                  value: selectedType,
                  items: types.map((String name){
                    return DropdownMenuItem<String>(
                      value: name,
                      child: Text(name),);
                  },
                  ).toList(),
                  onChanged: (value){

                    setState(() {
                      prefs!.setString(SELECTED_TYPE, value.toString());
                      selectedType = value.toString();
                    });
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                      "Add your type",
                    style: TextStyle(
                      fontSize: height*0.015,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Switch(
                    value: isSwitched,
                    onChanged: (value){
                      setState((){
                        isSwitched = value;
                      });
                    },
                  )
                ],
              ),
              isSwitched == true ? AnimatedSize(
                duration: Duration(
                  milliseconds: 300
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: TextField(
                    controller: typeController,
                    decoration: InputDecoration(
                      label: Text("Type f.e. diary"),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.grey, width: 1, style: BorderStyle.solid)
                      ),
                    ),
                  ),
                ),
              ) : Container(),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Text(
                  "Expiry Date",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.redAccent[400],
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      fontSize: height * 0.02
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  DatePicker.showDatePicker(
                    context,
                    maxTime: DateTime(currentYear + 1, 12, 31),
                    onChanged: (date) {
                      setState(() {
                        expiryDate = date;
                      });
                    },
                    onConfirm: (date) {
                      setState(() {
                        expiryDate = date;
                      });
                      print(date);
                    },
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          expiryDate == null
                              ? "$currentDay"
                              : "${expiryDate.toString().substring(8, 10)}",
                          style: TextStyle(
                              fontSize: height * 0.025,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        "/",
                        style: TextStyle(
                            fontSize: height * 0.025,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          expiryDate == null
                              ? "$currentMonth"
                              : "${expiryDate.toString().substring(5, 7)}",
                          style: TextStyle(
                              fontSize: height * 0.025,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        "/",
                        style: TextStyle(
                            fontSize: height * 0.025,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          expiryDate == null
                              ? "$currentYear"
                              : "${expiryDate.toString().substring(0, 4)}",
                          style: TextStyle(
                              fontSize: height * 0.025,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(15, 0, 15, 8),
              //   child: Container(
              //     width: width * 0.4,
              //     height: height * 0.07,
              //     child: SpinBox(
              //       textAlign: TextAlign.center,
              //       incrementIcon: Icon(
              //         Icons.add,
              //         color: Colors.redAccent[400],
              //       ),
              //       decrementIcon: Icon(
              //         Icons.remove,
              //         color: Colors.redAccent[400],
              //       ),
              //       min: 1,
              //       max: 20,
              //       value: 1,
              //       onChanged: (value){
              //         setState((){
              //           amount = value;
              //         });
              //       },
              //       focusNode: myFocusNode,
              //       decoration: InputDecoration(
              //         labelText: "Enter product amount",
              //         labelStyle: TextStyle(
              //             color: Colors.black54,
              //             fontSize: 18,
              //             fontWeight: FontWeight.bold),
              //         floatingLabelAlignment: FloatingLabelAlignment.center,
              //         border: OutlineInputBorder(
              //           borderSide: BorderSide(width: 1, color: Colors.black38),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: height * 0.03,
              // ),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(15, 0, 15, 8),
              //   child: Container(
              //     width: width * 0.4,
              //     height: height * 0.07,
              //     child: SpinBox(
              //       textAlign: TextAlign.center,
              //       incrementIcon: Icon(
              //         Icons.add,
              //         color: Colors.redAccent[400],
              //       ),
              //       decrementIcon: Icon(
              //         Icons.remove,
              //         color: Colors.redAccent[400],
              //       ),
              //       min: 1,
              //       max: 2000,
              //       value: 50,
              //       step: 50,
              //       onChanged: (value){
              //         setState((){
              //           quantity = value;
              //         });
              //       },
              //       focusNode: myFocusNode,
              //       decoration: InputDecoration(
              //         suffixText: 'g',
              //         labelText: "Enter product quantity",
              //         labelStyle: TextStyle(
              //             color: Colors.black54,
              //             fontSize: 18,
              //             fontWeight: FontWeight.bold),
              //         floatingLabelAlignment: FloatingLabelAlignment.center,
              //         border: OutlineInputBorder(
              //           borderSide: BorderSide(width: 1, color: Colors.black38),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(
                width: width,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                          "Price",
                        style: TextStyle(
                            color: Colors.redAccent[400],
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            fontSize: height * 0.02
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: SizedBox(
                          width: width/3,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: priceController,
                            maxLength: 8,
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.attach_money),
                              hintText: "0.0",
                              hintStyle: TextStyle(fontWeight: FontWeight.bold),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.grey, width: 1, style: BorderStyle.solid)
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Add discount",
                      style: TextStyle(
                          color: Colors.redAccent[400],
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          fontSize: height * 0.02),
                    ),
                    Checkbox(
                        activeColor: Colors.redAccent,
                        value: hasDiscount,
                        onChanged: (value) {
                          setState(() {
                            hasDiscount = value!;
                          });
                          print(hasDiscount);
                        })
                  ],
                ),
              ),
              AnimatedSize(
                duration: Duration(milliseconds: 500),
                child: Container(
                  height: hasDiscount ? 120 : 0,
                  width: width,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: width * 0.5,
                            height: height * 0.04,
                            child: RadioListTile<Discounts>(
                              activeColor: Colors.redAccent,
                              title: Text(
                                "25% discount",
                                style: TextStyle(
                                    color: discounts != Discounts.userChoice
                                        ? Colors.black
                                        : Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                              value: Discounts.discountBy25,
                              groupValue: discounts,
                              onChanged: (Discounts? value) {
                                setState(() {
                                  discounts = value!;
                                  if(value == Discounts.discountBy25){
                                    discountAmount = "25";
                                  } else if(value == Discounts.discountBy50){
                                    discountAmount = "50";
                                  } else if(value == Discounts.userChoice){
                                    discountAmount = "0";
                                  }
                                });
                              },
                            ),
                          ),
                          Container(
                            width: width * 0.5,
                            height: height * 0.04,
                            child: RadioListTile<Discounts>(
                              activeColor: Colors.redAccent,
                              title: Text(
                                "50% discount",
                                style: TextStyle(
                                    color: discounts != Discounts.userChoice
                                        ? Colors.black
                                        : Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                              value: Discounts.discountBy50,
                              groupValue: discounts,
                              onChanged: (Discounts? value) {
                                setState(() {
                                  discounts = value!;
                                  if(value == Discounts.discountBy25){
                                    discountAmount = "25";
                                  } else if(value == Discounts.discountBy50){
                                    discountAmount = "50";
                                  } else if(value == Discounts.userChoice){
                                    discountAmount = "0";
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: width * 0.04,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AnimatedSize(
                            duration: Duration(milliseconds: 500),
                            child: Container(
                              width: width * 0.6,
                              height: hasDiscount ? 60 : 0,
                              child: RadioListTile<Discounts>(
                                activeColor: Colors.redAccent,
                                title: Text(
                                  "Custom discount",
                                  style: TextStyle(
                                      color: discounts == Discounts.userChoice
                                          ? Colors.black
                                          : Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                                value: Discounts.userChoice,
                                groupValue: discounts,
                                onChanged: (Discounts? value) {
                                  setState(() {
                                    discounts = value!;
                                    if(value == Discounts.discountBy25){
                                      discountAmount = "25";
                                    } else if(value == Discounts.discountBy50){
                                      discountAmount = "50";
                                    } else if(value == Discounts.userChoice){
                                      discountAmount = "0";
                                    }
                                  });
                                  print(discounts);
                                },
                              ),
                            ),
                          ),
                          Card(
                            elevation: 3,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5))),
                            child: AnimatedSize(
                              duration: Duration(milliseconds: 500),
                              child: SizedBox(
                                height: hasDiscount ? 40 : 0,
                                width: width * 0.25,
                                child: Center(
                                  child: TextField(
                                    onChanged: (value){
                                      setState((){
                                        discountAmount = value;
                                      });
                                      print("${discountAmount}");
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: "0.0",
                                      suffixIcon: Icon(Icons.percent),
                                      hintStyle: TextStyle(
                                          color: discounts == Discounts.userChoice
                                              ? Colors.redAccent
                                              : Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5,
                                          fontSize: height * 0.02),
                                      floatingLabelStyle: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: height * 0.02,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5,
                                      ),
                                      labelStyle: const TextStyle(
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5,
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          borderSide: BorderSide(
                                              color: Colors.white,
                                              style: BorderStyle.none,
                                              width: 0)),
                                      disabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          borderSide: BorderSide(
                                              color: Colors.white,
                                              style: BorderStyle.none,
                                              width: 0)),
                                      enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          borderSide: BorderSide(
                                              color: Colors.white,
                                              style: BorderStyle.none,
                                              width: 0)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: width * 0.1,
                    margin: const EdgeInsets.all(5),
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: !hasDiscount ?
                        brandController.text.isNotEmpty && titleController.text.isNotEmpty && typeController.text.isNotEmpty && priceController.text.isNotEmpty && _imageUrl != null ? Colors.redAccent : Colors.grey
                        :
                        brandController.text.isNotEmpty && titleController.text.isNotEmpty && typeController.text.isNotEmpty && priceController.text.isNotEmpty && discountAmount != "0" && _imageUrl != null ? Colors.redAccent : Colors.grey,
                      ),
                      onPressed: () async {
                        brandController.text.isNotEmpty && titleController.text.isNotEmpty && typeController.text.isNotEmpty && priceController.text.isNotEmpty && _imageUrl != null && expiryDate != null ? await FirebaseFirestore.instance.collection("Markets").doc("${FirebaseAuth.instance.currentUser?.uid}").collection("products").add({
                          "title": titleController.text,
                          "brand": brandController.text,
                          "price": priceController.text,
                          "market": FirebaseAuth.instance.currentUser?.uid,
                          "image": _imageUrl,
                          "discount": discountAmount,
                          "expiry date": expiryDate
                        }) : print("Fill the gaps");
                        brandController.text.isNotEmpty && titleController.text.isNotEmpty && typeController.text.isNotEmpty && priceController.text.isNotEmpty && _imageUrl != null && expiryDate != null ? await FirebaseFirestore.instance.collection("Products").add({
                          "title": titleController.text,
                          "brand": brandController.text,
                          "price": priceController.text,
                          "market": FirebaseAuth.instance.currentUser?.uid,
                          "image": _imageUrl,
                          "discount": discountAmount,
                          "expiry date": expiryDate
                        }) : print("Fill the gaps");
                        brandController.text.isNotEmpty && titleController.text.isNotEmpty && typeController.text.isNotEmpty && priceController.text.isNotEmpty && _imageUrl != null && expiryDate != null ? await FirebaseFirestore.instance.collection("Markets").doc("${FirebaseAuth.instance.currentUser?.uid}").collection("typed").doc("types").collection("${typeController.text.toLowerCase()}").add({
                          "title": titleController.text,
                          "brand": brandController.text,
                          "price": priceController.text,
                          "market": FirebaseAuth.instance.currentUser?.uid,
                          "image": _imageUrl,
                          "discount": discountAmount,
                          "expiry date": expiryDate
                        }) : print("Fill the gaps");
                        brandController.text.isNotEmpty && titleController.text.isNotEmpty && typeController.text.isNotEmpty && priceController.text.isNotEmpty && _imageUrl != null && expiryDate != null ? await FirebaseFirestore.instance.collection("Typed").doc("Types").collection("${typeController.text.toLowerCase()}").add({
                          "title": titleController.text,
                          "brand": brandController.text,
                          "price": priceController.text,
                          "market": FirebaseAuth.instance.currentUser?.uid,
                          "image": _imageUrl,
                          "discount": discountAmount,
                          "expiry date": expiryDate
                        }) : print("Fill the gaps");
                        Navigator.of(context).pop();
                      },
                      child: const Text('Approve '),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
