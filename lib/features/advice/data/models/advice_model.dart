import 'package:json_annotation/json_annotation.dart';
import 'package:lear2/features/advice/domain/entities/advice.dart';

part 'advice_model.g.dart';

@JsonSerializable()
class AdviceModel extends Advice {
  final String advice;

  const AdviceModel({required this.advice}) : super(advice: advice);

  factory AdviceModel.fromJson(Map<String, dynamic> json) => _$AdviceModelFromJson(json);
}
