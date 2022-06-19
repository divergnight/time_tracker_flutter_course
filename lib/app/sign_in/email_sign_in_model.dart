enum EmailSignInFormType { signIn, register }

class EmailSignInModel {
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
}
