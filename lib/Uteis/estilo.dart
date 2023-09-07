import 'package:flutter/material.dart';
import 'package:senturionglist/Uteis/paleta_cores.dart';

class Estilo {
  ThemeData get estiloGeral => ThemeData(
      primaryColor: PaletaCores.corAzulEscuro,
      fontFamily: 'Zubayr',
      appBarTheme: const AppBarTheme(
        color: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: PaletaCores.corAzulEscuro,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 2, color: PaletaCores.corAmarelaAdtlLetras),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      cardTheme: const CardTheme(

      ),
      inputDecorationTheme: InputDecorationTheme(
          errorStyle: const TextStyle(
              fontSize: 13, color: Colors.red, fontWeight: FontWeight.bold),
          hintStyle: const TextStyle(
              color: PaletaCores.corAzulEscuro, fontWeight: FontWeight.bold),
          focusedBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(width: 2, color: PaletaCores.corAzulEscuro),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(width: 2, color: PaletaCores.corAzulEscuro),
            borderRadius: BorderRadius.circular(20),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(width: 2, color: PaletaCores.corAzulEscuro),
            borderRadius: BorderRadius.circular(20),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: Colors.red),
            borderRadius: BorderRadius.circular(20),
          ),
          labelStyle: const TextStyle(
            color: PaletaCores.corAzulEscuro,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          )),

      // estilo dos botoes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          side: const BorderSide(color: PaletaCores.corAmarelaAdtlLetras, width: 1),
          shadowColor: PaletaCores.corRosaClaro,
          backgroundColor: Colors.white,
          elevation: 10,
          textStyle: const TextStyle(
              color: PaletaCores.corAzulEscuro,
              fontWeight: FontWeight.bold,
              fontSize: 19),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
      ));
}
