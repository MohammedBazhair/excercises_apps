import 'package:file_picker/file_picker.dart';

class FilePickerService {
  static Future<String?> pickExcelFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result == null) return null;

    return result.files.single.path;
  }

  static Future<String?> pickOutputFolder() async {
    return await FilePicker.platform.getDirectoryPath();
  }
}
