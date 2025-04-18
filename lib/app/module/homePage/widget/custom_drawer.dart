import 'package:flutter/material.dart';

class ProfileDrawer extends StatelessWidget {
  final String profileImageUrl;
  final String name;
  final String contactNumber;
  final String email;
  final VoidCallback onLogout;

  const ProfileDrawer({
    super.key,
    required this.profileImageUrl,
    required this.name,
    required this.contactNumber,
    required this.email,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(profileImageUrl),
            ),
            SizedBox(height: 10),
            Text(
              name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              contactNumber,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 5),
            Text(
              email,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            Spacer(),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text("Logout"),
              onTap: onLogout,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
