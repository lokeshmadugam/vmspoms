import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/PositiveButton.dart';
import '/model/CountryModel.dart';
import '../../utils/MyDropdown.dart';
import '../../utils/MyTextField.dart';
import '../model/ServiceType.dart';
import '../utils/Utils.dart';

import '../viewmodel/SignUpViewModel.dart';
import 'LoginScreen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController unitNumberController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();
  TextEditingController identityIdController = TextEditingController();
  TextEditingController propertyIdController = TextEditingController();
  TextEditingController raceController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  var viewmodel = SignUpViewModel();
  List<ServiceItems> items = [];
  List<CountryItems> countryItems = [];
  List<ServiceItems> identificationItems = [];
  int genderId = 0;
  int identificationTypeId = 0;
String country = '';
  bool isAgree = false;
  // KeyValueModel selectedValue;
  // String hello;
  TextEditingController v = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchGender('Gender');
    fetchIdentificationType('IdentityType');
    fetchCountry();
  }

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    unitNumberController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    nationalityController.dispose();
    identityIdController.dispose();
    propertyIdController.dispose();
    raceController.dispose();
    addressController.dispose();
  }

  Future<void> fetchGender(var configKey) async {
    viewmodel.fetchGender(configKey).then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.items;
          if (data != null) {
            setState(() {
              items = data;
            });
          }
        }
      }
    }).catchError((error) {
      Utils.flushBarErrorMessage("failed", context);
    });
  }

  Future<void> fetchIdentificationType(var configKey) async {
    viewmodel.fetchGender(configKey).then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.items;
          if (data != null) {
            setState(() {
              identificationItems = data;
            });
          }
        }
      }
    }).catchError((error) {
      Utils.flushBarErrorMessage("failed", context);
    });
  }
  Future<void> fetchCountry() async {
    viewmodel.fetchCountry("ASC","id",1, 500).then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.items;
          if (data != null) {
            setState(() {
              countryItems = data;
            });
          }
        }
      }
    }).catchError((error) {
      Utils.flushBarErrorMessage("failed", context);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leadingWidth: 90,
          elevation: 0.0,
          leading: Row(
            children: [
              SizedBox(
                width: 20,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                  iconSize: 20, // reduce the size of the icon
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 1.0),
                child: SizedBox(
                  width: 60, // set a wider width for the text
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    child: Text(
                      'Back',
                      style: Theme.of(context).textTheme.headlineMedium
                      // TextStyle(
                      //   fontSize: 16, // reduce the font size
                      //   color: Colors.white,
                      //   fontWeight: FontWeight.bold,
                      // ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          title: Text(
            'Sign Up',
            style: Theme.of(context).textTheme.headlineLarge,
            // TextStyle(
            //     fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/VMS-POMS_Logo1.png',
                      height: MediaQuery.of(context).size.height * 0.08,
                    ),
                  ),
                  Text('E - Residences', style: TextStyle(fontSize: 20)),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  buildContainer(
                      controller: propertyIdController,
                      textInputType: TextInputType.text,
                      icon: Icons.ac_unit_outlined,
                      hinttext: 'Property ID',),
                  buildContainer(
                      controller: unitNumberController,
                      textInputType: TextInputType.text,
                      icon: Icons.confirmation_num,
                      hinttext: 'Unit No'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        child: buildContainer(
                          controller: firstNameController,
                          hinttext: 'First Name',
                          icon: Icons.person,
                          textInputType: TextInputType.text,
                        ),
                      ),
                      Expanded(
                          child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        child: buildContainer(
                          controller: lastNameController,
                          textInputType: TextInputType.text,
                          icon: Icons.perm_identity,
                          hinttext: 'Last Name',
                        ),
                      ))
                    ],
                  ),
                  MyDropDown(
                      value: null,
                      hintText: 'Gender',
                      items: items
                          .map((item) => item.keyValue)
                          .map((gender) =>
                          DropdownMenuItem<String>(
                            value: gender,
                            child: Text(gender!),
                          ))
                          .toList(),
                      onchanged: (value) {
                        for(int i=0;i<items.length;i++){
                          if(value==items[i].keyValue){
                            genderId = items[i].id!;
                            break;
                          }
                        }
                      }
                  ),
                  buildContainer(
                      controller: phoneNumberController,
                      textInputType: TextInputType.number,
                      icon: Icons.numbers,
                      hinttext: 'Phone Number'),
                  buildContainer(
                      controller: emailController,
                      textInputType: TextInputType.emailAddress,
                      icon: Icons.mail,
                      hinttext: 'Email Address'),
                  buildContainer(
                      controller: raceController,
                      textInputType: TextInputType.text,
                      icon: Icons.supervisor_account,
                      hinttext: 'Race'),











              Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownSearch<CountryItems>(

                        selectedItem:null,
                        items: countryItems,
                        itemAsString: (CountryItems item) => item.name ?? " ",


                          dropdownDecoratorProps: DropDownDecoratorProps(

                            dropdownSearchDecoration: InputDecoration(
                              // labelText: "Nationality",
                              hintText: "Nationality",

                              hintStyle: GoogleFonts.roboto(textStyle:TextStyle(color: Colors.grey,fontSize: 13), ) ,


                              // contentPadding: EdgeInsets.symmetric(horizontal: 30), // Adjust padding for size

                              contentPadding:
                              const EdgeInsets.fromLTRB(10,0,0,0),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.grey, width: 0.5),
                              ),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.grey, width: 0.5),

                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.grey, width: 0.5),
                                borderRadius: BorderRadius.circular(10.0),
                              ),


                            ),


                            baseStyle: const TextStyle(color: Colors.black),
                          ),
                        dropdownButtonProps: DropdownButtonProps(
                          padding: EdgeInsets.fromLTRB(30,0,4,0),
                          iconSize: 24,
                          icon: Icon(Icons.arrow_drop_down_outlined,color: Colors.black54,),
                          constraints: BoxConstraints(
                            minHeight: 5,
                            minWidth: 5
                          )

                        ),
                        dropdownBuilder: (BuildContext context, CountryItems? item)  {
                          if (item == null) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Text("Nationality",style:GoogleFonts.roboto(textStyle:TextStyle(color: Colors.grey,fontSize: 13), )),
                            ); // Replace "Nationality" with your desired hint text
                          }else {
                            return Row(
                              children: [
                                if (item != null && item.mobFlagUrl != null &&
                                    item.mobFlagUrl != "Select")
                                  Image.network(
                                      item.mobFlagUrl ?? '', fit: BoxFit.fill,
                                      width: 24,
                                      height: 24),
                                const SizedBox(width: 8),
                                Text(item?.name ?? ''),
                                // Icon(Icons.arrow_drop_down),
                              ],
                            );
                          }
                        },
                        onChanged: (value) async{

                          v.text = value!.name.toString();
                          print(value.name);
                        },

                        filterFn: (instance, filter) {
                          final lowercaseFilter = filter.toLowerCase();
                          if (instance.name!.toLowerCase().contains(lowercaseFilter)) {
                            print(filter);
                            country = filter;
                            return true;
                          } else {
                            return false;
                          }
                        },


                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          showSelectedItems: false,
                          // disabledItemFn: (String s) => s.startsWith('I'),
                          searchFieldProps: TextFieldProps(
                              controller: v,

                              decoration: InputDecoration(

                                enabledBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                ),
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(color: Colors.grey, width: 1.0),

                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    v.clear();
                                  },
                                ),
                              )
                          ),
                          itemBuilder: (BuildContext context, CountryItems? item, bool isSelected)  {
                            return ListTile(
                              selected: isSelected,
                              leading: item != null && item.mobFlagUrl != null && item.mobFlagUrl != "Select"
                                  ? Image.network(item.mobFlagUrl ?? '', fit: BoxFit.fill, width: 24, height: 24)
                                  : null,
                              title: Text(item?.name ?? ''),
                            );

                          },
                        ),


                      ),
                    ),
                  ),






                  MyDropDown(
                      value: null,
                      hintText: 'Select Identification Type',
                      items: identificationItems
                          .map((item) => item.keyValue)
                          .map((identityType) =>
                          DropdownMenuItem<String>(
                            value: identityType,
                            child: Text(identityType!),
                          ))
                          .toList(),
                      onchanged: (value) {
                        for(int i=0;i<identificationItems.length;i++){
                          if(value==identificationItems[i].keyValue){
                            identificationTypeId = identificationItems[i].id!;
                            break;
                          }
                        }
                      }
                  ),
                  buildContainer(
                      controller: identityIdController,
                      textInputType: TextInputType.number,
                      icon: Icons.account_balance,
                      hinttext: 'Identity ID'),

                  buildContainer(
                      controller: addressController,
                      textInputType: TextInputType.streetAddress,
                      icon: Icons.location_city_rounded,
                      hinttext: 'Current Address'),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
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
                                      (states) => BorderSide(width: 1.0, color: Colors.grey.shade700),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3.0),
                                ),
                                value: isAgree,
                                onChanged: (value) {
                                  setState(() {
                                    isAgree = value!;
                                  });
                                }
                            ),
                          ),
                          Text(
                            'By proceeding I also agree',
                            textAlign: TextAlign.center,
                           style:GoogleFonts.roboto(textStyle:TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.normal), ),
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
                              style:GoogleFonts.roboto(textStyle:TextStyle(color: Color(0xFF036CB2),fontSize: 15,fontWeight: FontWeight.normal), ),

                              // style: TextStyle(fontSize: 15,color: ),
                            ),
                            onPressed: (){
                              if( isAgree == true) {
                                _launchWebsite();
                              }
                            },
                          ),
                          Text(
                            'and',
                            textAlign: TextAlign.center,
                            style:GoogleFonts.roboto(textStyle:TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.normal), ),

                          ),
                          Text(
                            ' Privacy Policy ',
                            textAlign: TextAlign.center,
                            // style: TextStyle(fontSize: 15,color: Color(0xFF036CB2)),
                            style:GoogleFonts.roboto(textStyle:TextStyle(color: Color(0xFF036CB2),fontSize: 15,fontWeight: FontWeight.normal), ),

                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: PositiveButton(
                        text: 'Submit',
                        onPressed: () {
                          submitSignUpDetails();
                        }
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          'Do you have an account? ',
                        style:GoogleFonts.roboto(textStyle:TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.normal), ),

                        // style: TextStyle(
                          //   fontSize: 15,
                          // )
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      TextButton(
                        child:  Text(
                          'Sign In',
                          style:GoogleFonts.roboto(textStyle:TextStyle(color:  Color(0xFF036CB2),fontSize: 15,fontWeight: FontWeight.normal), ),

                          // style:
                          //     TextStyle(fontSize: 15, color: Color(0xFF036CB2)),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Container buildContainer(
      {required String hinttext,
      required TextEditingController controller,
      required TextInputType textInputType,
      required IconData icon,
      String? labelText}) {
    return Container(
        color: Colors.white,
        child: MyTextField(
          controller: controller,
          hintText: hinttext,
          labelText: labelText,
          preffixIcon: icon,
          textInputType: textInputType,
        ));
  }

  void submitSignUpDetails() async {

    Map<String, dynamic> data = {
      "created_by": 31,
      "current_address": addressController.text.toString(),
      "email_address": emailController.text.toString(),
      "email_valid": "string",
      "first_name": firstNameController.text.toString(),
      "gender": genderId,
      "identification_type_id": identificationTypeId,
      "last_name": lastNameController.text.toString(),
      "nationality": country,
      "otp": 0,
      "phone": phoneNumberController.text.toString(),
      "property_id": propertyIdController.text.toString(),
      "race": raceController.text.toString(),
      "rec_status": 8,
      "signup_mode": 1,
      "signup_req_status": "R",
      "unique_id": identityIdController.text.toString(),
      "unit_number": unitNumberController.text.toString()
    };

    viewmodel.submitSignUpDetails(data, context).then((value) {
      if (value.data!.status == 201) {
        print('msg = ${value.data!.mobMessage}');
        Utils.flushBarErrorMessage("${value.data!.mobMessage}", context);
      } else {
        Utils.flushBarErrorMessage(
            " Update failed".toString(), context);
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        Utils.flushBarErrorMessage(error.toString(), context);
        print(error.toString());
      }
    });
  }
  void _launchWebsite() async {
    const url = 'https://www.Halcyonss.com'; // Replace with your desired website URL

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  void _launchWebsite1() async {
    const url = 'https://www.GaliniosInfotech.com'; // Replace with your desired website URL

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}




