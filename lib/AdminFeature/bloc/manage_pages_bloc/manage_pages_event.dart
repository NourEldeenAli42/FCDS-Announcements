part of 'manage_pages_bloc.dart';

sealed class ManagePagesEvent extends Equatable {
  const ManagePagesEvent();

  @override
  List<Object> get props => [];
}
class LoadPagesEvent extends ManagePagesEvent {
  const LoadPagesEvent();
}
class DeletePageEvent extends ManagePagesEvent {
  final int pageId;
  const DeletePageEvent({required this.pageId});
}
class RefreshPagesEvent extends ManagePagesEvent {
  const RefreshPagesEvent();
}