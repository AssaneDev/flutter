import 'package:flutter/material.dart';
import 'package:icandoit/controllers/challenge_controller.dart';

import 'package:provider/provider.dart';

import '../../models/challenge_model.dart';

class BuildChallengeList extends StatefulWidget {
  const BuildChallengeList({Key? key}) : super(key: key);

  @override
  _BuildChallengeListState createState() => _BuildChallengeListState();
}

class _BuildChallengeListState extends State<BuildChallengeList> {
  final String unityPattern = 'unity_challenge.';
  @override
  Widget build(BuildContext context) {
  List<ChallengeModel> _challengeList =
        Provider.of<ChallengeController>(context).getChallenges();
           if (_challengeList.isEmpty) {
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'Pas de challenge créer et pourtant tu peut le faire',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
           }
      return ListView.builder(
          itemCount: _challengeList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding:
                  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
              child: Dismissible(
                onDismissed: (direction) {
                  if (direction == DismissDirection.endToStart) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      _buildSnackBar(
                          "Le challenge ${_challengeList[index].name} à été validé"),
                    );
                   Provider.of<ChallengeController>(context).remove(index);
                  }
                },
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    final result = await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              'Confirmation',
                              style: TextStyle(color: Colors.blue),
                            ),
                            content: const Text(
                                'Etes vous sur de vouloir supprimer'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    _buildSnackBar(
                                        "Le challenge ${_challengeList[index].name} à été supprimé"),
                                  );
                                  Provider.of<ChallengeController>(context).remove(index);
                                },
                                child: const Text('Oui'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                child: const Text("Non"),
                              ),
                            ],
                          );
                        });
                    return result;
                  }
                  return true;
                },
                background: Container(
                  alignment: Alignment.centerLeft,
                  color: Colors.red,
                  child: const Icon(
                    Icons.delete,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                secondaryBackground: Container(
                  alignment: Alignment.centerRight,
                  color: Colors.green,
                  child: const Icon(
                    Icons.check,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                key: Key(UniqueKey().toString()),
                child: Container(
                  color: Colors.white,
                  child: ListTile(
                    title: Text(_challengeList[index].name),
                    subtitle: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Objectif :',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          _challengeList[index].target.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(
                          width: 2.0,
                        ),
                        Text(
                          _challengeList[index]
                              .unity
                              .toString()
                              .replaceAll(unityPattern, ' '),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                ),
              ),
            );
          });
    }
    
  }

  SnackBar _buildSnackBar(String content) {
    return SnackBar(
      content: Text(
        content,
        textAlign: TextAlign.center,
      ),
    );
  }
