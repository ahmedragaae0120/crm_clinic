import 'package:crm_clinic/data/model/user_model.dart';
import 'package:flutter/material.dart';

class ReceptionistUsersWidget extends StatelessWidget {
  final UserModel receptionist;
  const ReceptionistUsersWidget({super.key, required this.receptionist});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const CircleAvatar(
          radius: 24,
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text(receptionist.fullName ?? ''),
        subtitle: Text(receptionist.email ?? ''),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      ),
    );
  }
}
