import 'dart:async';

import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_model.dart';

class EmailSignInBloc {
  final StreamController<EmailSignInModel> _modelController =
      StreamController<EmailSignInModel>();
  Stream<EmailSignInModel> get modelStream => _modelController.stream;
  EmailSignInModel _model = EmailSignInModel();

  void dipose() {
    _modelController.close();
  }

  void updateWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool submitted,
    bool isLoading,
  }) {
    _model = _model.copyWith(
      email: email,
      password: password,
      formType: formType,
      isLoading: isLoading,
      submitted: submitted,
    );
    _modelController.add(_model);
  }
}
