import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:senturionglist/Modelo/locais_trabalho_cooperadores.dart';
import 'package:senturionglist/Uteis/textos.dart';

import 'salvarPDF/SavePDFMobile.dart'
    if (dart.library.html) 'salvarPDF/SavePDFWeb.dart';

class GerarPDF {
  static List<String> listaLegenda = [];
  List<LocaisTrabalhoCooperadores> listaEscala;
  String nomeEscala;
  bool exibirMesaApoio;
  bool exibirRecolherOferta;
  bool exibirIrmaoReserva;
  bool exibirServirSantaCeia;

  GerarPDF(
      {required this.listaEscala,
      required this.nomeEscala,
      required this.exibirMesaApoio,
      required this.exibirRecolherOferta,
      required this.exibirIrmaoReserva,
      required this.exibirServirSantaCeia});

  pegarDados() {
    listaLegenda.addAll([Textos.labelData, Textos.labelHorarioTroca]);

    if (exibirMesaApoio == false) {
      listaLegenda.addAll([
        Textos.labelPrimeiroHoraPulpito,
        Textos.labelSegundoHoraPulpito,
      ]);
    }
    listaLegenda.addAll([
      Textos.labelPrimeiroHoraEntrada,
      Textos.labelSegundoHoraEntrada,
    ]);
    if (exibirMesaApoio) {
      listaLegenda.addAll([Textos.labelMesaApoio]);
    }
    listaLegenda.addAll([
      Textos.labelUniforme,
    ]);
    if (exibirServirSantaCeia) {
      listaLegenda.add(Textos.labelServirSantaCeia);
    } else {
      listaLegenda.add("");
    }
    if (exibirIrmaoReserva && exibirRecolherOferta) {
      listaLegenda
          .addAll([Textos.labelRecolherOferta, Textos.labelIrmaoReserva]);
    } else if (exibirRecolherOferta) {
      listaLegenda.add(Textos.labelRecolherOferta);
    } else if (exibirRecolherOferta == false && exibirIrmaoReserva) {
      listaLegenda.addAll(["", Textos.labelIrmaoReserva]);
    }
    gerarPDF();
  }

  gerarPDF() async {
    final pdfLib.Document pdf = pdfLib.Document();
    //definindo que a variavel vai receber o caminho da
    // imagem para serem exibidas
    final image = (await rootBundle.load('assets/imagens/logo_adtl.png'))
        .buffer
        .asUint8List();
    final imageLogo =
        (await rootBundle.load('assets/imagens/Logo.png')).buffer.asUint8List();
    //adicionando a pagina ao pdf
    pdf.addPage(pdfLib.MultiPage(
        //definindo formato
        margin:
            const pdfLib.EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 10),
        //CABECALHO DO PDF
        header: (context) => pdfLib.Column(
              children: [
                pdfLib.Container(
                  alignment: pdfLib.Alignment.centerRight,
                  child: pdfLib.Column(children: [
                    pdfLib.Image(pdfLib.MemoryImage(image),
                        width: 50, height: 50),
                    pdfLib.Text(Textos.nomeIgreja),
                  ]),
                ),
                pdfLib.SizedBox(height: 5),
                pdfLib.Text(Textos.txtCabecalhoPDF,
                    textAlign: pdfLib.TextAlign.center),
              ],
            ),
        //RODAPE DO PDF
        footer: (context) => pdfLib.Column(children: [
              pdfLib.Container(
                child: pdfLib.Text(Textos.txtRodapePDF,
                    textAlign: pdfLib.TextAlign.center),
              ),
              pdfLib.Container(
                  padding: const pdfLib.EdgeInsets.only(
                      left: 0.0, top: 10.0, bottom: 0.0, right: 0.0),
                  alignment: pdfLib.Alignment.centerRight,
                  child: pdfLib.Container(
                    alignment: pdfLib.Alignment.centerRight,
                    child: pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.end,
                        children: [
                          pdfLib.Text(Textos.txtGeradoApk,
                              textAlign: pdfLib.TextAlign.center),
                          pdfLib.SizedBox(width: 10),
                          pdfLib.Image(pdfLib.MemoryImage(imageLogo),
                              width: 20, height: 20),
                        ]),
                  )),
            ]),
        pageFormat: PdfPageFormat.a4,
        orientation: pdfLib.PageOrientation.portrait,
        //CORPO DO PDF
        build: (context) => [
              pdfLib.SizedBox(height: 20),
              pdfLib.Table.fromTextArray(
                  cellPadding: const pdfLib.EdgeInsets.symmetric(
                      horizontal: 0.0, vertical: 0.0),
                  headerPadding: const pdfLib.EdgeInsets.symmetric(
                      horizontal: 0.0, vertical: 5.0),
                  cellAlignment: pdfLib.Alignment.center,
                  data: listagemDados()),
            ]));

    List<int> bytes = await pdf.save();
    salvarPDF(bytes, '$nomeEscala.pdf');
    listaEscala = [];
    listaLegenda = [];
  }

  listagemDados() {
    if (exibirMesaApoio) {
      return <List<String>>[
        listaLegenda,
        ...listaEscala.map((e) {
          return [
            e.data,
            e.horarioTroca,
            e.primeiroHorarioEntrada,
            e.segundoHorarioEntrada,
            e.mesaApoio,
            e.uniforme,
            e.servirSantaCeia,
            e.recolherOferta,
            e.irmaoReserva
          ];
        }),
      ];
    } else {
      return <List<String>>[
        listaLegenda,
        ...listaEscala.map((e) => [
              e.data,
              e.horarioTroca,
              e.primeiroHorarioPulpito,
              e.segundoHorarioPulpito,
              e.primeiroHorarioEntrada,
              e.segundoHorarioEntrada,
              e.uniforme,
              e.servirSantaCeia,
              e.recolherOferta,
              e.irmaoReserva
            ])
      ];
    }
  }
}
