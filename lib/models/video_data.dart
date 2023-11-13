import 'dart:convert';

class VideoData {
  final String thumbnail;
  final String title;
  final String description;
  final String url;
  const VideoData({
    required this.thumbnail,
    required this.title,
    required this.description,
    required this.url,
  });
  factory VideoData.fromJson(Map<String,dynamic> json){
    return VideoData(
        thumbnail: json.containsKey('videoThumbnail') ? json['videoThumbnail'] : '',
        title: json.containsKey('videoTitle') ? json['videoTitle'] : '',
        description: json.containsKey('videoDescription') ? json['videoDescription'] : '',
        url: json.containsKey('videoUrl') ? json['videoUrl'] : ''
    );
  }
  static Map<String, dynamic> toMap(VideoData model) =>
      <String, dynamic> {
        'videoThumbnail': model.thumbnail,
        'videoTitle': model.title,
        'videoDescription': model.description,
        'videoUrl': model.url
      };
  static String serialize(VideoData model) =>
      json.encode(VideoData.toMap(model));

  static VideoData deserialize(String json) =>
      VideoData.fromJson(jsonDecode(json));
}
class Videos {
  List<VideoData> videos = [];
  Videos.fromJson(List<dynamic> json){
    videos = json.map((i) => VideoData.fromJson(i)).toList();
  }
}