import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frerro/all%20screens/main_screen.dart';
import 'package:frerro/auth/registerScreen.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'forgotScreen.dart';

class LoginScreen extends StatefulWidget {
  bool isFromBiometricPage;

  LoginScreen({this.isFromBiometricPage = false});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();



  final storage = FlutterSecureStorage();
  final formKey = GlobalKey<FormState>();

  bool showPass = true;
  bool isLoading = false;


  @override
  void initState() {

    super.initState();
  }
  userLogin() async {
    isLoading = true;
    setState(() {});
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      UserCredential userCredential=await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email.text, password: password.text);

      print(userCredential.user?.uid);
      await storage.write(key: "uid", value: userCredential.user?.uid);
      isLoading = false;
      setState(() {});
      await preferences.setString('user', email.text.trim());

      Fluttertoast.showToast(msg: 'Successfully logged in');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(),
        ),
      );


    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print("No User Found for that Email");
        isLoading = false;
        setState(() {});
        Fluttertoast.showToast(msg: 'No User Found for that Email');

      } else if (e.code == 'wrong-password') {
        print("Wrong Password Provided by User");
        isLoading = false;
        setState(() {});
        Fluttertoast.showToast(msg: 'Wrong Password Provided by User');

      }
    }
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(

        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(120)),
                    color: Colors.blue,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("images/frerrologo.png",height: 200,width: 200,)
                          ],
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("Login",style: TextStyle(fontSize: 22,color: Colors.white),)
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, ),
                  child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     const SizedBox(
                       height: 24,
                     ),
                     Card(
                       elevation: 1,
                       child: TextFormField(
                         controller: email,
                         decoration: InputDecoration(
                           hintText: "Enter your email",
                           prefixIcon: Icon(Icons.email),
                           border: InputBorder.none,

                         ),
                       ),
                     ),
                     const SizedBox(
                       height: 14,
                     ),
                     Card(
                       elevation: 1,
                       child: TextFormField(
                         controller: password,
                         decoration: InputDecoration(
                           hintText: "password",
                           prefixIcon: Icon(Icons.remove_red_eye),
                           border: InputBorder.none,

                         ),
                       ),
                     ),
                     const SizedBox(
                       height: 5,
                     ),

                     Row(
                       mainAxisAlignment: MainAxisAlignment.end,
                       children: [
                         GestureDetector(
                             onTap: (){
                               Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPassword()));
                             },
                             child: const Text("Forgot Password",style: TextStyle(color: Colors.blue),))
                       ],
                     ),
                     const SizedBox(
                       height: 25,
                     ),
                     isLoading
                         ? Center(
                       child: SizedBox(
                           width: 80,
                           child: LoadingIndicator(
                               indicatorType: Indicator.ballBeat,
                               colors: [
                                 Theme.of(context).primaryColor,
                               ],
                               strokeWidth: 2,
                               pathBackgroundColor:
                               Theme.of(context).primaryColor)),
                     ):
                     buttonWidget(),
                     const  SizedBox(
                       height: 40,
                     ),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         const  Text(
                           "Don't have account?",
                           style: TextStyle(
                               color: Colors.grey, fontSize: 15, letterSpacing: 0.8),
                         ),
                         GestureDetector(
                           onTap: (){
                             Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterScreen()));
                           },
                           child:const  Text(
                             "SignUp",
                             style: TextStyle(
                                 color: Colors.blue, fontSize: 16, letterSpacing: 0.8),
                           ),
                         ),

                       ],
                     ),
                   ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget buttonWidget() {
    return ButtonTheme(
      height: 47,
      minWidth: MediaQuery.of(context).size.width,
      child: MaterialButton(
        color: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        onPressed: () async {
          if (formKey.currentState!.validate()) {


            userLogin();
          }
        },
        child: const Text(
          'Login',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
        ),

      ),

    );

  }

}