import 'package:flutter/material.dart';
import 'package:senturionglist/Uteis/constantes.dart';
import 'package:senturionglist/Uteis/estilo.dart';
import 'package:senturionglist/Uteis/paleta_cores.dart';
import 'package:senturionglist/Uteis/textos.dart';
import 'package:senturionglist/Widgets/barra_navegacao.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  Color corFundoTela = PaletaCores.corAzulEscuro;
  Estilo estilo = Estilo();

  Widget botao(String nomeBtn) => SizedBox(
        width: 150,
        height: 50,
        child: ElevatedButton(
            onPressed: () {
              String tipoCadastro = "";
              if (nomeBtn == Textos.btnCooperador) {
                tipoCadastro = Constantes.tipoCadastroCooperador;
              } else {
                tipoCadastro = Constantes.tipoCadastroCooperadora;
              }
              Navigator.popAndPushNamed(context, Constantes.rotaTelaCadastroNomeCooperadores,
                  arguments: tipoCadastro);
            },
            child: Text(
              nomeBtn,
              style: const TextStyle(color: PaletaCores.corAzulEscuro),
            )),
      );

  @override
  Widget build(BuildContext context) {
    double larguraTela = MediaQuery.of(context).size.width;
    double alturaTela = MediaQuery.of(context).size.height;
    return Theme(
        data: estilo.estiloGeral,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(Textos.nomeApp),
          ),
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
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(30),
                        child: Text(Textos.descricaoTelaInicial,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 20)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          botao(Textos.btnCooperador),
                          botao(Textos.btnCooperadora)
                        ],
                      ),
                    ],
                  )),
            ),
          ),
          bottomNavigationBar: SizedBox(
            width: larguraTela,
            height: alturaTela * 0.1,
            child: const BarraNavegacao(nomeRotaTela: Constantes.rotaTelaInicial),
          ),
        ));
  }
}
