import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/MyTextField.dart';

// import '../../view/BottomNavigationBarScreen.dart';
import '../../view/OTPScreen.dart';
import '../data/respose/Status.dart';
import '../utils/NegativeButton.dart';
import '../utils/PositiveButton.dart';
import '../utils/utils.dart';
import '../viewmodel/LoginViewModel.dart';
import '../viewmodel/services/SplashServices.dart';
import 'SignUpScreen.dart';
import 'bottomnvgbar/BottomNavigationBarScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  List<bool> isSelected = [true, false];
  bool isAuth = false;
  ValueNotifier obsecurePassword = ValueNotifier(true);

  TextEditingController emailPopupController = TextEditingController();
  TextEditingController mobileNumberPopupController = TextEditingController();
  TextEditingController unitNumberPopupController = TextEditingController();
  List<bool> isSelectedPopup = [true, false];
  bool isRememberMe = false;
  bool isAgree = false;
  SplashServices splashServices = SplashServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // splashServices.getUserDetails(context);
    rememberMe();
  }

  Future<void> rememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isRememberMe = prefs.getBool('rememberMe')!;
    if (isRememberMe) {
      setState(() {
        emailController.text = prefs.getString('email')!;
        passwordController.text = prefs.getString('password')!;
        isRememberMe = true;
      });
    }
  }

  void showBiometricAlertDialogPopup() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 16,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color(0xFF036CB2),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    //gradient: blueGreenGradient,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Center(
                      child: Text(
                        'Alert',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Text(
                  'Do you want to enable Biometrics?',
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    PositiveButton(
                        text: 'No',
                        onPressed: () async {
                          if (emailController.text.isNotEmpty &&
                              passwordController.text.isNotEmpty) {
                            createLoginDetails(context);
                          }

                          Navigator.of(context).pop();
                        }),
                    PositiveButton(
                        text: 'Yes',
                        onPressed: () async {
                          _checkBiometric();

                          Navigator.of(context).pop();
                        }),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _checkBiometric() async {
    final viewModel = Provider.of<LoginViewModel>(context, listen: false);
    // check for biometric availability
    final LocalAuthentication auth = LocalAuthentication();
    bool canCheckBiometrics = false;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } catch (e) {
      print("error biome trics $e");
    }

    print("biometric is available: $canCheckBiometrics");

    // enumerate biometric technologies
    List<BiometricType>? availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } catch (e) {
      print("error enumerate biometrics $e");
    }

    print("following biometrics are available");
    if (availableBiometrics!.isNotEmpty) {
      availableBiometrics.forEach((ab) {
        print("\ttech: $ab");
      });
    } else {
      print("no biometrics are available");
    }

    // authenticate with biometrics
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Touch your finger on the sensor to login',
        // useErrorDialogs: true,
        // stickyAuth: false,
        // androidAuthStrings:
        // AndroidAuthMessages(signInTitle: "Login to HomePage")
      );
      if (authenticated) {
        Map<String, dynamic> data = {
          "email": emailController.text.toString(),
          "login_type": 1,
          "mob_user_signup": 1,
          "password": passwordController.text.toString(),
          "user_type": 4,
        };

        viewModel.fetchUserDetails(data, context);
      }
    } catch (e) {
      print("error using biometric auth: $e");
    }
    setState(() {
      isAuth = authenticated ? true : false;
    });

    print("authenticated: $authenticated");
  }

  Future createLoginDetails(BuildContext context) async {
    final viewModel = Provider.of<LoginViewModel>(context, listen: false);

    if (emailController.text.isEmpty) {
      Utils.flushBarErrorMessage('Email can\'t be empty', context);
    } else if (passwordController.text.isEmpty) {
      Utils.flushBarErrorMessage('Password can\'t be empty', context);
    } else {
      Map<String, dynamic> data = {
        //
        "email": emailController.text.toString(),
        "login_type": 1,
        "user_type": 4,
        "password": passwordController.text.toString(),
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('rememberMe', isRememberMe);
      prefs.setString('email', emailController.text.toString());
      prefs.setString('password', passwordController.text.toString());

      viewModel.fetchUserDetails(data, context);
    }
  }

  Future createLoginDetails1(BuildContext context) async {
    final viewModel = Provider.of<LoginViewModel>(context, listen: false);

    if (emailController.text.isEmpty) {
      Utils.flushBarErrorMessage('Email can\'t be empty', context);
    } else if (passwordController.text.isEmpty) {
      Utils.flushBarErrorMessage('Password can\'t be empty', context);
    } else {
      Map<String, dynamic> data = {
        "email": emailController.text.toString(),
        "login_type": 1,
        "mob_user_signup": 1,
        "password": passwordController.text.toString(),
        "user_type": 4
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('rememberMe', isRememberMe);
      prefs.setString('email', emailController.text.toString());
      prefs.setString('password', passwordController.text.toString());

      viewModel.fetchUserDetails1(data, context).then((value) {
        print("resp = $value");
        if (value.data!.status == 201) {
          print('msg = ${value.data!.mobMessage}');
          Utils.flushBarErrorMessage("${value.data!.mobMessage}", context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BottomNavigationBarScreen()));
        } else {
          if (value.data!.mobMessage != null) {
            Utils.flushBarErrorMessage("${value.data!.mobMessage}", context);
          }
        }
      }).onError((error, stackTrace) {
        if (kDebugMode) {
          Utils.flushBarErrorMessage(error.toString(), context);
          print(error.toString());
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();

    emailController.dispose();
    mobileNumberController.dispose();
    passwordController.dispose();
    obsecurePassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isAuth
        ? BottomNavigationBarScreen()
        : Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            body: SafeArea(
                child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    color: Colors.white30,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          // height: MediaQuery.of(context).size.height * 0.25,
                          child: Image.asset(
                            'assets/images/splsh.jpg',
                            height: MediaQuery.of(context).size.height * 0.25,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.009,
                        ),
                        SizedBox(
                            // height:MediaQuery.of(context).size.height * 0.08,
                            child: Center(
                          child: Image.asset(
                            'assets/images/VMS-POMS_Logo1.png',
                            height: MediaQuery.of(context).size.height * 0.08,
                          ),
                        )),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.015,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                          // width: MediaQuery.of(context).size.width * 0.95,
                          child: Center(
                            child: ToggleButtons(
                              borderRadius: BorderRadius.circular(10.0),
                              selectedColor: Color(0xFF85D2FF),
                              fillColor: Color(0xFF036CB2),
                              // Colors.indigo.shade500,
                              borderColor: Colors.grey.shade400,
                              borderWidth: 1,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30, right: 30),
                                  child: Text(
                                    'Email',
                                    style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                          color: isSelected[0]
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal),
                                    ),

                                    // style: TextStyle(
                                    //   color: isSelected[0]
                                    //       ? Colors.white
                                    //       : Colors.black,
                                    // ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30, right: 30),
                                  child: Text(
                                    'Mobile Number',
                                    style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                          color: isSelected[1]
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ),
                              ],
                              isSelected: isSelected,
                              onPressed: (index) {
                                setState(() {
                                  for (int i = 0; i < isSelected.length; i++) {
                                    isSelected[i] = i == index;
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),

                        // isSelected[0]?  MyTextField( controller: emailController, textInputType: TextInputType.emailAddress,hintText: 'Email',):
                        //   MyTextField( controller: mobileNumberController, textInputType: TextInputType.emailAddress,hintText: 'Mohile Number',),
                        isSelected[0]
                            ? SizedBox(
                                width: MediaQuery.of(context).size.width * 0.90,
                                child: TextFormField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  cursorColor: Colors.grey,
                                  style: Theme.of(context).textTheme.bodySmall,
                                  decoration: InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 20.0),
                                      prefixText: ' ',
                                      hintText: "Email",
                                      hintStyle: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 13,
                                              fontWeight: FontWeight.normal)),
                                      prefixIcon: Icon(Icons.email_rounded)),
                                ),
                              )
                            : SizedBox(
                                width: MediaQuery.of(context).size.width * 0.90,
                                child: TextFormField(
                                  controller: mobileNumberController,
                                  keyboardType: TextInputType.number,
                                  cursorColor: Colors.grey,
                                  style: Theme.of(context).textTheme.bodySmall,
                                  decoration: InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 20.0),
                                      prefixText: ' ',
                                      hintStyle: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 13,
                                              fontWeight: FontWeight.normal)),
                                      hintText: "Mobile Number",
                                      prefixIcon: Icon(Icons.dialpad)),
                                ),
                              ),

                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.90,
                          child: ValueListenableBuilder(
                              valueListenable: obsecurePassword,
                              builder: (context, value, child) {
                                return TextFormField(
                                  controller: passwordController,
                                  obscureText: obsecurePassword.value,
                                  keyboardType: TextInputType.visiblePassword,
                                  cursorColor: Colors.grey,
                                  style: Theme.of(context).textTheme.bodySmall,
                                  decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    labelStyle: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                    prefixText: ' ',
                                    hintText: "Password",
                                    hintStyle: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal)),
                                    prefixIcon: Icon(Icons.password_rounded),
                                    suffixIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              obsecurePassword.value =
                                                  !obsecurePassword.value;
                                            },
                                            child: obsecurePassword.value
                                                ? const Icon(
                                                    Icons.visibility_off,
                                                    color: Colors.grey,
                                                  )
                                                : const Icon(
                                                    Icons.visibility_outlined,
                                                    color: Colors.grey,
                                                  )),
                                        IconButton(
                                          icon: Image.asset(
                                            "assets/images/face-id-100.png",
                                          ),
                                          onPressed: () {
                                            showBiometricAlertDialogPopup();
                                            // _checkBiometric();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Checkbox(
                                  activeColor: Colors.white,
                                  checkColor: Colors.grey.shade700,
                                  side: MaterialStateBorderSide.resolveWith(
                                    (states) => BorderSide(
                                        width: 1.0,
                                        color: Colors.grey.shade700),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3.0),
                                  ),
                                  value: isRememberMe,
                                  onChanged: (value) {
                                    setState(() {
                                      isRememberMe = value!;
                                    });
                                  }),
                            ),
                            Text('Remember Me',
                                style: Theme.of(context).textTheme.bodySmall),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Text('Do you have an account? ',
                                  style: Theme.of(context).textTheme.bodySmall),
                            ),
                          ],
                        ),

                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.70,
                          child: PositiveButton(
                              text: 'Sign In',
                              onPressed: () {
                                createLoginDetails1(context);
                              }),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.055,
                              width: MediaQuery.of(context).size.width * 0.30,
                              child: PositiveButton(
                                  text: 'Sign Up',
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignupScreen()));
                                  }),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1,
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.055,
                              width: MediaQuery.of(context).size.width * 0.30,
                              child: PositiveButton(
                                  text: 'First Time Activation',
                                  onPressed: () {
                                    popUp();
                                  }),
                            ),
                          ],
                        ),
                        TextButton(
                          child: Text('Forgot Password?',
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromRGBO(3, 5, 68, 1.0),
                                    fontWeight: FontWeight.normal),
                              )),
                          onPressed: () {},
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Checkbox(
                                      activeColor: Colors.white,
                                      checkColor: Colors.grey.shade700,
                                      side: MaterialStateBorderSide.resolveWith(
                                        (states) => BorderSide(
                                            width: 1.0,
                                            color: Colors.grey.shade700),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(3.0),
                                      ),
                                      value: isAgree,
                                      onChanged: (value) {
                                        setState(() {
                                          isAgree = value!;
                                        });
                                      }),
                                ),
                                Text(
                                  'By proceeding I also agree to',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  child: Text(
                                    'Terms of Service',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                          color: Color(0xFF036CB2),
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (isAgree == true) {
                                      _launchWebsite();
                                    }
                                  },
                                ),
                                Text(
                                  'and',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                                Text(
                                  ' Privacy Policy ',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                        color: Color(0xFF036CB2),
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.025,
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/images/312p-eeZ-App Full-Logo.png',
                          height: MediaQuery.of(context).size.height * 0.04,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
          );
  }

  void _launchWebsite() async {
    const url =
        'https://www.Halcyonss.com'; // Replace with your desired website URL

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchWebsite1() async {
    const url =
        'https://www.GaliniosInfotech.com'; // Replace with your desired website URL

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void popUp() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 16,
          child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Color(0xFF036CB2),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      //gradient: blueGreenGradient,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Center(
                        child: Text(
                          'Verify Unit',
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.04,
                    // width: MediaQuery.of(context).size.width * 0.95,
                    child: Center(
                      child: ToggleButtons(
                        borderRadius: BorderRadius.circular(10.0),
                        selectedColor: Color(0xFF85D2FF),
                        fillColor: Color(0xFF036CB2),
                        // Colors.indigo.shade500,
                        borderColor: Colors.grey.shade400,
                        borderWidth: 1,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 30, right: 30),
                            child: Text('Email',
                                style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                    color: isSelectedPopup[0]
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 30, right: 30),
                            child: Text(
                              'Mobile Number',
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                  color: isSelectedPopup[1]
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                        isSelected: isSelectedPopup,
                        onPressed: (index) {
                          setState(() {
                            for (int i = 0; i < isSelectedPopup.length; i++) {
                              isSelectedPopup[i] = i == index;
                            }
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  isSelectedPopup[0]
                      ? MyTextField(
                          controller: emailPopupController,
                          labelText: 'Enter Email',
                          preffixIcon: Icons.email,
                          textInputType: TextInputType.emailAddress)
                      : MyTextField(
                          controller: mobileNumberPopupController,
                          labelText: 'Enter Mobile Number',
                          preffixIcon: Icons.numbers,
                          textInputType: TextInputType.number),
                  MyTextField(
                      controller: unitNumberPopupController,
                      labelText: 'Unit No',
                      preffixIcon: Icons.confirmation_number,
                      textInputType: TextInputType.text),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.30,
                        child: PositiveButton(
                            text: 'Submit',
                            onPressed: () {
                              submitEmail();
                            }),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.30,
                        child: PositiveButton(
                            text: 'Cancel',
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  void submitEmail() async {
    final viewModel = Provider.of<LoginViewModel>(context, listen: false);

    Map<String, dynamic> data = {
      "email_to": emailPopupController.text.toString(),
      "unit_no": unitNumberPopupController.text.toString()
    };

    viewModel.submitEmail(data, context).then((value) {
      if (value.data!.status == 201) {
        print('msg = ${value.data!.mobMessage}');
        Utils.flushBarErrorMessage("${value.data!.mobMessage}", context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OTPScreen(
                      data: emailPopupController.text.toString(),
                    )));
      } else {
        Utils.flushBarErrorMessage("${value.data!.mobMessage}", context);
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        Utils.flushBarErrorMessage(error.toString(), context);
        print(error.toString());
      }
    });
  }
}
/*
viewModel.fetchUserDetails1(data, context).then((value) {
        print("resp = $value");
        if (value.status == Status.success) {

          Utils.flushBarErrorMessage("${value.data!.mobMessage}", context);
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => BottomNavigationBarScreen( )));
        } else {
          Utils.flushBarErrorMessage("${value.data!.mobMessage}", context);
          print('Message = ${value.data!.mobMessage}');
        } ;
      }).onError((error, stackTrace) {
        // Handle error during the fetchUserDetails1 operation
        if (kDebugMode) {
          Utils.flushBarErrorMessage(error.toString(), context);
          print(error.toString());
        }
      });
 */
