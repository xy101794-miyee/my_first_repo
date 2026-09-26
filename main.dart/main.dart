import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final user = TextEditingController();
  final pass = TextEditingController();

  void login() {
    if (user.text == 'Mae' && pass.text == '0129') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Dashboard()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wrong username or password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Login'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person, size: 80, color: Colors.green),
            const SizedBox(height: 20),
            TextField(
              controller: user,
              decoration: const InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: pass,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('LOGIN'),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= DASHBOARD =================

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome, Roselyn Anne!',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Student Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text('Name: Roselyn Anne Dulang'),
            const Text('ID: 2024-03702'),
            const Text('Course: BSIT'),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.book),
              label: const Text('My Subjects'),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.assignment),
              label: const Text('Assignments'),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.grade),
              label: const Text('My Grades'),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('LOGOUT'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= SUBJECTS PAGE =================

class SubjectsPage extends StatelessWidget {
  const SubjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final subjects = [
      {
        'code': 'IT 221',
        'name': 'Introduction to Data Structure and Algorithm',
        'units': '3 units',
      },
      {
        'code': 'IT 224',
        'name': 'Introduction to Information Management',
        'units': '3 units',
      },
      {
        'code': 'IT 225',
        'name': 'Introduction to Networking',
        'units': '3 units',
      },
      {'code': 'PE 3', 'name': 'Physical Education', 'units': '1 unit'},
      {
        'code': 'ITELEC2',
        'name': 'Mobile Application Development',
        'units': '2 units',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Subjects'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          final subject = subjects[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  subject['code']!.split('')[1],
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              title: Text(
                subject['name']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(subject['code']!),
              trailing: Chip(
                label: Text(subject['units']!),
                backgroundColor: Colors.blue.shade100,
              ),
            ),
          );
        },
      ),
    );
  }
}
