import 'package:equatable/equatable.dart';
import 'package:fcds_announcements/PageFeedFeature/Data%20Models/announcement_data_model.dart';
import 'package:fcds_announcements/PageFeedFeature/repository/feed_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  FeedBloc() : super(FeedInitial()) {
    FeedRepository repository = FeedRepository();
    on<FeedEvent>((event, emit) async {
      if (event is LoadAnnouncementsEvent) {
        emit(FeedLoading());
        final announcements = await repository.fetchAnnouncements(event.pageId);
        emit(FeedLoaded(announcements: announcements));
      } else if (event is RefreshAnnouncementsEvent) {
        final announcements = await repository.fetchAnnouncements(event.pageId);
        emit(FeedLoaded(announcements: announcements));
      }
    });
  }
}
