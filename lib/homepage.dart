import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gen/String.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

TextEditingController search = TextEditingController();
bool showimage = false;
ScreenshotController ss = ScreenshotController();

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AI Image Gen',
          style: GoogleFonts.nunito(fontSize: height * .025),
        ),
      ),
      bottomSheet: Container(
          padding: EdgeInsets.symmetric(
            vertical: height * .015,
            horizontal: width * .05,
          ),
          decoration: BoxDecoration(color: Colors.white24),
          height: height * .1,
          width: width,
          child: SearchBar(
            controller: search,
            trailing: [
              IconButton(
                onPressed: () {
                  setState(() {
                    if (search.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text('Please Enter Input For Genrate A Image')));
                    } else {
                      url = "$url/${search.text}";
                      showimage = true;
                    }
                  });
                },
                icon: const Icon(CupertinoIcons.search),
              ),
            ],
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(width: 0.0, height: height * .1),
            Center(
                child: Text(
              'Genrate Your Image',
              style: GoogleFonts.nunito(fontSize: height * .025),
            )),
            SizedBox(width: 0.0, height: height * .05),
            Center(
                child: Screenshot(
                    child: Container(
                      height: height * .3,
                      width: width * .67,
                      decoration: BoxDecoration(
                          image: showimage
                              ? DecorationImage(image: NetworkImage(url))
                              : null,
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                              begin: Alignment.centerRight,
                              end: Alignment.centerLeft,
                              colors: [
                                Colors.lightBlue,
                                Colors.transparent,
                                Colors.redAccent
                              ]),
                          color: Colors.red),
                    ),
                    controller: ss)),
            SizedBox(width: 0.0, height: height * .06),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        await ss.capture().then((value) async {
                          final tempdir = await getTemporaryDirectory();
                          final path = "${tempdir.path}/${search.text}.png";
                          final image = await File(path).writeAsBytes(value!);
                          await Share.shareXFiles([
                            XFile(image.path),
                          ], text: "This App Is Developed By Code With Ashh");
                        });
                      },
                      child: CircleAvatar(
                        radius: height * .03,
                        child: Icon(Icons.share),
                        backgroundColor: Colors.white24,
                      ),
                    ),
                    SizedBox(width: 0.0, height: height * .01),
                    Text(
                      'Share',
                      style: GoogleFonts.nunito(fontSize: height * .015),
                    )
                  ],
                ),
                Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        await ss
                            .captureAndSave(
                                "/storage/emulated/0/Download/CodeWithAshh/")
                            .then((path) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(path.toString())));
                        });
                      },
                      child: CircleAvatar(
                        radius: height * .03,
                        child: Icon(Icons.download_rounded),
                        backgroundColor: Colors.white24,
                      ),
                    ),
                    SizedBox(width: 0.0, height: height * .01),
                    Text(
                      'Download',
                      style: GoogleFonts.nunito(fontSize: height * .015),
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
