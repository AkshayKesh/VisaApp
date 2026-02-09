/// A model representing the structure of an API response.
///
/// This class is used to encapsulate the response from an API,
/// including the status code, data, and any error information.
class ResponseAPI {
  /// The HTTP status code of the API response.
  final int code;

  /// The data returned by the API, typically in a key-value map structure.
  final Map<String, dynamic> data;

  /// A flag indicating whether the response contains an error.
  /// Defaults to `null` if not explicitly set.
  bool? isError;

  /// Details of the error if the response contains one.
  /// This is `null` when there is no error.
  ApiError? error;

  /// Constructor for creating an instance of [ResponseAPI].
  ///
  /// [code] is the HTTP status code of the response.
  /// [data] contains the response data in a key-value map.
  /// Optional parameters:
  /// - [isError]: Indicates if the response represents an error.
  /// - [error]: Provides detailed information about the error.
  ResponseAPI(this.code, this.data, {this.isError, this.error});
}

/// A model representing the structure of an error in an API response.
///
/// This class is used to provide detailed information about an API error.
class ApiError {
  /// The error code associated with the API error.
  final int code;

  /// A user-friendly error message describing the issue.
  final String message;

  /// Additional details about the error (optional).
  /// Can be of any type depending on the API's error format.
  final dynamic details;

  /// Constructor for creating an instance of [ApiError].
  ///
  /// [code] is the error code provided by the API.
  /// [message] is a description of the error.
  /// Optional parameter:
  /// - [details]: Additional error-related information.
  ApiError(this.code, this.message, {this.details});
}
