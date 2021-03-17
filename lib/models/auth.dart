import 'package:sogamax_canhotos/helpers/me_helper.dart';

class Auth {
  String nome;
  String access_token;

  Auth(this.nome, this.access_token);

  @override
  String toString() {
    return '$nome: $access_token';
  }

  Auth.fromMap(Map map) {
    nome = map[nomeColumn];
    access_token = map[accessTokenColumn];
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'access_token': access_token,
    };
  }

}
