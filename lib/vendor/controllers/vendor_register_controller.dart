import 'package:image_picker/image_picker.dart';

class VendorController {
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
}
