// lib/providers/analytics_provider.dart
import 'package:flutter/material.dart';
import '../models/macro_entry_model.dart';
import '../models/step_entry_model.dart';
import '../services/api_service.dart';

class AnalyticsProvider with ChangeNotifier {
  List<MacroEntry>? _macroData;
  List<StepEntry> _stepData = [];
  bool _isLoading = true;
  String? _error;

  // Getters
  List<MacroEntry>? get macroData => _macroData;
  List<StepEntry> get stepData => _stepData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadData(String userId, String date) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final macroFuture = ApiService.fetchMacroBreakdown(userId, date);
      final stepFuture = ApiService.fetchLast7DaysSteps(userId);

      _macroData = await macroFuture;
      _stepData = await stepFuture;
    } catch (e, stackTrace) {
      _error = 'Failed to load analytics data: ${e.toString()}';
      print('Error loading data: $e');
      print(stackTrace);
    }

    _isLoading = false;
    notifyListeners();
  }

  void clear() {
    _macroData = null;
    _stepData = [];
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
