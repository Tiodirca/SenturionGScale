import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:senturionglist/Modelo/checkbox.dart';
import 'package:senturionglist/Uteis/constantes.dart';
import 'package:senturionglist/Uteis/textos.dart';
import 'package:senturionglist/Widgets/barra_navegacao.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MetodosAuxiliares {
  static definirTamanhoTextField(double larguraTela) {
    if (larguraTela < 600) {
      return 250.00;
    } else {
      return 400.00;
    }
  }

  static exibirMensagens(String msg, String tipoAlerta, BuildContext context) {
    if (tipoAlerta == Textos.tipoAlertaSucesso) {
      ElegantNotification.success(
        width: 360,
        notificationPosition: NotificationPosition.topRight,
        animation: AnimationType.fromRight,
        title: Text(tipoAlerta),
        showProgressIndicator: false,
        animationDuration: const Duration(seconds: 1),
        toastDuration: const Duration(seconds: 3),
        description: Text(msg),
      ).show(context);
    } else {
      return ElegantNotification.error(
        width: 360,
        notificationPosition: NotificationPosition.topRight,
        animation: AnimationType.fromRight,
        title: Text(tipoAlerta),
        showProgressIndicator: false,
        animationDuration: const Duration(seconds: 1),
        toastDuration: const Duration(seconds: 3),
        description: Text(msg),
      ).show(context);
    }
  }

  // metodo para gravar valores padroes no
  // share preferences
  gravarDadosPadrao() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final horaMudada = prefs.getString(Constantes.horarioMudado) ?? '';
    if (horaMudada != Constantes.horarioMudado) {
      prefs.setString(Constantes.shareHorarioInicialSemana,
          Constantes.horarioInicialSemana);
      prefs.setString(
          Constantes.shareHorarioTrocaSemana, Constantes.horarioTrocaSemana);
      prefs.setString(Constantes.shareHorarioInicialFSemana,
          Constantes.horarioInicialFSemana);
      prefs.setString(
          Constantes.shareHorarioTrocaFsemana, Constantes.horarioTrocaFsemana);
    }
  }

  // metodo para definir valor da lista caso nao seja definido
  // trabalhos em dias especificos
  static limparSelecaoDiasTrabalhoEspecifico() async {
    BarraNavegacao.itensDatasEspecificas.clear();
    BarraNavegacao.itensPessoasEspecificas.clear();
    BarraNavegacao.listaPessoasTrabalhoConvertido.clear();
    BarraNavegacao.listaPeriodoTrabalhoConvertido.clear();
    BarraNavegacao.itensPessoasEspecificas.add(Constantes.semAgrupamento);
    BarraNavegacao.itensDatasEspecificas.add(Constantes.semAgrupamento);
    await carregarListaTrabalhoDiaEspecifico();
  }

  static carregarListaTrabalhoDiaEspecifico() {
    for (var element in BarraNavegacao.itensPeriodoTrabalho) {
      BarraNavegacao.listaPeriodoTrabalhoConvertido
          .add(CheckBoxModel(texto: element, checked: false));
    }
    for (var element in BarraNavegacao.itensPessoasSelecionadas) {
      BarraNavegacao.listaPessoasTrabalhoConvertido
          .add(CheckBoxModel(texto: element.texto, checked: false));
    }
  }

  static Future<String> recuperarValoresSharePreferences(String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var horarioInicioSemana =
        prefs.getString(Constantes.shareHorarioInicialSemana) ?? '';
    var horarioTrocaSemana =
        prefs.getString(Constantes.shareHorarioTrocaSemana) ?? '';
    var horarioInicioFSemana =
        prefs.getString(Constantes.shareHorarioInicialFSemana) ?? '';
    var horarioTrocaFSemana =
        prefs.getString(Constantes.shareHorarioTrocaFsemana) ?? '';

    if (data.toString().contains(Constantes.diaSabado) ||
        data.toString().contains(Constantes.diaDomingo)) {
      return "${Textos.msgComecoHorarioEscala} $horarioInicioFSemana ${Textos.msgTrocaHorarioEscala} $horarioTrocaFSemana";
    } else {
      return "${Textos.msgComecoHorarioEscala} $horarioInicioSemana ${Textos.msgTrocaHorarioEscala} $horarioTrocaSemana";
    }
  }
}
