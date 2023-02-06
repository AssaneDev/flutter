import 'package:flutter/material.dart';
import 'package:icandoit/controllers/challenge_controller.dart';

import 'package:provider/provider.dart';

import './screens/home_screen.dart';

void main() => runApp(const ICanDOIt());

class ICanDOIt extends StatelessWidget {
  const ICanDOIt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider<ChallengeController>(
        create: (context) => ChallengeController(),
        child: const Home(),
      ),
    );
  }
}
