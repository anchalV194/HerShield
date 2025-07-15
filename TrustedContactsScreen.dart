import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';

class TrustedContactsScreen extends StatelessWidget {
  const TrustedContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseReference ref = FirebaseDatabase.instance.ref('trusted_contacts');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trusted Contacts'),
        backgroundColor: Colors.deepPurple[200],
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: ref.onValue,
        builder: (context, snapshot) {
          // LOADING STATE
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ERROR STATE
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          // EMPTY STATE
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text("No trusted contacts found."));
          }

          // PARSE DATA
          try {
            final Map<dynamic, dynamic> raw = snapshot.data!.snapshot.value as Map;
            final data = raw.map((key, value) =>
                MapEntry(key.toString(), Map<String, dynamic>.from(value)));

            return ListView(
              padding: const EdgeInsets.all(12),
              children: data.entries.map((entry) {
                final contact = entry.value;
                return Card(
                  color: Colors.deepPurple.shade50,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.contact_page_outlined, color: Colors.deepPurple),
                    title: Text(contact['name'] ?? 'No Name',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(contact['phone'] ?? 'No Phone'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.message_rounded, color: Colors.deepPurple),
                          tooltip: 'Send Message',
                          onPressed: () async {
                            final Uri smsUri = Uri(
                              scheme: 'sms',
                              path: contact['phone'],
                              queryParameters: {
                                'body': 'Hi, this is a safety update from HerShield.'
                              },
                            );
                            if (await canLaunchUrl(smsUri)) {
                              await launchUrl(smsUri);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Could not launch SMS app')),
                              );
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.call, color: Colors.green),
                          tooltip: 'Call',
                          onPressed: () async {
                            final Uri telUri = Uri(scheme: 'tel', path: contact['phone']);
                            if (await canLaunchUrl(telUri)) {
                              await launchUrl(telUri);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Could not launch dialer')),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          } catch (e) {
            return Center(child: Text('Parsing error: $e'));
          }
        },
      ),
    );
  }
}
