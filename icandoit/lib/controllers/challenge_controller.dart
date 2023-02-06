import 'dart:collection';

import 'package:flutter/material.dart';

import '../models/challenge_model.dart';

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

const String keyAcess = 'challengesList';

class ChallengeController extends ChangeNotifier {
  List<ChallengeModel> _challengesList = [];
  late SharedPreferences _localData;

  List<ChallengeModel> getChallenges() {
    return UnmodifiableListView(_challengesList);
  }

  ChallengeController() {
    initChallenge();
  }

  void initChallenge() async {
    _localData = await SharedPreferences.getInstance();

    final List<String>? _tempList = _localData.getStringList(keyAcess);
    if (_tempList!.isNotEmpty) {
      final List<dynamic> _jsonEncodeList = _tempList
          .map((challengeEncoded) => jsonDecode(challengeEncoded))
          .toList();

      _challengesList = _jsonEncodeList
          .map((challenge) => ChallengeModel.fromJson(challenge))
          .toList();
    }
    notifyListeners();
  }

  void addChallenge(
      {required String name,
      required String target,
      required String unity}) async {
    _challengesList.add(
      ChallengeModel(
        name: name,
        target: int.parse(target),
        unity: unity == 'KG' ? unity_challenge.kg : unity_challenge.km,
      ),
    );
    //save
    await _save(true);
    notifyListeners();
  }

  Future<bool> _save(bool remove) async {
    if (_challengesList.length < 1 && remove) {
      return _localData.setStringList(keyAcess, []);
    }
    if (_challengesList.isNotEmpty) {
      List<String> _toJson = _challengesList
          .map((challenge) => jsonEncode(challenge.toJson()))
          .toList();
      // ignore: avoid_print
      print(_toJson);

      return _localData.setStringList(keyAcess, _toJson);
    }
    return false;
  }

  void remove(int index) async {
    _challengesList.removeAt(index);

    await _save(true);
    notifyListeners();
  }
}
