import 'package:flutter/material.dart';
import 'package:senturionglist/Modelo/checkbox.dart';
import 'package:senturionglist/Uteis/constantes.dart';
import 'package:senturionglist/Uteis/metodos_auxiliares.dart';
import 'package:senturionglist/Uteis/paleta_cores.dart';

import '../Uteis/textos.dart';

class BarraNavegacao extends StatelessWidget {
  const BarraNavegacao({super.key, required this.nomeRotaTela});

  final String nomeRotaTela;

  static List<CheckBoxModel> itensPessoasSelecionadas = [];
  static List<CheckBoxModel> itensDiasSemanaSelecionados = [];
  static List<String> itensPeriodoTrabalho = [];

  // Trabalho dia especifico
  static List<String> itensDatasEspecificas = [];
  static List<String> itensPessoasEspecificas = [];
  static List<CheckBoxModel> listaPessoasTrabalhoConvertido = [];
  static List<CheckBoxModel> listaPeriodoTrabalhoConvertido = [];
  static String tipoCadastro = "";

  Widget botoes(IconData iconData, BuildContext context) => SizedBox(
        width: 55,
        height: 55,
        child: FloatingActionButton(
          heroTag: iconData.toString(),
          onPressed: () {
            if (iconData == Constantes.iconeAvancar) {
              redirecionarTela(nomeRotaTela, context);
            } else if (iconData == Constantes.iconeConfiguracoes) {
              Navigator.pushReplacementNamed(
                  context, Constantes.rotaTelaConfiguracoes);
            } else if (iconData == Constantes.iconeLista) {
              Navigator.pushReplacementNamed(
                  context, Constantes.rotaTelaSelecaoListaEscala);
            } else if (iconData == Constantes.iconeHome) {
              itensPessoasSelecionadas.clear();
              itensDiasSemanaSelecionados.clear();
              itensPeriodoTrabalho.clear();
              itensDatasEspecificas.clear();
              itensPessoasEspecificas.clear();
              listaPeriodoTrabalhoConvertido.clear();
              listaPessoasTrabalhoConvertido.clear();
              tipoCadastro = "";
              Navigator.pushReplacementNamed(
                  context, Constantes.rotaTelaInicial);
            }
          },
          child: Icon(iconData, size: 45, color: PaletaCores.corRosaClarinho),
        ),
      );

  redirecionarTela(String nomeTela, BuildContext context) {
    switch (nomeTela) {
      case Constantes.rotaTelaCadastroNomeCooperadores:
        if (itensPessoasSelecionadas.isNotEmpty &&
                (itensPessoasSelecionadas.length >= 5 &&
                    tipoCadastro == Constantes.tipoCadastroCooperador) ||
            (itensPessoasSelecionadas.length >= 4 &&
                tipoCadastro != Constantes.tipoCadastroCooperador)) {
          Navigator.pushNamed(context, Constantes.rotaTelaSelecaoDiasSemana);
        } else {
          exibirMensagemErro(context); //chamar metodo
        }
        //limpando listas
        itensDiasSemanaSelecionados.clear();
        itensPeriodoTrabalho.clear();
      case Constantes.rotaTelaSelecaoDiasSemana:
        if (itensDiasSemanaSelecionados.isNotEmpty) {
          Navigator.pushNamed(
              context, Constantes.rotaTelaSelecaoPeriodoTrabalho);
        } else {
          MetodosAuxiliares.exibirMensagens(
              Textos.erroSelecaoCheckBox, Textos.tipoAlertaErro, context);
        }
        //limpando lista
        itensPeriodoTrabalho.clear();
      case Constantes.rotaTelaSelecaoPeriodoTrabalho:
        if (itensPeriodoTrabalho.isNotEmpty) {
          Navigator.pushNamed(
              context, Constantes.rotaTelaTrabalhoDiaEspecifico);
        } else {
          MetodosAuxiliares.exibirMensagens(
              Textos.erroSelecaoPeriodo, Textos.tipoAlertaErro, context);
        }
        //limpando lista
        itensDatasEspecificas.clear();
        itensPessoasEspecificas.clear();
      case Constantes.rotaTelaTrabalhoDiaEspecifico:
        if ((itensPessoasEspecificas.isNotEmpty &&
                itensDatasEspecificas.isNotEmpty) ||
            (itensPessoasEspecificas.contains(Constantes.semAgrupamento) &&
                itensDatasEspecificas.contains(Constantes.semAgrupamento))) {
          Navigator.pushNamed(context, Constantes.rotaTelaGerarEscala);
        } else {
          MetodosAuxiliares.exibirMensagens(
              Textos.erroTrabalhoDiaEspecifico, Textos.tipoAlertaErro, context);
        }
    }
  }

  exibirMensagemErro(BuildContext context) {
    String msg = "";
    if (tipoCadastro == Constantes.tipoCadastroCooperador) {
      msg = Textos.erroSelecaoPessoasCadastroCooperador;
    } else {
      msg = Textos.erroSelecaoPessoasCadastroCooperadora;
    }
    MetodosAuxiliares.exibirMensagens(msg, Textos.tipoAlertaErro, context);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (nomeRotaTela == Constantes.rotaTelaCadastroNomeCooperadores ||
            nomeRotaTela == Constantes.rotaTelaSelecaoDiasSemana ||
            nomeRotaTela == Constantes.rotaTelaSelecaoPeriodoTrabalho ||
            nomeRotaTela == Constantes.rotaTelaTrabalhoDiaEspecifico) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              botoes(Constantes.iconeHome, context),
              botoes(Constantes.iconeAvancar, context)
            ],
          );
        } else if (nomeRotaTela == Constantes.rotaTelaInicial ||
            nomeRotaTela == Constantes.rotaTelaConfiguracoes ||
            nomeRotaTela == Constantes.rotaTelaSelecaoListaEscala ||
            nomeRotaTela == Constantes.rotaTelaEscalaDetalhada ||
            nomeRotaTela == Constantes.rotaTelaEditarItem ||
            nomeRotaTela == Constantes.rotaTelaGerarEscala) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              botoes(Constantes.iconeHome, context),
              LayoutBuilder(
                builder: (context, constraints) {
                  if (nomeRotaTela == Constantes.rotaTelaEscalaDetalhada ||
                      nomeRotaTela == Constantes.rotaTelaSelecaoListaEscala ||
                      nomeRotaTela == Constantes.rotaTelaEditarItem) {
                    return Container();
                  } else {
                    return botoes(Constantes.iconeLista, context);
                  }
                },
              ),
              botoes(Constantes.iconeConfiguracoes, context)
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}
