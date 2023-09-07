import 'package:flutter/material.dart';
import 'package:senturionglist/Uteis/constantes.dart';
import 'package:senturionglist/Uteis/estilo.dart';
import 'package:senturionglist/Uteis/paleta_cores.dart';
import 'package:senturionglist/Uteis/textos.dart';
import 'package:senturionglist/Widgets/barra_navegacao.dart';
import 'package:intl/intl.dart';

class TelaSelecaoPeriodoTrabalho extends StatefulWidget {
  const TelaSelecaoPeriodoTrabalho({super.key});

  @override
  State<TelaSelecaoPeriodoTrabalho> createState() =>
      _TelaSelecaoPeriodoTrabalhoState();
}

class _TelaSelecaoPeriodoTrabalhoState
    extends State<TelaSelecaoPeriodoTrabalho> {
  Color corFundoTela = PaletaCores.corAzulEscuro;
  Estilo estilo = Estilo();
  DateTime dataInicial = DateTime.now();
  DateTime dataFinal = DateTime.now();
  List<String> listaDatasFinal = [];
  List<DateTime> listaDatasAuxiliar = [];

  @override
  void initState() {
    super.initState();
  }

  redirecionarTela() {
    Navigator.pop(context);
  }

  Widget selecaoPeriodoTrabalho(String label, DateTime data) => Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      width: 200,
      child: Column(
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: PaletaCores.corAzulEscuro),
          ),
          TextFormField(
            readOnly: true,
            onTap: () async {
              DateTime? novaData = await showDatePicker(
                  builder: (context, child) {
                    return Theme(
                        data: ThemeData.dark().copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: PaletaCores.corAzulEscuro,
                            onPrimary: Colors.white,
                            onSurface: Colors.black,
                          ),
                          dialogBackgroundColor: Colors.white,
                        ),
                        child: child!);
                  },
                  context: context,
                  initialDate: data,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100));

              if (novaData == null) return;
              setState(() {
                if (label.contains(Textos.labelPeriodoInicio)) {
                  dataInicial = novaData;
                } else {
                  dataFinal = novaData;
                }
                listaDatasAuxiliar = [];
                listaDatasFinal = [];
                BarraNavegacao.itensPeriodoTrabalho.clear();
                pegarDatasIntervalo();
              });
            },
            decoration: InputDecoration(
              hintStyle: const TextStyle(color: PaletaCores.corAzulEscuro),
              hintText: '${data.day}/${data.month}/${data.year}',
            ),
          ),
        ],
      ));

  // metodo para pegar o intervalo de datas entre
  // o primeiro periodo e o periodo final
  pegarDatasIntervalo() {
    DateTime datasDiferenca = dataInicial;
    dynamic diferencaDias = datasDiferenca
        .difference(dataFinal.add(const Duration(days: 1)))
        .inDays;
    //verificando se a variavel recebeu um valor negativo
    if (diferencaDias.toString().contains("-")) {
      // passando para positivo
      diferencaDias = -(diferencaDias);
    }
    //pegando todas as datas
    for (int interacao = 0; interacao <= diferencaDias; interacao++) {
      listaDatasAuxiliar.add(datasDiferenca);
      // definindo que a variavel vai receber ela mesma com a adicao de parametro de duracao
      datasDiferenca = datasDiferenca.add(const Duration(days: 1));
    }
    listarDatas();
  }

// metodo para listar as datas formatando elas para
// o formato que contenha da data em numeros e o dia da semana
  listarDatas() {
    // pegando todos os itens da lista
    for (var element in listaDatasAuxiliar) {
      String data = DateFormat("dd/MM/yyyy EEEE", "pt_BR").format(element);
      for (var element in BarraNavegacao.itensDiasSemanaSelecionados) {
        if (data.contains(element.texto)) {
          listaDatasFinal.add(data);
        }
      }
    }
    verificarItensSelecionados();
  }

  //verificando se o elemento da lista contem em outra lista
  // caso nao contenha adicionar elemento na outra lista
  verificarItensSelecionados() {
    //verificando cada elemento da lista
    for (var element in listaDatasFinal) {
      if (!BarraNavegacao.itensPeriodoTrabalho.contains(element)) {
        BarraNavegacao.itensPeriodoTrabalho.add(element);
      }
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
                  title: Text(Textos.tituloTelaPeriodoTrabalho),
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
                            flex: 2,
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
                                              "${Textos.descricaoTipoCadastro}${BarraNavegacao.tipoCadastro}",
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
                                            Textos.descricaoPeriodoTrabalho,
                                            textAlign: TextAlign.center,
                                            style:
                                                const TextStyle(fontSize: 20)),
                                      ),
                                      Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        alignment: WrapAlignment.spaceEvenly,
                                        children: [
                                          selecaoPeriodoTrabalho(
                                              Textos.labelPeriodoInicio,
                                              dataInicial),
                                          selecaoPeriodoTrabalho(
                                              Textos.labelPeriodoFinal,
                                              dataFinal),
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
                                                .descricaoListagemPeriodoTrabalho,
                                            textAlign: TextAlign.center,
                                            style:
                                                const TextStyle(fontSize: 20)),
                                      ),
                                      SizedBox(
                                          height: alturaTela * 0.30,
                                          width: larguraTela,
                                          child: ListView(
                                            children: [
                                              ...BarraNavegacao
                                                  .itensPeriodoTrabalho
                                                  .map(
                                                    (e) => SizedBox(
                                                      width: larguraTela,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Icon(
                                                              Icons
                                                                  .date_range_rounded,
                                                              color: PaletaCores
                                                                  .corAzulEscuro),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(5),
                                                            width: 300,
                                                            child: Text(
                                                              e,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                  .toList()
                                            ],
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
                    nomeRotaTela: Constantes.rotaTelaSelecaoPeriodoTrabalho),
              ),
            ),
          ),
        ));
  }
}
