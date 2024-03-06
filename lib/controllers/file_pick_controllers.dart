import 'package:file_picker/file_picker.dart';

import '../widgets/toast.dart';

pickFile() async {
  try {
    // if (await checkPermission()) {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      List<PlatformFile> files = result.files;
      return await validateFile(files);
    } else {
      showToast('File not Picked');
    }
    // } else {
    //   showToast('Permission not granted', Colors.red, Colors.white);
    // }
  } catch (e) {
    showToast('Error picking files: $e');
  }
}

validateFile(List<PlatformFile> files) async {
  List selectedFile = [];
  for (PlatformFile file in files) {
    if (file.size > 1024 * 1024 * 10) {
      showToast('File size exceeds 10 MB');
      return;
    }

    if (!['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png']
        .contains(file.extension)) {
      showToast('Invalid file type: ${file.name}');
      return;
    }
    selectedFile.add(file.path);
    selectedFile.add(file.name);
  }
  return selectedFile;
}

pickFiles() async {
  try {
    // if (await checkPermission()) {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      List<PlatformFile> files = result.files;
      return await validateFiles(files);
    } else {
      showToast('File not Picked');
    }
    // } else {
    //   showToast('Permission not granted', Colors.red, Colors.white);
    // }
  } catch (e) {
    showToast('Error picking files: $e');
  }
}

validateFiles(List<PlatformFile> files) async {
  List selectedFiles = [[], []];
  for (PlatformFile file in files) {
    if (file.size > 1024 * 1024 * 10) {
      showToast('File size exceeds 10 MB');
      return;
    }

    if (!['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png']
        .contains(file.extension)) {
      showToast('Invalid file type: ${file.name}');
      return;
    }
    selectedFiles[0].add(file.path);
    selectedFiles[1].add(file.name);
  }
  return selectedFiles;
}
