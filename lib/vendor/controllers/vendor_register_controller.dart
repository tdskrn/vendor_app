import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class VendorController {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // FUNCTION TO STORE IMAGE IN FIREBASE STORAGE STARTS
  _uploadVendorImageToStorage(Uint8List? image) async {
    Reference ref =
        _storage.ref().child('storeImage').child(_auth.currentUser!.uid);

    UploadTask uploadTask = ref.putData(image!);

    TaskSnapshot snapshot = await uploadTask;

    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }
  // FUNCTION TO STORE IMAGE IN FIREBASE STORAGE ENDS HERE

  //Function to pick store image ==Start
  pickStoreImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();

    XFile? _file = await _imagePicker.pickImage(source: source);

    if (_file != null) {
      return await _file.readAsBytes();
    } else {
      print('No Image selected');
    }
  }
  //Function to pick store image ==End

  // Function to saveData vendor starts here
  Future<String> registerVendor(
    String bussinessName,
    String email,
    String phoneNumber,
    String countryValue,
    String stateValue,
    String cityValue,
    String taxRegistered,
    String taxNumber,
    Uint8List? image,
  ) async {
    String res = 'some error ocurred';

    try {
      if (bussinessName.isNotEmpty &&
          email.isNotEmpty &&
          phoneNumber.isNotEmpty &&
          countryValue.isNotEmpty &&
          stateValue.isNotEmpty &&
          cityValue.isNotEmpty &&
          taxRegistered.isNotEmpty &&
          taxNumber.isNotEmpty &&
          image != null) {
        // SAVE DATA TO CLOUD FIRESTORE

        String _storeImage = await _uploadVendorImageToStorage(image);

        await _firestore.collection('vendors').doc(_auth.currentUser!.uid).set({
          'bussinessName': bussinessName,
          'email': email,
          'phoneNumber': phoneNumber,
          'countryValue': countryValue,
          'stateValue': stateValue,
          'cityValue': cityValue,
          'taxRegistered': taxRegistered,
          'taxNumber': taxNumber,
          'storeImage': _storeImage,
          'approved': false,
          'vendorId': _auth.currentUser!.uid,
        });
      } else {
        res = 'Please fields must not be empty';
      }
    } catch (e) {
      res = e.toString();
    }

    return res;
  }
  // function to saveData vendor ends here
}
