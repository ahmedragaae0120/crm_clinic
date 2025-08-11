abstract class Constant {
  static const String regExValidateEmail =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  static const String removeUserEndPoint =
      "https://firestore-delete-api-production.up.railway.app/delete";

  static const String isRememberMe = "isRememberMe";
  static const String adminEmail = "admin@crm.com";
  static String adminPassword = "Admin@123";
}
