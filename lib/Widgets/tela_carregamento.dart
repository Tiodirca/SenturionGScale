import 'package:flutter/material.dart';

import '../Uteis/paleta_cores.dart';
import '../Uteis/textos.dart';

class TelaCarregamento extends StatelessWidget {
  const TelaCarregamento({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double larguraTela = MediaQuery.of(context).size.width;
    return Container(
        padding: const EdgeInsets.all(10),
        width: larguraTela * 0.9,
        height: 200,
        child: Card(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Textos.txtCarregamento,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(PaletaCores.corAzulAdtl),
                  strokeWidth: 2.0,
                )
              ],
            ),
          ),
        ));
  }
}
