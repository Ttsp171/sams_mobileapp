  // Future<void> downloadFile(String url, String filename) async {
  //   setState(() {
  //     downloading = true;
  //     downloadMessage = 'Downloading $filename...';
  //   });

  //   final directory = await getExternalStorageDirectory();
  //   final filePath = '${directory.path}/$filename';

  //   final response = await http.get(Uri.parse(url));
  //   final file = File(filePath);
  //   await file.writeAsBytes(response.bodyBytes);

  //   setState(() {
  //     downloading = false;
  //     downloadMessage = 'Downloaded $filename';
  //   });
  // }