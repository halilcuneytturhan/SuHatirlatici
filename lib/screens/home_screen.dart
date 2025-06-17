import 'package:flutter/material.dart';
import '../services/notification_service.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const HomeScreen({super.key, required this.onToggleTheme});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double dailyGoal = 4000;
  double drankAmount = 0;
  bool loading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    loading = false;

    NotificationService.showScheduledNotification(
      id: 1,
      title: "Drink Water 💧",
      body: "Time to hydrate!",
      hour: 9,
      minute: 0,
    );
    NotificationService.showScheduledNotification(
      id: 2,
      title: "Keep Hydrated 🧊",
      body: "Take a sip!",
      hour: 12,
      minute: 0,
    );
    NotificationService.showScheduledNotification(
      id: 3,
      title: "Evening Water 💦",
      body: "Don't forget your last glass.",
      hour: 18,
      minute: 0,
    );
  }

  void addWater(double amount) {
    setState(() {
      drankAmount += amount;
      if (drankAmount > dailyGoal) {
        drankAmount = dailyGoal;
      }
    });
  }

  void logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(onToggleTheme: widget.onToggleTheme),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (error.isNotEmpty) {
      return Scaffold(
        body: Center(
          child: Text(
            error,
            style: const TextStyle(color: Colors.red, fontSize: 16),
          ),
        ),
      );
    }

    final percent = (drankAmount / dailyGoal).clamp(0.0, 1.0);
    final isGoalReached = drankAmount >= dailyGoal;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Su İçme Hatırlatıcısı"),
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: logout),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Ayarlar',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.brightness_6),
              title: const Text('Tema Değiştir'),
              onTap: widget.onToggleTheme,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Hedef Litre: ${dailyGoal.toInt()} ml",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              "İçilen Litre: ${drankAmount.toInt()} ml",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: percent,
              minHeight: 10,
              color: Colors.blue,
              backgroundColor: Colors.grey.shade300,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: isGoalReached ? null : () => addWater(250),
              child: const Text("+250 ml"),
            ),
            ElevatedButton(
              onPressed: isGoalReached ? null : () => addWater(500),
              child: const Text("+500 ml"),
            ),
            const SizedBox(height: 30),
            if (isGoalReached)
              const Text(
                "Günlük su içme limitinize ulaştınız, tebrikler!",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
