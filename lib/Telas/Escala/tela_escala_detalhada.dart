import 'package:flutter/material.dart';
import 'package:senturionglist/Modelo/locais_trabalho_cooperadores.dart';
import 'package:senturionglist/Uteis/BancoDados/banco_dados.dart';
import 'package:senturionglist/Uteis/PDF/GerarPDF.dart';
import 'package:senturionglist/Uteis/constantes.dart';
import 'package:senturionglist/Uteis/estilo.dart';
import 'package:senturionglist/Uteis/metodos_auxiliares.dart';
import 'package:senturionglist/Uteis/paleta_cores.dart';
import 'package:senturionglist/Uteis/textos.dart';
import 'package:senturionglist/Widgets/barra_navegacao.dart';
import 'package:senturionglist/Widgets/tela_carregamento.dart';
import 'package:intl/intl.dart';

class TelaEscalaDetalhada extends StatefulWidget {
  const TelaEscalaDetalhada({super.key, required this.nomeEscalaSelecionada});

  final String nomeEscalaSelecionada;

  @override
  State<TelaEscalaDetalhada> createState() => _TelaEscalaDetalhadaState();
}

class _TelaEscalaDetalhadaState extends State<TelaEscalaDetalhada> {
  Color corFundoTela = PaletaCores.corAzulEscuro;
  Estilo estilo = Estilo();
  TextEditingController nomeEscala = TextEditingController(text: "");
  BancoDados bancoDados = BancoDados();
  bool exibirTelaCarregamento = true;
  List<LocaisTrabalhoCooperadores> escalaDetalhada = [];
  bool exibirOcultarCampoRecolherOferta = false;
  bool exibirOcultarCampoIrmaoReserva = false;
  bool exibirOcultarCampoMesaApoio = false;
  bool exibirOcultarServirSantaCeia = false;

  @override
  void initState() {
    super.initState();
    recuperarEscalas();
  }

  // metodo para consultar banco de dados
  // e pegar itens
  recuperarEscalas() async {
    await bancoDados.recuperarDadosLista(widget.nomeEscalaSelecionada).then(
      (value) {
        if (value.isNotEmpty) {
          setState(() {
            escalaDetalhada = value;
            escalaDetalhada.sort((a, b) =>
                DateFormat("dd/MM/yyyy EEEE", "pt_BR").parse(a.data).compareTo(
                    DateFormat("dd/MM/yyyy EEEE", "pt_BR").parse(b.data)));
            exibirTelaCarregamento = false;
            chamarVerificarColunaVazia(); //chamando metodo para
            // verificar se as colunas nao contem dados varios em suas linhas
            // caso tiver ocultar o campo
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
    Navigator.popAndPushNamed(context, Constantes.rotaTelaSelecaoListaEscala);
  }

  redirecionarTelaEditarItem(LocaisTrabalhoCooperadores trabalhoCooperadores) {
    Map dados = {};
    dados[Constantes.parametroNomeEscala] = widget.nomeEscalaSelecionada;
    dados[Constantes.parametroDadosItem] = trabalhoCooperadores;
    Navigator.pushReplacementNamed(context, Constantes.rotaTelaEditarItem,
        arguments: dados);
  }

  // metodo para chamar metodo para verificar
  // se a coluna esta vazia
  chamarVerificarColunaVazia() {
    for (var element in escalaDetalhada) {
      if (element.mesaApoio != "") {
        exibirOcultarCampoMesaApoio = true;
        break;
      } else {
        exibirOcultarCampoMesaApoio = false;
      }
    }
    for (var element in escalaDetalhada) {
      if (element.irmaoReserva != "") {
        exibirOcultarCampoIrmaoReserva = true;
        break;
      } else {
        exibirOcultarCampoIrmaoReserva = false;
      }
    }
    for (var element in escalaDetalhada) {
      if (element.recolherOferta != "") {
        exibirOcultarCampoRecolherOferta = true;
        break;
      } else {
        exibirOcultarCampoRecolherOferta = false;
      }
    }
    for (var element in escalaDetalhada) {
      if (element.servirSantaCeia != "") {
        exibirOcultarServirSantaCeia = true;
        break;
      } else {
        exibirOcultarServirSantaCeia = false;
      }
    }
  }

  // metodo para verificar se a coluna
  // contem algum valor em uma de suas linhas
  verificarColunaVazia(String valor) {
    if (valor.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> alertaExclusao(BuildContext context,
      LocaisTrabalhoCooperadores locaisTrabalhoCooperadores) async {
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
                      locaisTrabalhoCooperadores.data.toString(),
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
                chamarDeletar(locaisTrabalhoCooperadores);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  chamarDeletar(LocaisTrabalhoCooperadores trabalhoCooperadores) async {
    bool retorno = await bancoDados.excluirDado(
        trabalhoCooperadores.id, widget.nomeEscalaSelecionada);
    chamarExibirMensagem(retorno, Textos.sucessoExcluirItemBancoDados,
        Textos.erroExcluirItemBancoDados);
    recarregarTela();
  }

  recarregarTela() {
    Navigator.pushReplacementNamed(context, Constantes.rotaTelaEscalaDetalhada,
        arguments: widget.nomeEscalaSelecionada);
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

  // metodo para chamar a geracao do arquivo em pdf
  // e permitir o usuario baixar o arquivo
  chamarGerarArquivoPDF() {
    GerarPDF gerarPDF = GerarPDF(
        listaEscala: escalaDetalhada,
        nomeEscala: widget.nomeEscalaSelecionada,
        exibirMesaApoio: exibirOcultarCampoMesaApoio,
        exibirRecolherOferta: exibirOcultarCampoRecolherOferta,
        exibirIrmaoReserva: exibirOcultarCampoIrmaoReserva,
        exibirServirSantaCeia: exibirOcultarServirSantaCeia);
    gerarPDF.pegarDados();
  }

  Widget botoes(IconData iconData, double tamanho,
          LocaisTrabalhoCooperadores trabalhoCooperadores) =>
      SizedBox(
          width: tamanho,
          height: tamanho,
          child: FloatingActionButton(
            heroTag: trabalhoCooperadores.data.toString(),
            backgroundColor: Colors.white,
            onPressed: () {
              if (iconData == Constantes.iconeExclusao) {
                alertaExclusao(context, trabalhoCooperadores);
              } else {
                redirecionarTelaEditarItem(trabalhoCooperadores);
              }
            },
            child: Icon(iconData,
                size: tamanho - 10, color: PaletaCores.corAzulEscuro),
          ));

  Widget botoesAcoes(String nomeBtn) => Container(
        margin: const EdgeInsets.all(10),
        width: 120,
        height: 50,
        child: ElevatedButton(
          child: Text(nomeBtn,
              textAlign: TextAlign.center,
              style: TextStyle(color: corFundoTela)),
          onPressed: () {
            if (nomeBtn == Textos.btnDownloadEscala) {
              chamarGerarArquivoPDF();
            } else {
              Map dados = {};
              dados[Constantes.parametroNomeEscala] =
                  widget.nomeEscalaSelecionada;
              dados[Constantes.parametroExibirCampos] =
                  !exibirOcultarCampoMesaApoio;
              Navigator.pushReplacementNamed(
                  context, Constantes.rotaTelaCadastrarItem,
                  arguments: dados);
            }
          },
        ),
      );

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
                    child: Text(Textos.tituloTelaEscalaDetalhada),
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
                                  if (escalaDetalhada.isNotEmpty) {
                                    return SizedBox(
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
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10.0),
                                                    child: Text(
                                                      "${Textos.descricaoEscalaSelecionada}${widget.nomeEscalaSelecionada}",
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Container(
                                                margin:
                                                    const EdgeInsets.all(10),
                                                child: Text(
                                                    Textos
                                                        .descricaoTelaEscalaDetalhada,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        fontSize: 20)),
                                              ),
                                              SizedBox(
                                                  width: larguraTela,
                                                  height: alturaTela * 0.7,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      SizedBox(
                                                        width: larguraTela,
                                                        height:
                                                            alturaTela * 0.6,
                                                        child: ListView(
                                                          children: [
                                                            SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              child: DataTable(
                                                                columns: [
                                                                  DataColumn(
                                                                      label: Text(
                                                                          Textos
                                                                              .labelData,
                                                                          textAlign:
                                                                              TextAlign.center)),
                                                                  DataColumn(
                                                                    label: Text(
                                                                        Textos
                                                                            .labelHorarioTroca,
                                                                        textAlign:
                                                                            TextAlign.center),
                                                                  ),
                                                                  DataColumn(
                                                                      label:
                                                                          Visibility(
                                                                    visible:
                                                                        !exibirOcultarCampoMesaApoio,
                                                                    child: Text(
                                                                        Textos
                                                                            .labelPrimeiroHoraPulpito,
                                                                        textAlign:
                                                                            TextAlign.center),
                                                                  )),
                                                                  DataColumn(
                                                                      label:
                                                                          Visibility(
                                                                    visible:
                                                                        !exibirOcultarCampoMesaApoio,
                                                                    child: Text(
                                                                        Textos
                                                                            .labelSegundoHoraPulpito,
                                                                        textAlign:
                                                                            TextAlign.center),
                                                                  )),
                                                                  DataColumn(
                                                                      label: Text(
                                                                          Textos
                                                                              .labelPrimeiroHoraEntrada,
                                                                          textAlign:
                                                                              TextAlign.center)),
                                                                  DataColumn(
                                                                    label: Text(
                                                                        Textos
                                                                            .labelSegundoHoraEntrada,
                                                                        textAlign:
                                                                            TextAlign.center),
                                                                  ),
                                                                  DataColumn(
                                                                      label:
                                                                          Visibility(
                                                                    visible:
                                                                        exibirOcultarCampoMesaApoio,
                                                                    child: Text(
                                                                        Textos
                                                                            .labelMesaApoio,
                                                                        textAlign:
                                                                            TextAlign.center),
                                                                  )),
                                                                  DataColumn(
                                                                    label: Text(
                                                                        Textos
                                                                            .labelUniforme,
                                                                        textAlign:
                                                                            TextAlign.center),
                                                                  ),
                                                                  DataColumn(
                                                                      label:
                                                                          Visibility(
                                                                    visible:
                                                                        exibirOcultarCampoRecolherOferta,
                                                                    child: Text(
                                                                        Textos
                                                                            .labelRecolherOferta,
                                                                        textAlign:
                                                                            TextAlign.center),
                                                                  )),
                                                                  DataColumn(
                                                                      label:
                                                                          Visibility(
                                                                    visible:
                                                                        exibirOcultarServirSantaCeia,
                                                                    child: Text(
                                                                        Textos
                                                                            .labelServirSantaCeia,
                                                                        textAlign:
                                                                            TextAlign.center),
                                                                  )),
                                                                  DataColumn(
                                                                      label:
                                                                          Visibility(
                                                                    visible:
                                                                        exibirOcultarCampoIrmaoReserva,
                                                                    child: Text(
                                                                        Textos
                                                                            .labelIrmaoReserva,
                                                                        textAlign:
                                                                            TextAlign.center),
                                                                  )),
                                                                  DataColumn(
                                                                    label: Text(
                                                                        Textos
                                                                            .labelEditar,
                                                                        textAlign:
                                                                            TextAlign.center),
                                                                  ),
                                                                  DataColumn(
                                                                    label: Text(
                                                                        Textos
                                                                            .labelExcluir,
                                                                        textAlign:
                                                                            TextAlign.center),
                                                                  ),
                                                                ],
                                                                rows:
                                                                    escalaDetalhada
                                                                        .map(
                                                                          (item) =>
                                                                              DataRow(cells: [
                                                                            DataCell(SizedBox(
                                                                                width: 90,
                                                                                //SET width
                                                                                child: SingleChildScrollView(
                                                                                  child: Text(item.data, textAlign: TextAlign.center),
                                                                                ))),
                                                                            DataCell(Container(
                                                                                alignment: Alignment.center,
                                                                                width: 150,
                                                                                //SET width
                                                                                child: SingleChildScrollView(
                                                                                  child: Text(item.horarioTroca, textAlign: TextAlign.center),
                                                                                ))),
                                                                            DataCell(Visibility(
                                                                              visible: !exibirOcultarCampoMesaApoio,
                                                                              child: SizedBox(
                                                                                  width: 90,
                                                                                  //SET width
                                                                                  child: Text(item.primeiroHorarioPulpito, textAlign: TextAlign.center)),
                                                                            )),
                                                                            DataCell(Visibility(
                                                                              visible: !exibirOcultarCampoMesaApoio,
                                                                              child: SizedBox(
                                                                                  width: 90,
                                                                                  //SET width
                                                                                  child: Text(item.segundoHorarioPulpito, textAlign: TextAlign.center)),
                                                                            )),
                                                                            DataCell(SizedBox(
                                                                                width: 90,
                                                                                //SET width
                                                                                child: Text(item.primeiroHorarioEntrada, textAlign: TextAlign.center))),
                                                                            DataCell(SizedBox(
                                                                                width: 90,
                                                                                //SET width
                                                                                child: Text(item.segundoHorarioEntrada, textAlign: TextAlign.center))),
                                                                            DataCell(Visibility(
                                                                              visible: exibirOcultarCampoMesaApoio,
                                                                              child: SizedBox(
                                                                                  width: 90,
                                                                                  //SET width
                                                                                  child: Text(item.mesaApoio, textAlign: TextAlign.center)),
                                                                            )),
                                                                            DataCell(SizedBox(
                                                                                width: 150,
                                                                                //SET width
                                                                                child: SingleChildScrollView(
                                                                                  child: Text(item.uniforme, textAlign: TextAlign.center),
                                                                                ))),
                                                                            DataCell(Visibility(
                                                                              visible: exibirOcultarCampoRecolherOferta,
                                                                              child: SizedBox(
                                                                                  width: 90,
                                                                                  //SET width
                                                                                  child: Text(item.recolherOferta, textAlign: TextAlign.center)),
                                                                            )),
                                                                            DataCell(Visibility(
                                                                              visible: exibirOcultarServirSantaCeia,
                                                                              child: SizedBox(
                                                                                  width: 90,
                                                                                  //SET width
                                                                                  child: Text(item.servirSantaCeia, textAlign: TextAlign.center)),
                                                                            )),
                                                                            DataCell(Visibility(
                                                                              visible: exibirOcultarCampoIrmaoReserva,
                                                                              child: SizedBox(
                                                                                  width: 90,
                                                                                  //SET width
                                                                                  child: Text(item.irmaoReserva, textAlign: TextAlign.center)),
                                                                            )),
                                                                            DataCell(botoes(
                                                                                Constantes.iconeEditar,
                                                                                40,
                                                                                item)),
                                                                            DataCell(botoes(
                                                                                Constantes.iconeExclusao,
                                                                                40,
                                                                                item)),
                                                                          ]),
                                                                        )
                                                                        .toList(),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          botoesAcoes(Textos
                                                              .btnAdicionarItem),
                                                          botoesAcoes(Textos
                                                              .btnDownloadEscala)
                                                        ],
                                                      )
                                                    ],
                                                  ))
                                            ],
                                          ),
                                        ));
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
                        nomeRotaTela: Constantes.rotaTelaEscalaDetalhada),
                  )),
            ),
          ),
        ));
  }
}
