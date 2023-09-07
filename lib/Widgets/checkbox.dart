import 'package:flutter/material.dart';
import 'package:senturionglist/Modelo/checkbox.dart';
import 'package:senturionglist/Uteis/constantes.dart';
import 'package:senturionglist/Uteis/paleta_cores.dart';
import 'package:senturionglist/Widgets/barra_navegacao.dart';

class CheckboxWidget extends StatefulWidget {
  const CheckboxWidget(
      {Key? key,
      required this.item,
      required this.listaItens,
      required this.telaListagem})
      : super(key: key);

  final CheckBoxModel item;
  final List<CheckBoxModel> listaItens;
  final String telaListagem;

  @override
  _CheckboxWidgetState createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<CheckboxWidget> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      activeColor: PaletaCores.corAzulEscuro,
      checkColor: PaletaCores.corRosaClaro,
      title: Text(widget.item.texto,
          style: const TextStyle(color: Colors.black, fontSize: 20)),
      side: const BorderSide(width: 2, color: PaletaCores.corAzulEscuro),
      value: widget.item.checked,
      onChanged: (value) {
        setState(() {
          widget.item.checked = value!;
          verificarItensSelecionados();
          verificarSelecaoTrabalhoDiasEspecifico(
              BarraNavegacao.itensPessoasEspecificas,
              Constantes.listaTrabalhoEspecificoPessoas);
          verificarSelecaoTrabalhoDiasEspecifico(
              BarraNavegacao.itensDatasEspecificas,
              Constantes.listaTrabalhoEspecificoDias);
        });
      },
    );
  }

  verificarItensSelecionados() {
    //verificando cada elemento da lista
    for (var element in widget.listaItens) {
      //verificando se o item foi selecionado pelo usuario
      if (element.checked == true) {
        //verificando se na lista de pessoas selecionadas NAO contem o item
        // da lista desta tela caso nao contem adiciona o item na lista da barra de navegacao
        if (!BarraNavegacao.itensDiasSemanaSelecionados.contains(element) &&
            widget.telaListagem == Constantes.rotaTelaSelecaoDiasSemana) {
          BarraNavegacao.itensDiasSemanaSelecionados.add(element);
        }
      } else if (element.checked == false &&
          widget.telaListagem != Constantes.rotaTelaSelecaoDiasSemana) {
        // caso seja desmarcado pelo usuario remover
        // item da lista da barra de navegacao
        BarraNavegacao.itensDiasSemanaSelecionados.remove(element);
      }
    }
  }

  verificarSelecaoTrabalhoDiasEspecifico(
      List<String> lista, String tipoListagem) {
    //verificando cada elemento da lista
    for (var element in widget.listaItens) {
      //verificando se o item foi selecionado pelo usuario
      if (element.checked == true) {
        //verificando se na lista de pessoas selecionadas NAO contem o item
        // da lista desta tela caso nao contem adiciona o item na lista da barra de navegacao
        if (!lista.contains(element.texto) &&
            widget.telaListagem == tipoListagem) {
          lista.add(element.texto);
        }
      } else if (element.checked == false &&
          widget.telaListagem == tipoListagem) {
        // caso seja desmarcado pelo usuario remover
        // item da lista da barra de navegacao
        lista.remove(element.texto);
      }
    }
    return lista;
  }
}
