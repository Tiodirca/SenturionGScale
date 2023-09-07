import 'package:flutter/material.dart';
import 'package:senturionglist/Uteis/constantes.dart';
import 'package:senturionglist/Uteis/estilo.dart';
import 'package:senturionglist/Uteis/metodos_auxiliares.dart';
import 'package:senturionglist/Uteis/paleta_cores.dart';
import 'package:senturionglist/Uteis/textos.dart';
import 'package:senturionglist/Widgets/barra_navegacao.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TelaConfiguracoes extends StatefulWidget {
  const TelaConfiguracoes({super.key});

  @override
  State<TelaConfiguracoes> createState() => _TelaConfiguracoesState();
}

class _TelaConfiguracoesState extends State<TelaConfiguracoes> {
  Color corFundoTela = PaletaCores.corAzulEscuro;
  Estilo estilo = Estilo();

  String horarioInicioSemana = "";
  String horarioTrocaSemana = "";
  String horarioInicioFSemana = "";
  String horarioTrocaFSemana = "";
  TimeOfDay? horario = const TimeOfDay(hour: 19, minute: 00);
  int contadorSetarHorario = 0;

  @override
  void initState() {
    super.initState();
    recuperarValoresSharePreferences();
  }

  //metodo para recuperar o horario gravado no share prefereces
  recuperarValoresSharePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      horarioInicioSemana =
          prefs.getString(Constantes.shareHorarioInicialSemana) ?? '';
      horarioTrocaSemana =
          prefs.getString(Constantes.shareHorarioTrocaSemana) ?? '';
      horarioInicioFSemana =
          prefs.getString(Constantes.shareHorarioInicialFSemana) ?? '';
      horarioTrocaFSemana =
          prefs.getString(Constantes.shareHorarioTrocaFsemana) ?? '';
    });
  }

  Widget botoesAcoes(double larguraTela, String horarioInicio,
          String horarioTroca, String qualHoraMudar) =>
      Container(
        margin: const EdgeInsets.symmetric(vertical: 20.0),
        width: larguraTela,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {
                  exibirTimePicker(qualHoraMudar);
                },
                child: const Icon(Constantes.iconeRelogio,
                    size: 35, color: PaletaCores.corAzulEscuro),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                  "1° Hora começa às : $horarioInicio e troca às : $horarioTroca "),
            )
          ],
        ),
      );

  exibirTimePicker(String qualHoraMudar) async {
    TimeOfDay? novoHorario = await showTimePicker(
      context: context,
      initialTime: horario!,
      helpText: contadorSetarHorario == 1
          ? Textos.descricaoTimePickerHorarioTroca
          : Textos.descricaoTimePickerHorarioInicial,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.white,
              onPrimary: PaletaCores.corAmarelaAdtlLetras,
              surface: PaletaCores.corAzulAdtl,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (novoHorario != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        horario = novoHorario;
        contadorSetarHorario++;
        //definindo o horario inicial
        if (contadorSetarHorario == 1) {
          if (qualHoraMudar == Constantes.trocarHorarioSemana) {
            prefs.setString(Constantes.shareHorarioInicialSemana,
                "${horario!.hour.toString().padLeft(2, "0")}:${horario!.minute.toString().padLeft(2, "0")}");
          } else if (qualHoraMudar == Constantes.trocarHorarioFimSemana) {
            prefs.setString(Constantes.shareHorarioInicialFSemana,
                "${horario!.hour.toString().padLeft(2, "0")}:${horario!.minute.toString().padLeft(2, "0")}");
          }
          exibirTimePicker(qualHoraMudar);
        } else {
          // definindo horario de troca
          if (qualHoraMudar == Constantes.trocarHorarioSemana) {
            prefs.setString(Constantes.shareHorarioTrocaSemana,
                "${horario!.hour.toString().padLeft(2, "0")}:${horario!.minute.toString().padLeft(2, "0")}");
          } else if (qualHoraMudar == Constantes.trocarHorarioFimSemana) {
            prefs.setString(Constantes.shareHorarioTrocaFsemana,
                "${horario!.hour.toString().padLeft(2, "0")}:${horario!.minute.toString().padLeft(2, "0")}");
          }
          // redefindo valores das variaveis para os valores padroes
          contadorSetarHorario = 0;
          horario = const TimeOfDay(hour: 19, minute: 00);
        }
      });
      recuperarValoresSharePreferences();
    } else {
      // redefindo valor caso o
      // usuario cancele a acao
      contadorSetarHorario = 0;
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
            Navigator.pushReplacementNamed(context, Constantes.rotaTelaInicial);
            return false;
          },
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Scaffold(
              appBar: AppBar(
                  elevation: 0,
                  title: Text(Textos.telaConfiguracoes),
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, Constantes.rotaTelaInicial);
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
                        Container(
                          margin: const EdgeInsets.only(bottom: 20.0),
                          width: larguraTela * 0.8,
                          child: Text(Textos.descricaoBtnDefinirHorario,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 20)),
                        ),
                        Text(Textos.descricaoTrocaSemana,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        botoesAcoes(larguraTela, horarioInicioSemana,
                            horarioTrocaSemana, Constantes.trocarHorarioSemana),
                        Text(Textos.descricaoTrocaFimSemana,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        botoesAcoes(
                            larguraTela,
                            horarioInicioFSemana,
                            horarioTrocaFSemana,
                            Constantes.trocarHorarioFimSemana),
                        Container(
                          margin: const EdgeInsets.only(bottom: 20.0),
                          width: larguraTela * 0.8,
                          child: Text(
                              Textos.descricaoRedefinirValoresHorarioTroca,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 20)),
                        ),
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: FloatingActionButton(
                            backgroundColor: Colors.white,
                            onPressed: () {
                              MetodosAuxiliares metodosAuxiliares =
                                  MetodosAuxiliares();
                              metodosAuxiliares.gravarDadosPadrao();
                              recuperarValoresSharePreferences();
                            },
                            child: const Icon(Constantes.iconeRecarregar,
                                size: 35, color: PaletaCores.corAzulEscuro),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: SizedBox(
                width: larguraTela,
                height: alturaTela * 0.1,
                child: const BarraNavegacao(
                    nomeRotaTela: Constantes.rotaTelaConfiguracoes),
              ),
            ),
          ),
        ));
  }
}
