import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BudgetGoal {
  const BudgetGoal({
    required this.id,
    required this.name,
    required this.draft,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final Map<String, dynamic> draft;
  final DateTime updatedAt;

  BudgetGoal copyWith({
    String? name,
    Map<String, dynamic>? draft,
    DateTime? updatedAt,
  }) => BudgetGoal(
    id: id,
    name: name ?? this.name,
    draft: draft ?? this.draft,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'draft': draft,
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory BudgetGoal.fromJson(Map<dynamic, dynamic> json) {
    final savedDraft = json['draft'];
    return BudgetGoal(
      id: json['id'] as String,
      name: json['name'] as String,
      draft: savedDraft is Map
          ? Map<String, dynamic>.from(savedDraft)
          : const {},
      updatedAt:
          DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}

abstract interface class BudgetGoalsRepository {
  Future<List<BudgetGoal>> load();
  Future<void> save(BudgetGoal goal);
  Future<void> delete(String id);
}

class SecureBudgetGoalsRepository implements BudgetGoalsRepository {
  static const _storageKey = 'saved_budget_goals_v1';

  SecureBudgetGoalsRepository({FlutterSecureStorage? storage})
    : _storage = storage ?? FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<List<BudgetGoal>> load() async {
    final encoded = await _storage.read(key: _storageKey);
    if (encoded == null || encoded.isEmpty) return [];

    final decoded = jsonDecode(encoded);
    if (decoded is! List) return [];

    return decoded
        .whereType<Map>()
        .map(BudgetGoal.fromJson)
        .toList(growable: true);
  }

  @override
  Future<void> save(BudgetGoal goal) async {
    final goals = await load();
    final index = goals.indexWhere((savedGoal) => savedGoal.id == goal.id);
    if (index < 0) {
      goals.add(goal);
    } else {
      goals[index] = goal;
    }
    await _storage.write(
      key: _storageKey,
      value: jsonEncode(goals.map((savedGoal) => savedGoal.toJson()).toList()),
    );
  }

  @override
  Future<void> delete(String id) async {
    final goals = await load();
    goals.removeWhere((goal) => goal.id == id);
    if (goals.isEmpty) {
      await _storage.delete(key: _storageKey);
      return;
    }
    await _storage.write(
      key: _storageKey,
      value: jsonEncode(goals.map((goal) => goal.toJson()).toList()),
    );
  }
}
