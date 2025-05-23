abstract class AppValidator {
  String? validator(String? value);
}

//  TEXT VALIDATOR
class TextValidator extends AppValidator {
  @override
  validator(String? value) {
    if (value == null || value.isEmpty) {
      return "Please Enter this field";
    } else {
      return null;
    }
  }
}

//  EMAIL VALIDATOR
class EmailValidator extends AppValidator {
  @override
  validator(String? value) {
    if (value == null || value.isEmpty) {
      return "Please Enter Your Email";
    } else if (!value.endsWith("@gmail.com")) {
      return "Please Enter a Valid Email";
    } else {
      return null;
    }
  }
}

//  PASSWORD VALIDATOR
class PasswordValidator extends AppValidator {
  @override
  validator(String? value) {
    if (value == null || value.isEmpty) {
      return "Please Enter Your Password";
    } else if (value.length < 4) {
      return "Please Enter atleast 4 characters as Password";
    } else {
      return null;
    }
  }
}
