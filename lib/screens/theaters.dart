import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ticket_app/components/avatar.dart';
import 'package:ticket_app/main.dart';
import 'package:ticket_app/screens/addevent.dart';
import 'package:ticket_app/screens/login.dart';

class EventWidget extends StatelessWidget {
  final Map<String, dynamic> eventData;

  const EventWidget({super.key, required this.eventData});

  @override
  Widget build(BuildContext context) {
    final imageUrl = eventData['event_image'] ??
        'https://ltuangxwymejnflvtrws.supabase.co/storage/v1/object/public/profiller/robot.png';

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _builEventDetails(),
              ),
            ),
            // Resmi gösteren kısım
            Image.network(
              imageUrl,
              width: 100, // Resmin genişliğini ayarlayın
              height: 100, // Resmin yüksekliğini ayarlayın
              fit: BoxFit.cover, // Resmi kutuya sığdır
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _builEventDetails() {
    return [
      Text(
        'Event Name: ${eventData['event_name']}',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      Text('Event Data: ${eventData['event_data']}'),
      Text('Event Type: ${eventData['event_type']}'),
      Text('Producer: ${eventData['producer']}'),
      Text('Event Date: ${eventData['event_date']}'),
    ];
  }
}

class TheaterList extends StatefulWidget {
  const TheaterList({Key? key}) : super(key: key);

  @override
  _TheaterListState createState() => _TheaterListState();
}

class _TheaterListState extends State<TheaterList> {
  final Future<List<Map<String, dynamic>>> _future = Supabase.instance.client
      .from('events')
      .select<List<Map<String, dynamic>>>()
      .gte('event_date', DateTime.now().toIso8601String());
  String? _imageUrl;
  bool _hasPermissionToCreateEvent = false;

  @override
  void initState() {
    super.initState();
    //_redirect();
    _checkPermissionToCreateEvent();
  }

  Future<void> _checkPermissionToCreateEvent() async {
    final hasPermission = await hasPermissionToCreateEvent();
    setState(() {
      _hasPermissionToCreateEvent = hasPermission;
    });
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);
    if (!mounted) {
      return;
    }

    final session = supabase.auth.currentSession;
    if (session != null) {
      Navigator.of(context).pushReplacementNamed('/account');
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('THEATERS'),
        actions: _hasPermissionToCreateEvent
            ? [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddEvent()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // Butonun rengi
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(0), // Dikdörtgen şekli
                    ),
                    // Butonun boyutunu ayarlamak için padding ekleyebilirsiniz
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: const Text(
                    'EKLE',
                    style: TextStyle(
                      color: Colors.white, // Metin rengi beyaz
                      fontWeight: FontWeight.bold, // Metin kalınlığı
                    ),
                  ),
                )
              ]
            : null, // Title displayed in the AppBar
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final events = snapshot.data!;

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final eventData = events[index];
              return EventWidget(eventData: eventData);
            },
          );
        },
      ),
    );
  }
}

/*
FloatingActionButton(
  onPressed: () => (context2){},
  child : const Icon(Icons.filter_list),
)*/

/*
async Future<void> _showFilterPopup(BuildContext context2) async {
  showModalBottomSheet(
    context: context2,
    builder: (BuildContext bc) {
      return Container(
        child: Wrap(
          children: <Widget>[
            ListTile(
                leading: const Icon(Icons.text_format),
                title: const Text('Alphabetical Order'),
                onTap: () => _filterEventsAlphabetically()),
            ListTile(
                leading: const Icon(Icons.date_range),
                title: const Text('By Event Date'),
                onTap: () => _filterEventsByDate()),
            ListTile(
                leading: const Icon(Icons.category),
                title: const Text('By Event Type'),
                onTap: () => _filterEventsByType()),
          ],
        ),
      );
    }
  );
}
*/

void _filterEventsAlphabetically() {
  // Implement alphabetical sorting logic here
}

void _filterEventsByDate() {
  // Implement event date sorting logic here
}

void _filterEventsByType() {
  // Implement event type sorting logic here
}
