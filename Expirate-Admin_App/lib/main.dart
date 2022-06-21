import 'package:comp_part1_2/pages/create_profile_page.dart';
import 'package:comp_part1_2/pages/home_page.dart';
import 'package:comp_part1_2/providers/location_provider.dart';
import 'package:comp_part1_2/providers/product_list.dart';
import 'package:comp_part1_2/providers/sign_up_provider.dart';
import 'package:comp_part1_2/services/authentication_services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:comp_part1_2/pages/page.dart';

import 'constants.dart';
import 'models/product_model.dart';
import 'models/products.dart';
import 'services/location_service.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp( MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final Future<FirebaseApp> _initializtion = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return StreamProvider(
      create: (context) => LocationService().locationStream, initialData: null,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<SLpage>(create: (BuildContext context) => SLpage()),
          ChangeNotifierProvider<ProductList>(create: (BuildContext context) => ProductList()),
          ChangeNotifierProvider<SignUpProvider>(create: (BuildContext context) => SignUpProvider(username: "")),
          ChangeNotifierProvider<Products>(create: (BuildContext context) => Products()),
          ChangeNotifierProvider<ProductModel>(create: (BuildContext context) => ProductModel()),
          ChangeNotifierProvider<AuthenticationService>(create: (BuildContext context)=> AuthenticationService(FirebaseAuth.instance)),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.red,
          ),
          //home: Provider.of<SLpage>(context).Login,
          home: FutureBuilder(
            future:  _initializtion,
            builder: (context, snapshot){
              if(snapshot.hasError){
                return Center(child: Text("Error"),);
              }
              else if(snapshot.hasData){
                return StreamBuilder<User?>(
                  stream: AuthenticationService(FirebaseAuth.instance).authService,
                  builder: (context, snapshot) {
                    Widget returnedChild;
                    if(snapshot.connectionState == ConnectionState.waiting){
                      returnedChild = CircularProgressIndicator();
                    }else{
                      if (snapshot.data == null) {
                        returnedChild = CommonPage();
                      }else{
                        print(Provider.of<SLpage>(context).isLogin);
                        returnedChild = !Provider.of<SLpage>(context).isLogin ? Home() : CreateProfilePage(username: Provider.of<SignUpProvider>(context, listen: false).username);
                      }
                    }
                    return returnedChild;
                  },

                );
              }
              else{
                return Center(child: CircularProgressIndicator(),);
              }
            },
          )

        ),
      ),
    );
  }
}

class CommonPage extends StatefulWidget {
  const CommonPage({Key? key}) : super(key: key);

  @override
  _CommonPageState createState() => _CommonPageState();
}

class _CommonPageState extends State<CommonPage> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(

      body: Provider.of<SLpage>(context).Login,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: height * 0.2,
        centerTitle: true,
        title: SwitchListTile(
          activeColor: Colors.redAccent[400],
          autofocus: false,
          title: Provider.of<SLpage>(context).isLogin?
          Text("SignIn", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),):
          Text("SingUp",  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          onChanged: (_){
            Provider.of<SLpage>(context, listen: false).toggleLogin();
          },
          value: Provider.of<SLpage>(context).isLogin,
        ),
      ),

    );

  }
}