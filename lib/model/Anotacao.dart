// @dart=2.9

import 'package:blocodetarefas/helper/AnotacaoHelper.dart';

class Anotacao {
  int id;
  String titulo;
  String descricao;
  String data;

  Anotacao(this.titulo, this.descricao, this.data);

  Anotacao.fromMap(Map map) {
    this.id = map[AnotacaoHelper.colunaId];
    this.titulo = map[AnotacaoHelper.tituloC];
    this.descricao = map[AnotacaoHelper.descricaoC];
    this.data = map[AnotacaoHelper.dataC];
  }
  Map toMap() {
    Map<String, dynamic> map = {
      'titulo': this.titulo,
      'descricao': this.descricao,
      'data': this.data
    };

    if (this.id != null) {
      map['id'] = this.id;
    }

    return map;
  }
}
