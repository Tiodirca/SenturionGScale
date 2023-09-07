import 'package:flutter/material.dart';
import 'package:senturionglist/Modelo/checkbox.dart';
import 'package:senturionglist/Uteis/constantes.dart';
import 'package:senturionglist/Uteis/estilo.dart';
import 'package:senturionglist/Uteis/paleta_cores.dart';
import 'package:senturionglist/Uteis/textos.dart';
import 'package:senturionglist/Widgets/barra_navegacao.dart';
import 'package:senturionglist/Widgets/checkbox.dart';

class TelaSelecaoDiasSemana extends StatefulWidget {
  const TelaSelecaoDiasSemana({
    super.key,
  });

  @override
  State<TelaSelecaoDiasSemana> createState() => _TelaSelecaoDiasSemanaState();
}

class _TelaSelecaoDiasSemanaState extends State<TelaSelecaoDiasSemana> {
  Color corFundoTela = PaletaCores.corAzulEscuro;
  Estilo estilo = Estilo();
  final List<CheckBoxModel> itensDiasSemana = [
    CheckBoxModel(texto: Constantes.diaSegunda, idItem: 0),
    CheckBoxModel(texto: Constantes.diaTerca, idItem: 1),
    CheckBoxModel(texto: Constantes.diaQuarta, idItem: 2),
    CheckBoxModel(texto: Constantes.diaQuinta, idItem: 3),
    CheckBoxModel(texto: Constantes.diaSexta, idItem: 4),
    CheckBoxModel(texto: Constantes.diaSabado, idItem: 5),
    CheckBoxModel(texto: Constantes.diaDomingo, idItem: 6)
  ];

  @override
  void initState() {
    super.initState();
  }

  redirecionarTela() {
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
                  title: Text(Textos.telaSelecaoDiasSemana),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
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
                          child: Text(Textos.descricaoTelaSelecaoDias,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 20)),
                        ),
                        SizedBox(
                            height: alturaTela * 0.5,
                            width: larguraTela,
                            child: ListView(
                              children: [
                                ...itensDiasSemana
                                    .map((e) => CheckboxWidget(
                                        item: e,
                                        listaItens: itensDiasSemana,
                                        telaListagem: Constantes
                                            .rotaTelaSelecaoDiasSemana))
                                    .toList()
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: SizedBox(
                width: larguraTela,
                height: alturaTela * 0.1,
                child: const BarraNavegacao(
                    nomeRotaTela: Constantes.rotaTelaSelecaoDiasSemana),
              ),
            ),
          ),
        ));
  }
}
