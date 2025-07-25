import 'package:dio/dio.dart';
import '../models/step_entry_model.dart';
import '../models/macro_entry_model.dart';

class ApiService {
  static const String baseUrl = 'https://ada93a08cb4d.ngrok-free.app';
  static final Dio _dio = Dio();

  static Future<List<MacroEntry>> fetchMacroBreakdown(String userId, String date) async {
    final url = '$baseUrl/api/CalorieEntries/macro-breakdown/$userId?date=$date';

    try {
      final response = await _dio.get(url);
      print('Macro breakdown response: ${response.data}');

      if (response.statusCode == 200) {
        if (response.data is List) {
          return (response.data as List)
              .map((item) => MacroEntry.fromJson(item))
              .toList();
        } else {
          throw Exception('Expected a list of macro entries');
        }
      } else {
        throw Exception(
          'Failed to load macro breakdown. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error in fetchMacroBreakdown: $e');
      rethrow;
    }
  }


  static Future<List<StepEntry>> fetchLast7DaysSteps(String userId) async {
    final url = '$baseUrl/api/stepentry/last7days/$userId';

    try {
      final response = await _dio.get(url);
      print('Step data response: ${response.data}');

      if (response.statusCode == 200) {
        final rawList = response.data;
        if (rawList is List) {
          return rawList.map((item) => StepEntry.fromJson(item)).toList();
        } else {
          throw Exception('Unexpected response format: expected List');
        }
      } else {
        throw Exception(
          'Failed to load step data. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error in fetchLast7DaysSteps: $e');
      rethrow;
    }
  }
}
