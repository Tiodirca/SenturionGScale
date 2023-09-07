import 'package:path_provider/path_provider.dart';
import 'package:senturionglist/Modelo/checkbox.dart';
import 'package:senturionglist/Modelo/locais_trabalho_cooperadores.dart';
import 'package:senturionglist/Uteis/constantes.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io' as io;
import 'package:path/path.dart' as p;

class BancoDados {
  var bancoDados;

  abirConexaoBancoDadosDesktop() async {
    sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfi;
    final io.Directory appDocumentsDir =
        await getApplicationDocumentsDirectory();
    String dbPath =
        p.join(appDocumentsDir.path, "databases", "bancoDadosScale.db");
    bancoDados = await databaseFactory.openDatabase(
      dbPath,
    );
  }

// metodo para criar tabela no banco de dados
  Future<bool> criarTabela(String SQL, String nomeTabela) async {
    await abirConexaoBancoDadosDesktop();
    try {
      await bancoDados.execute('''CREATE TABLE IF NOT EXISTS $nomeTabela
    (id INTEGER PRIMARY KEY, $SQL)''');
      print("criou Tabela");
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> inserirNomeCooperadores(
      String nomePessoa, String nomeTabela) async {
    await abirConexaoBancoDadosDesktop();
    try {
      await bancoDados.insert(nomeTabela,
          <String, Object?>{Constantes.nomeCooperadores: nomePessoa});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> inserirDadosEscalaCooperadores(
      String nomeTabela, LocaisTrabalhoCooperadores trabalhoCooperador) async {
    await abirConexaoBancoDadosDesktop();
    try {
      await bancoDados.insert(nomeTabela, <String, Object?>{
        Constantes.dataCulto: trabalhoCooperador.data,
        Constantes.primeiraHoraPulpito:
            trabalhoCooperador.primeiroHorarioPulpito,
        Constantes.segundaHoraPulpito: trabalhoCooperador.segundoHorarioPulpito,
        Constantes.primeiraHoraEntrada:
            trabalhoCooperador.primeiroHorarioEntrada,
        Constantes.segundaHoraEntrada: trabalhoCooperador.segundoHorarioEntrada,
        Constantes.mesaApoio: trabalhoCooperador.mesaApoio,
        Constantes.recolherOferta: trabalhoCooperador.recolherOferta,
        Constantes.uniforme: trabalhoCooperador.uniforme,
        Constantes.horarioTroca: trabalhoCooperador.horarioTroca,
        Constantes.servirSantaCeia: trabalhoCooperador.servirSantaCeia,
        Constantes.irmaoReserva: trabalhoCooperador.irmaoReserva,
      });
      print("Inseriou Dados");
      return true;
    } catch (e) {
      print(e.toString());
      print("Erros");
      return false;
    }
  }

  // metodo para recuperar dados no banco de dados
  Future<List<LocaisTrabalhoCooperadores>> recuperarDadosLista(
      String nomeTabela) async {
    await abirConexaoBancoDadosDesktop();
    List<Map> lista = await bancoDados.query(nomeTabela);
    List<LocaisTrabalhoCooperadores> listaFinal = [];
    for (var element in lista) {
      listaFinal.add(LocaisTrabalhoCooperadores(
          id: element[Constantes.idItem],
          data: element[Constantes.dataCulto],
          primeiroHorarioPulpito: element[Constantes.primeiraHoraPulpito],
          segundoHorarioPulpito: element[Constantes.segundaHoraPulpito],
          primeiroHorarioEntrada: element[Constantes.primeiraHoraEntrada],
          segundoHorarioEntrada: element[Constantes.segundaHoraEntrada],
          recolherOferta: element[Constantes.recolherOferta],
          mesaApoio: element[Constantes.mesaApoio].toString(),
          uniforme: element[Constantes.uniforme],
          horarioTroca: element[Constantes.horarioTroca],
          servirSantaCeia: element[Constantes.servirSantaCeia],
          irmaoReserva: element[Constantes.irmaoReserva]));
    }
    return listaFinal;
  }

// metodo para recuperar dados no banco de dados
  Future<List<CheckBoxModel>> recuperarNomeCooperadores(
      String nomeTabela) async {
    await abirConexaoBancoDadosDesktop();
    List<Map> lista = await bancoDados.rawQuery('SELECT * FROM $nomeTabela');
    List<CheckBoxModel> listaFinal = [];
    for (var element in lista) {
      listaFinal.add(CheckBoxModel(
          idItem: element.values.elementAt(0),
          texto: element.values.elementAt(1)));
    }
    return listaFinal;
  }

// metodo para recuperar dados no banco de dados
  Future<List<String>> recuperarEscalas() async {
    await abirConexaoBancoDadosDesktop();
    List<Map> lista = await bancoDados
        .rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
    List<String> listaFinal = [];
    for (var element in lista) {
      listaFinal.add(
          element.values.toString().replaceAll("(", "").replaceAll(")", ""));
    }
    listaFinal.removeWhere((element) =>
        element == Constantes.tipoCadastroCooperador ||
        element == Constantes.tipoCadastroCooperadora);
    return listaFinal;
  }

  Future<bool> excluirDado(int id, String nomeTabela) async {
    await abirConexaoBancoDadosDesktop();
    try {
      await bancoDados.execute('''DELETE FROM $nomeTabela WHERE id = $id''');
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> excluirTabela(String nomeTabela) async {
    await abirConexaoBancoDadosDesktop();
    try {
      await bancoDados.execute("DROP table $nomeTabela");
      return true;
    } catch (e) {
      return false;
    }
  }

//metodo para atualizar valores
  Future<bool> atualizarDados(
      LocaisTrabalhoCooperadores locaisTrabalhoCooperadores,
      String nomeTabela) async {
    await abirConexaoBancoDadosDesktop();
    try {
      await bancoDados.execute('''UPDATE $nomeTabela SET
    ${Constantes.dataCulto} = '${locaisTrabalhoCooperadores.data}',
    ${Constantes.primeiraHoraPulpito} = '${locaisTrabalhoCooperadores.primeiroHorarioPulpito}',
    ${Constantes.segundaHoraPulpito} = '${locaisTrabalhoCooperadores.segundoHorarioPulpito}',
    ${Constantes.primeiraHoraEntrada} = '${locaisTrabalhoCooperadores.primeiroHorarioEntrada}',
    ${Constantes.segundaHoraEntrada} = '${locaisTrabalhoCooperadores.segundoHorarioEntrada}',
    ${Constantes.mesaApoio} = '${locaisTrabalhoCooperadores.mesaApoio}',
    ${Constantes.recolherOferta} = '${locaisTrabalhoCooperadores.recolherOferta}',
     ${Constantes.uniforme} = '${locaisTrabalhoCooperadores.uniforme}',
    ${Constantes.horarioTroca} = '${locaisTrabalhoCooperadores.horarioTroca}',
     ${Constantes.servirSantaCeia} = '${locaisTrabalhoCooperadores.servirSantaCeia}',
    ${Constantes.irmaoReserva} = '${locaisTrabalhoCooperadores.irmaoReserva}'WHERE id = ${locaisTrabalhoCooperadores.id}
    ''');
      return true;
    } catch (e) {
      return false;
    }
  }

// // metodo para atualizar valores da tarefa
// Future<bool> atualizarDados(AnotacaoModelo anotacaoModelo) async {
//   await abirConexaoBancoDadosDesktop();
//   try {
//     await bancoDados.execute('''UPDATE ${Constantes.bancoNomeTabela} SET
//     ${Constantes.bancoNomeAnotacao} = '${anotacaoModelo.nomeAnotacao}',
//     ${Constantes.bancoConteudoAnotacao} = '${anotacaoModelo.conteudoAnotacao}',
//     ${Constantes.bancoStatusAnotacao} = '${anotacaoModelo.statusAnotacao}',
//     ${Constantes.bancoCorAnotacao} = '${anotacaoModelo.corAnotacao}',
//     ${Constantes.bancoData} = '${anotacaoModelo.data}',
//     ${Constantes.bancoHorario} = '${anotacaoModelo.horario}',
//     ${Constantes.bancoFavorito} = '${anotacaoModelo.favorito}',
//     ${Constantes.bancoNotificacaoAtiva} = '${anotacaoModelo.notificacaoAtiva}'WHERE id = ${anotacaoModelo.id}''');
//     return true;
//   } catch (e) {
//     return false;
//   }
// }
//
// // metodo para excluir dado
// Future<bool> excluirDado(int id) async {
//   await abirConexaoBancoDadosDesktop();
//   try {
//     await bancoDados.execute(
//         '''DELETE FROM ${Constantes.bancoNomeTabela} WHERE id = $id''');
//     return true;
//   } catch (e) {
//     return false;
//   }
// }
}
