import 'dart:ui';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:fluttertoast/fluttertoast.dart';
import "package:url_launcher/url_launcher.dart";
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'custom_bottom_nav_bar.dart';
import 'home_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final data = await FirebaseDatabase.instance.ref("trusted_contacts").get();
  print("Initial Firebase read: ${data.value}");
  runApp(const WomensSafetyApp());
}

class WomensSafetyApp extends StatelessWidget {
  const WomensSafetyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HerShield',
      color: Colors.purple[700],// Updated App Title
      theme: ThemeData(
        primarySwatch: Colors.purple,
        primaryColor: Colors.purple[700], // Changed from 100 to a darker shade for more impact
        scaffoldBackgroundColor: Colors.purple[50],
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            // foregroundColor: Colors.white,
            elevation: 4.0,
            centerTitle: true,
            shadowColor: Colors.black26 // Lighter shadow
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          // backgroundColor: Colors.white, // Will be overridden by CustomBottomNavBar
          selectedItemColor: Colors.purple[600],
          unselectedItemColor: Colors.purple[200],
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple[600],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0), // Slightly more rounded
            borderSide: BorderSide(color: Colors.purple[200]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.purple[700]!, width: 2.0),
            borderRadius: BorderRadius.circular(12.0),
          ),
          labelStyle: TextStyle(color: Colors.purple[700]),
          floatingLabelStyle: TextStyle(color: Colors.purple[700], fontWeight: FontWeight.bold),
          filled: true,
          fillColor: Colors.purple[50]?.withOpacity(0.5),
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(color: Colors.purple[800], fontWeight: FontWeight.bold, fontSize: 22),
          titleMedium: TextStyle(color: Colors.purple[700], fontWeight: FontWeight.w600, fontSize: 18),
          bodyMedium: TextStyle(fontSize: 16.0, color: Colors.grey[800], height: 1.4),
          labelLarge: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // For button text
        ),
        cardTheme: CardThemeData(
          elevation: 3.0, // Slightly more elevation
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0), // More rounded cards
          ),
          color: Colors.white, // Explicitly white cards
        ),
        iconTheme: IconThemeData(
          color: Colors.purple[700], // Default icon color
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const MainNavigationScreen(),
    );
  }
}
class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;
  const MainNavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  final List<Widget> _screens = const [
    HomeScreen(),
    CouncilScreen(),
    ConcernScreen(),
    FollowMeScreen(),
    EmergencyScreen(),
  ];

  final List<String> _appBarTitles = const [
    'HerShield',
    'Council',
    'Raise Concern',
    'Follow Me',
    'Emergency',
  ];

  final List<IconData> _icons = [
    Icons.home_filled,
    Icons.people_alt_rounded,
    Icons.report_gmailerrorred_rounded,
    Icons.location_on_rounded,
    Icons.contact_page_outlined,
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _openRakshakMode() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RakshakScreen()),
    );
  }

  void _openTipsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TipsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.lightbulb_outline_rounded),
          tooltip: 'Safety Tips',
          onPressed: _openTipsScreen,
        ),
        title: Text(_appBarTitles[_currentIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.shield_rounded),
            tooltip: 'Rakshak Mode',
            onPressed: _openRakshakMode,
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/bg.jpeg',
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.55),
            colorBlendMode: BlendMode.darken,
          ),
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        icons: _icons,
        onTabSelected: _onTabTapped,
      ),
    );
  }
}
// TipsScreen remains largely the same, but it's now navigated to.
class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold( // Add Scaffold if it's a full screen now
      appBar: AppBar(
        title: const Text('Safety Tips', style: TextStyle(color: Colors.deepPurple)),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.deepPurple,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.deepPurple),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0, // No shadow
        // Inherits from theme
        //foregroundColor: theme.appBarTheme.foregroundColor, // Inherits from theme
      ),
      body: ListView( // Changed to ListView for potentially more tips
        padding: const EdgeInsets.all(20),
        children: [
          _buildTipCard(
            context,
            icon: Icons.noise_aware_outlined, // Example
            title: 'Be Aware of Your Surroundings',
            content: 'Always pay attention to what\'s happening around you. Avoid distractions like using your phone excessively when walking alone, especially at night.',
          ),
          _buildTipCard(
            context,
            icon: Icons.phone_android_rounded,
            title: 'Keep Your Phone Charged',
            content: 'Ensure your mobile phone is always charged and has emergency contacts saved for quick access. Consider installing a safety app.',
          ),
          _buildTipCard(
            context,
            icon: Icons.directions_walk_rounded,
            title: 'Trust Your Instincts',
            content: 'If a situation or someone makes you feel uncomfortable, remove yourself from the situation immediately. Don\'t worry about being polite.',
          ),
          _buildTipCard(
            context,
            icon: Icons.group_rounded,
            title: 'Inform Someone About Your Plans',
            content: 'When going out, especially to a new place or at night, let a friend or family member know your plans, including where you are going and when you expect to be back.',
          ),
          _buildTipCard(
            context,
            icon: Icons.local_taxi_rounded,
            title: 'Use Trusted Transportation',
            content: 'Opt for well-lit and reputable taxi services or ride-sharing options. Share your ride details with someone you trust.',
          ),
          // Add more tips as _buildTipCard widgets
        ],
      ),
    );
  }

  Widget _buildTipCard(BuildContext context, {required IconData icon, required String title, required String content}) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.primaryColor, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              content,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

class RakshakScreen extends StatefulWidget {
  const RakshakScreen({super.key});

  @override
  State<RakshakScreen> createState() => _RakshakScreenState();
}

class _RakshakScreenState extends State<RakshakScreen> with SingleTickerProviderStateMixin {
  bool _isRakshakModeActive = false;
  late AnimationController _animationController;
  late Animation<Color?> _backgroundColorAnimation;
  bool _animationInitialized = false; // To ensure animation is initialized once with context

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    // We will initialize _backgroundColorAnimation in didChangeDependencies
    // or ensure a default non-context value here if absolutely needed before build.
    // For now, let's defer it.
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize animation here where Theme.of(context) is reliably available
    if (!_animationInitialized) {
      _backgroundColorAnimation = ColorTween(
        begin: Theme.of(context).scaffoldBackgroundColor, // Default screen background
        end: Colors.purple[200], // Active Rakshak mode background
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ));
      _animationInitialized = true;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleRakshakMode(bool isActive) {
    setState(() {
      _isRakshakModeActive = isActive;
      if (_isRakshakModeActive) {
        _animationController.forward();
        Fluttertoast.showToast(
            msg: "Rakshak Mode Activated: Stay vigilant!",
            toastLength: Toast.LENGTH_SHORT, // LENGTH_LONG might be better
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white);
      } else {
        _animationController.reverse();
        Fluttertoast.showToast(
            msg: "Rakshak Mode Deactivated.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    });
  }

  Future<void> _callEmergency(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      Fluttertoast.showToast(
          msg: 'Could not launch dialer for $phoneNumber',
          gravity: ToastGravity.CENTER
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Ensure _backgroundColorAnimation is initialized before use
    if (!_animationInitialized) {
      // This is a fallback, ideally didChangeDependencies handles it.
      // If it reaches here, it means build is called before didChangeDependencies
      // which can happen in some scenarios.
      _backgroundColorAnimation = ColorTween(
        begin: theme.scaffoldBackgroundColor,
        end: Colors.purple[200],
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ));
      _animationInitialized = true; // Mark as initialized
    }


    return AnimatedBuilder(
      animation: _animationController, // Listen to the controller directly
      builder: (context, child) {
        return Scaffold(
          // Use the animation value if mode is active, otherwise default scaffold color
          backgroundColor: _isRakshakModeActive
              ? _backgroundColorAnimation.value
              : theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: const Text("I'm the Shield"),
            // Optionally, animate AppBar color too
            backgroundColor: _isRakshakModeActive
                ? Color.lerp(theme.appBarTheme.backgroundColor, theme.primaryColorLight, _animationController.value)
                : theme.appBarTheme.backgroundColor,
          ),
          body: child, // The static part of the UI
        );
      },
      child: Padding( // This child is passed to AnimatedBuilder's builder
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  // Animate border and background opacity as well for smoother transition
                    color: _isRakshakModeActive
                        ? Colors.purple.withOpacity(0.1 * _animationController.value)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isRakshakModeActive
                          ? Color.lerp(Colors.grey[300]!, theme.primaryColor, _animationController.value)!
                          : Colors.grey[300]!,
                      width: _isRakshakModeActive
                          ? lerpDouble(1, 2, _animationController.value)!
                          : 1,
                    )),
                child: Column(
                  children: [
                    // Icon can also be animated, e.g., cross-fade
                    Icon(
                      _isRakshakModeActive ? Icons.shield_rounded : Icons.shield_outlined,
                      size: 60,
                      color: Color.lerp(Colors.deepPurple, theme.primaryColorDark, _animationController.value),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _isRakshakModeActive
                          ? 'You are in Rakshak Mode!'
                          : 'Activate Rakshak Mode to help.',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Color.lerp(Colors.black87, theme.primaryColorDark, _animationController.value),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Join hands to protect and support female colleagues in need, right where you are.',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Rakshak Mode:',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  Switch(
                    value: _isRakshakModeActive,
                    onChanged: _toggleRakshakMode,
                    activeColor: theme.primaryColorDark,
                    inactiveThumbColor: Colors.grey,
                    activeTrackColor: theme.primaryColorLight,
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // AnimatedSwitcher for content based on mode for smoother transitions
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, 0.3),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: _isRakshakModeActive
                    ? _buildActiveRakshakContent(context, key: const ValueKey("activeContent"))
                    : _buildInactiveRakshakContent(context, key: const ValueKey("inactiveContent")),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Added Key to these widgets for AnimatedSwitcher
  Widget _buildActiveRakshakContent(BuildContext context, {Key? key}) {
    final theme = Theme.of(context);
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Rakshak Guidelines:',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.primaryColorDark),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        _buildGuidelineItem(Icons.visibility_rounded, 'Be Vigilant: Pay attention to your surroundings.'),
        _buildGuidelineItem(Icons.support_agent_rounded, 'Offer Assistance: If safe, ask if someone needs help.'),
        _buildGuidelineItem(Icons.campaign_rounded, 'Report Concerns: Use emergency contacts if needed.'),
        const SizedBox(height: 30),
        ElevatedButton.icon(
          icon: const Icon(Icons.report_problem_outlined),
          label: const Text('Report Suspicious Activity'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const MainNavigationScreen(initialIndex: 2),
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          icon: const Icon(Icons.call_rounded),
          label: const Text('Call Security (192)'),
          onPressed: () => _callEmergency('192'),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: theme.primaryColor),
            foregroundColor: theme.primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildInactiveRakshakContent(BuildContext context, {Key? key}) {
    Theme.of(context);
    return Column(
      key: key,
      children: [
        Icon(Icons.info_outline_rounded, color: Colors.blue[700], size: 40),
        const SizedBox(height: 10),
        Text(
          'When you activate Rakshak Mode, you signal your willingness to be an active bystander and support the safety of your colleagues.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: Colors.grey[700], height: 1.4),
        ),
        const SizedBox(height: 10),
        Text(
          'You might receive alerts if someone nearby needs assistance (feature coming soon).',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildGuidelineItem(IconData icon, String text) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.primaryColor, size: 22),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: TextStyle(fontSize: 15, color: Colors.grey[800], height: 1.4))),
        ],
      ),
    );
  }
}
// CouncilScreen
class CouncilScreen extends StatelessWidget {
  const CouncilScreen({super.key});

  final List<Map<String, String>> members = const [ // Changed to Map for more structured data
    {'name': 'ARUN SOBTI', 'role': 'DIRECTOR', 'icon': 'assets/member1.png'}, // Example with asset
    {'name': 'LAXMI KANTA HALDER', 'role': 'DS (WS-II)', 'icon': 'assets/member1.png'},
    {'name': 'R V YADAV ', 'role': 'DC (LEGAL)', 'icon': 'assets/member1.png'},
    {'name': 'MADHU PURI', 'role': 'US-COORD (WS)', 'icon': 'assets/member1.png'},
    {'name': 'SATYENDRA SINGH', 'role': 'CONSULTANT (WS-I)', 'icon': 'assets/member1.png'}
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: members.length,
      itemBuilder: (context, index) {
        final member = members[index];
        return Card(
          child: ListTile(
            leading: CircleAvatar( // Example for image, ensure you have assets
              backgroundImage: AssetImage(member['icon']!),
              backgroundColor: theme.primaryColorLight,
              child: member['icon']!.isEmpty ? Icon(Icons.person_rounded, color: theme.primaryColorDark) : null,
            ),
            //leading: Icon(Icons.person_pin_circle_rounded, color: theme.primaryColorDark, size: 36),
            title: Text(
              member['name']!,
              style: theme.textTheme.titleMedium?.copyWith(color: theme.primaryColorDark),
            ),
            subtitle: Text(
              member['role']!,
              style: TextStyle(color: Colors.grey[600]),
            ),
            trailing: IconButton(
              icon: Icon(Icons.info_outline_rounded, color: theme.iconTheme.color?.withOpacity(0.7)),
              onPressed: (){
                Fluttertoast.showToast(msg: "More info about ${member['name']}");
              },
            ),
          ),
        );
      },
    );
  }
}
class ConcernScreen extends StatefulWidget {
  const ConcernScreen({super.key});

  @override
  State<ConcernScreen> createState() => _ConcernScreenState();
}

class _ConcernScreenState extends State<ConcernScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final List<String> _issueTypes = ['Harassment', 'Safety Hazard', 'Infrastructure', 'Suggestion', 'Other'];
  String? _selectedIssueType;

  List<Map<String, dynamic>> _submittedConcerns = [];

  @override
  void initState() {
    super.initState();
    _loadConcerns();
  }

  Future<void> _loadConcerns() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('concern_list');
    if (data != null) {
      _submittedConcerns = List<Map<String, dynamic>>.from(json.decode(data));
      setState(() {});
    }
  }

  Future<void> _saveConcern(Map<String, dynamic> concern) async {
    final prefs = await SharedPreferences.getInstance();
    _submittedConcerns.insert(0, concern);
    await prefs.setString('concern_list', json.encode(_submittedConcerns));
    setState(() {});
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final concern = {
        'type': _selectedIssueType,
        'description': _descriptionController.text.trim(),
        'timestamp': DateTime.now().toIso8601String(),
      };
      _saveConcern(concern);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Concern submitted successfully'), backgroundColor: Colors.green),
      );

      _formKey.currentState!.reset();
      _selectedIssueType = null;
      _descriptionController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Reach out for help, We\'re here'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'New Request'),
              Tab(text: 'History'),
            ],
          ),
        ),
        resizeToAvoidBottomInset: true,
        body: TabBarView(
          children: [
            _buildForm(),
            _buildHistory(),
          ],
        ),
      ),
    );
  }
  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedIssueType,
              decoration: InputDecoration(
                labelText: 'Choose the type of issue',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.category, color: Colors.deepPurple),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: _issueTypes.map((issue) {
                return DropdownMenuItem(
                  value: issue,
                  child: Text(issue),
                );
              }).toList(),
              onChanged: (val) => setState(() => _selectedIssueType = val),
              validator: (val) =>
              val == null ? 'Please select an issue type' : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Brief your issue...',
                hintText: 'Describe the issue in detail.',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.description, color: Colors.deepPurple),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Description is required';
                }
                if (val.trim().length < 10) {
                  return 'Minimum 10 characters required';
                }
                return null;
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Submit', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistory() {
    if (_submittedConcerns.isEmpty) {
      return const Center(child: Text("No concerns submitted yet."));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: _submittedConcerns.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final concern = _submittedConcerns[index];
        return ListTile(
          leading: const Icon(Icons.report_problem, color: Colors.deepPurple),
          title: Text(style : const TextStyle(fontWeight: FontWeight.bold, color: Colors.white), concern['type']),
          subtitle: Text(style: const TextStyle(color: Colors.white),concern['description']),
          trailing: Text(
            _formatDate(concern['timestamp']),
            style: const TextStyle(color : Colors.white, fontSize: 12),
          ),
        );
      },
    );
  }

  String _formatDate(String isoDate) {
    final dateTime = DateTime.parse(isoDate);
    return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}

class FollowMeScreen extends StatefulWidget {
  const FollowMeScreen({super.key});

  @override
  State<FollowMeScreen> createState() => _FollowMeScreenState();
}

class _FollowMeScreenState extends State<FollowMeScreen> {
  String? _currentAddress = 'Fetching...';
  final Location location = Location();
  final DatabaseReference _firebaseRef = FirebaseDatabase.instance.ref();
  bool _isLoading = true;
  double? _currentLat;
  double? _currentLng;

  @override
  void initState() {
    super.initState();
    _getInitialLocation();
  }

  Future<void> _getInitialLocation() async {
    try {
      if (!await location.serviceEnabled()) {
        if (!await location.requestService()) return;
      }
      if (await location.hasPermission() == PermissionStatus.denied) {
        if (await location.requestPermission() != PermissionStatus.granted) return;
      }

      final loc = await location.getLocation();
      _currentLat = loc.latitude;
      _currentLng = loc.longitude;
      await _getAddressFromLatLng(_currentLat!, _currentLng!);
    } catch (e) {
      setState(() {
        _currentAddress = "Location permission denied or error occurred";
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      Placemark place = placemarks.first;
      setState(() {
        _currentAddress = "${place.name}, ${place.locality}";
      });
    } catch (e) {
      _currentAddress = "Unknown location";
    }
  }

  Future<Map<String, dynamic>> _fetchTrustedContacts() async {
    final snapshot = await _firebaseRef.child('trusted_contacts').get();
    if (snapshot.exists) {
      return Map<String, dynamic>.from(snapshot.value as Map);
    }
    return {};
  }

  void _showContactDialogAndShare(double lat, double lng) async {
    final contacts = await _fetchTrustedContacts();

    if (contacts.isEmpty) {
      Fluttertoast.showToast(msg: 'No trusted contacts found.');
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select a contact to share with'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: contacts.entries.map((entry) {
              final id = entry.key;
              final name = entry.value['name'];
              final phone = entry.value['phone'];
              return ListTile(
                leading: const Icon(Icons.person_pin_rounded, color: Colors.deepPurple),
                title: Text(name),
                subtitle: Text(phone),
                trailing: const Icon(Icons.send_rounded, color: Colors.green),
                onTap: () async {
                  final timestamp = DateTime.now().toIso8601String();
                  final locationUrl = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';

                  await _firebaseRef.child("shared_locations/$id").set({
                    'lat': lat,
                    'lng': lng,
                    'timestamp': timestamp,
                    'shared_by': 'User', // optional: add user name
                  });

                  // Optionally open SMS app with message:
                  final smsUri = Uri.parse('sms:$phone?body=I\'m here: $locationUrl');
                  if (await canLaunchUrl(smsUri)) {
                    await launchUrl(smsUri);
                  }

                  Fluttertoast.showToast(msg: 'Location shared with $name');
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Future<void> _shareMyLocation() async {
    try {
      final currentLocation = await location.getLocation();
      _showContactDialogAndShare(currentLocation.latitude!, currentLocation.longitude!);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Could not fetch location');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/bg.jpeg',
              fit: BoxFit.cover,
              color: Colors.deepPurple.withOpacity(0.4),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _buildInfoTile(_currentAddress ?? 'Unknown location', Icons.my_location),
                  const Spacer(),
                  _buildShareButton(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String text, IconData icon) {
    return GestureDetector(
      onTap: () {
        if (_currentLat != null && _currentLng != null) {
          final mapsUrl = 'https://www.google.com/maps/search/?api=1&query=$_currentLat,$_currentLng';
          launchUrl(Uri.parse(mapsUrl));
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.green),
            const SizedBox(width: 10),
            Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
            const Icon(Icons.map_outlined, color: Colors.deepPurple),
          ],
        ),
      ),
    );
  }

  Widget _buildShareButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.share_location),
        label: const Text('Share My Location'),
        onPressed: _shareMyLocation,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  final List<Map<String, String>> contacts = const [
    {'name': 'Police', 'number': '100'},
    {'name': 'Ambulance', 'number': '101'}, // Added example
    {'name': 'Fire Department', 'number': '102'}, // Added example
    {'name': 'Security', 'number': '192'},
    // Add more contacts with icons if desired
    {'name': 'Women Helpline', 'number': '1091'},
  ];

  // Function to launch the dialer
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      // Could show a toast or snackbar if call cannot be made
      Fluttertoast.showToast(msg: 'Could not launch $phoneNumber');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated( // Use separated for dividers
      padding: const EdgeInsets.all(16.0),
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        return Card( // Wrap ListTile in a Card for better visual separation
          child: ListTile(
            leading: Icon(
              // contact['icon'] ?? Icons.phone, // Example for custom icons per contact
              Icons.contact_page_outlined,
              color: Theme.of(context).primaryColorDark,
              size: 30,
            ),
            title: Text(
              contact['name']!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
            subtitle: Text(
              contact['number']!,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            trailing: IconButton(
              icon: Icon(Icons.call, color: Colors.grey[700], size: 28),
              onPressed: () => _makePhoneCall(contact['number']!),
              tooltip: 'Call ${contact['name']}',
            ),
            onTap: () => _makePhoneCall(contact['number']!), // Make whole tile tappable
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 8), // Spacing between cards
    );
  }
}