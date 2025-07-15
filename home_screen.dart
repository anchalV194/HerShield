import 'package:flutter/material.dart';
import 'TrustedContactsScreen.dart';
import 'main.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showTrustedContacts(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        final trustedContacts = [
          {'name': 'Mom', 'phone': '+91 9826162466'},
          {'name': 'Dad', 'phone': '+91 9826132109'},
          {'name': 'Sister', 'phone': '+91 6263817742'},
        ];

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Trusted Contacts',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...trustedContacts.map((contact) => ListTile(
                leading: const Icon(Icons.contact_page_outlined),
                title: Text(contact['name']!),
                subtitle: Text(contact['phone']!),
                trailing: IconButton(
                  icon: const Icon(Icons.call, color: Colors.green),
                  onPressed: () {
                    // Simulate call (for now)
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Calling ${contact['name']}...'),
                    ));
                  },
                ),
              )),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final TextStyle whiteTextStyle = TextStyle(
      color: Colors.white,
      shadows: [
        Shadow(
          blurRadius: 4.0,
          color: Colors.deepPurple.withOpacity(0.5),
          offset: const Offset(2.0, 2.0),
        ),
      ],
    );

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/bg.jpeg',
            fit: BoxFit.cover,
            color: Colors.deepPurple.withOpacity(0.4),
            colorBlendMode: BlendMode.darken,
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.female,
                    size: 80,
                    color: Colors.white.withOpacity(0.9),
                    shadows: [
                      Shadow(
                        blurRadius: 5.0,
                        color: Colors.black.withOpacity(0.6),
                        offset: const Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Welcome to HerShield!',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 4.0,
                          color: Colors.black.withOpacity(0.6),
                          offset: const Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Your safety and support companion.',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.grey[200],
                      shadows: [
                        Shadow(
                          blurRadius: 3.0,
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.shield_outlined, color: Colors.white),
                    label: const Text('Explore Rakshak Mode'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RakshakScreen()),
                      );
                    },
                    style: theme.elevatedButtonTheme.style?.copyWith(
                      backgroundColor: MaterialStateProperty.all(
                          theme.primaryColor.withOpacity(0.85)),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
                      elevation: MaterialStateProperty.all(8.0),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: BorderSide(color: Colors.white.withOpacity(0.5)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
                    label: const Text('Emergency SOS'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TrustedContactsScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Use navigation bar to explore features.')),
                      );
                    },
                    child: Text(
                      'Explore Other Features',
                      style: whiteTextStyle.copyWith(
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white70,
                        decorationThickness: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}