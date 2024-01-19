import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ticket_app/main.dart';
import 'package:ticket_app/screens/login.dart';
import 'package:uuid/uuid.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({Key? key}) : super(key: key);

  @override
  
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final _formKey = GlobalKey<FormState>();
  String event_name = '';
  String event_id = Uuid().v4();
  DateTime event_date = DateTime.now();
  String event_type = '';
  String producer = '';
  String venue = '';
  String event_image = '';

  bool _hasPermissionToCreateEvent = true;

  @override
  void initState() {
    super.initState();
    _checkPermissionToCreateEvent();
  }

  Future<void> _checkPermissionToCreateEvent() async {
    final hasPermission = await hasPermissionToCreateEvent();
    setState(() {
      _hasPermissionToCreateEvent = hasPermission;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Etkinlik Ekle'),
      ),
      body: _hasPermissionToCreateEvent
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Etkinlik Tarihi',
                      ),
                      onSaved: (value) {
                        if (value != null) {
                          event_date = DateFormat('yyyy-MM-dd').parse(value);
                        }
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Etkinlik İsmi',
                      ),
                      onSaved: (value) => event_name = value ?? '',
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Etkinlik Tipi',
                      ),
                      onSaved: (value) => event_type = value ?? '',
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Yapımcı',
                      ),
                      onSaved: (value) => producer = value ?? '',
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Yer',
                      ),
                      onSaved: (value) => venue = value ?? '',
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          _addEventToDatabase();
                        }
                      },
                      child: const Text('Etkinliği Kaydet'),
                    ),
                  ],
                ),
              ),
            )
          : const Center(
              child: Text('You do not have permission to add an event.'),
            ),
    );
  }

  // void _addEventToDatabase() {
  //   print('Event Name: $event_name');
  //   print('Event ID: $event_id');
  //   print('Event Date: $event_date');
  //   print('Event Type: $event_type');
  //   print('Producer: $producer');
  //   print('Venue: $venue');
  //   // Add the logic to insert these values into your database
  // }
  void _addEventToDatabase() async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(event_date);
    try {
      final rsp = await Supabase.instance.client.from('events').insert({
        'event_id': event_id,
        'event_name': event_name,
        'event_date': formattedDate,
        'event_type': event_type,
        'producer': producer,
        'venue': venue,
        'event_image': event_image,
      }).execute();

      // var response = await supabase.from('events').insert({
      //   'event_id': event_id,
      //   'event_name': event_name,
      //   'event_date': formattedDate,
      //   'event_type': event_type,
      //   'producer': producer,
      //   'venue': venue,
      // });
    } catch (e) {
      print('Eklemede hata var $e');
    }
  }
}

Future<bool> hasPermissionToCreateEvent() async {
  final user = globaluser?.email;

  if (user != null) {
    final response = await supabase
        .from('admins')
        .select('email')
        .eq('email', user)
        .execute();

    for (var mail in response.data) {
      if (mail['email'] == globaluser?.email) {
        return true;
      } else {
        return false;
      }
    }
  }
  return false;
}
