import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_indicator/loading_indicator.dart';


class ForgotPassword extends StatefulWidget {
  bool isFromBiometricPage;

  ForgotPassword({this.isFromBiometricPage = false});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();

}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool showPass = true;
  bool isLoading = false;


  @override
  void initState() {

    super.initState();
  }
  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
      // ScaffoldMessenger.of(context).
      Fluttertoast.showToast(msg: 'Password Reset Email has been sent !');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: 'No user found!');

      }
    }
  }
  @override
  Widget build(BuildContext context) {
    var _passwordVisible;
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
                            Text("Forgot Password",style: TextStyle(fontSize: 22,color: Colors.white),)
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
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


                      SizedBox(
                        height: 5,
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
                      SizedBox(
                        height: 10,
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
            resetPassword();
          }
        },
        child: const Text(
          'Confirm',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
        ),

      ),

    );

  }

}