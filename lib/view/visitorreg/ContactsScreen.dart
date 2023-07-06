
import 'dart:typed_data';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../model/SignInModel.dart';
import '../../utils/MyTextField.dart';
import 'InvitationsScreen.dart';
import 'VisitorRegistrationFormScreen.dart';
import 'dart:io';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Contact> _contacts = [];
  List<Contact> _contactsFiltered = [];
  List<Permissions> permissions = [];
  TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _getContacts();

  }

  Future<void> _getContacts() async {
    if (Platform.isAndroid) {
      final status = await Permission.contacts.request();
      if (!status.isGranted) {
        // Handle permission denied
        return;
      }
    }
    _searchController.addListener(() {
      filterContacts();
    });
    final contacts = await ContactsService.getContacts(withThumbnails: true);
    setState(() {
      _contacts = contacts.map((c) {
        // final phones = c.phones?.map((p) => p.value).toList();
        return Contact(
          displayName: c.displayName ?? '',
          givenName: c.givenName ?? '',
          phones: c.phones ?? [],
          avatar: c.avatar != null ? c.avatar! : null,
        );
      }).toList();
    });
  }
  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }
  filterContacts() {
    String searchTerm = _searchController.text.toLowerCase();
    String searchTermFlatten = flattenPhoneNumber(searchTerm);

    setState(() {
      _contactsFiltered = _contacts.where((contact) {
        String contactName = contact.displayName.toLowerCase();
        bool nameMatches = contactName.contains(searchTerm);

        if (nameMatches) {
          return true;
        }

        if (searchTermFlatten.isEmpty) {
          return false;
        }

        return contact.phones.any((phn) {
          String phnFlattened = flattenPhoneNumber(phn.value ?? '');
          return phnFlattened.contains(searchTermFlatten);
        });
      }).toList();
    });
  }
  Contact? _selectedContact;
  bool? select;
  void _selectContact(Contact contact, bool? value, String selectedPhone) {
    setState(() {
      if (value == true) {
        // Select the contact
        _selectedContact = contact;

        // Deselect all other contacts
        for (var c in _contacts) {
          c.isSelected = (c == contact);
        }

        // Set the selected phone number for the contact
        if (contact.phones != null) {
          for (var phone in contact.phones!) {
            if (phone.value == selectedPhone) {
              contact.selectedPhone = selectedPhone;
              break;
            }else{
              contact.selectedPhone = '';
            }
          }
        }
      } else {
        // Deselect the contact
        _selectedContact = null;
        contact.isSelected = false;
      }
    });
  }
  List<String> getDistinctPhones(Contact contact) {
    final phones = contact.phones?.map((phn) => phn.value).toList() ?? [];
    final distinctPhones = <String>[];

    for (var phone in phones) {
      final normalizedPhone = normalizePhoneNumber(phone ?? '');
      if (!distinctPhones.contains(normalizedPhone)) {
        distinctPhones.add(normalizedPhone);
      }
    }

    return distinctPhones;
  }

  String normalizePhoneNumber(String phoneNumber) {
    return phoneNumber.replaceAll(RegExp(r'\D'), '');
  }

  void _selectPhone(Contact contact, String? phone) {
    setState(() {
      contact.selectedPhone = phone;

    });
  }
  bool isPhoneSelected(Contact contact, String phone) {
    return contact.phones?.any((phn) => normalizePhoneNumber(phn.value ?? '') == normalizePhoneNumber(phone)) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = _searchController.text.isNotEmpty;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    print("Wid = $width");
    print("hei = $height");
    double? fontSize;
    if(width < 411 || height < 707){
      fontSize = 11;
      print("SmallSize = $fontSize");
    }else {
      fontSize = 14;
      print("BigSize = $fontSize");
    }
    return Scaffold(

      appBar: AppBar(
        leadingWidth: 90,
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
                  ),
                ),
              ),
            ),
          ],
        ),
        title: Text(
          'Phone Contacts',
     style: Theme.of(context).textTheme.headlineLarge
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF036CB2),
      ),
      body:
      SafeArea(
        child: Column(
          children: [
            SizedBox(
              child: Container(
                  child: MyTextField(
                    hintText: 'Search',
                    controller: _searchController,
                    onChanged: (value) {

                    },
                    textInputType: TextInputType.text,
                    suffixIcon: Icons.search,
                  )),
            ),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.01,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: isSearching == true ? _contactsFiltered.length : _contacts.length,
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final contact = isSearching == true ? _contactsFiltered[index] : _contacts[index];
                  final distinctPhones = getDistinctPhones(contact);
                  return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300, width: 1.0), // Add a bottom border to separate contacts
                        ),
                      ),
                      child:
                      CheckboxListTile(
                        title: Text(contact.displayName,style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: fontSize), )),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (distinctPhones.length == 1)
                              Text(
                                contact.phones?.isNotEmpty == true ? contact.phones!.first.value ?? '' : '',
                              ),
                            if (distinctPhones.length > 1)
                              Column(
                                children: distinctPhones.map((phone) {
                                  return ListTile(
                                    title: Text(phone),
                                    onTap: () {
                                      if (contact.selectedPhone == phone) {
                                        _selectPhone(contact, ''); // Deselect the phone
                                      } else {
                                        _selectPhone(contact, phone); // Select the phone
                                      }
                                    },
                                    trailing: Visibility(
                                        visible: contact.isSelected,
                                        child:Checkbox(
                                          value: (distinctPhones.indexOf(phone) == 0 && contact.selectedPhone?.isEmpty == true) ||
                                              (contact.selectedPhone == phone),
                                          onChanged: (bool? value) {
                                            setState(() {
                                              if (value == true) {
                                                // Deselect the first phone if it is selected
                                                if (distinctPhones.indexOf(phone) != 0 &&
                                                    contact.selectedPhone == distinctPhones[0]) {
                                                  _selectPhone(contact, '');
                                                }
                                                // Select the current phone
                                                _selectPhone(contact, phone);
                                              } else {
                                                // Deselect the phone
                                                _selectPhone(contact, '');
                                              }
                                            });
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                        )

                                    ),

                                  );
                                }).toList(),
                              )

                          ],
                        ),
                        value: contact.isSelected,
                        checkboxShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        onChanged: (bool? value) {
                          if (value == true) {
                            setState(() {
                              contact.isSelected = true; // Select the contact
                            });
                            _selectContact(contact, true, contact.selectedPhone ?? '');
                            // _selectPhone(contact, contact.selectedPhone ?? ''); // Select the distinct phone
                          } else {
                            setState(() {
                              contact.isSelected = false; // Deselect the contact
                            });
                            _selectContact(contact, false, '');
                            _selectPhone(contact, '');
                          }

                        },

                        secondary: (contact.avatar != null && contact.avatar!.isNotEmpty)
                            ? CircleAvatar(
                          backgroundImage: MemoryImage(contact.avatar!),
                          backgroundColor: Colors.white,
                        )
                            : CircleAvatar(
                          child: Text(contact.displayName.isNotEmpty ? contact.displayName[0] : '',style: TextStyle(color: Colors.white),),
                          backgroundColor: Color(0xFF036CB2),
                        ),
                      )



                  );
                },
              ),
            ),
    //         SizedBox(
    //           child: ElevatedButton(
    //
    //             style: ElevatedButton.styleFrom(
    //                 primary:Color(0xFF036CB2),
    //                 shape: RoundedRectangleBorder(
    //                     borderRadius: BorderRadius.circular(25))),
    //
    //
    //             child: Text("Select",style: const TextStyle(
    //                 fontWeight: FontWeight.w500, fontSize: 18,
    //                 color: Colors.white),),
    //             onPressed: _selectedContact != null
    //                 ? () {
    //               // Navigator.push(
    //               //   context,
    //               //   MaterialPageRoute(
    //               //     builder: (context) => InviteGuestScreen(contact: _selectedContact!,
    //               //
    //               //
    //               //     ),
    //               //
    //               //   ),
    //               // );
    //               // Navigator.pop(context, {
    //               //   'contact': _selectedContact,
    //               // });
    // Navigator.pop(context, {
    // 'contact': _selectedContact!,
    //
    // });
    // print(_selectedContact)  ;          }
    //
    //                 : null,
    //           ),
    //         ),

          ],
        ),
      ),
      floatingActionButton: SizedBox(
        height: MediaQuery.of(context).size.height * 0.04,
        width: MediaQuery.of(context).size.width * 0.20,
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25)),
          backgroundColor:Color(0xFF036CB2),
          onPressed: _selectedContact != null
              ? () {

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => InvitationsScreen(contact: _selectedContact!, data: permissions,)),
            );
          }
              : null,
          child: Text('Add'),
        ),
      ),
    );
  }


}

class Contact {
  String displayName;
  String? givenName;
  List<Item> phones;
  Uint8List? avatar;
  List<Item>? emails;
  List<PostalAddress>? postalAddresses;
  bool isSelected = false;

  String? selectedPhone;

  Contact({required this.displayName, required this.phones,this.givenName, this.avatar,this.emails,this.postalAddresses,this.selectedPhone});
}


