import '../../../authentication/data/models/user_model.dart';
import '../../domain/entities/theme.dart';

class TeamModel {
  final int id;
  final String name;
  final int treasureHuntId;
  final List<UserModel> members;

  const TeamModel({
    required this.id,
    required this.name,
    required this.treasureHuntId,
    required this.members
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      id: json['id'],
      name: json['name'],
      treasureHuntId: json['treasure_hunt'],
      members: json['team_members'].map((member) => UserModel.fromJson(member)).toList()
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
