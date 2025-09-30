class Validators {

  static String? validateName(String? value) {
    if(value == null || value.trim().isEmpty) return 'Name is required';
    if(value.trim().length < 3) return 'Name must be at least 3 characters long';
    return null;
  }

  static String? validateEmail(String? value) {
    if(value == null || value.trim().isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if(!emailRegex.hasMatch(value.trim())) return 'Invalid email address';
    return null;
  }

  static String? validatePassword(String? value) {
    if(value == null || value.trim().isEmpty) return 'Password is required';
    if(value.trim().length < 6) return 'Password must be at least 8 characters long';
    return null;
  }

 static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Phone number is required';
    if (!value.startsWith('+91')) return 'Phone must start with + (e.g., +911234567890)';
    final phoneRegex = RegExp(r'^\+[0-9]{8,15}$'); // + followed by 8–15 digits
    if (!phoneRegex.hasMatch(value.trim())) return 'Enter a valid phone number';
    return null;
  }


  
}