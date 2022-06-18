import 'package:flutter/material.dart';

class EmailSignInForm extends StatelessWidget {
  List<Widget> _buildChildren() {
    return [
      TextField(
        decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'test@test.com',
        ),
      ),
      SizedBox(height: 8.0),
      TextField(
        decoration: InputDecoration(
          labelText: 'Password',
        ),
        obscureText: true,
      ),
      SizedBox(height: 8.0),
      ElevatedButton(
        child: Text('Sign In'),
        style: ElevatedButton.styleFrom(
          primary: Colors.grey[350],
          onPrimary: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(2.0)),
          ),
        ),
        onPressed: () {},
      ),
      SizedBox(height: 8.0),
      TextButton(
        onPressed: () {},
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all<Color>(
            Colors.grey[300],
          ),
          padding: MaterialStateProperty.all<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 16.0),
          ),
        ),
        child: Text(
          "Need an account ? Register",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }
}
