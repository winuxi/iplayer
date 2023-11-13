import 'package:iplayer/models/video_data.dart';

class HomeScreenArgs{
  Videos videos;
  HomeScreenArgs({required this.videos});
}
class PlayerScreenArgs{
  VideoData video;
  PlayerScreenArgs({required this.video});
}
