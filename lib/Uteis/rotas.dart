import 'package:flutter/material.dart';
import 'package:senturionglist/Telas/Escala/tela_editar_item.dart';
import 'package:senturionglist/Telas/Escala/tela_escala_detalhada.dart';
import 'package:senturionglist/Telas/Selecao/tela_selecao_dias_semana.dart';
import 'package:senturionglist/Telas/Selecao/tela_selecao_intervalo_trabalho.dart';
import 'package:senturionglist/Telas/Escala/tela_cadastro_item.dart';
import 'package:senturionglist/Telas/tela_cadastro_nome_cooperadores.dart';
import 'package:senturionglist/Telas/tela_configuracoes.dart';
import 'package:senturionglist/Telas/tela_gerar_escala.dart';
import 'package:senturionglist/Telas/Selecao/tela_selecao_trabalho_dia_especifico.dart';
import 'package:senturionglist/Telas/tela_inicial.dart';
import 'package:senturionglist/Telas/Selecao/tela_selecao_escalas.dart';
import 'package:senturionglist/Telas/tela_splash.dart';
import 'package:senturionglist/Uteis/constantes.dart';

class Rotas {
  static Route<dynamic> gerarRotas(RouteSettings settings) {
    final argumentos = settings.arguments;

    switch (settings.name) {
      case Constantes.rotaTelaInicial:
        return MaterialPageRoute(builder: (_) => const TelaInicial());
      case Constantes.rotaTelaSplashScreen:
        return MaterialPageRoute(builder: (_) => const TelaSplashScreen());
      case Constantes.rotaTelaSelecaoDiasSemana:
        return MaterialPageRoute(builder: (_) => const TelaSelecaoDiasSemana());
      case Constantes.rotaTelaGerarEscala:
        return MaterialPageRoute(builder: (_) => const TelaGerarEscala());
      case Constantes.rotaTelaSelecaoListaEscala:
        return MaterialPageRoute(builder: (_) => const TelaSelecaoEscalas());
      case Constantes.rotaTelaEscalaDetalhada:
        if (argumentos is String) {
          return MaterialPageRoute(
              builder: (_) =>
                  TelaEscalaDetalhada(nomeEscalaSelecionada: argumentos));
        } else {
          return erroRota(settings);
        }
      case Constantes.rotaTelaTrabalhoDiaEspecifico:
        return MaterialPageRoute(
            builder: (_) => const TelaTrabalhoDiaEspecifico());
      case Constantes.rotaTelaSelecaoPeriodoTrabalho:
        return MaterialPageRoute(
            builder: (_) => const TelaSelecaoPeriodoTrabalho());
      case Constantes.rotaTelaConfiguracoes:
        return MaterialPageRoute(builder: (_) => const TelaConfiguracoes());
      case Constantes.rotaTelaCadastroNomeCooperadores:
        if (argumentos is String) {
          return MaterialPageRoute(
              builder: (_) => TelaCadastroNomeCooperadores(
                    tipoCadastro: argumentos,
                  ));
        } else {
          return erroRota(settings);
        }
      case Constantes.rotaTelaEditarItem:
        if (argumentos is Map) {
          return MaterialPageRoute(
              builder: (_) => TelaEditarItem(
                  nomeEscalaSelecionada:
                      argumentos[Constantes.parametroNomeEscala],
                  locaisTrabalhoCooperadores:
                      argumentos[Constantes.parametroDadosItem]));
        } else {
          return erroRota(settings);
        }
      case Constantes.rotaTelaCadastrarItem:
        if (argumentos is Map) {
          return MaterialPageRoute(
              builder: (_) => TelaCadastroItem(
                    nomeEscalaSelecionada:
                        argumentos[Constantes.parametroNomeEscala],
                    exibirCamposCooperadores:
                        argumentos[Constantes.parametroExibirCampos],
                  ));
        } else {
          return erroRota(settings);
        }
    }
    return erroRota(settings);
  }

  //metodo para exibir mensagem de erro
  static Route<dynamic> erroRota(RouteSettings settings) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text("Tela não encontrada!"),
        ),
        body: Container(
          color: Colors.red,
          child: const Center(
            child: Text("Tela não encontrada."),
          ),
        ),
      );
    });
  }
}
