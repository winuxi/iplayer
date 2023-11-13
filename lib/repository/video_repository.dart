import 'dart:convert';
import 'dart:ui';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iplayer/models/video_data.dart';

import 'package:http/http.dart' as http;
import 'package:iplayer/utils/constatnts.dart';

class VideoRepository {
  final _storage = const FlutterSecureStorage();
  Future<Videos> loadVideos() async {
    try{
      final responses = await http.get(Uri.parse(baseUrl));
      if (responses.statusCode == 200) {
        Map<String, dynamic> rawData = jsonDecode(responses.body);
        saveToLocal(rawData['videos']);
        List data = rawData['videos'];
        Videos videos = Videos.fromJson(data);
        setBackgroundColor(rawData['appBackgroundHexColor']);
        return loadDataFromLocal();
        //return videos;
      } else {
        return loadDataFromLocal();
      }
    }catch(e){
      return loadDataFromLocal();
    }

  }


  Future<String> getBackgroundColor() async{
    return await _storage.read(key: 'color') ?? '#3498db';
  }

  void setBackgroundColor(String color){
    _storage.write(key: 'color', value: color);
  }
  void saveToLocal(List rawData){
    //print(jsonEncode(rawData));
    _storage.write(key: "videos", value: jsonEncode(rawData));
  }
  Future<Videos> loadDataFromLocal() async{
    var foundData = await _storage.read(key: "videos");
    if(foundData != null){
      List videos = jsonDecode(foundData);
      return Videos.fromJson(videos);
    }else{
      throw 'No Data Available';
    }
  }
}
