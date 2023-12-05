import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Add Image / Icon'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  XFile? image;
  File? finalDisplayImg;
  int? filterType;


  Widget displayFile(XFile? imageTemp){
    File finalImage = File(imageTemp!.path);


    return Wrap(children: <Widget>[Image.file(finalImage)],);
  }

  List<Widget> getFilterButtons(XFile? imageTemp){
    List<Widget> buttons = <Widget>[];

    buttons.add(
      Container(
        constraints: BoxConstraints(maxWidth: 80,maxHeight: 80),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              this.image = imageTemp;
            });
          },
          child: Text("Original",  textScaleFactor: 0.63),
        )
      )
    );

    for (int i=1; i<=4; i++){
      buttons.add(
          IconButton(
            icon: Image.asset('lib/imgs/user_image_frame_' + i.toString() +'.png'),
            constraints: const BoxConstraints(
              maxHeight: 50,
              maxWidth: 50,
            ),
            onPressed: () {
              setState(() {
                this.image = imageTemp;
                this.filterType = i;
              });
            },
          )
      );
    }

    return buttons;
  }

  Future<XFile?> showFilterDialog(XFile? imageTemp) async {

    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CloseButton(
                onPressed: () { Navigator.of(context).pop(); },
                style: const ButtonStyle(
                  alignment: Alignment.topLeft
                ),
              ),
            ],
          ),
          content: Container(
            height: 500,
            width: 300,
            child: Column(
              children: [
                const Text(
                  "Uploaded Image",
                  textScaleFactor: 2,
                ),
                const SizedBox(
                  height: 20,
                ),
                displayFile(imageTemp),
                const SizedBox(
                  height: 30,
                ),
                Wrap(children: getFilterButtons(imageTemp)),
                ElevatedButton(onPressed: ()=>{Navigator.of(context).pop()}, child: Text("Use This Image"))
              ],
            ),
          ),
        )
    );

    return imageTemp;
  }

  Future<void> getAndSetImageOnPress() async {
    if (kDebugMode) {
      print('Get The Image from Gallery');
    }
    final ImagePicker picker = ImagePicker();
    XFile? imageTemp = await picker.pickImage(source: ImageSource.gallery);

    imageTemp = await showFilterDialog(imageTemp);

    setState(() {
      finalDisplayImg = File(imageTemp!.path);
    });

    this.image = imageTemp;
    if (kDebugMode) {
      print("Gots the file ${image!.name}");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(widget.title),
          ),
          leading: IconButton(
            icon: const Icon(
                Icons.arrow_back_ios,
              color: Colors.black54,
            ),
            onPressed: () => SystemNavigator.pop(),

          ),
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.teal
          ),
          elevation: 15,
          shadowColor: Colors.white,
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            children: [
              _getUploadContainer(),
              const SizedBox(
                height: 150,
              ),
              _setImage(),
            ],
          ),
        ));
  }

  Container _getUploadContainer() {
    return Container(
      margin: const EdgeInsets.all(5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 10,
          ),
          const Text("Upload Image"),
          const SizedBox(
            height: 5,
          ),
          ElevatedButton(
            onPressed: getAndSetImageOnPress,
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                )),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.teal)),
            child: const Text(
              "Choose from Device",
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }



  Container _setImage() {

    Container imgContainer = Container();

    final image = this.finalDisplayImg;



    if (image!=null){
      File finalImage = File(image!.path);

      imgContainer = Container(
        child: Image.file(finalImage),
      );
    }

    return imgContainer;
  }
}

