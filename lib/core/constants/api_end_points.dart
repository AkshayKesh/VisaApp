class ApiEndpoints {
  ApiEndpoints._();

  static final ApiEndpoints _instance = ApiEndpoints._();

  factory ApiEndpoints() => _instance;

  // Base URL for APIs
  static const String baseUrl = "https://continue-jill-console-moscow.trycloudflare.com"; // Update with your backend base URL
  // static const String baseUrl = "http://localhost:2000";

  // Add your endpoint paths here as static const String variables if needed.
  // Example: Jimmi@gmail.com Jimmi@123
  static const String login = "/user/login";
  static const String checkUserOrRegister = "/user/checkUserOrRegister";
  static const String signup = "/user/signup";

  static const String refreshToken = "/user/refreshToken";
  static const String changePassword = "/user/changePassword";
  static const String packages = "/user/package/getAllForAppUser";
  static const String getPackageByCountry = "/user/package/getPackageByCountry";
  static const String packagesSearch = "/user/package/search";
  static const String packagesDetails = "/user/package/get";
  static const String addPassport = "/user/passport/add";
  static const String addBulkPassport = "/user/passport/addBulkPassport";
  static const String addBulkPassportWithoutAuth = "/user/passport/addBulkPassportWithoutAuth";
  static const String submitApplication = "/user/application/submit";
  static const String submitApplicationWithoutLogin = "/user/application/submitApplicationWithoutLogin";
  static const String makePayment = "/user/application/makePayment";
  static const String makePaymentWithoutAuth = "/user/application/makePaymentWithoutAuth";
  static const String updatePassport = "/user/passport/update";
  static String updatePassportById(String passportId) => "$updatePassport/$passportId";
  static const String uploadProfilePic = "/user/image/uploadProfilePic";
  static const String uploadDocumentImage = "/user/image/uploadDocumentImage";
  static const String uploadPassportSizePhoto = "/user/image/uploadPassportSizePhoto";
  static const String updateUser = "/user/updateUser";
  static const String getAllCard = "/user/card/getCardByUser";
  static const String getCardLink = "/user/card/getAddCardLink";
  static const String getAllPassport = "/user/passport/my";
  static const String getAllApplication = "/user/application/get";
  static const String getApplicationById = "/user/application/getApplicationById";
  static const String getApplicationStatusByTraveller = "/user/application-status/app/getApplicationStatusByTraveller";
  static const String airportList = "/admin/airport/list";
  static const String createTripDetails = "/user/application/createTripDetails";
  static const String createPersonDetails = "/user/application/createPersonDetails";
}
