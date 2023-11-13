import '../models/video_data.dart';

class VideoState{}
class VideoInit extends VideoState{}
class VideoLoading extends VideoState{}
class VideoLoaded extends VideoState{
  Videos videos;
  VideoLoaded({required this.videos});
}
class VideoLoadingFailed extends VideoState{
  String errorMessage;
  VideoLoadingFailed({required this.errorMessage});
}
