import 'api_helper.dart';

class ApiResponse<T> {
  final String message; // comma separated if multiple errors exist
  final T? data;
  final int status;
  final bool isSuccess;

  ApiResponse(
      {required this.message,
      required this.data,
      required this.status,
      required this.isSuccess});

  factory ApiResponse.fromJson(Map<String, dynamic> json, int statusCode,
      T Function(Map<String, dynamic> json)? fromJson) {
    /*
      fromJSON=null signifies that caller isn't interested in the 'data' returned by the client
      json can either be of type List of Maps or just a single Map
      */
    final responseData = json['data'];
    T? data;
    if (responseData != null && fromJson != null) {
      data = responseData.fromJson();
    }
    return ApiResponse(
        message: ApiHelper.formatMessage(json['message']),
        data: data,
        status: statusCode,
        isSuccess: statusCode >= 200 && statusCode <= 299);
  }
}

class ApiResponseList<T> {
  final String message; // comma separated if multiple errors exist
  final List<T>? data;
  final int status;
  final bool isSuccess;

  ApiResponseList(
      {required this.message,
      required this.data,
      required this.status,
      required this.isSuccess});

  factory ApiResponseList.fromJson(Map<String, dynamic> json, int statusCode,
      T Function(Map<String, dynamic> json)? fromJson) {
    List<T>? data = <T>[];
    final responseData = json['data'];
    if (responseData != null && responseData.length > 0) {
      data =
          responseData.map<T>((jsonObject) => fromJson!(jsonObject)).toList();
    }

    return ApiResponseList(
      message: ApiHelper.formatMessage(json['message']),
      data: data,
      status: statusCode,
      isSuccess: statusCode >= 200 && statusCode <= 299,
    );
  }
}
