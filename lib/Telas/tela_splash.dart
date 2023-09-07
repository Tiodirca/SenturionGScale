import 'dart:async';

import 'package:flutter/material.dart';
import 'package:senturionglist/Uteis/BancoDados/banco_dados.dart';
import 'package:senturionglist/Uteis/constantes.dart';
import 'package:senturionglist/Uteis/estilo.dart';
import 'package:senturionglist/Uteis/metodos_auxiliares.dart';
import 'package:senturionglist/Uteis/paleta_cores.dart';
import 'package:senturionglist/Widgets/tela_carregamento.dart';

class TelaSplashScreen extends StatefulWidget {
  const TelaSplashScreen({super.key});

  @override
  State<TelaSplashScreen> createState() => _TelaSplashScreenState();
}

class _TelaSplashScreenState extends State<TelaSplashScreen> {
  Color corFundoTela = PaletaCores.corAzulEscuro;
  Estilo estilo = Estilo();

  @override
  void initState() {
    super.initState();
    MetodosAuxiliares metodosAuxiliares = MetodosAuxiliares();
    metodosAuxiliares.gravarDadosPadrao();
    BancoDados bancoDados = BancoDados();
    bancoDados.criarTabela(
        Constantes.sqlCooperadores, Constantes.tipoCadastroCooperador);
    bancoDados.criarTabela(
        Constantes.sqlCooperadores, Constantes.tipoCadastroCooperadora);
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, Constantes.rotaTelaInicial);
    });
  }

  @override
  Widget build(BuildContext context) {
    double larguraTela = MediaQuery.of(context).size.width;
    double alturaTela = MediaQuery.of(context).size.height;
    return Theme(
        data: estilo.estiloGeral,
        child: Scaffold(
          backgroundColor: corFundoTela,
          body: SizedBox(
            width: larguraTela,
            height: alturaTela,
            child: Card(
              elevation: 0,
              color: Colors.white,
              margin: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Container(
                  margin: const EdgeInsets.all(20),
                  width: larguraTela,
                  height: alturaTela,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // const Image(
                      //   image: AssetImage('@minimap'),
                      //   width: 200,
                      //   height: 200,
                      // ),
                      TelaCarregamento(),
                    ],
                  )),
            ),
          ),
          bottomNavigationBar: SizedBox(
            width: larguraTela,
            height: alturaTela * 0.1,
          ),
        ));
  }
}
