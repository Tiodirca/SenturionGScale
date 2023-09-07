import 'package:flutter/material.dart';
import 'package:senturionglist/Modelo/checkbox.dart';
import 'package:senturionglist/Uteis/BancoDados/banco_dados.dart';
import 'package:senturionglist/Uteis/constantes.dart';
import 'package:senturionglist/Uteis/estilo.dart';
import 'package:senturionglist/Uteis/metodos_auxiliares.dart';
import 'package:senturionglist/Uteis/paleta_cores.dart';
import 'package:senturionglist/Uteis/textos.dart';
import 'package:senturionglist/Widgets/barra_navegacao.dart';

class TelaCadastroNomeCooperadores extends StatefulWidget {
  const TelaCadastroNomeCooperadores({super.key, required this.tipoCadastro});

  final String tipoCadastro;

  @override
  State<TelaCadastroNomeCooperadores> createState() => _TelaCadastroNomeCooperadoresState();
}

class _TelaCadastroNomeCooperadoresState extends State<TelaCadastroNomeCooperadores> {
  Color corFundoTela = PaletaCores.corAzulEscuro;
  Estilo estilo = Estilo();
  List<CheckBoxModel> listaItensPessoas = [];
  TextEditingController nomePessoa = TextEditingController(text: "");
  BancoDados bancoDados = BancoDados();
  String nomeTabela = "";
  final _formKeyFormulario = GlobalKey<FormState>();

  verificarTipoCadastro() {
    if (widget.tipoCadastro == Constantes.tipoCadastroCooperador) {
      return Text(Textos.telaCadastroCooperadores);
    } else {
      return Text(Textos.telaCadastroCooperadoras);
    }
  }

  recuperarNomePessoas() async {
    String nomeTabela = "";
    if (widget.tipoCadastro == Constantes.tipoCadastroCooperador) {
      nomeTabela = Constantes.tipoCadastroCooperador;
    } else {
      nomeTabela = Constantes.tipoCadastroCooperadora;
    }
    BarraNavegacao.tipoCadastro = nomeTabela;
    await bancoDados.recuperarNomeCooperadores(nomeTabela).then(
      (value) {
        setState(() {
          listaItensPessoas = value;
        });
      },
    );
    //limpando valor
    nomePessoa.clear();
  }

  @override
  void initState() {
    super.initState();
    recuperarNomePessoas();
    if (widget.tipoCadastro == Constantes.tipoCadastroCooperador) {
      nomeTabela = Constantes.tipoCadastroCooperador;
    } else {
      nomeTabela = Constantes.tipoCadastroCooperadora;
    }
  }

  Widget checkBoxPersonalizado(CheckBoxModel checkBoxModel) => CheckboxListTile(
        activeColor: PaletaCores.corAzulEscuro,
        checkColor: PaletaCores.corRosaClaro,
        secondary: Theme(
          data: estilo.estiloGeral,
          child: SizedBox(
              width: 30,
              height: 30,
              child: FloatingActionButton(
                heroTag: "btnExcluirPessoa${checkBoxModel.idItem}",
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.close, size: 20),
                onPressed: () {
                  alertaExclusao(checkBoxModel, context);
                },
              )),
        ),
        title: Text(checkBoxModel.texto, style: const TextStyle(fontSize: 20)),
        value: checkBoxModel.checked,
        side: const BorderSide(width: 2, color: PaletaCores.corAzulEscuro),
        onChanged: (value) {
          setState(() {
            // verificando se o balor
            checkBoxModel.checked = value!;
            verificarItensSelecionados();
          });
        },
      );

  verificarItensSelecionados() {
    //verificando cada elemento da lista
    for (var element in listaItensPessoas) {
      //verificando se o item foi selecionado pelo usuario
      if (element.checked == true) {
        //verificando se na lista de pessoas selecionadas NAO contem o item
        // da lista desta tela caso nao contem adiciona o item na lista da barra de navegacao
        if (!BarraNavegacao.itensPessoasSelecionadas.contains(element)) {
          BarraNavegacao.itensPessoasSelecionadas.add(element);
        }
      } else if (element.checked == false) {
        // caso seja desmarcado pelo usuario remover
        // item da lista da barra de navegacao
        BarraNavegacao.itensPessoasSelecionadas.remove(element);
      }
    }
  }

  redirecionarTela() {
    BarraNavegacao.itensPessoasSelecionadas.clear();
    BarraNavegacao.tipoCadastro = "";
    Navigator.popAndPushNamed(context, Constantes.rotaTelaInicial);
  }

  // metodo para inserir valor no banco de dados
  chamarInserirNome() async {
    bool retorno =
        await bancoDados.inserirNomeCooperadores(nomePessoa.text, nomeTabela);
    chamarExibirMensagem(
        retorno, Textos.sucessoInserirBancoDados, Textos.erroInserirBancoDados);
  }

  //metodo para retornar mesagem ao usuario
  chamarExibirMensagem(bool valor, String msgSucesso, String msgErro) {
    if (valor) {
      MetodosAuxiliares.exibirMensagens(
          msgSucesso, Textos.tipoAlertaSucesso, context);
    } else {
      MetodosAuxiliares.exibirMensagens(
          msgErro, Textos.tipoAlertaErro, context);
    }
  }

  Future<void> alertaExclusao(
      CheckBoxModel boxModel, BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            Textos.tituloAlerta,
            style: const TextStyle(color: Colors.black),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  Textos.descricaoAlerta,
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(
                  height: 10,
                ),
                Wrap(
                  children: [
                    Text(
                      boxModel.texto,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Não',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Sim',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                chamarDeletar(boxModel.idItem);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  chamarDeletar(int id) async {
    print(nomeTabela);
    bool retorno = await bancoDados.excluirDado(id, nomeTabela);
    chamarExibirMensagem(retorno, Textos.sucessoExcluirItemBancoDados,
        Textos.erroExcluirItemBancoDados);
    setState(() {
      BarraNavegacao.itensPessoasSelecionadas.clear();
      listaItensPessoas.clear();
      recuperarNomePessoas();
    });
  }

  @override
  Widget build(BuildContext context) {
    double larguraTela = MediaQuery.of(context).size.width;
    double alturaTela = MediaQuery.of(context).size.height;
    return Theme(
        data: estilo.estiloGeral,
        child: WillPopScope(
          onWillPop: () async {
            redirecionarTela();
            return false;
          },
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Scaffold(
              appBar: AppBar(
                  elevation: 0,
                  title: verificarTipoCadastro(),
                  leading: IconButton(
                    onPressed: () {
                      redirecionarTela();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: corFundoTela,
                    ),
                  )),
              backgroundColor: corFundoTela,
              body: SizedBox(
                width: larguraTela,
                height: alturaTela,
                child: Card(
                  elevation: 0,
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: SizedBox(
                    width: larguraTela,
                    height: alturaTela,
                    child: Column(
                      children: [
                        Expanded(
                            flex: 1,
                            child: SizedBox(
                                width: larguraTela,
                                height: alturaTela,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: Text(
                                              "${Textos.descricaoTipoCadastro}${widget.tipoCadastro}",
                                              style: const TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Container(
                                        margin: const EdgeInsets.all(10),
                                        child: Text(
                                            Textos.descricaoTelaCadastro,
                                            textAlign: TextAlign.center,
                                            style:
                                                const TextStyle(fontSize: 20)),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              height: 80,
                                              width: MetodosAuxiliares
                                                  .definirTamanhoTextField(
                                                      larguraTela),
                                              child: Form(
                                                key: _formKeyFormulario,
                                                child: TextFormField(
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return Textos
                                                          .erroPreenchaCampo;
                                                    }
                                                    return null;
                                                  },
                                                  controller: nomePessoa,
                                                  decoration: InputDecoration(
                                                      label: Text(Textos
                                                          .labelCampoCadastro)),
                                                ),
                                              )),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 10.0, bottom: 25.0),
                                            width: 120,
                                            height: 50,
                                            child: ElevatedButton(
                                              child: Text(Textos.btnCadastrar,
                                                  style: TextStyle(
                                                      color: corFundoTela)),
                                              onPressed: () {
                                                if (_formKeyFormulario
                                                    .currentState!
                                                    .validate()) {
                                                  chamarInserirNome();
                                                  recuperarNomePessoas();
                                                }
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ))),
                        Expanded(
                            flex: 3,
                            child: SizedBox(
                                width: larguraTela,
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(10),
                                        child: Text(
                                            Textos
                                                .descricaoTelaCadastroListagem,
                                            textAlign: TextAlign.center,
                                            style:
                                                const TextStyle(fontSize: 20)),
                                      ),
                                      SizedBox(
                                          height: alturaTela * 0.5,
                                          width: larguraTela,
                                          child: LayoutBuilder(
                                            builder: (context, constraints) {
                                              if (listaItensPessoas.isEmpty) {
                                                return SizedBox(
                                                  width: larguraTela,
                                                  height: alturaTela,
                                                  child: Center(
                                                    child: Text(
                                                      Textos
                                                          .semDadosNoBancoDados,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: PaletaCores
                                                              .corAzulEscuro),
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                return ListView(
                                                  children: [
                                                    ...listaItensPessoas
                                                        .map((e) =>
                                                            checkBoxPersonalizado(
                                                              e,
                                                            ))
                                                        .toList()
                                                  ],
                                                );
                                              }
                                            },
                                          )),
                                    ],
                                  ),
                                )))
                      ],
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: SizedBox(
                width: larguraTela,
                height: alturaTela * 0.1,
                child: const BarraNavegacao(
                    nomeRotaTela: Constantes.rotaTelaCadastroNomeCooperadores),
              ),
            ),
          ),
        ));
  }
}
