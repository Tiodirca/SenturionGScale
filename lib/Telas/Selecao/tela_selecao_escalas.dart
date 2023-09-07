import 'package:flutter/material.dart';
import 'package:senturionglist/Uteis/BancoDados/banco_dados.dart';
import 'package:senturionglist/Uteis/constantes.dart';
import 'package:senturionglist/Uteis/estilo.dart';
import 'package:senturionglist/Uteis/metodos_auxiliares.dart';
import 'package:senturionglist/Uteis/paleta_cores.dart';
import 'package:senturionglist/Uteis/textos.dart';
import 'package:senturionglist/Widgets/barra_navegacao.dart';
import 'package:senturionglist/Widgets/tela_carregamento.dart';

class TelaSelecaoEscalas extends StatefulWidget {
  const TelaSelecaoEscalas({super.key});

  @override
  State<TelaSelecaoEscalas> createState() => _TelaSelecaoEscalasState();
}

class _TelaSelecaoEscalasState extends State<TelaSelecaoEscalas> {
  Color corFundoTela = PaletaCores.corAzulEscuro;
  Estilo estilo = Estilo();
  TextEditingController nomeEscala = TextEditingController(text: "");
  BancoDados bancoDados = BancoDados();
  bool exibirTelaCarregamento = true;
  List<String> listaEscalas = [];
  String nomeItemDrop = "";
  String nomeTabelaSelecionada = "";
  bool exibirConfirmacaoTabelaSelecionada = false;

  @override
  void initState() {
    super.initState();
    recuperarEscalas();
  }

  recuperarEscalas() {
    bancoDados.recuperarEscalas().then(
      (value) {
        if (value.isNotEmpty) {
          setState(() {
            listaEscalas = value;
            exibirTelaCarregamento = false;
            nomeItemDrop = value.first;
          });
        } else {
          setState(() {
            exibirTelaCarregamento = false;
          });
        }
      },
    );
  }

  redirecionarTelaAnterior() {
    Navigator.popAndPushNamed(context, Constantes.rotaTelaInicial);
  }

  Future<void> alertaExclusao(BuildContext context) async {
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
                      nomeTabelaSelecionada,
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
                chamarDeletar();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  chamarDeletar() async {
    bool retorno = await bancoDados.excluirTabela(nomeTabelaSelecionada);
    chamarExibirMensagem(retorno, Textos.sucessoExcluirItemBancoDados,
        Textos.erroExcluirItemBancoDados);
    recarregarTela();
  }

  recarregarTela() {
    Navigator.pushReplacementNamed(
        context, Constantes.rotaTelaSelecaoListaEscala);
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

  @override
  Widget build(BuildContext context) {
    double larguraTela = MediaQuery.of(context).size.width;
    double alturaTela = MediaQuery.of(context).size.height;
    return Theme(
        data: estilo.estiloGeral,
        child: WillPopScope(
          onWillPop: () async {
            redirecionarTelaAnterior();
            return false;
          },
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Scaffold(
              appBar: AppBar(
                  elevation: 0,
                  title: Visibility(
                    visible: !exibirTelaCarregamento,
                    child: Text(Textos.tituloTelaSelecaoEscalas),
                  ),
                  leading: Visibility(
                    visible: !exibirTelaCarregamento,
                    child: IconButton(
                      onPressed: () {
                        redirecionarTelaAnterior();
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: corFundoTela,
                      ),
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
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        if (exibirTelaCarregamento) {
                          return Container(
                              margin: const EdgeInsets.all(20),
                              width: larguraTela,
                              height: alturaTela,
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TelaCarregamento(),
                                ],
                              ));
                        } else {
                          return SizedBox(
                              width: larguraTela,
                              height: alturaTela,
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  if (listaEscalas.isNotEmpty) {
                                    return Column(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: SizedBox(
                                                width: larguraTela,
                                                height: alturaTela,
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .all(10),
                                                        child: Text(
                                                            Textos
                                                                .descricaoTelaSelecaoEscala,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        20)),
                                                      ),
                                                      DropdownButton(
                                                        value: nomeItemDrop,
                                                        icon: const Icon(
                                                          Icons
                                                              .keyboard_arrow_down,
                                                          size: 40,
                                                          color: Colors.black,
                                                        ),
                                                        items: listaEscalas
                                                            .map((item) =>
                                                                DropdownMenuItem<
                                                                    String>(
                                                                  value: item,
                                                                  child: Text(
                                                                    item.toString(),
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            20),
                                                                  ),
                                                                ))
                                                            .toList(),
                                                        onChanged:
                                                            (String? value) {
                                                          setState(() {
                                                            nomeItemDrop =
                                                                value!;
                                                            nomeTabelaSelecionada =
                                                                nomeItemDrop;
                                                            exibirConfirmacaoTabelaSelecionada =
                                                                true;
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ))),
                                        Expanded(
                                            flex: 3,
                                            child: SizedBox(
                                                width: larguraTela,
                                                child: Visibility(
                                                    visible:
                                                        exibirConfirmacaoTabelaSelecionada,
                                                    child: Container(
                                                        margin: const EdgeInsets
                                                            .all(10),
                                                        width: larguraTela,
                                                        child: Column(
                                                          children: [
                                                            Wrap(
                                                              crossAxisAlignment:
                                                                  WrapCrossAlignment
                                                                      .center,
                                                              alignment:
                                                                  WrapAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  Textos
                                                                      .descricaoTelaSelecaoTabelaSelecionada,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          20),
                                                                ),
                                                                Text(
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  nomeTabelaSelecionada,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                Container(
                                                                    margin:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            10),
                                                                    width: 30,
                                                                    height: 30,
                                                                    child:
                                                                        FloatingActionButton(
                                                                      heroTag:
                                                                          "btnExcluir",
                                                                      backgroundColor:
                                                                          Colors
                                                                              .redAccent,
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10)),
                                                                      child: const Icon(
                                                                          Icons
                                                                              .close,
                                                                          size:
                                                                              20),
                                                                      onPressed:
                                                                          () {
                                                                        alertaExclusao(
                                                                            context);
                                                                      },
                                                                    )),
                                                              ],
                                                            ),
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(20),
                                                              width: 150,
                                                              height: 50,
                                                              child:
                                                                  ElevatedButton(
                                                                child: Text(
                                                                  Textos
                                                                      .btnUsarEscala,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: const TextStyle(
                                                                      color: PaletaCores
                                                                          .corAzulEscuro,
                                                                      fontSize:
                                                                          18),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.popAndPushNamed(
                                                                      context,
                                                                      Constantes
                                                                          .rotaTelaEscalaDetalhada,
                                                                      arguments:
                                                                          nomeTabelaSelecionada);
                                                                },
                                                              ),
                                                            )
                                                          ],
                                                        )))))
                                      ],
                                    );
                                  } else {
                                    return SizedBox(
                                      width: larguraTela,
                                      height: alturaTela,
                                      child: Center(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            Textos.semDadosNoBancoDados,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    PaletaCores.corAzulEscuro),
                                          ),
                                          SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: FloatingActionButton(
                                              backgroundColor: Colors.white,
                                              onPressed: () {
                                                recarregarTela();
                                                setState(() {
                                                  exibirTelaCarregamento = true;
                                                });
                                              },
                                              child: const Icon(
                                                  Constantes.iconeRecarregar,
                                                  size: 35,
                                                  color: PaletaCores
                                                      .corAzulEscuro),
                                            ),
                                          )
                                        ],
                                      )),
                                    );
                                  }
                                },
                              ));
                        }
                      },
                    )),
              ),
              bottomNavigationBar: SizedBox(
                  width: larguraTela,
                  height: alturaTela * 0.1,
                  child: Visibility(
                    visible: !exibirTelaCarregamento,
                    child: const BarraNavegacao(
                        nomeRotaTela: Constantes.rotaTelaSelecaoListaEscala),
                  )),
            ),
          ),
        ));
  }
}
