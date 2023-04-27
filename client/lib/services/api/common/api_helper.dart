class ApiHelper {
  static String formatMessage(dynamic message) {
    String formattedMessage = "";
    if (message is String) {
      formattedMessage = message;
    } else {
      message.forEach((key, value) {
        formattedMessage += value.join(", ");
      });
    }
    return formattedMessage;
  }
}
