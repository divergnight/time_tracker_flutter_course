import 'dart:ui';

import 'package:time_tracker_flutter_course/app/sign_in/validators.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInModel with EmailAndPasswordValidators {
  EmailSignInModel({
    this.email = '',
    this.password = '',
    this.formType = EmailSignInFormType.signIn,
    this.submitted = false,
    this.isLoading = false,
  });
  final String email;
  final String password;
  final EmailSignInFormType formType;
  final bool submitted;
  final bool isLoading;

  String get primaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';
  }

  String get secondaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'Need an account ? Register'
        : 'Have an account ? Sign in';
  }

  bool get canSubmit {
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        !isLoading;
  }

  String get passwordErrorText {
    bool showErrotText = submitted && !passwordValidator.isValid(password);
    return showErrotText ? invalidPasswordErrorText : null;
  }

  String get emailErrorText {
    bool showErrotText = submitted && !emailValidator.isValid(email);
    return showErrotText ? invalidEmailErrorText : null;
  }

  EmailSignInModel copyWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool submitted,
    bool isLoading,
  }) {
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
    );
  }

  @override
  String toString() {
    return 'email: $email, password: $password, formType: $formType, isLoading: $isLoading, submitted: $submitted';
  }

  @override
  int get hashCode =>
      hashValues(email, password, formType, isLoading, submitted);

  @override
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (this.runtimeType != other.runtimeType) return false;
    final EmailSignInModel otherModel = other;
    return email == otherModel.email &&
        password == otherModel.password &&
        formType == otherModel.formType &&
        isLoading == otherModel.isLoading &&
        submitted == otherModel.submitted;
  }
}
