import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:senturionglist/Modelo/locais_trabalho_cooperadores.dart';
import 'package:senturionglist/Uteis/BancoDados/banco_dados.dart';
import 'package:senturionglist/Uteis/constantes.dart';
import 'package:senturionglist/Uteis/estilo.dart';
import 'package:senturionglist/Uteis/metodos_auxiliares.dart';
import 'package:senturionglist/Uteis/paleta_cores.dart';
import 'package:senturionglist/Uteis/textos.dart';
import 'package:senturionglist/Widgets/barra_navegacao.dart';
import 'package:senturionglist/Widgets/tela_carregamento.dart';

class TelaGerarEscala extends StatefulWidget {
  const TelaGerarEscala({super.key});

  @override
  State<TelaGerarEscala> createState() => _TelaGerarEscalaState();
}

class _TelaGerarEscalaState extends State<TelaGerarEscala> {
  Color corFundoTela = PaletaCores.corAzulEscuro;
  Estilo estilo = Estilo();
  TextEditingController nomeEscala = TextEditingController(text: "");
  BancoDados bancoDados = BancoDados();
  bool exibirTelaCarregamento = false;
  int quantiLocaisDiponivel = 0;
  final _formKeyFormulario = GlobalKey<FormState>();

  // cooperador 5 locais de trabalho irmao reserva e servir ceia manual
  // cooperadora 4 locais de trabalho irmao reserva e servir ceia manual
  Random random = Random();
  List<int> listaNumeroAuxiliarRepeticao = [];
  List<LocaisTrabalhoCooperadores> escalaSorteada = [];
  List<String> listaNomePessoas = [];
  List<String> locaisSorteioCooperadores = [
    Constantes.primeiraHoraPulpito,
    Constantes.segundaHoraPulpito,
    Constantes.primeiraHoraEntrada,
    Constantes.segundaHoraEntrada,
    Constantes.mesaApoio,
    Constantes.recolherOferta,
  ];

  String horarioSemana = "";
  String horarioFinalSemana = "";

  @override
  void initState() {
    super.initState();
    if (BarraNavegacao.tipoCadastro != Constantes.tipoCadastroCooperador) {
      locaisSorteioCooperadores.removeWhere((element) =>
          element.contains(
            Constantes.primeiraHoraPulpito,
          ) ||
          element.contains(
            Constantes.segundaHoraPulpito,
          ));
    } else {
      locaisSorteioCooperadores.removeWhere((element) => element.contains(
            Constantes.mesaApoio,
          ));
    }
    for (var element in BarraNavegacao.itensPessoasSelecionadas) {
      listaNomePessoas.add(element.texto);
    }
   recupararHorarioTroca();
  }

  recupararHorarioTroca() async {
    horarioSemana = await MetodosAuxiliares.recuperarValoresSharePreferences(Constantes.diaSegunda);
    horarioFinalSemana = await MetodosAuxiliares.recuperarValoresSharePreferences(Constantes.diaDomingo);
  }

  chamarCriarTabela() async {
    bool retorno = await bancoDados.criarTabela(
        Constantes.sqlLocaisTrabalhoCooperadores, nomeEscala.text);
    chamarExibirMensagem(retorno);
  }

  //metodo para retornar mesagem ao usuario
  chamarExibirMensagem(bool valor) {
    if (valor) {
      MetodosAuxiliares.exibirMensagens(Textos.sucessoCriarEscalaBancoDados,
          Textos.tipoAlertaSucesso, context);
      fazerSorteio();
    } else {
      MetodosAuxiliares.exibirMensagens(
          Textos.erroCriarEscalaBancoDados, Textos.tipoAlertaErro, context);
    }
  }

  fazerSorteio() {
    setState(() {
      exibirTelaCarregamento = true;
    });
    escalaSorteada.clear();
    listaNumeroAuxiliarRepeticao.clear();
    var linha = {};
    int numeroRandomico = 0;
    sortearNomesSemRepeticao(numeroRandomico);
    for (var elemento in BarraNavegacao.itensPeriodoTrabalho) {
      for (int index = 0; index < locaisSorteioCooperadores.length; index++) {
        linha[locaisSorteioCooperadores.elementAt(index)] = listaNomePessoas
            .elementAt(listaNumeroAuxiliarRepeticao.elementAt(index));
      }
      String horarioTroca = "";
      if(elemento.contains(Constantes.diaDomingo) || elemento.contains(Constantes.diaSabado)){
        horarioTroca = horarioFinalSemana;
      }else{
        horarioTroca = horarioSemana;
      }
      escalaSorteada.add(LocaisTrabalhoCooperadores(
          data: elemento,
          primeiroHorarioPulpito:
              BarraNavegacao.tipoCadastro == Constantes.tipoCadastroCooperador
                  ? linha[Constantes.primeiraHoraPulpito]
                  : "",
          segundoHorarioPulpito:
              BarraNavegacao.tipoCadastro == Constantes.tipoCadastroCooperador
                  ? linha[Constantes.segundaHoraPulpito]
                  : "",
          primeiroHorarioEntrada: linha[Constantes.primeiraHoraEntrada],
          segundoHorarioEntrada: linha[Constantes.segundaHoraEntrada],
          recolherOferta: linha[Constantes.recolherOferta],
          mesaApoio:
              BarraNavegacao.tipoCadastro == Constantes.tipoCadastroCooperador
                  ? ""
                  : linha[Constantes.mesaApoio],
          uniforme: "",
          horarioTroca: horarioTroca,
          servirSantaCeia: "",
          irmaoReserva: ""));
      sortearNomesSemRepeticao(numeroRandomico);
    }
    chamarInserirDados();
  }

  chamarInserirDados() {
    for (var elementos in escalaSorteada) {
      bancoDados.inserirDadosEscalaCooperadores(nomeEscala.text, elementos);
    }
    Timer(const Duration(seconds: 6), () {
      //removendo todas as telas anteriormente abertas
      Navigator.pop(context, Constantes.rotaTelaCadastroNomeCooperadores);
      Navigator.pop(context, Constantes.rotaTelaSelecaoDiasSemana);
      Navigator.pop(context, Constantes.rotaTelaSelecaoPeriodoTrabalho);
      Navigator.pop(context, Constantes.rotaTelaTrabalhoDiaEspecifico);
      BarraNavegacao.itensPessoasSelecionadas.clear();
      BarraNavegacao.itensDiasSemanaSelecionados.clear();
      BarraNavegacao.itensPeriodoTrabalho;
      BarraNavegacao.itensDatasEspecificas;
      BarraNavegacao.itensPessoasEspecificas.clear();
      BarraNavegacao.listaPessoasTrabalhoConvertido.clear();
      BarraNavegacao.listaPeriodoTrabalhoConvertido.clear();
      BarraNavegacao.tipoCadastro = "";
      Navigator.popAndPushNamed(context, Constantes.rotaTelaSelecaoListaEscala);
    });
  }

  // metodo para chamar o sorteio de nomes sem repecitcao
  sortearNomesSemRepeticao(int numeroRandomico) {
    listaNumeroAuxiliarRepeticao.clear(); //limpando lista
    for (var element in locaisSorteioCooperadores) {
      // para cada interacao sortear um numero entre 0 e o
      // tamanho da lista de pessoas
      numeroRandomico = random.nextInt(listaNomePessoas.length);
      sortearNumeroSemRepeticao(numeroRandomico); //chamando metodo
    }
  }

  // metodo para sortear numero sem repeticao
  sortearNumeroSemRepeticao(int numeroRandomico) {
    //caso a lista nao contenha o numero randomico entrar no if
    if (!listaNumeroAuxiliarRepeticao.contains(numeroRandomico)) {
      listaNumeroAuxiliarRepeticao.add(numeroRandomico);
      return numeroRandomico;
    } else {
      // sorteando outro numero pois o numero
      // sorteado anteriormente ja esta na lista
      numeroRandomico = random.nextInt(listaNomePessoas.length);
      sortearNumeroSemRepeticao(numeroRandomico);
    }
  }

  redirecionarTelaAnterior() {
    MetodosAuxiliares.limparSelecaoDiasTrabalhoEspecifico(); //chamando metodo
    Navigator.pop(context);
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
                    child: Text(Textos.tituloTelaGerarEscala),
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
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10.0),
                                                    child: Text(
                                                      "${Textos.descricaoTipoCadastro}${BarraNavegacao.tipoCadastro}",
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
                                                        .descricaoTelaGerarEscala,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        fontSize: 20)),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                      width: MetodosAuxiliares
                                                          .definirTamanhoTextField(
                                                              larguraTela),
                                                      child: Form(
                                                        key: _formKeyFormulario,
                                                        child: TextFormField(
                                                          validator: (value) {
                                                            if (value!
                                                                .isEmpty) {
                                                              return Textos
                                                                  .erroPreenchaCampo;
                                                            }
                                                            return null;
                                                          },
                                                          controller:
                                                              nomeEscala,
                                                          decoration: InputDecoration(
                                                              label: Text(Textos
                                                                  .labelCampoCadastro)),
                                                        ),
                                                      )),
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 10.0),
                                                width: 120,
                                                height: 50,
                                                child: ElevatedButton(
                                                  child: Text(
                                                      Textos.btnGerarEscala,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: corFundoTela)),
                                                  onPressed: () {
                                                    if (_formKeyFormulario
                                                        .currentState!
                                                        .validate()) {
                                                      chamarCriarTabela(); // chamar metodo
                                                    }
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                        )))
                              ],
                            ),
                          );
                        }
                      },
                    )),
              ),
              bottomNavigationBar: SizedBox(
                width: larguraTela,
                height: alturaTela * 0.1,
                child: const BarraNavegacao(
                    nomeRotaTela: Constantes.rotaTelaGerarEscala),
              ),
            ),
          ),
        ));
  }
}
