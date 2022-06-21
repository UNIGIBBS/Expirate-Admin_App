import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comp_part1_2/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../providers/location_provider.dart';

class CreateProfilePage extends StatefulWidget {
  CreateProfilePage({Key? key, required this.username}) : super(key: key);

  String username;

  @override
  State<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {

  var _imageUrl;

  var _picker = ImagePicker();

  double zoomValue = 8;
  MapController mapController = MapController();

  List<LatLng> listOfCoordinates = [LatLng(38.9637, 35.2433), LatLng(38.9, 35.243)];

  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController villageController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    var userLocation = Provider.of<UserLocation?>(context);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: (){
        FocusNode currentFocus = FocusScope.of(context);
        if(!currentFocus.hasPrimaryFocus){
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                ListView(
                  children: [
                    SizedBox(
                      height: height*0.1,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Your Info",
                        style: TextStyle(
                            fontSize: height*0.035,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    SizedBox(height: 16,),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        " Profile picture",
                        style: TextStyle(
                            fontSize: height*0.025,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
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
                          height: width * 0.4,
                          width: width - 16,
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
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        " Location",
                        style: TextStyle(
                            fontSize: height*0.025,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:10,left: 15, right: 15),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          //side: BorderSide(style: BorderStyle.solid, width: 1),
                          borderRadius:BorderRadius.circular(20),
                        ),
                        elevation: 10,
                        child: SizedBox(
                          height: width / 2,
                          width: width * 0.6,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              //side: BorderSide(style: BorderStyle.solid, width: 1),
                              borderRadius:BorderRadius.circular(20),
                            ),
                            elevation: 10,
                            child: userLocation != null
                                ? FlutterMap(
                              mapController: mapController,
                              options: MapOptions(
                                  center: LatLng(userLocation.latitude!,
                                      userLocation.longitude!),
                                  zoom: zoomValue),
                              layers: [
                                TileLayerOptions(
                                  urlTemplate:
                                  "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                  subdomains: ['a', 'b', 'c'],
                                ),
                                MarkerLayerOptions(markers: [
                                  Marker(
                                      point: LatLng(userLocation.latitude!,
                                          userLocation.longitude!),
                                      builder: (context) => IconButton(
                                        icon:
                                        Icon(Icons.person_pin_circle_sharp),
                                        iconSize: height * 0.03,
                                        color: Color(0xfff20c60),
                                        onPressed: () {},
                                      )),
                                  Marker(
                                      point: listOfCoordinates[1],
                                      builder: (context) => IconButton(
                                        icon:
                                        Icon(Icons.person_pin_circle_sharp),
                                        iconSize: height * 0.03,
                                        color: Colors.blue,
                                        onPressed: () {},
                                      )),
                                ])
                              ],
                            )
                                : Container(),
                          ),
                        ),
                      ),
                    ),
                    TextField(
                      controller: addressController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, style: BorderStyle.solid, width: 2),
                          borderRadius: BorderRadius.circular(5)
                        ),
                        label: Text("Address"),
                      ),
                      maxLength: 100,
                    ),
                    SizedBox(height: 8,),
                    Row(
                      children: [
                        SizedBox(
                          width: width/2-12,
                          child: TextField(
                            controller: cityController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey, style: BorderStyle.solid, width: 2),
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              label: Text("City"),
                            ),
                          ),
                        ),
                        SizedBox(width: 8,),
                        SizedBox(
                          width: width/2-12,
                          child: TextField(
                            controller: villageController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey, style: BorderStyle.solid, width: 2),
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              label: Text("Village"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 100,
                    )
                  ],
                ),
                Positioned(
                  bottom: 20,
                  right: 10,
                  child: GestureDetector(
                    onTap: ()async{
                      await FirebaseFirestore.instance.collection("Markets").doc(FirebaseAuth.instance.currentUser?.uid).set({
                        "email": FirebaseAuth.instance.currentUser?.email,
                        "username": widget.username,
                        "lat": userLocation!.latitude,
                        "lng": userLocation!.longitude,
                        "image": _imageUrl,
                        "address": addressController.text,
                        "city": cityController.text,
                        "village": villageController.text
                      });
                      _imageUrl != null && addressController.text != "" && cityController.text != "" && villageController.text != "" ? Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Home())) : print("Not full");
                    },
                    child: Row(
                      children: [
                        Text(
                            "Continue",
                          style: TextStyle(
                            color: _imageUrl != null && addressController.text != "" && cityController.text != "" && villageController.text != "" ? Colors.red : Colors.grey,
                          ),
                        ),
                        IconButton(
                            onPressed: (){},
                            icon: Icon(
                              Icons.navigate_next,
                              color: _imageUrl != null && addressController.text != "" && cityController.text != "" && villageController.text != "" ? Colors.red : Colors.grey,
                            )
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}