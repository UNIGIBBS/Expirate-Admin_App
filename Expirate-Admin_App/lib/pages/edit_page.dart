// import 'package:comp_part1_2/widgets/barcode_scanner_without_controller.dart';
// import 'package:comp_part1_2/widgets/drop_down.dart';
// import 'package:comp_part1_2/widgets/location_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:comp_part1_2/widgets/date_widget.dart';
// import 'package:comp_part1_2/widgets/time_widget.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
// import 'package:flutter_spinbox/flutter_spinbox.dart';
//
// enum Discounts { discountBy25, discountBy50, userChoice }
//
// class EditPage extends StatefulWidget {
//   const EditPage({Key? key}) : super(key: key);
//
//   @override
//   _EditPageState createState() => _EditPageState();
// }
//
// class _EditPageState extends State<EditPage> {
//   Discounts? discounts = Discounts.discountBy25;
//
//   var expiryDate;
//
//   bool openTypeSelector = false;
//
//   bool hasDiscount = false;
//
//   int discountAmount = 0;
//
//   bool openChoice = false;
//
//   String chooseChoice = "";
//
//   late FocusNode myFocusNode;
//
//   @override
//   void initState() {
//     super.initState();
//     myFocusNode = FocusNode();
//   }
//
//   @override
//   void dispose() {
//     myFocusNode.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//
//     var currentDate = DateTime.now();
//
//     int currentDay = currentDate.day;
//     int currentMonth = currentDate.month;
//     int currentYear = currentDate.year;
//
//     int currentMin = currentDate.minute;
//     int currentHour = currentDate.hour;
//
//     List<String> brands = ['pınar', 'sütaş', 'uno', 'banvit', 'damak', 'ekici'];
//     List<String> titles = [
//       'süt',
//       'yoğurt',
//       'ekmek',
//       'tavuk',
//       'çikolata',
//       'peynir'
//     ];
//     List<String> types = [
//       'breakfast',
//       'milk & dairy',
//       'baked goods',
//       'meat',
//       'snacks',
//       'food'
//     ];
//     brands.sort((a, b) {
//       return a.compareTo(b);
//     });
//     types.sort((a, b) {
//       return a.compareTo(b);
//     });
//     titles.sort((a, b) {
//       return a.compareTo(b);
//     });
//
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.of(context).pop();
//         },
//         child: Icon(
//           Icons.done,
//           color: Colors.white,
//           size: height * 0.03,
//         ),
//         elevation: 10,
//         backgroundColor: Colors.redAccent,
//       ),
//       appBar: AppBar(
//         title: Text("Edit Page"),
//         backgroundColor: Colors.redAccent[400],
//         actions: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: GestureDetector(
//               onTap: () {
//                 setState(() {
//                   openChoice == false ? openChoice = true : openChoice = false;
//                 });
//               },
//               child: Container(
//                 height: 50,
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.all(Radius.circular(12))),
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Center(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           chooseChoice == "" ? "Choose" : chooseChoice,
//                           style: TextStyle(
//                               color: Colors.black, fontWeight: FontWeight.bold),
//                         ),
//                         Icon(
//                           openChoice
//                               ? Icons.keyboard_arrow_down
//                               : Icons.keyboard_arrow_up,
//                           color: Colors.black,
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//       body: GestureDetector(
//         onTap: () {
//           FocusScopeNode currentScope = FocusScope.of(context);
//
//           if (!currentScope.hasPrimaryFocus) {
//             currentScope.unfocus();
//           }
//         },
//         child: Stack(
//           children: [
//             ListView(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(15.0, 8, 8, 8),
//                   child: Location(),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.fromLTRB(15, 8, 15, 8),
//                   child: Row(
//                     children: [
//                       SizedBox(
//                         height: width * 0.35,
//                         width: width * 0.35,
//                         child: Card(
//                           elevation: 0,
//                           child: ElevatedButton(
//                             child: Icon(
//                               Icons.camera_alt,
//                               size: width / 7,
//                             ),
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) =>
//                                     const BarcodeScannerWithoutController()),
//                               );
//                             },
//                             style: ElevatedButton.styleFrom(
//                               primary: Colors.grey[350],
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Spacer(),
//                       Column(
//                         children: [
//                           dropdown_menu(
//                             width: width,
//                             myFocusNode: myFocusNode,
//                             list: brands,
//                             name: "Brand",
//                           ),
//                           SizedBox(
//                             height: height * 0.03,
//                           ),
//                           dropdown_menu(
//                             width: width,
//                             myFocusNode: myFocusNode,
//                             list: titles,
//                             name: "Title",
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.fromLTRB(15, 8, 15, 8),
//                   child: dropdown_menu(
//                       width: width,
//                       myFocusNode: myFocusNode,
//                       list: types,
//                       name: 'Type'),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
//                   child: Text(
//                     "Expiry Date",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                         color: Colors.redAccent[400],
//                         fontWeight: FontWeight.bold,
//                         letterSpacing: 1.5,
//                         fontSize: height * 0.02),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     DatePicker.showDatePicker(
//                       context,
//                       maxTime: DateTime(currentYear + 1, 12, 31),
//                       onChanged: (date) {
//                         setState(() {
//                           expiryDate = date;
//                         });
//                       },
//                       onConfirm: (date) {
//                         setState(() {
//                           expiryDate = date;
//                         });
//                         print(date);
//                       },
//                     );
//                   },
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Card(
//                         elevation: 5,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(15.0),
//                           child: Text(
//                             expiryDate == null
//                                 ? "$currentDay"
//                                 : "${expiryDate.toString().substring(8, 10)}",
//                             style: TextStyle(
//                                 fontSize: height * 0.025,
//                                 fontStyle: FontStyle.italic,
//                                 fontWeight: FontWeight.normal),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(20.0),
//                         child: Text(
//                           "/",
//                           style: TextStyle(
//                               fontSize: height * 0.025,
//                               fontStyle: FontStyle.italic,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       Card(
//                         elevation: 3,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(15.0),
//                           child: Text(
//                             expiryDate == null
//                                 ? "$currentMonth"
//                                 : "${expiryDate.toString().substring(5, 7)}",
//                             style: TextStyle(
//                                 fontSize: height * 0.025,
//                                 fontStyle: FontStyle.italic,
//                                 fontWeight: FontWeight.normal),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(20.0),
//                         child: Text(
//                           "/",
//                           style: TextStyle(
//                               fontSize: height * 0.025,
//                               fontStyle: FontStyle.italic,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       Card(
//                         elevation: 5,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(15.0),
//                           child: Text(
//                             expiryDate == null
//                                 ? "$currentYear"
//                                 : "${expiryDate.toString().substring(0, 4)}",
//                             style: TextStyle(
//                                 fontSize: height * 0.025,
//                                 fontStyle: FontStyle.italic,
//                                 fontWeight: FontWeight.normal),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: height * 0.03,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(15, 0, 15, 8),
//                   child: Container(
//                     width: width * 0.4,
//                     height: height * 0.07,
//                     child: SpinBox(
//                       textAlign: TextAlign.center,
//                       incrementIcon: Icon(
//                         Icons.add,
//                         color: Colors.redAccent[400],
//                       ),
//                       decrementIcon: Icon(
//                         Icons.remove,
//                         color: Colors.redAccent[400],
//                       ),
//                       min: 1,
//                       max: 20,
//                       value: 1,
//                       onChanged: (value) => print(value),
//                       focusNode: myFocusNode,
//                       decoration: InputDecoration(
//                         labelText: "Enter product amount",
//                         labelStyle: TextStyle(
//                             color: Colors.black54,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold),
//                         floatingLabelAlignment: FloatingLabelAlignment.center,
//                         border: OutlineInputBorder(
//                           borderSide:
//                           BorderSide(width: 1, color: Colors.black38),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: height * 0.03,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(15, 0, 15, 8),
//                   child: Container(
//                     width: width * 0.4,
//                     height: height * 0.07,
//                     child: SpinBox(
//                       textAlign: TextAlign.center,
//                       incrementIcon: Icon(
//                         Icons.add,
//                         color: Colors.redAccent[400],
//                       ),
//                       decrementIcon: Icon(
//                         Icons.remove,
//                         color: Colors.redAccent[400],
//                       ),
//                       min: 1,
//                       max: 2000,
//                       value: 50,
//                       step: 50,
//                       onChanged: (value) => print(value),
//                       focusNode: myFocusNode,
//                       decoration: InputDecoration(
//                         suffixText: 'g',
//                         labelText: "Enter product quantity",
//                         labelStyle: TextStyle(
//                             color: Colors.black54,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold),
//                         floatingLabelAlignment: FloatingLabelAlignment.center,
//                         border: OutlineInputBorder(
//                           borderSide:
//                           BorderSide(width: 1, color: Colors.black38),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Add discount",
//                         style: TextStyle(
//                             color: Colors.redAccent[400],
//                             fontWeight: FontWeight.bold,
//                             letterSpacing: 1.5,
//                             fontSize: height * 0.02),
//                       ),
//                       Checkbox(
//                           activeColor: Colors.redAccent,
//                           value: hasDiscount,
//                           onChanged: (value) {
//                             setState(() {
//                               hasDiscount = value!;
//                             });
//                             print(hasDiscount);
//                           })
//                     ],
//                   ),
//                 ),
//                 AnimatedSize(
//                   duration: Duration(milliseconds: 500),
//                   child: Container(
//                     height: hasDiscount ? 120 : 0,
//                     width: width,
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             Container(
//                               width: width * 0.5,
//                               height: height * 0.05,
//                               child: RadioListTile<Discounts>(
//                                 activeColor: Colors.redAccent,
//                                 title: Text(
//                                   "25% discount",
//                                   style: TextStyle(
//                                       color: discounts != Discounts.userChoice
//                                           ? Colors.black
//                                           : Colors.grey,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 value: Discounts.discountBy25,
//                                 groupValue: discounts,
//                                 onChanged: (Discounts? value) {
//                                   setState(() {
//                                     discounts = value!;
//                                   });
//                                 },
//                               ),
//                             ),
//                             Container(
//                               width: width * 0.5,
//                               height: height * 0.05,
//                               child: RadioListTile<Discounts>(
//                                 activeColor: Colors.redAccent,
//                                 title: Text(
//                                   "50% discount",
//                                   style: TextStyle(
//                                       color: discounts != Discounts.userChoice
//                                           ? Colors.black
//                                           : Colors.grey,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 value: Discounts.discountBy50,
//                                 groupValue: discounts,
//                                 onChanged: (Discounts? value) {
//                                   setState(() {
//                                     discounts = value!;
//                                   });
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           height: width * 0.04,
//                         ),
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             AnimatedSize(
//                               duration: Duration(milliseconds: 500),
//                               child: Container(
//                                 width: width * 0.6,
//                                 height: hasDiscount ? 60 : 0,
//                                 child: RadioListTile<Discounts>(
//                                   activeColor: Colors.redAccent,
//                                   title: Text(
//                                     "Custom discount",
//                                     style: TextStyle(
//                                         color: discounts == Discounts.userChoice
//                                             ? Colors.black
//                                             : Colors.grey,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   value: Discounts.userChoice,
//                                   groupValue: discounts,
//                                   onChanged: (Discounts? value) {
//                                     setState(() {
//                                       discounts = value!;
//                                     });
//                                     print(discounts);
//                                   },
//                                 ),
//                               ),
//                             ),
//                             Card(
//                               elevation: 3,
//                               shape: const RoundedRectangleBorder(
//                                   borderRadius:
//                                   BorderRadius.all(Radius.circular(5))),
//                               child: AnimatedSize(
//                                 duration: Duration(milliseconds: 500),
//                                 child: SizedBox(
//                                   height: hasDiscount ? 40 : 0,
//                                   width: width * 0.2,
//                                   child: TextField(
//                                     keyboardType: TextInputType.number,
//                                     decoration: InputDecoration(
//                                       hintText: "%",
//                                       hintStyle: TextStyle(
//                                           color:
//                                           discounts == Discounts.userChoice
//                                               ? Color(0xff00798c)
//                                               : Colors.grey,
//                                           fontWeight: FontWeight.bold,
//                                           letterSpacing: 1.5,
//                                           fontSize: height * 0.02),
//                                       floatingLabelStyle: TextStyle(
//                                         color: Colors.blueGrey,
//                                         fontSize: height * 0.02,
//                                         fontWeight: FontWeight.bold,
//                                         letterSpacing: 1.5,
//                                       ),
//                                       labelStyle: const TextStyle(
//                                         color: Color(0xff00798c),
//                                         fontWeight: FontWeight.bold,
//                                         letterSpacing: 1.5,
//                                       ),
//                                       focusedBorder: const OutlineInputBorder(
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(5)),
//                                           borderSide: BorderSide(
//                                               color: Colors.white,
//                                               style: BorderStyle.none,
//                                               width: 0)),
//                                       disabledBorder: const OutlineInputBorder(
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(5)),
//                                           borderSide: BorderSide(
//                                               color: Colors.white,
//                                               style: BorderStyle.none,
//                                               width: 0)),
//                                       enabledBorder: const OutlineInputBorder(
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(5)),
//                                           borderSide: BorderSide(
//                                               color: Colors.white,
//                                               style: BorderStyle.none,
//                                               width: 0)),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Positioned(
//               top: 1,
//               right: 10,
//               child: Card(
//                 elevation: 10,
//                 color: Colors.white,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(8))),
//                 child: AnimatedSize(
//                   duration: Duration(milliseconds: 300),
//                   child: SizedBox(
//                     height: !openChoice ? 124 : 0,
//                     child: Column(
//                       children: [
//                         GestureDetector(
//                           behavior: HitTestBehavior.translucent,
//                           onTap: () {
//                             setState(() {
//                               chooseChoice = "Publish";
//                               openChoice = true;
//                             });
//                             print(openChoice);
//                           },
//                           child: Container(
//                             height: height * 0.055,
//                             width: width * 0.5,
//                             child: Padding(
//                               padding: const EdgeInsets.fromLTRB(8, 10, 60, 10),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     "Publish",
//                                     textAlign: TextAlign.left,
//                                     style: TextStyle(fontSize: height * 0.02),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         Container(
//                           color: Colors.grey[100],
//                           height: height * 0.003,
//                           width: width * 0.5,
//                         ),
//                         GestureDetector(
//                           behavior: HitTestBehavior.translucent,
//                           onTap: () {
//                             setState(() {
//                               chooseChoice = "Save as a draft";
//                               openChoice = true;
//                             });
//                             print(openChoice);
//                           },
//                           child: SizedBox(
//                               height: height * 0.055,
//                               width: width * 0.5,
//                               child: Padding(
//                                 padding: const EdgeInsets.fromLTRB(08, 0, 0, 0),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       "Save as a draft",
//                                       textAlign: TextAlign.left,
//                                       style: TextStyle(fontSize: 20),
//                                     ),
//                                   ],
//                                 ),
//                               )),
//                         ),
//                         Container(
//                           color: Colors.grey[100],
//                           height: height * 0.003,
//                           width: width * 0.5,
//                         ),
//                         GestureDetector(
//                           behavior: HitTestBehavior.translucent,
//                           onTap: () {
//                             setState(() {
//                               chooseChoice = "Copy and edit on";
//                               openChoice = true;
//                             });
//                             print(openChoice);
//                           },
//                           child: SizedBox(
//                               height: height * 0.055,
//                               width: width * 0.5,
//                               child: Padding(
//                                 padding: const EdgeInsets.fromLTRB(08, 0, 0, 0),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       "Copy and edit on",
//                                       textAlign: TextAlign.left,
//                                       style: TextStyle(fontSize: 20),
//                                     ),
//                                   ],
//                                 ),
//                               )),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
