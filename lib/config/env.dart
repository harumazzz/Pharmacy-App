import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env', requireEnvFile: true)
abstract class Env {
  @EnviedField(obfuscate: true, varName: 'DEEPSEEK_API_KEY')
  static final String deepseekApiKey = _Env.deepseekApiKey;
}
