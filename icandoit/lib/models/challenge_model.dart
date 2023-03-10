enum unity_challenge { kg, km }

class ChallengeModel {
  final String name;
  final int target;
  final unity_challenge unity;

  ChallengeModel(
      {required this.name, required this.target, required this.unity});

  ChallengeModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        target = json['target'],
        unity = json['unity'] == 'unity_challenge.kg'
            ? unity_challenge.kg
            : unity_challenge.km;

  Map<String, dynamic> toJson() {
    return {"name": name, "target": target, "unity": unity.toString()};
  }
}
