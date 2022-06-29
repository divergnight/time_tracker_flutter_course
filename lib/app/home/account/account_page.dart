import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/common_widgets/avatar.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class AccountPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(
      context,
      title: 'Logout',
      content: 'Are you sure that you want to logout ?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    );
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 2.0,
        actions: [
          TextButton(
            onPressed: () => _confirmSignOut(context),
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all<Color>(
                Colors.indigo[600],
              ),
              padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ),
            child: Text(
              "Logout",
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(130),
          child: _buildUserInto(auth.currentUser),
        ),
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildUserInto(User user) {
    return Column(
      children: <Widget>[
        Avatar(
          radius: 50,
          photoUrl: user.photoURL,
        ),
        SizedBox(height: 16.0),
        Text(
          user.displayName != null ? user.displayName : user.uid,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container();
  }
}
