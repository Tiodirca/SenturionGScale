import 'package:flutter/material.dart';
import 'package:senturionglist/Modelo/locais_trabalho_cooperadores.dart';
import 'package:senturionglist/Uteis/BancoDados/banco_dados.dart';
import 'package:senturionglist/Uteis/constantes.dart';
import 'package:senturionglist/Uteis/estilo.dart';
import 'package:senturionglist/Uteis/metodos_auxiliares.dart';
import 'package:senturionglist/Uteis/paleta_cores.dart';
import 'package:senturionglist/Uteis/textos.dart';
import 'package:senturionglist/Widgets/barra_navegacao.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class TelaCadastroItem extends StatefulWidget {
  const TelaCadastroItem({super.key,
    required this.exibirCamposCooperadores,
    required this.nomeEscalaSelecionada});

  final String nomeEscalaSelecionada;
  final bool exibirCamposCooperadores;

  @override
  State<TelaCadastroItem> createState() => _TelaCadastroItemState();
}

class _TelaCadastroItemState extends State<TelaCadastroItem> {
  Color corFundoTela = PaletaCores.corAzulEscuro;
  Estilo estilo = Estilo();
  BancoDados bancoDados = BancoDados();
  final _formKeyFormulario = GlobalKey<FormState>();
  String horarioTroca = "";
  late DateTime dataSelecionada = DateTime.now();
  bool exibirCampoServirSantaCeia = false;
  bool exibirSoCamposCooperadora = false;
  bool exbirCampoIrmaoReserva = false;
  TextEditingController ctPrimeiroHoraPulpito = TextEditingController(text: "");
  TextEditingController ctSegundoHoraPulpito = TextEditingController(text: "");
  TextEditingController ctPrimeiroHoraEntrada = TextEditingController(text: "");
  TextEditingController ctSegundoHoraEntrada = TextEditingController(text: "");
  TextEditingController ctRecolherOferta = TextEditingController(text: "");
  TextEditingController ctUniforme = TextEditingController(text: "");
  TextEditingController ctMesaApoio = TextEditingController(text: "");
  TextEditingController ctServirSantaCeia = TextEditingController(text: "");
  TextEditingController ctIrmaoReserva = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    if (!widget.exibirCamposCooperadores) {
      exibirSoCamposCooperadora = true;
    }
    recuperarHorarioTroca();
  }

  redirecionarTela() {
    Navigator.pushReplacementNamed(context, Constantes.rotaTelaEscalaDetalhada,
        arguments: widget.nomeEscalaSelecionada);
  }

  //metodo para retornar mesagem ao usuario
  chamarExibirMensagem(bool valor, String msgSucesso, String msgErro) {
    if (valor) {
      MetodosAuxiliares.exibirMensagens(
          msgSucesso, Textos.tipoAlertaSucesso, context);
      redirecionarTelaEscalaDetalhada();
    } else {
      MetodosAuxiliares.exibirMensagens(
          msgErro, Textos.tipoAlertaErro, context);
    }
  }

  // metodo para mudar status dos switch
  mudarSwitch(String label, bool valor) {
    if (label == Textos.labelSwitchCooperadora) {
      setState(() {
        exibirSoCamposCooperadora = !valor;
        exibirSoCamposCooperadora = valor;
      });
    } else if (label == Textos.labelSwitchIrmaoReserva) {
      setState(() {
        exbirCampoIrmaoReserva = !valor;
        exbirCampoIrmaoReserva = valor;
      });
    } else if (label == Textos.labelSwitchServirSantaCeia) {
      setState(() {
        exibirCampoServirSantaCeia = !valor;
        exibirCampoServirSantaCeia = valor;
      });
    }
  }

  // metodo para recuperar os horarios definidos
  // e gravados no share preferences
  recuperarHorarioTroca() async {
    String data = formatarData(dataSelecionada).toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // verificando se a data corresponde a um dia do fim de semana
    if (data.contains(Constantes.diaSabado) ||
        data.contains(Constantes.diaDomingo)) {
      setState(() {
        horarioTroca = "${Textos.msgComecoHorarioEscala} "
            "${prefs.getString(Constantes.shareHorarioInicialFSemana) ?? ''}"
            " ${Textos.msgTrocaHorarioEscala} ${prefs.getString(
            Constantes.shareHorarioTrocaFsemana) ?? ''} ";
      });
    } else {
      setState(() {
        horarioTroca = "${Textos.msgComecoHorarioEscala} "
            "${prefs.getString(Constantes.shareHorarioInicialSemana) ?? ''}"
            " ${Textos.msgTrocaHorarioEscala} "
            "${prefs.getString(Constantes.shareHorarioTrocaSemana) ?? ''} ";
      });
    }
  }

  // metodo para formatar a data e exibir
  // ela nos moldes exigidos
  formatarData(DateTime data) {
    String dataFormatada = DateFormat("dd/MM/yyyy EEEE", "pt_BR").format(data);
    if (exibirCampoServirSantaCeia) {
      return dataFormatada = "$dataFormatada ( Santa Ceia )";
    } else {
      return dataFormatada;
    }
  }

  // metodo para exibir data picker para
  // o usuario selecionar uma data
  exibirDataPicker() {
    showDatePicker(
      helpText: Textos.descricaoDataPicker,
      context: context,
      initialDate: dataSelecionada,
      firstDate: DateTime(2001),
      lastDate: DateTime(2222),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.light(
              primary: PaletaCores.corAzulAdtl,
              onPrimary: Colors.white,
              surface: PaletaCores.corAzulAdtl,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    ).then((date) {
      setState(() {
        //definindo que a  variavel vai receber o
        // valor selecionado no data picker
        if (date != null) {
          dataSelecionada = date;
        }
      });
      formatarData(dataSelecionada);
      recuperarHorarioTroca();
    });
  }

  chamarInserirItem() async {
    LocaisTrabalhoCooperadores locaisTrabalhoCooperadores = LocaisTrabalhoCooperadores(
        data: formatarData(dataSelecionada),
        primeiroHorarioPulpito: ctPrimeiroHoraPulpito.text,
        segundoHorarioPulpito: ctSegundoHoraPulpito.text,
        primeiroHorarioEntrada: ctPrimeiroHoraEntrada.text,
        segundoHorarioEntrada: ctSegundoHoraEntrada.text,
        recolherOferta: ctRecolherOferta.text,
        mesaApoio: ctMesaApoio.text,
        uniforme: ctUniforme.text,
        horarioTroca: horarioTroca,
        servirSantaCeia: ctServirSantaCeia.text,
        irmaoReserva: ctIrmaoReserva.text);
    bool retorno = await bancoDados.inserirDadosEscalaCooperadores(
        widget.nomeEscalaSelecionada, locaisTrabalhoCooperadores);
    chamarExibirMensagem(
        retorno, Textos.sucessoInserirBancoDados, Textos.erroInserirBancoDados);
  }

  redirecionarTelaEscalaDetalhada() {
    Navigator.pushReplacementNamed(context, Constantes.rotaTelaEscalaDetalhada,
        arguments: widget.nomeEscalaSelecionada);
  }

  Widget botoesSwitch(String label, bool valorBotao) =>
      SizedBox(
        width: 170,
        child: Row(
          children: [
            Text(label),
            Switch(
                value: valorBotao,
                activeColor: PaletaCores.corAzulEscuro,
                onChanged: (bool valor) {
                  setState(() {
                    mudarSwitch(label, valor);
                  });
                })
          ],
        ),
      );

  Widget camposFormulario(double larguraTela, TextEditingController controller,
      String label) =>
      Container(
        padding:
        const EdgeInsets.only(left: 5.0, top: 5.0, right: 5.0, bottom: 5.0),
        width: MetodosAuxiliares.definirTamanhoTextField(larguraTela),
        child: TextFormField(
          keyboardType: TextInputType.text,
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    double larguraTela = MediaQuery
        .of(context)
        .size
        .width;
    double alturaTela = MediaQuery
        .of(context)
        .size
        .height;
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
                  title: Text(Textos.tituloTelaCadastroItem),
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
                              flex: 3,
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
                                              margin:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 10.0),
                                              child: Text(
                                                "${Textos
                                                    .descricaoEscalaSelecionada}${widget
                                                    .nomeEscalaSelecionada}",
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
                                              Textos.descricaoTelaCadastroItem,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontSize: 20)),
                                        ),
                                        SizedBox(
                                            height: 60,
                                            width: 60,
                                            child: ElevatedButton(
                                                onPressed: () async {
                                                  exibirDataPicker();
                                                },
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                        Icons
                                                            .date_range_outlined,
                                                        color: PaletaCores
                                                            .corAzulAdtl,
                                                        size: 30),
                                                    Text(
                                                      Textos.labelData,
                                                      textAlign:
                                                      TextAlign.center,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 12,
                                                          color: PaletaCores
                                                              .corAzulAdtl),
                                                    )
                                                  ],
                                                ))),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 0),
                                          width: larguraTela,
                                          child: Text(
                                              Textos.descricaoDataSelecionada +
                                                  formatarData(dataSelecionada),
                                              textAlign: TextAlign.center),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 0),
                                          width: larguraTela,
                                          child: Text(horarioTroca,
                                              textAlign: TextAlign.center),
                                        ),
                                        Form(
                                          key: _formKeyFormulario,
                                          child: Wrap(
                                            children: [
                                              Visibility(
                                                  visible:
                                                  !exibirSoCamposCooperadora,
                                                  child: Wrap(
                                                    children: [
                                                      camposFormulario(
                                                          larguraTela,
                                                          ctPrimeiroHoraPulpito,
                                                          Textos
                                                              .labelPrimeiroHoraPulpito),
                                                      camposFormulario(
                                                          larguraTela,
                                                          ctSegundoHoraPulpito,
                                                          Textos
                                                              .labelSegundoHoraPulpito),
                                                    ],
                                                  )),
                                              camposFormulario(
                                                  larguraTela,
                                                  ctPrimeiroHoraEntrada,
                                                  Textos
                                                      .labelPrimeiroHoraEntrada),
                                              camposFormulario(
                                                  larguraTela,
                                                  ctSegundoHoraEntrada,
                                                  Textos
                                                      .labelSegundoHoraEntrada),
                                              camposFormulario(
                                                  larguraTela,
                                                  ctRecolherOferta,
                                                  Textos.labelRecolherOferta),
                                              camposFormulario(
                                                  larguraTela,
                                                  ctUniforme,
                                                  Textos.labelUniforme),
                                              Visibility(
                                                visible:
                                                exibirSoCamposCooperadora,
                                                child: camposFormulario(
                                                    larguraTela,
                                                    ctMesaApoio,
                                                    Textos.labelMesaApoio),
                                              ),
                                              Visibility(
                                                visible:
                                                exibirCampoServirSantaCeia,
                                                child: camposFormulario(
                                                    larguraTela,
                                                    ctServirSantaCeia,
                                                    Textos
                                                        .labelServirSantaCeia),
                                              ),
                                              Visibility(
                                                visible: exbirCampoIrmaoReserva,
                                                child: camposFormulario(
                                                    larguraTela,
                                                    ctIrmaoReserva,
                                                    Textos.labelIrmaoReserva),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))),
                          Expanded(
                              flex: 1,
                              child: SizedBox(
                                height: larguraTela,
                                width: larguraTela,
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(10),
                                        width: 400,
                                        height: 70,
                                        child: Card(
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                          ),
                                          elevation: 1,
                                          child: SingleChildScrollView(
                                            child: Wrap(
                                              alignment: WrapAlignment.center,
                                              children: [
                                                botoesSwitch(
                                                    Textos
                                                        .labelSwitchServirSantaCeia,
                                                    exibirCampoServirSantaCeia),
                                                botoesSwitch(
                                                    Textos
                                                        .labelSwitchIrmaoReserva,
                                                    exbirCampoIrmaoReserva)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.all(10),
                                        width: 120,
                                        height: 50,
                                        child: ElevatedButton(
                                          child: Text(Textos.btnAdicionarItem,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: corFundoTela)),
                                          onPressed: () {
                                            chamarInserirItem();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ))
                        ],
                      )),
                ),
              ),
              bottomNavigationBar: SizedBox(
                width: larguraTela,
                height: alturaTela * 0.1,
                child: const BarraNavegacao(
                    nomeRotaTela: Constantes.rotaTelaCadastrarItem),
              ),
            ),
          ),
        ));
  }
}
