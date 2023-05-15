part of 'responses.dart';

class Response<T> {
  final bool isCancel;
  final bool isSuccessful;
  final bool isLoading;
  final bool isFailed;
  final String message;
  final String error;
  final T? data;
  final List<T>? result;
  final dynamic snapshot;
  final Status status;
  final String tag;

  const Response({
    this.data,
    this.result,
    this.message = '',
    this.error = '',
    this.isCancel = false,
    this.isLoading = false,
    this.isSuccessful = false,
    this.isFailed = false,
    this.snapshot,
    this.status = Status.noContent,
    this.tag = "",
  });

  Response<T> copy({
    bool? isCancel,
    bool? isSuccessful,
    bool? isLoading,
    bool? isFailed,
    T? data,
    List<T>? result,
    String? message,
    String? error,
    dynamic snapshot,
    Status? status,
    String? tag,
  }) {
    return Response<T>(
      isCancel: isCancel ?? this.isCancel,
      isLoading: isLoading ?? this.isLoading,
      isSuccessful: isSuccessful ??
          (result != null
              ? true
              : message != null
                  ? true
                  : this.isSuccessful),
      isFailed: isFailed ?? this.isFailed,
      data: data ?? this.data,
      result: result ?? this.result,
      snapshot: snapshot ?? this.snapshot,
      tag: tag ?? this.tag,
      message:
          message ?? (isSuccessful ?? false ? "Successful!" : this.message),
      error: error ?? this.error,
      status: status ??
          (result != null
              ? Status.ok
              : (snapshot != null
                  ? Status.created
                  : (message != null ? Status.notFound : this.status))),
    );
  }

  Snapshot? getSnapshot<Snapshot>() {
    return snapshot != null && snapshot is Snapshot ? snapshot : null;
  }

  get statusCode => status.value;

  int get size => (result ?? []).length;
}

enum Status {
  processing(200),
  ok(200),
  created(201),
  accepted(202),
  noContent(204),
  resetContent(205),
  partialContent(206),
  multipleChoices(300),
  movedPermanently(301),
  notFound(404),
  notAcceptable(406),
  requestTimeout(408);

  const Status(this.value);

  final int value;
}
