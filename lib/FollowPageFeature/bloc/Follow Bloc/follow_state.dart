part of 'follow_bloc.dart';

enum PageFollowStatus { initial, loading, success, error }

class FollowState extends Equatable {
  final Map<String, PageFollowStatus> pageStatuses;
  final Map<String, String> pageErrors;

  const FollowState({this.pageStatuses = const {}, this.pageErrors = const {}});

  PageFollowStatus getStatus(String pageId) {
    return pageStatuses[pageId] ?? PageFollowStatus.initial;
  }

  String? getError(String pageId) {
    return pageErrors[pageId];
  }

  FollowState copyWith({
    Map<String, PageFollowStatus>? pageStatuses,
    Map<String, String>? pageErrors,
  }) {
    return FollowState(
      pageStatuses: pageStatuses ?? this.pageStatuses,
      pageErrors: pageErrors ?? this.pageErrors,
    );
  }

  @override
  List<Object> get props => [pageStatuses, pageErrors];
}
