part of 'media_capture_cubit.dart';

@immutable
sealed class MediaCaptureState {}

final class MediaCaptureLoading extends MediaCaptureState {}

final class MediaCaptureInitial extends MediaCaptureState {
  final MediaType mediaType;
  MediaCaptureInitial({required this.mediaType});
}

final class MediaCaptureError extends MediaCaptureState {
  final String errorMessage;
  MediaCaptureError({required this.errorMessage});
}
