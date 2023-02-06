import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../models/challenge_model.dart';
import 'components/build_challenge_list.dart';
import '../controllers/challenge_controller.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> scarfoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late Future<List<ChallengeModel>> challengesData;
  String unityChallenge = "KG";
  late String nameChallenge;
  late String targetChallenge;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scarfoldKey,
      backgroundColor: const Color(0xff414a4c),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: const Text('ICanDOit'),
        centerTitle: true,
      ),
      body: BuildChallengeList(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange[700],
        onPressed: () {
          _buildBootomSheet();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  PersistentBottomSheetController _buildBootomSheet() {
    return scarfoldKey.currentState!.showBottomSheet((context) {
      return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          alignment: Alignment.center,
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                children: [
                  TextFormField(
                    onSaved: (value) {
                      nameChallenge = value!;
                    },
                    validator: (value) {
                      final RegExp checkReg = RegExp(r'^\D+$');
                      if (value!.isEmpty) {
                        return "Merci d'entrer un nom pour le challenge";
                      } else if (!checkReg.hasMatch(value)) {
                        return value;
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Nom du challenge",
                    ),
                  ),
                  TextFormField(
                    onSaved: (value) {
                      targetChallenge = value!;
                    },
                    validator: (value) {
                      final _isInt = int.tryParse(value!);
                      if (_isInt == null) {
                        return "Merci d'entrer d'uniquement des chiffres pour l'objectif";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Objectif",
                    ),
                  ),
                  DropdownButtonFormField<dynamic>(
                    value: unityChallenge,
                    onChanged: (value) {
                      setState(() {
                        unityChallenge = value;
                      });
                    },
                    onSaved: (value) {
                      setState(() {
                        unityChallenge = value;
                      });
                    },
                    items: const <DropdownMenuItem>[
                      DropdownMenuItem(
                        value: "KG",
                        child: Text('Kg'),
                      ),
                      DropdownMenuItem(
                        value: "KM",
                        child: Text('Km'),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        Provider.of<ChallengeController>(context).addChallenge(
                          name: nameChallenge,
                          target: targetChallenge,
                          unity: unityChallenge,
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Ajouter'),
                  ),
                ],
              ),
            ),
          ));
    });
  }
}
