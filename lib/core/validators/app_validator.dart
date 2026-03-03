class AppValidators {
  AppValidators._(); // prevents instantiation

  // ---------------- NAME ----------------
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Name is required";
    }

    final name = value.trim();

    if (name.length < 2) {
      return "Name must be at least 2 characters";
    }

    final regex = RegExp(r"^[a-zA-Z\s]+$");
    if (!regex.hasMatch(name)) {
      return "Name can contain only letters";
    }

    return null;
  }

  // ---------------- DOB ----------------
  static String? dob(DateTime? dob, {int minAge = 18}) {
    if (dob == null) {
      return "Date of birth is required";
    }

    final today = DateTime.now();
    int age = today.year - dob.year;

    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }

    if (age < minAge) {
      return "You must be at least $minAge years old";
    }

    return null;
  }

  // ---------------- GENDER ----------------
  static String? gender(String? gender) {
    if (gender == null || gender.isEmpty) {
      return "Please select a gender";
    }
    return null;
  }

  // ---------------- UPI ID ----------------
  static String? upiId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "UPI ID is required";
    }

    final upi = value.trim();

    // Basic UPI format: username@bankname
    final regex = RegExp(r"^[a-zA-Z0-9.\-_]{2,}@[a-zA-Z]{2,}$");
    if (!regex.hasMatch(upi)) {
      return "Please enter a valid UPI ID";
    }

    return null;
  }

  // ---------------- PAN ----------------
  static String? pan(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "PAN card number is required";
    }

    final pan = value.trim().toUpperCase();

    // PAN format: 5 letters, 4 digits, 1 letter (e.g., ABCDE1234F)
    final regex = RegExp(r"^[A-Z]{5}[0-9]{4}[A-Z]{1}$");
    if (!regex.hasMatch(pan)) {
      return "Please enter a valid PAN number";
    }

    return null;
  }

  // ---------------- IFSC ----------------
  static String? ifsc(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "IFSC code is required";
    }

    final ifsc = value.trim().toUpperCase();

    // IFSC format: 4 letters, 0, 6 alphanumeric characters
    final regex = RegExp(r"^[A-Z]{4}0[A-Z0-9]{6}$");
    if (!regex.hasMatch(ifsc)) {
      return "Please enter a valid IFSC code";
    }

    return null;
  }

  // ---------------- ACCOUNT NUMBER ----------------
  static String? accountNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Account number is required";
    }

    final account = value.trim();

    // Account number format: 9-18 digits
    final regex = RegExp(r"^[0-9]{9,18}$");
    if (!regex.hasMatch(account)) {
      return "Please enter a valid account number";
    }

    return null;
  }
}
