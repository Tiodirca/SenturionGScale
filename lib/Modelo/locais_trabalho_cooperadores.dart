class LocaisTrabalhoCooperadores {
  int id;
  String data;
  String primeiroHorarioPulpito;
  String segundoHorarioPulpito;
  String primeiroHorarioEntrada;
  String segundoHorarioEntrada;
  String mesaApoio;
  String recolherOferta;
  String uniforme;
  String horarioTroca;
  String servirSantaCeia;
  String irmaoReserva;

  LocaisTrabalhoCooperadores(
      {this.id = 0,
      required this.data,
      required this.primeiroHorarioPulpito,
      required this.segundoHorarioPulpito,
      required this.primeiroHorarioEntrada,
      required this.segundoHorarioEntrada,
      required this.recolherOferta,
      required this.mesaApoio,
      required this.uniforme,
      required this.horarioTroca,
      required this.servirSantaCeia,
      required this.irmaoReserva});

  LocaisTrabalhoCooperadores.vazio(
      {this.id = 0,
      this.data = "",
      this.primeiroHorarioPulpito = "",
      this.segundoHorarioPulpito = "",
      this.primeiroHorarioEntrada = "",
      this.segundoHorarioEntrada = "",
      this.recolherOferta = "",
      this.mesaApoio = "",
      this.uniforme = "",
      this.horarioTroca = "",
      this.servirSantaCeia = "",
      this.irmaoReserva = ""});
}
