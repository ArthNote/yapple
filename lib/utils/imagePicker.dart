
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  XFile? pickedFile = await ImagePicker().pickImage(source: source);
  if (pickedFile != null) {
    return await pickedFile.readAsBytes();
  } else {
    print('No image selected.');
    return null;
  }
}
