import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendor_app/vendor/controllers/vendor_register_controller.dart';

class VendorRegistrationScreen extends StatefulWidget {
  @override
  State<VendorRegistrationScreen> createState() =>
      _VendorRegistrationScreenState();
}

class _VendorRegistrationScreenState extends State<VendorRegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final VendorController _vendorController = VendorController();
  late String bussinessName;
  late String email;
  late String phoneNumber;
  late String taxNumber;
  late String countryValue;
  late String stateValue;
  late String cityValue;

  Uint8List? _image;

  selectGalleryImage() async {
    Uint8List im = await _vendorController.pickStoreImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  selectCameraImage() async {
    Uint8List im = await _vendorController.pickStoreImage(ImageSource.camera);
    setState(() {
      _image = im;
    });
  }

  String? _taxStatus;

  List<String> _taxOptions = ['YES', 'NO'];

  void exibirMenuPopup(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Escolha uma opção:'),
            content: Text("Deseja usar a camera ou galeria?"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  selectCameraImage();
                },
                child: Text('Camera'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  selectGalleryImage();
                },
                child: Text('Galeria'),
              ),
            ],
          );
        });
  }

  _saveVendorDetails() async {
    EasyLoading.show(status: 'PLEASE WAIT');
    if (_formKey.currentState!.validate()) {
      await _vendorController
          .registerVendor(bussinessName, email, phoneNumber, countryValue,
              stateValue, cityValue, _taxStatus!, taxNumber, _image)
          .whenComplete(() {
        EasyLoading.dismiss();
        setState(() {
          _formKey.currentState!.reset();
          _image = null;
        });
      });
    } else {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          toolbarHeight: 200,
          flexibleSpace: LayoutBuilder(
            builder: (context, constraints) {
              return FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.yellow.shade900,
                        Colors.yellow,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _image != null
                              ? Image.memory(_image!)
                              : IconButton(
                                  onPressed: () {
                                    exibirMenuPopup(context);
                                  },
                                  icon: Icon(CupertinoIcons.photo),
                                ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    onChanged: (value) {
                      bussinessName = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Bussiness Name must not be empty';
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: 'Bussiness Name',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      email = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please email address must not be empty';
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      phoneNumber = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please phone number must not be empty';
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SelectState(
                      onCountryChanged: (value) {
                        setState(() {
                          countryValue = value;
                        });
                      },
                      onStateChanged: (value) {
                        setState(() {
                          stateValue = value;
                        });
                      },
                      onCityChanged: (value) {
                        setState(() {
                          cityValue = value;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          'Tax Registered ?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Flexible(
                          child: Container(
                            width: 100,
                            child: DropdownButtonFormField(
                              items: _taxOptions.map<DropdownMenuItem<String>>(
                                  (String dropItem) {
                                return DropdownMenuItem(
                                  value: dropItem,
                                  child: Text(
                                    dropItem,
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _taxStatus = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_taxStatus == 'YES')
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onChanged: (value) {
                          taxNumber = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please tax number must not be empty';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Tax Number',
                        ),
                      ),
                    ),
                  InkWell(
                    onTap: () {
                      _saveVendorDetails();
                    },
                    child: Container(
                      height: 30,
                      width: MediaQuery.of(context).size.width - 40,
                      decoration: BoxDecoration(
                        color: Colors.yellow.shade900,
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Save",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
