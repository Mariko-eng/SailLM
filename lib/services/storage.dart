import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class CloudStorage {
  final _uuid = Uuid();

  Future uploadImage(File image) async {
    String filePath = 'images/${_uuid.v4()}.${image.path.split('.').last}';

    try {
      final ref = FirebaseStorage.instance.ref().child(filePath);
      final uploadTask = ref.putFile(image);
      final taskSnapshot = await uploadTask.onComplete;
      return {'isValid': true, 'url': await taskSnapshot.ref.getDownloadURL()};
    } catch (e) {
      return {'isValid': false, 'url': ''};
    }
  }
}
