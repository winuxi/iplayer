import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iplayer/repository/video_repository.dart';

import 'video_state.dart';

class VideoCubit extends Cubit<VideoState>{
  VideoRepository videoRepository;
  VideoCubit({required this.videoRepository}) : super(VideoState());
  Future<void> loadVideos() async {
    emit(VideoLoading());
    try{
      var videos = await videoRepository.loadVideos();
      emit(VideoLoaded(videos: videos));
    }catch(e){
      emit(VideoLoadingFailed(errorMessage: e.toString()));
    }
  }
}