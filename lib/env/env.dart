import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: ".env")
abstract class Env {
  @EnviedField(varName: "OPENAIKEY")
  static const String openAIKey = _Env.openAIKey;
}
