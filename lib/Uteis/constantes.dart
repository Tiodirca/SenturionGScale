import 'package:flutter/material.dart';

class Constantes {
  static const rotaTelaInicial = "telaInicial";
  static const rotaTelaCadastroNomeCooperadores =
      "telaCadastroNomeCooperadores";
  static const rotaTelaConfiguracoes = "telaConfiguracoes";
  static const rotaTelaSelecaoDiasSemana = "telaSelecaoDiasSemana";
  static const rotaTelaListagemEscala = "telaListagemEscala";
  static const rotaTelaSelecaoListaEscala = "telaSelecaoListaEscala";
  static const rotaTelaSplashScreen = "telaSplashScreen";
  static const rotaTelaSelecaoPeriodoTrabalho = "telaSelecaoPeriodoTrabalho";
  static const rotaTelaGerarEscala = "telaGerarEscala";
  static const rotaTelaTrabalhoDiaEspecifico = "telaTrabalhoDiaEspecifico";
  static const rotaTelaEscalaDetalhada = "telaEscalaDetalhada";
  static const rotaTelaEditarItem = "telaEditarItem";
  static const rotaTelaCadastrarItem = "telaCadastrarItem";

  static const iconeExclusao = Icons.close;
  static const iconeRecarregar = Icons.reset_tv;
  static const iconeLista = Icons.list_alt_outlined;
  static const iconeConfiguracoes = Icons.settings;
  static const iconeAvancar = Icons.arrow_circle_right_outlined;
  static const iconeRelogio = Icons.access_time_filled_outlined;
  static const iconeEditar = Icons.edit;
  static const iconeHome = Icons.home;
  static const iconeData = Icons.date_range_rounded;

  static const parametroNomeEscala = "nomeEscala";
  static const parametroDadosItem = "dadosItem";
  static const parametroExibirCampos = "exibirCampos";

  static const tipoCadastroCooperador = "cooperador";
  static const tipoCadastroCooperadora = "cooperadora";

  static const listaTrabalhoEspecificoPessoas = "listaPessoas";
  static const listaTrabalhoEspecificoDias = "listaDias";
  static const semAgrupamento = "sem agrupamento";

  static const horarioInicialSemana = "19:00";
  static const horarioTrocaSemana = "20:00";
  static const horarioInicialFSemana = "18:00";
  static const horarioTrocaFsemana = "19:00";
  static const horarioMudado = "sim";

  static const shareHorarioInicialSemana = "horarioInicialSemana";
  static const shareHorarioTrocaSemana = "horarioFinalSemana";
  static const shareHorarioInicialFSemana = "horarioInicialFSemana";
  static const shareHorarioTrocaFsemana = "horarioFinalFSemana";

  static const trocarHorarioSemana = "semana";
  static const trocarHorarioFimSemana = "fimSemana";

  static const idItem = "id";
  static const primeiraHoraPulpito = "primeiraHoraPulpito";
  static const segundaHoraPulpito = "segundaHoraPulpito";
  static const primeiraHoraEntrada = "primeiraHoraEntrada";
  static const segundaHoraEntrada = "segundaHoraEntrada";
  static const recolherOferta = "recolherOferta";
  static const uniforme = "uniforme";
  static const mesaApoio = "mesaApoio";
  static const servirSantaCeia = "servirSantaCeia";
  static const dataCulto = "dataCulto";
  static const horarioTroca = "horarioTroca";
  static const irmaoReserva = "irmaoReserva";
  static const nomeTabela = "tabela";

  // datas da semana
  static String diaSegunda = "segunda-feira";
  static String diaTerca = "terça-feira";
  static String diaQuarta = "quarta-feira";
  static String diaQuinta = "quinta-feira";
  static String diaSexta = "sexta-feira";
  static String diaSabado = "sábado";
  static String diaDomingo = "domingo";

  static const nomeTabelaLocalTrabalhoCooperador = "localTrabalhoCooperador";
  static const nomeTabelaLocalTrabalhoCooperadora = "localTrabalhoCooperadora";

  static const nomeCooperadores = "nome";
  static const sqlCooperadores = "$nomeCooperadores Text";

  static const sqlLocaisTrabalhoCooperadores =
      "$dataCulto TEXT,$primeiraHoraPulpito TEXT,$segundaHoraPulpito TEXT,$primeiraHoraEntrada TEXT,$segundaHoraEntrada TEXT,$recolherOferta TEXT,$mesaApoio TEXT,$uniforme TEXT,$horarioTroca TEXT,$servirSantaCeia TEXT,$irmaoReserva TEXT";
}
