import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:huntly/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

import '../../../../core/theme/theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('USER NAME'),
        elevation: 0,
        backgroundColor: darkTheme.colorScheme.background,
      ),
      backgroundColor: darkTheme.colorScheme.background,
      body: Column(
        children: [
          Container(
            height: 200,
            width: 200,
            decoration:
                const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
          ),
          Center(
            child: Text(
              'John Doe'.toUpperCase(),
              style: darkTheme.textTheme.titleLarge,
            ),
          ),
          Center(
            child: Text(
              'jhondoe@gmail.com',
              style: darkTheme.textTheme.labelMedium,
            ),
          ),
          // Text feild for user description with complete border and max 150 characters
          Container(
            margin: const EdgeInsets.all(20),
            child: const TextField(
              maxLines: 5,
              maxLength: 150,
              decoration: InputDecoration(
                // bprder color white
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                border: OutlineInputBorder(),
                labelText: 'Description',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
