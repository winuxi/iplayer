import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iplayer/models/video_data.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ListCard extends StatelessWidget {
  VideoData videoData;
  bool isConnected;
  ListCard({Key? key, required this.videoData, required this.isConnected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(videoData.url);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.only(top: 5),
      child: Row(
        children: [
          SizedBox(
            height: 70,
            width: 90,
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: buildWidget(videoData.url),
            ),
          ),
           //Image(image: FileImage(File(opt(videoData.url)))),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  videoData.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  videoData.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget buildWidget(String tera) {
    return FutureBuilder(
      future: getThumbnail(tera),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Build the widget with the fetched data
          return Image.memory(snapshot.data!);
        } else if (snapshot.hasError) {
          // Handle error
          print(snapshot.error);
          return Icon(Icons.video_file);
        } else {
          // Show loading indicator
          return isConnected ? SizedBox(
            height: 50,width: 50,
              child: CircularProgressIndicator()) : Icon(Icons.video_file);
        }
      },
    );
  }
  prepareData(String path) async {
    await getThumbnail(path).then((value){
      return Image.memory(value!);
    });
    // return thumbnailData != null ? Image.memory(thumbnailData)
    //     : const Icon(Icons.music_video);
  }

  Future<Uint8List?> getThumbnail(String path) async {
    return await VideoThumbnail.thumbnailData(
      video: path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128,
      // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 25,
    );
  }
}
