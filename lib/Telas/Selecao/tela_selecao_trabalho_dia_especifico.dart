import 'package:flutter/material.dart';
import 'package:senturionglist/Modelo/checkbox.dart';

import 'package:senturionglist/Uteis/constantes.dart';
import 'package:senturionglist/Uteis/estilo.dart';
import 'package:senturionglist/Uteis/metodos_auxiliares.dart';
import 'package:senturionglist/Uteis/paleta_cores.dart';
import 'package:senturionglist/Uteis/textos.dart';
import 'package:senturionglist/Widgets/barra_navegacao.dart';
import 'package:senturionglist/Widgets/checkbox.dart';

class TelaTrabalhoDiaEspecifico extends StatefulWidget {
  const TelaTrabalhoDiaEspecifico({super.key});

  @override
  State<TelaTrabalhoDiaEspecifico> createState() =>
      _TelaTrabalhoDiaEspecificoState();
}

class _TelaTrabalhoDiaEspecificoState extends State<TelaTrabalhoDiaEspecifico> {
  Color corFundoTela = PaletaCores.corAzulEscuro;
  Estilo estilo = Estilo();
  bool opcaoRadioButton = false;
  int valorRadioButton = 0;

  @override
  void initState() {
    super.initState();
    // percorrendo a lista e adicionando os itens nas
    // listas para o usuario selecionar
    MetodosAuxiliares.limparSelecaoDiasTrabalhoEspecifico(); //chamando metodo
  }

  redirecionarTela() {
    Navigator.pop(context);
  }

//metodo para mudar o estado do radio button
  void mudarRadioButton(int value) {
    setState(() {
      valorRadioButton = value;
      switch (valorRadioButton) {
        case 0:
          setState(() {
            opcaoRadioButton = false;
            //limpando lista
            BarraNavegacao.itensPessoasEspecificas.clear();
            BarraNavegacao.itensDatasEspecificas.clear();
            BarraNavegacao.itensPessoasEspecificas
                .add(Constantes.semAgrupamento);
            BarraNavegacao.itensDatasEspecificas.add(Constantes.semAgrupamento);
          });
          break;
        case 1:
          setState(() {
            opcaoRadioButton = true;
            BarraNavegacao.itensPessoasEspecificas.clear();
            BarraNavegacao.itensDatasEspecificas.clear();
          });
          break;
      }
    });
  }

  // widget para fazer listagem dos dias e do nomes das
  // pessoas para selecao para trabalho em dias especificos
  Widget carregarListagem(double alturaTela, double larguraTela,
          List<CheckBoxModel> lista, String tipoLista) =>
      SizedBox(
          height: alturaTela * 0.4,
          width: larguraTela * 0.5,
          child: ListView(
            children: [
              ...lista
                  .map((e) => CheckboxWidget(
                      item: e, listaItens: lista, telaListagem: tipoLista))
                  .toList()
            ],
          ));

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
                  title: Text(Textos.tituloTelaTrabalhoDiaEspecifico),
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
                                            Textos
                                                .descricaoTelaTrabalhoDiaEspecifico,
                                            textAlign: TextAlign.center,
                                            style:
                                                const TextStyle(fontSize: 20)),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Radio(
                                              value: 0,
                                              activeColor:
                                                  PaletaCores.corAzulEscuro,
                                              groupValue: valorRadioButton,
                                              onChanged: (_) {
                                                mudarRadioButton(0);
                                              }),
                                          const Text(
                                            'Não',
                                            style: TextStyle(
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Radio(
                                              value: 1,
                                              activeColor:
                                                  PaletaCores.corAzulEscuro,
                                              groupValue: valorRadioButton,
                                              onChanged: (_) {
                                                mudarRadioButton(1);
                                              }),
                                          const Text(
                                            'Sim',
                                            style: TextStyle(
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ))),
                        Expanded(
                            flex: 4,
                            child: SizedBox(
                                width: larguraTela,
                                child: Visibility(
                                  visible: opcaoRadioButton,
                                  child: Column(
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: Text(
                                            Textos
                                                .descricaoSelecaoTrabalhoDiaEspecifico,
                                            textAlign: TextAlign.center,
                                            style:
                                                const TextStyle(fontSize: 18)),
                                      ),
                                      Wrap(
                                        alignment: WrapAlignment.spaceEvenly,
                                        children: [
                                          SizedBox(
                                            width: larguraTela * 0.5,
                                            height: alturaTela * 0.5,
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 50,
                                                  child: Text(
                                                      Textos
                                                          .descricaoListagemPessoas,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          fontSize: 18)),
                                                ),
                                                carregarListagem(
                                                    alturaTela,
                                                    larguraTela,
                                                    BarraNavegacao
                                                        .listaPessoasTrabalhoConvertido,
                                                    Constantes
                                                        .listaTrabalhoEspecificoPessoas)
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: larguraTela * 0.5,
                                            height: alturaTela * 0.5,
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 50,
                                                  child: Text(
                                                      Textos
                                                          .descricaoListagemDias,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          fontSize: 18)),
                                                ),
                                                carregarListagem(
                                                    alturaTela,
                                                    larguraTela,
                                                    BarraNavegacao
                                                        .listaPeriodoTrabalhoConvertido,
                                                    Constantes
                                                        .listaTrabalhoEspecificoDias)
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
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
                    nomeRotaTela: Constantes.rotaTelaTrabalhoDiaEspecifico),
              ),
            ),
          ),
        ));
  }
}
