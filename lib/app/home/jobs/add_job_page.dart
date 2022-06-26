import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

class AddJobPage extends StatefulWidget {
  const AddJobPage({Key key, @required this.database}) : super(key: key);
  final Database database;

  static Future<void> show(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AddJobPage(
        database: database,
      ),
      fullscreenDialog: true,
    ));
  }

  @override
  State<AddJobPage> createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  final _formKey = GlobalKey<FormState>();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _ratePerHourFocusNode = FocusNode();

  String _name;
  int _ratePerHour;

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _ratePerHourFocusNode.dispose();
    super.dispose();
  }

  void _nameComplete() {
    final newFocus = _name.isNotEmpty ? _ratePerHourFocusNode : _nameFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final job = Job(name: _name, ratePerHour: _ratePerHour);
        await widget.database.createJob(job);
        Navigator.of(context).pop();
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(
          context,
          title: 'Operation failed',
          exception: e,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text('New Job'),
        actions: <Widget>[
          TextButton(
            onPressed: _submit,
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all<Color>(
                Colors.indigo[600],
              ),
              padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ),
            child: Text(
              "Save",
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Job name'),
        focusNode: _nameFocusNode,
        textInputAction: TextInputAction.next,
        validator: (value) => value.isNotEmpty ? null : "Name can't be empty",
        onSaved: (value) => _name = value,
        onFieldSubmitted: (value) => _name = value,
        onEditingComplete: _nameComplete,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Rate per hour'),
        focusNode: _ratePerHourFocusNode,
        keyboardType:
            TextInputType.numberWithOptions(signed: false, decimal: false),
        textInputAction: TextInputAction.done,
        onSaved: (value) => _ratePerHour = int.tryParse(value) ?? 0,
        onEditingComplete: _submit,
      )
    ];
  }
}
