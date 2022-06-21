import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comp_part1_2/main.dart';
import 'package:comp_part1_2/pages/add_page.dart';
import 'package:comp_part1_2/pages/add_product.dart';
import 'package:comp_part1_2/pages/profile_page.dart';
import 'package:comp_part1_2/services/authentication_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/product_model.dart';
import '../providers/product_list.dart';
import '../services/map_utils.dart';
import '../widgets/location_widget.dart';

const Color customBackground = Color(0xffe6e6ec);
const Color customRed = Colors.redAccent;
const Color customOceanBlue = Color(0xff638181);
const Color customBlack54 = Colors.black54;
const Color customBackgroundWhite = Colors.white;

const TextStyle customHeadline1 =
TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: customBlack54);
const TextStyle customHeadline2 =
TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: customRed);
const TextStyle customBodyText =
TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: customBlack54);


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List productList = [

  ];

  var username;
  var image;
  var city;
  var village;
  var lat;
  var lng;

  var cats = [];

  var data;
  var generalInfo;
  var fakeList;
  void initState() {
    super.initState();
    getData();
  }

  getData()async{

    print("uid ${FirebaseAuth.instance.currentUser?.uid}");

    await FirebaseFirestore.instance.collection("Markets").doc(FirebaseAuth.instance.currentUser?.uid).get().then((value){
      print("getdata");
      print(value["username"]);
      print(value["image"]);
      print(value["city"]);

      print(FirebaseAuth.instance.currentUser?.uid);

      username = value["username"];
      image = value["image"];
      city = value["city"];
      village = value["village"];
      lat = value["lat"];
      lng = value["lng"];
    });

    var length = 0;

    productList = [];
    fakeList = [];
    Provider.of<ProductList>(context, listen: false).emptyList();

    generalInfo = await FirebaseFirestore.instance.collection("Markets").doc(FirebaseAuth.instance.currentUser?.uid).collection("products").get().then((value){
      List<MarketProductWidget> elementList = [];
      value.docs.forEach((element) {
        elementList.add(
            MarketProductWidget(brand: element["brand"], expiryDate: element["expiry date"], price: element["price"], image: element["image"], title: element["title"])
        );
      });
      Provider.of<ProductList>(context, listen: false).updateList(
          elementList
      );

      fakeList.add("generalInfo");
      print("first ${fakeList}");
    });
  }

  var _imageUrl;

  var _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              FutureBuilder(
                future: getData(),
                builder: (context, snapshot){
                  print("future");
                  print(city);
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator());
                  }else{
                    return Location(city: city, village: village, lat: lat, lng: lng, username: username);
                  }
                },
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 10, 8, 0),
                child: Stack(
                  children: [
                    FutureBuilder(
                      future: getData(),
                      builder: (context, snapshot){
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return Center(child: CircularProgressIndicator());
                        }else{
                          return Container(
                            height: width/2*0.9,
                            width: width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                    image: NetworkImage(image),
                                    fit: BoxFit.cover
                                )
                            ),
                          );
                        }
                      },
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: ()async{
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
                                          .child("Profile pictures")
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

                                      await FirebaseFirestore.instance.collection("Markets").doc(FirebaseAuth.instance.currentUser?.uid).get().then((value) =>
                                      data = value
                                      ).then((value)async{
                                        var city = value["city"];
                                        var email = value["email"];
                                        var image = value["image"];
                                        var lat = value["lat"];
                                        var lng = value["lng"];
                                        var username = value["username"];
                                        var village = value["village"];

                                        await FirebaseFirestore.instance.collection("Markets").doc(FirebaseAuth.instance.currentUser?.uid).set({
                                          "city": city,
                                          "email": email,
                                          "image": link,
                                          "lat": lat,
                                          "lng": lng,
                                          "username": username,
                                          "village": village,
                                        });
                                      });

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
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey,
                          ),
                          child: Icon(Icons.edit, color: Colors.white,),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FutureBuilder(
                      future: getData(),
                      builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return Center(child: CircularProgressIndicator());
                        }else {
                          return SizedBox(
                            width: width,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: width/6,
                                  child: FittedBox(
                                    child: Text(
                                      "Market - ",
                                      style: TextStyle(
                                          fontSize: height * 0.025,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8,),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: width/6*5-74,
                                            child: Text(
                                              username,
                                              style: TextStyle(
                                                  fontSize: height * 0.02,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey[800],
                                                  fontStyle: FontStyle.italic
                                              ),
                                            ),
                                          ),
                                          Expanded(child: IconButton(
                                              onPressed: ()async{

                                                var data;

                                                await FirebaseFirestore.instance.collection("Markets").doc(FirebaseAuth.instance.currentUser?.uid).get().then((value) =>
                                                  data = value
                                                ).then(
                                                        (value) {
                                                          var usernameController = TextEditingController();

                                                          showDialog(
                                                          context: context,
                                                          builder: (context) {


                                                            var city = value["city"];
                                                            var email = value["email"];
                                                            var image = value["image"];
                                                            var lat = value["lat"];
                                                            var lng = value["lng"];
                                                            var username = value["username"];
                                                            var village = value["village"];

                                                            return GestureDetector(
                                                              onTap: (){
                                                                FocusScopeNode currentScope = FocusScope.of(context);

                                                                if (!currentScope.hasPrimaryFocus) {
                                                                  currentScope.unfocus();
                                                                }
                                                              },
                                                              child: AlertDialog(
                                                                title: Text(
                                                                    "Edit Market Name"),
                                                                content: SizedBox(
                                                                  width: width - 150,
                                                                  height: width - 100,
                                                                  child: ListView(
                                                                    children: [
                                                                      TextField(
                                                                        controller: usernameController,
                                                                        decoration: InputDecoration(
                                                                            hintText: "New market name..."
                                                                        ),
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                                        children: [
                                                                          ElevatedButton(
                                                                              style: ButtonStyle(
                                                                                  backgroundColor: MaterialStateProperty
                                                                                      .all(
                                                                                      usernameController.text!="" ? Colors.red : Colors.grey
                                                                                  )
                                                                              ),
                                                                              onPressed: () async{
                                                                                if(usernameController.text!=""){
                                                                                  await FirebaseFirestore.instance.collection("Markets").doc(FirebaseAuth.instance.currentUser?.uid).set({
                                                                                    "city": city,
                                                                                    "email": email,
                                                                                    "image": image,
                                                                                    "lat": lat,
                                                                                    "lng": lng,
                                                                                    "username": usernameController.text,
                                                                                    "village": village,
                                                                                  });
                                                                                  Navigator.pop(context);
                                                                                }
                                                                              },
                                                                              child: Text(
                                                                                "Save",
                                                                                style: TextStyle(
                                                                                    color: Colors
                                                                                        .white,
                                                                                    fontWeight: FontWeight
                                                                                        .bold
                                                                                ),
                                                                              )
                                                                          ),
                                                                          IconButton(
                                                                            onPressed: (){
                                                                              Navigator.pop(context);
                                                                            },
                                                                            icon: Icon(Icons.cancel_outlined, color: Colors.redAccent,)
                                                                          )
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                      ).then((value) => setState((){}));
                                                    }
                                                );

                                              },
                                              icon: Icon(Icons.edit, color: Colors.redAccent,))
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8,)
                              ],
                            ),
                          );
                        }
                      }
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FutureBuilder(
                      future: getData(),
                      builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return Center(child: CircularProgressIndicator());
                        }else {
                          return SizedBox(
                            width: width,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: width/6,
                                  child: FittedBox(
                                    child: Text(
                                      " City -  ",
                                      style: TextStyle(
                                          fontSize: height * 0.025,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8,),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: width/6*5-74,
                                            child: Text(
                                              city,
                                              style: TextStyle(
                                                  fontSize: height * 0.02,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey[800],
                                                  fontStyle: FontStyle.italic
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              child: IconButton(
                                                  onPressed: ()async{

                                                    var data;

                                                    await FirebaseFirestore.instance.collection("Markets").doc(FirebaseAuth.instance.currentUser?.uid).get().then((value) =>
                                                    data = value
                                                    ).then(
                                                            (value) {
                                                          var cityController = TextEditingController();

                                                          showDialog(
                                                              context: context,
                                                              builder: (context) {


                                                                var city = value["city"];
                                                                var email = value["email"];
                                                                var image = value["image"];
                                                                var lat = value["lat"];
                                                                var lng = value["lng"];
                                                                var username = value["username"];
                                                                var village = value["village"];

                                                                return GestureDetector(
                                                                  onTap: (){
                                                                    FocusScopeNode currentScope = FocusScope.of(context);

                                                                    if (!currentScope.hasPrimaryFocus) {
                                                                      currentScope.unfocus();
                                                                    }
                                                                  },
                                                                  child: AlertDialog(
                                                                    title: Text(
                                                                        "Edit City Name"),
                                                                    content: SizedBox(
                                                                      width: width - 150,
                                                                      height: width - 100,
                                                                      child: ListView(
                                                                        children: [
                                                                          TextField(
                                                                            controller: cityController,
                                                                            decoration: InputDecoration(
                                                                                hintText: "New city name..."
                                                                            ),
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                                            children: [
                                                                              ElevatedButton(
                                                                                  style: ButtonStyle(
                                                                                      backgroundColor: MaterialStateProperty
                                                                                          .all(
                                                                                          cityController.text!="" ? Colors.red : Colors.grey
                                                                                      )
                                                                                  ),
                                                                                  onPressed: () async{
                                                                                    if(cityController.text!=""){
                                                                                      await FirebaseFirestore.instance.collection("Markets").doc(FirebaseAuth.instance.currentUser?.uid).set({
                                                                                        "city": cityController.text,
                                                                                        "email": email,
                                                                                        "image": image,
                                                                                        "lat": lat,
                                                                                        "lng": lng,
                                                                                        "username": username,
                                                                                        "village": village,
                                                                                      });
                                                                                      Navigator.pop(context);
                                                                                    }
                                                                                  },
                                                                                  child: Text(
                                                                                    "Save",
                                                                                    style: TextStyle(
                                                                                        color: Colors
                                                                                            .white,
                                                                                        fontWeight: FontWeight
                                                                                            .bold
                                                                                    ),
                                                                                  )
                                                                              ),
                                                                              IconButton(
                                                                                  onPressed: (){
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  icon: Icon(Icons.cancel_outlined, color: Colors.redAccent,)
                                                                              )
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                          ).then((value) => setState((){}));
                                                        }
                                                    );
                                                  },
                                                  icon: Icon(Icons.edit, color: Colors.redAccent,)
                                              )
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8,)
                              ],
                            ),
                          );
                        }
                      }
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FutureBuilder(
                      future: getData(),
                      builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return Center(child: CircularProgressIndicator());
                        }else {
                          return SizedBox(
                            width: width,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: width/6,
                                  child: FittedBox(
                                    child: Text(
                                      "Village - ",
                                      style: TextStyle(
                                          fontSize: height * 0.025,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8,),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: width/6*5-74,
                                            child: Text(
                                              village,
                                              style: TextStyle(
                                                  fontSize: height * 0.02,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey[800],
                                                  fontStyle: FontStyle.italic
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              child: IconButton(
                                                  onPressed: ()async{

                                                    var data;

                                                    await FirebaseFirestore.instance.collection("Markets").doc(FirebaseAuth.instance.currentUser?.uid).get().then((value) =>
                                                    data = value
                                                    ).then(
                                                            (value) {
                                                          var villageController = TextEditingController();

                                                          showDialog(
                                                              context: context,
                                                              builder: (context) {


                                                                var city = value["city"];
                                                                var email = value["email"];
                                                                var image = value["image"];
                                                                var lat = value["lat"];
                                                                var lng = value["lng"];
                                                                var username = value["username"];
                                                                var village = value["village"];

                                                                return GestureDetector(
                                                                  onTap: (){
                                                                    FocusScopeNode currentScope = FocusScope.of(context);

                                                                    if (!currentScope.hasPrimaryFocus) {
                                                                      currentScope.unfocus();
                                                                    }
                                                                  },
                                                                  child: AlertDialog(
                                                                    title: Text(
                                                                        "Edit Village Name"),
                                                                    content: SizedBox(
                                                                      width: width - 150,
                                                                      height: width - 100,
                                                                      child: ListView(
                                                                        children: [
                                                                          TextField(
                                                                            controller: villageController,
                                                                            decoration: InputDecoration(
                                                                                hintText: "New village name..."
                                                                            ),
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                                            children: [
                                                                              ElevatedButton(
                                                                                  style: ButtonStyle(
                                                                                      backgroundColor: MaterialStateProperty
                                                                                          .all(
                                                                                          villageController.text!="" ? Colors.red : Colors.grey
                                                                                      )
                                                                                  ),
                                                                                  onPressed: () async{
                                                                                    if(villageController.text!=""){
                                                                                      await FirebaseFirestore.instance.collection("Markets").doc(FirebaseAuth.instance.currentUser?.uid).set({
                                                                                        "city": city,
                                                                                        "email": email,
                                                                                        "image": image,
                                                                                        "lat": lat,
                                                                                        "lng": lng,
                                                                                        "username": username,
                                                                                        "village": villageController.text,
                                                                                      });
                                                                                      Navigator.pop(context);
                                                                                    }
                                                                                  },
                                                                                  child: Text(
                                                                                    "Save",
                                                                                    style: TextStyle(
                                                                                        color: Colors
                                                                                            .white,
                                                                                        fontWeight: FontWeight
                                                                                            .bold
                                                                                    ),
                                                                                  )
                                                                              ),
                                                                              IconButton(
                                                                                  onPressed: (){
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  icon: Icon(Icons.cancel_outlined, color: Colors.redAccent,)
                                                                              )
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                          ).then((value) => setState((){}));
                                                        }
                                                    );

                                                  },
                                                  icon: Icon(Icons.edit, color: Colors.redAccent,)
                                              )
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8,)
                              ],
                            ),
                          );
                        }
                      }
                  ),
                ),
              ),
              SizedBox(height: 16,),
              FutureBuilder(
                future: getData(),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator());
                  }else{
                    return itemListContainer(title: "Your products`", data: Provider.of<ProductList>(context, listen: false).productList);
                  }
                }
              ),
            ],
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.logout, color: Colors.redAccent,),
              onPressed: (){
                print("logout");
                Provider.of<AuthenticationService>(context, listen: false).signOut();
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CommonPage()));
              },
            ),
          )
        ],
      ),
      floatingActionButton: addButton(),

    );
  }
}


class addButton extends StatelessWidget {
  const addButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      backgroundColor: customRed,
      foregroundColor: customBackgroundWhite,
      onPressed: () {},
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddPage()));
        },
        child: Icon(
          Icons.add,
          size: 35,
        ),
      ),
    );
  }
}

class cardList extends StatefulWidget {
  cardList({Key? key, required this.data}) : super(key: key);
  var data;

  @override
  State<cardList> createState() => _cardListState();
}

class _cardListState extends State<cardList> {
  var currentItem = itemList.getData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  bool isFav = false;

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print("widget.data");
    print(widget.data);
    return SizedBox(
      height: width/2.5 + 90 + height * 0.085,
      child: widget.data == []? Text("There ıs no data"): ListView(
        scrollDirection: Axis.horizontal,
        children: widget.data,
      ),
    );
  }
}

class editButton extends StatelessWidget {
  editButton({Key? key, required this.isFav}) : super(key: key);
  Color customBackground = Color(0xffe6e6ec);
  Color customBlue = Color(0xff729b79);

  bool isFav;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 12,
      right: 12,
      child: SizedBox(
        height: 27,
        width: 27,
        child: FloatingActionButton(
          heroTag: null,
          shape: RoundedRectangleBorder(
            side:  BorderSide(width: 2, color: Colors.redAccent),
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: Colors.white,
          mini: true,
          // foregroundColor: customBlue,
          onPressed: () {},
          child: Icon(
            Icons.add, color: isFav == true ? Colors.redAccent : Colors.grey,
          ),
        ),
      ),
    );
  }
}

class itemListContainer extends StatelessWidget {
  itemListContainer({
    Key? key,
    required this.title,
    required this.data,
  }) : super(key: key);
  String title;
  var data;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: width/2.5 + 98 + height * 0.108,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
          color: Colors.grey[200],
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 5.0,
              spreadRadius: 0.0,
              offset: const Offset(
                0.0,
                5.0,
              ),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 8.0, top: 8, bottom: 8),
              child: SizedBox(
                height: height * 0.023,
                child: title!="" ? FittedBox(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.8),
                      fontWeight: FontWeight.w600,
                      fontSize: height * 0.023,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ) : Container(),
              ),
            ),
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 8),
                  child: cardList(data: data),
                )
            ),
          ],
        ),
      ),
    );
  }
}

class itemList {
  static final getData = [
    {
      'name': 'name1',
      'thumbnail': 'thumbnail1',
      'brand': 'brand1',
      'type': 'type1',
    },
  ];
}

class MarketProductWidget extends StatelessWidget {
  MarketProductWidget({
    Key? key,
    required this.brand,
    required this.expiryDate,
    required this.price,
    required this.image,
    required this.title,
  }) : super(key: key);

  var brand;
  var expiryDate;
  var price;
  var image;
  var title;

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 20, 32, 12),
                child: Container(
                  height: width/2.7,
                  width: width/2.7,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(image),
                        fit: BoxFit.cover
                    ),
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(.5),
                        blurRadius: 5.0,
                        spreadRadius: 0.0,
                        offset: Offset(
                          0.0,
                          3.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                child: Container(
                    height: height*0.03,
                    child: FittedBox(
                      child: Text(
                        price,
                        style: GoogleFonts.openSans(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    )
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 0,0),
                child: Container(
                  height: 2,
                  width: width/3,
                  color: Colors.grey[300],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 0, 4),
                child: Container(
                    height: height*0.03,
                    child: FittedBox(
                      child: Text(
                        title,
                        style: GoogleFonts.openSans(
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    )
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 0, 4),
                child: Container(
                    height: height*0.025,
                    child: FittedBox(
                      child: Text(
                        brand,
                        style: GoogleFonts.openSans(
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    )
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
