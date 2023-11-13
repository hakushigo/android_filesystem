import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class FileRWHomepage extends StatefulWidget {
  const FileRWHomepage({super.key});

  @override
  State<FileRWHomepage> createState() => _FileRWHomepageState();
}

class _FileRWHomepageState extends State<FileRWHomepage> {
  String text = "";

  final nimC = TextEditingController();
  final namaC = TextEditingController();
  final prodiC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Permission.storage.request();

    return Scaffold(
        appBar: AppBar(
          title: const Text("File RW"),
        ),
        body: Column(children: [
          Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
              child: Column(
                children: [
                  TextField(
                    textAlign: TextAlign.center,
                    controller: nimC,
                  ),
                  TextField(
                    textAlign: TextAlign.center,
                    controller: namaC,
                  ),
                  TextField(
                    textAlign: TextAlign.center,
                    controller: prodiC,
                    decoration: InputDecoration(),
                  ),
                ],
              )),
          Text('$text')
        ]),
        bottomNavigationBar: BottomAppBar(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                onPressed: () {
                  createFile(
                      "NIM: ${nimC.text}\nNama: ${namaC.text}\nProdi: ${prodiC.text}");
                },
                icon: Icon(Icons.save)),
            IconButton(
                onPressed: () {
                  readFile();
                  setState(() {});
                },
                icon: Icon(Icons.file_open))
          ],
        )));
  }

  Future<void> createFile(String txt) async {
    final directory = await FilePicker.platform.getDirectoryPath();
    final file = File('${directory}/file.txt');
    final req = await Permission.storage.request();
    if (req.isGranted) {
      await file.writeAsString(txt);
    }
  }

  Future<void> readFile() async {
    final tempdir = await getTemporaryDirectory();
    tempdir.delete(recursive: true);

    try {
      FilePickerResult? pf = await FilePicker.platform.pickFiles();
      if (pf != null) {
        final file = File(pf.files.single.path!);
        if (await Permission.storage.request().isGranted) {
          String ts = await file.readAsString();
          print("TexT? WHAT IS TEXT : ${ts}");

          final nimRegex = RegExp(r'NIM: (\w+)');
          final namaRegex = RegExp(r'Nama: (\w+)');
          final prodiRegex = RegExp(r'Prodi: (\w+)');

          var nim = nimRegex.firstMatch(ts)?.group(1);
          var nama = namaRegex.firstMatch(ts)?.group(1);
          var prodi = prodiRegex.firstMatch(ts)?.group(1);

          print("${nim} \n\n\n ${nama} \n\n\n ${prodi}");
          setState(() {
            text = "Hello ${nama} (${nim}) from ${prodi}";
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    nimC.dispose();
    super.dispose();
  }
}
