part of 'responses.dart';

class Response<T> {
  final int _requestCode;
  ResponseStatus status = ResponseStatus.none;
  T? _data;
  List<T>? _result;
  String? _message;
  dynamic _feedback;
  dynamic _snapshot;
  String? _exception;
  double? _progress;
  bool _available = false;
  bool _successful = false;
  bool _cancel = false;
  bool _complete = false;
  bool _internetError = false;
  bool _valid = false;
  bool _loaded = false;
  bool _paused = false;
  bool _nullableObject = false;
  bool _stopped = false;
  bool _failed = false;
  bool _timeout = false;

  Response([this._requestCode = 0]);

  set timeout(bool value) => _timeout = value;

  set failed(bool value) => _failed = value;

  set stopped(bool value) => _stopped = value;

  set nullableObject(bool value) => _nullableObject = value;

  set paused(bool value) => _paused = value;

  set loaded(bool value) => _loaded = value;

  set valid(bool value) => _valid = value;

  set internetError(bool value) => _internetError = value;

  set complete(bool value) => _complete = value;

  set cancel(bool value) => _cancel = value;

  set successful(bool value) => _successful = value;

  set available(bool value) => _available = value;

  set progress(double value) => _progress = value;

  set exception(String value) => _exception = value;

  set snapshot(dynamic value) => _snapshot = value;

  set message(String value) => _message = value;

  set feedback(dynamic value) => _feedback = value;

  set data(T? value) => _data = value;

  set result(List<T>? value) => _result = value;

  T? get data => _data is T ? _data as T : null;

  List<T> get result => _result ?? [];

  int get requestCode => _requestCode;

  int get statusCode => status.code;

  String get statusMessage => status.message;

  String get feedback => _message ?? '';

  String get exception => _exception ?? '';

  bool get isSuccessful => _successful;

  double get progress => _progress ?? 0;

  bool get isAvailable => _available;

  bool get isComplete => _complete;

  bool get isCancel => _cancel;

  bool get isValid => _valid;

  bool get isLoaded => _loaded;

  bool get isLoading => !_loaded;

  bool get isConnected => !_internetError;

  bool get isValidException => _exception != null && _exception!.isNotEmpty;

  bool get isInternetError => _internetError;

  bool get isPaused => _paused;

  bool get isNullableObject => _nullableObject;

  bool get isStopped => _stopped;

  bool get isFailed => _failed;

  bool get isTimeout => _timeout;

  Response<T> attach({
    bool? isCancel,
    bool? isSuccessful,
    bool? isFailed,
    T? data,
    List<T>? result,
    String? message,
    String? exception,
    dynamic feedback,
    dynamic snapshot,
    ResponseStatus? status,
    String? tag,
  }) {
    _cancel = isCancel ?? _cancel;
    _successful =
        isSuccessful ?? ((data != null || result != null) ? true : _successful);
    _internetError = isFailed ?? _internetError;
    _feedback = feedback ?? _feedback;
    _data = data ?? _data;
    _result = result ?? _result;
    _snapshot = snapshot ?? _snapshot;
    _message = message ?? _message;
    _exception = exception ?? _exception;
    return this;
  }

  Response<T> withStatus(ResponseStatus status) {
    withException(status: status);
    return this;
  }

  Response<T> withFeedback({
    dynamic feedback,
    String? message,
    String? exception,
    ResponseStatus status = ResponseStatus.ok,
  }) {
    this.status = status;
    _feedback = feedback ?? _feedback;
    _successful = status.isSuccessful ? true : _successful;
    _message = message ?? _message;
    _exception = exception ?? _exception;
    _complete = true;
    _loaded = true;
    return this;
  }

  Response<T> withData(T? data) {
    this.status = ResponseStatus.ok;
    _data = data;
    _successful = true;
    _complete = true;
    _loaded = true;
    return this;
  }

  Response<T> withResult(List<T>? result) {
    this.status = ResponseStatus.ok;
    _result = result;
    _successful = true;
    _complete = true;
    _loaded = true;
    return this;
  }

  Response<T> withMessage({
    dynamic message,
  }) {
    this.status = ResponseStatus.ok;
    _message = message ?? _message;
    _successful = true;
    _complete = true;
    _loaded = true;
    return this;
  }

  Response<T> withSnapshot(dynamic snapshot) {
    _snapshot = snapshot;
    return this;
  }

  Response<T> withException({
    ResponseStatus status = ResponseStatus.none,
    dynamic exception,
  }) {
    this.status = status;
    _exception = exception != null ? "$exception" : status.message;
    _message = null;
    _complete = true;
    _loaded = true;
    return this;
  }

  Response<T> withSuccessful(bool successful) {
    _successful = successful;
    _complete = true;
    return this;
  }

  Response<T> withProgress(double progress) {
    _progress = progress;
    return this;
  }

  Response<T> withAvailable(bool available) {
    _available = available;
    return this;
  }

  Response<T> withComplete(bool complete) {
    _complete = complete;
    return this;
  }

  Response<T> withCancel(bool cancel) {
    _cancel = cancel;
    return this;
  }

  Response<T> withValid(bool valid) {
    _valid = valid;
    _loaded = true;
    return this;
  }

  Response<T> withLoaded(bool loaded) {
    _loaded = loaded;
    return this;
  }

  Response<T> withInternetError(String message, [bool? internetError]) {
    withException(exception: message);
    _internetError = internetError ?? true;
    _valid = false;
    return this;
  }

  Response<T> withPaused(bool paused) {
    _paused = paused;
    return this;
  }

  Response<T> withNullableObject(bool nullableObject) {
    _nullableObject = nullableObject;
    return this;
  }

  Response<T> withStopped(bool stopped) {
    _stopped = stopped;
    return this;
  }

  Response<T> withFailed(bool failed) {
    _failed = failed;
    return this;
  }

  Response<T> withTimeout(bool timeout) {
    _timeout = timeout;
    return this;
  }

  Snapshot? getSnapshot<Snapshot>() => _snapshot is Snapshot ? _snapshot : null;
}

enum ResponseCode {
  add(10000),
  delete(20000),
  update(30000),
  blog(1000),
  photo(2000),
  story(3000),
  video(4000),
  choose(100),
  crop(200),
  translate(300);

  final int value;

  const ResponseCode(this.value);
}

enum ResponseStatus {
  none(10000, ""),
  canceled(10010, ResponseMessages.processCanceled),
  failure(10020, ResponseMessages.processFailed),
  networkError(10030, ResponseMessages.internetDisconnected),
  nullable(10040, ResponseMessages.invalidData),
  paused(10050, ResponseMessages.processPaused),
  resultNotFound(10060, ResponseMessages.resultNotFound),
  stopped(10070, ResponseMessages.processStopped),
  running(10090, ""),
  timeOut(10080, ResponseMessages.tryAgain),
  ok(10100, ResponseMessages.successful),
  invalid(10110, ResponseMessages.invalidData),
  undefined(10120, ResponseMessages.undefined),
  unmodified(10130, ResponseMessages.unmodified),
  error(10100, ResponseMessages.errorFound);

  final int code;
  final String message;

  const ResponseStatus(this.code, this.message);
}

extension ResponseStatusExtension on ResponseStatus {
  bool get isCanceled => this == ResponseStatus.canceled;

  bool get isFailure => this == ResponseStatus.failure;

  bool get isNetworkError => this == ResponseStatus.networkError;

  bool get isNullable => this == ResponseStatus.nullable;

  bool get isPaused => this == ResponseStatus.paused;

  bool get isResultNotFound => this == ResponseStatus.resultNotFound;

  bool get isStopped => this == ResponseStatus.stopped;

  bool get isRunning => this == ResponseStatus.running;

  bool get isTimeout => this == ResponseStatus.timeOut;

  bool get isSuccessful => this == ResponseStatus.ok;

  bool get isInvalid => this == ResponseStatus.invalid;

  bool get isUndefined => this == ResponseStatus.undefined;

  bool get isUnmodified => this == ResponseStatus.unmodified;

  bool get isError => this == ResponseStatus.error;
}

class ResponseMessages {
  static const String internetDisconnected =
      "Your internet service has disconnected. Please confirm your internet connection.";
  static const String processCanceled = "Process has canceled!";
  static const String processFailed = "Process has failed, please try again!";
  static const String processPaused = "Process has paused!";
  static const String processStopped = "Process has stopped!";
  static const String resultNotFound = "Result not found!";
  static const String resultNotValid = "Result not valid!";
  static const String tryAgain = "Something went wrong, please try again?";
  static const String postingUnsuccessful =
      "Posting unsuccessful, please try again!";
  static const String uploadingUnsuccessful =
      "Uploading unsuccessful, please try again!";

  static const String loaded = "Your process completed";
  static const String loading =
      "Please wait a second. Because process is running...";
  static const String invalidData = "Invalid data!";
  static const String undefined = "Undefined data!";
  static const String unmodified = "Unmodified data!";
  static const String dataNotValid = "Data not valid!";
  static const String successful = "Successful!";
  static const String errorFound = "Error found!";
}
