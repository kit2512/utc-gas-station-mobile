import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gas Station App'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              showDialog<bool?>(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to log out?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Logout'),
                          ),
                        ],
                      )).then((value) {
                if (value == true) {
                  Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                }
              });
            },
            child: const Row(
              children: [
                Icon(Icons.logout),
                SizedBox(width: 4),
                Text('Logout'),
              ],
            ),
          ),
        ],
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 8,
        children: [
          MainMenuCard(
            icon: const Icon(
              Icons.qr_code_2_rounded,
              size: 64,
              color: Colors.white,
            ),
            label: 'Scan QR',
            onTap: () => Navigator.of(context).pushNamed('/scan-qr'),
          ),
          MainMenuCard(
            icon: const Icon(
              Icons.description_outlined,
              size: 64,
              color: Colors.white,
            ),
            label: 'Manual',
            onTap: () => Navigator.of(context).pushNamed('/manual'),
          ),
        ],
      ),
    );
  }
}

class MainMenuCard extends StatelessWidget {
  const MainMenuCard({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final Widget icon;
  final String label;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(
                height: 12,
              ),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
}
