import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  File? file;
  ImagePicker image = ImagePicker();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera and Media Access'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
      ),
      body: Center(
          child: Stack(
              children: [
        CircleAvatar(
          radius: 150,
          backgroundColor: Colors.black,
          child: ClipOval(
            child: SizedBox(
              width: 300.0,
              height: 300.0,
              child: file == null
                  ? const Icon(
                      Icons.image,
                      size: 50,
                    )
                  : Image.file(
                      file!,
                      fit: BoxFit.fill,
                    ),
            ),
          ),
        ),

        //use Positioned
        Positioned(
          bottom: 0,
          right: 0,
          child: Column(
            // child: Container(
            //   padding: const EdgeInsets.all(20),
            //   color: Colors.green,
            //   child: const Icon(Icons.camera),
            // ),
            children: <Widget>[
              IconButton(
                padding: const EdgeInsets.all(20),
                icon: const Icon(Icons.camera_alt),
                color: Colors.green,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Please choose"),
                      content: const Text("From:"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () async {
                            // getCam();
                            PermissionStatus cameraStatus = await Permission.camera.request();
                            if (cameraStatus == PermissionStatus.granted) {
                              getCam(ImageSource.camera);
                            } else if (cameraStatus == PermissionStatus.denied) {
                              return;
                            }

                            Navigator.of(ctx).pop();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            child: const Text("Camera"),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            // getGall();
                            PermissionStatus cameraStatus = await Permission.storage.request();
                            if (cameraStatus == PermissionStatus.granted) {
                              getGall(ImageSource.gallery);
                            } else if (cameraStatus == PermissionStatus.denied) {
                              return;
                            }

                            Navigator.of(ctx).pop();

                          },
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            child: const Text("Gallery"),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            child: const Text("Cancel"),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ])),
    );
  }

  getCam(ImageSource source) async {
    // ignore: deprecated_member_use
    var img = await image.getImage(source: ImageSource.camera);
    setState(() {
      file = File(img!.path);
    });
  }

  getGall(ImageSource source) async {
    // ignore: deprecated_member_use
    var img = await image.getImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });
  }
}
