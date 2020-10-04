import 'package:flutter_test/flutter_test.dart';

import '../lib/auth_screen.dart';

void main() {
  group('TextField Validation:', () {
    // Email
    test('empty email returns error string', () {
      var result = EmailFieldValidator.validate('');
      expect(result, 'Email can\'t be empty');
    });
    test('non-empty but invalid email returns error String', () {
      var result = EmailFieldValidator.validate('email');
      expect(result, 'Invalid email format');
    });

    test('non-empty and valid email returns null', () {
      var result = EmailFieldValidator.validate('email@gmail.com');
      expect(result, null);
    });
    // Username
    test('empty username returns error string', () {
      var result = UsernameFieldValidator.validate('');
      expect(result, 'Username can\'t be empty');
    });
    test('non-empty username returns null', () {
      var result = UsernameFieldValidator.validate('hamza123');
      expect(result, null);
    });
    // Password
    test('empty password returns error string', () {
      var result = PasswordFieldValidator.validate('');
      expect(result, 'Password can\'t be empty');
    });
    test('non-empty password returns null', () {
      var result = PasswordFieldValidator.validate('hamza123');
      expect(result, null);
    });

    test('empty code returns error string', () {
      var result = CodeFieldValidator.validate('');
      expect(result, 'Code is required');
    });

    test('non-empty but short code returns error string', () {
      var result = CodeFieldValidator.validate('4545');
      expect(result, 'Code should be 6 digit long');
    });

    test('non-empty and 6 digits code returns null', () {
      var result = CodeFieldValidator.validate('123456');
      expect(result, null);
    });
  });
}
