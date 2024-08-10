import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lear2/features/advice/data/models/advice_model.dart';
import 'package:lear2/features/core/failure.dart';


const String adviceUrl = "https://api.adviceslip.com/advice";

abstract class AdviseRemoteDataSource {
  Future<AdviceModel> getAdvice();
  
}

class AdviceRemoteDatasourceImpl extends AdviseRemoteDataSource {

  @override
  Future<AdviceModel> getAdvice() async {
    try { 
      final response = await http.get(Uri.parse(adviceUrl));
     
      if (response.statusCode == 200) {
          
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return AdviceModel.fromJson(jsonResponse['slip']);
      } else {
        throw Failure(message: "Failed to load advice");
      }
    } catch (e) {
      throw Failure(message: "An error occurred: $e");
    } 
  }
}
