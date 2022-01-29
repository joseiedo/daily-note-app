// @dart=2.9

import 'package:blocodetarefas/helper/AnotacaoHelper.dart';
import 'package:blocodetarefas/model/Anotacao.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

const PRIMARY = 'primary';
const SECONDARY = 'secondary';
const WHITE = 'secondary';

const Map<String, Color> myColors = {
  PRIMARY: Color.fromRGBO(142, 68, 173, 1),
  SECONDARY: Color.fromRGBO(236, 240, 241, 1)
};

// ignore: unused_element
Map<String, dynamic> _ultimaAnotacaoRemovida = Map();

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _controllerTitulo = TextEditingController();
  TextEditingController _controllerDescricao = TextEditingController();
  var _db = AnotacaoHelper();
  List<Anotacao> _anotacoes = <Anotacao>[];

  _exibirTelaCadastro({Anotacao anotacao}) {
    String textoSalvarAtualizar = '';
    if (anotacao == null) {
      _controllerTitulo.text = '';
      _controllerDescricao.text = '';
      textoSalvarAtualizar = 'Salvar';
    } else {
      _controllerTitulo.text = anotacao.titulo;
      _controllerDescricao.text = anotacao.descricao;
      textoSalvarAtualizar = 'Atualizar';
    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: myColors[SECONDARY],
            title: Text('$textoSalvarAtualizar Anotação'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  maxLength: 400,
                  style: TextStyle(color: Colors.black),
                  controller: _controllerTitulo,
                  autofocus: true,
                  decoration: _decoracaoTexto('Título', 'Digite o título...'),
                  onChanged: (text) {},
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                    maxLength: 800,
                    controller: _controllerDescricao,
                    decoration:
                        _decoracaoTexto('Descrição', 'Digite a descrição...'),
                    onChanged: (text) {})
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "Cancelar",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text(
                  textoSalvarAtualizar,
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  //salvar
                  _salvarAtualizarAnotacao(anotacaoSelecionada: anotacao);
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  // ignore: non_constant_identifier_names
  InputDecoration _decoracaoTexto(String texto, String descricao) {
    return InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: myColors[PRIMARY])),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: myColors[PRIMARY])),
        border: OutlineInputBorder(),
        labelText: texto,
        labelStyle: TextStyle(color: myColors[PRIMARY]),
        hintText: descricao);
  }

  _exibirAnotacao({Anotacao anotacao}) {
    showDialog(
        context: context,
        builder: (context) {
          // ignore: unnecessary_statements
          return AlertDialog(
            backgroundColor: myColors[SECONDARY],
            title: Text(anotacao.titulo),
            content: Text(anotacao.descricao),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Voltar',
                    style: TextStyle(fontSize: 20, color: myColors[PRIMARY]),
                  ))
            ],
          );
        });
  }

  _exibirTelaExclusao({Anotacao anotacao}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: myColors[SECONDARY],
            title: Text(
              'Confirmar exclusão?',
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image(
                  image: AssetImage('assets/images/cleaner.png'),
                  height: 120,
                  width: 120,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 8, right: 8),
                  child: Text(
                    'Enquanto eu existir, bagunça não haverá!',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                        color: Colors.black54),
                  ),
                )
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _removerAnotacao(anotacao.id);
                  Navigator.pop(context);
                },
                child: Text(
                  'Confirmar',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancelar',
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        });
  }

  _recuperarAnotacoes() async {
    // _anotacoes.clear();

    List anotacoesRecuperadas = await _db.recuperarAnotacoes();

    List<Anotacao> listaTemporaria = <Anotacao>[];

    for (var item in anotacoesRecuperadas) {
      Anotacao anotacao = Anotacao.fromMap(item);
      listaTemporaria.add(anotacao);
    }

    setState(() {
      _anotacoes = listaTemporaria;
    });

    listaTemporaria = null;

    //print('Lista anotacoes:' + anotacoesRecuperadas.toString());
  }

  _salvarAtualizarAnotacao({Anotacao anotacaoSelecionada}) async {
    String titulo = _controllerTitulo.text;
    String descricao = _controllerDescricao.text;

    if (anotacaoSelecionada == null) {
      Anotacao anotacao =
          Anotacao(titulo, descricao, DateTime.now().toString());
      // ignore: unused_local_variable
      int resultado = await _db.salvarAnotacao(anotacao);
    } else {
      anotacaoSelecionada.titulo = titulo;
      anotacaoSelecionada.descricao = descricao;
      anotacaoSelecionada.data = DateTime.now().toString();
      // ignore: unused_local_variable
      int resultado = await _db.atualizarAnotacao(anotacaoSelecionada);
    }

    _controllerTitulo.clear();
    _controllerDescricao.clear();
    _recuperarAnotacoes();
  }

  _formatarData(String data) {
    initializeDateFormatting('pt_BR');
    var formater = DateFormat('d/MMM/y H:m:s');

    DateTime dataConvert = DateTime.parse(data);
    String dataFormatada = formater.format(dataConvert);

    return dataFormatada;
  }

  _removerAnotacao(int id) async {
    await _db.removerAnotacao(id);

    _recuperarAnotacoes();
  }

  _salvarAnotacaoSnack(Anotacao ultimaAnotacaoRemovida) async {
    Anotacao anotacao = Anotacao(ultimaAnotacaoRemovida.titulo,
        ultimaAnotacaoRemovida.descricao, DateTime.now().toString());
    // ignore: unused_local_variable
    int i = await _db.salvarAnotacao(anotacao);
    _recuperarAnotacoes();
  }

  @override
  void initState() {
    super.initState();
    _recuperarAnotacoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myColors[SECONDARY],
      appBar: AppBar(
        backgroundColor: myColors[PRIMARY],
        title: Text(
          'Bloco de notas',
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: _anotacoes.length,
                  itemBuilder: (context, index) {
                    final anotacao = _anotacoes[index];
                    return Card(
                      child: Dismissible(
                        key: ObjectKey(anotacao),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          padding: EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [Icon(Icons.delete, color: Colors.white)],
                          ),
                        ),
                        onDismissed: (direction) {
                          Anotacao _ultimaAnotacaoRemovida = anotacao;

                          _removerAnotacao(anotacao.id);

                          final snackbar = SnackBar(
                            duration: Duration(seconds: 5),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.delete_sweep_sharp,
                                  color: Colors.white,
                                ),
                                Text('Anotação removida!'),
                              ],
                            ),
                            action: SnackBarAction(
                              label: 'Desfazer',
                              onPressed: () {
                                _salvarAnotacaoSnack(_ultimaAnotacaoRemovida);
                              },
                            ),
                          );
                          // ignore: deprecated_member_use
                          Scaffold.of(context).showSnackBar(snackbar);
                        },
                        child: ListTile(
                          title: Text(anotacao.titulo),
                          subtitle: Text(
                              '${_formatarData(anotacao.data)} - ${anotacao.descricao}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _exibirTelaCadastro(anotacao: anotacao);
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(right: 0),
                                  child: Icon(Icons.edit, color: Colors.green),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _exibirTelaExclusao(anotacao: anotacao);
                                },
                                child: Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _exibirAnotacao(anotacao: anotacao);
                                },
                                child: Icon(
                                  Icons.menu_book_sharp,
                                  color: myColors[PRIMARY],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }))
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: myColors[PRIMARY],
        onPressed: () {
          _exibirTelaCadastro();
        },
        label: Row(
          children: [
            Icon(
              Icons.add,
            ),
            SizedBox(width: 10),
            Text('Adicionar anotação')
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
