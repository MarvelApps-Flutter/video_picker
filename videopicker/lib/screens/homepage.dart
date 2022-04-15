import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:videopicker/models/video_model.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as thumbnail;

import 'video_view.dart';

List<Videomodel> videosList = [];

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 75,
          backgroundColor: Colors.white60,
          title: Text(
            "Gallery",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: videosList.length == 0 ? emptyGalleryView() : videoGalleryView(),
        floatingActionButton: videosList.length == 0
            ? Container()
            : InkWell(
                onTap: () async {
                  await videopicker();
                },
                child: Container(
                  decoration: new BoxDecoration(
                    color: Colors.black12,
                    shape: BoxShape.circle,
                  ),
                  height: 100,
                  width: 100,
                  child: const Icon(
                    Icons.video_call,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ));
  }

  Widget emptyGalleryView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () async {
              await videopicker();
            },
            child: Container(
              decoration: new BoxDecoration(
                color: Colors.black12,
                shape: BoxShape.circle,
              ),
              height: 100,
              width: 100,
              child: const Icon(
                Icons.video_call,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(
              "No videos",
              style:
                  TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
            ),
          ),
          InkWell(
            onTap: () async {
              await videopicker();
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                "Click to pick video",
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget videoGalleryView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 8.0,
        children: List.generate(videosList.length, (index) {
          Image img = Image.memory(videosList[index].thumbnail as Uint8List);

          return InkWell(
            onTap: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => VideoView(
                          videomodel: Videomodel(
                              name: videosList[index].name.toString(),
                              path: videosList[index].path))));
            },
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      image:
                          DecorationImage(image: img.image, fit: BoxFit.cover),
                    ),
                    width: double.infinity,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 33,
                      backgroundColor: Colors.black12,
                      child: Icon(
                        // ? Icons.pause
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8.0),
                          bottomRight: Radius.circular(8.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        videosList[index].name.toString(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }

  Future<void> videopicker() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    final uint8list = await thumbnail.VideoThumbnail.thumbnailData(
      video: video!.path,
      imageFormat: thumbnail.ImageFormat.JPEG,
      maxWidth:
          500, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 25,
    );
    videosList.add(Videomodel(
        name: video.name, path: video.path, thumbnail: uint8list as Uint8List));

    setState(() {});
  }
}
