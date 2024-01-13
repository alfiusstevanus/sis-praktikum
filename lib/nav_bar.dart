import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tubes_prak_app/homepage.dart';
import 'package:tubes_prak_app/login.dart';
import 'package:tubes_prak_app/peminjaman.dart';
import 'package:tubes_prak_app/tabel_peminjaman.dart';

class NavbarDemo extends StatefulWidget {
  const NavbarDemo({Key? key, this.useMaterial3 = false}) : super(key: key);

  final bool useMaterial3;

  @override
  State<NavbarDemo> createState() => _NavbarDemoState();
}

class _NavbarDemoState extends State<NavbarDemo> {
  int _selectedIndex = 0;
  bool _isSigningOut = false;

  Future<void> _signOut() async {
    setState(() {
      _isSigningOut = true;
    });
    await FirebaseAuth.instance.signOut();
    setState(() {
      _isSigningOut = false;
    });
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );

    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, 'login');
    } catch (e) {
      print("Error during sign out: $e");
    }
  }

  Future<void> _showLogoutConfirmation(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text('Are you sure you want to Log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _signOut();
              },
              child: Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = widget.useMaterial3 ? Colors.blue : Colors.blueAccent;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("James Ronald"),
              accountEmail: Text("jamesronald@itenas.ac.id"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person),
              ),
              decoration: BoxDecoration(
                color: primaryColor,
              ),
            ),
            ListTile(
              leading: Icon(Icons.home_filled),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context); // Tutup drawer
                _onBottomNavItemTapped(0);
              },
            ),
            ListTile(
              leading: Icon(Icons.badge),
              title: Text('Borrow'),
              onTap: () {
                Navigator.pop(context); // Tutup drawer
                _onBottomNavItemTapped(2);
              },
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Text("Settings"),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout Account'),
              onTap: () {
                _showLogoutConfirmation(context);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: _buildContent(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.blue[100],
        backgroundColor: Colors.blueAccent,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.badge),
            label: 'Borrow',
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return const HomePage(
          useMaterial3: true,
        );
      case 1:
        return TabelPeminjaman();
      default:
        return Container();
    }
  }

  void _onBottomNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
