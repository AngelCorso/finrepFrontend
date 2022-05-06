import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class ConveridorDataTable {
  /*DataRow createRowBalanceGeneral(datos) {
    List<DataCell> celdas = [];

    celdas.add(DataCell(Text(datos[0])));
    celdas.add(DataCell(Text(datos[1])));

    DataRow renglon = DataRow(cells: celdas);

    return renglon;
  }*/

  DataRow createRow(datos) {
    List<DataCell> celdas = [];

    for (int i = 0; i < datos.length; i++) {
      celdas.add(DataCell(Text(datos[i])));
    }

    DataRow renglon = DataRow(cells: celdas);

    return renglon;
  }

  List<DataRow> createRowsGroup(data) {
    List<DataRow> grupoRenglones = [];

    for (int i = 0; i < data.length; i++) {
      DataRow curRow = createRow(data[i]);
      grupoRenglones.add(curRow);
    }

    return grupoRenglones;
  }

  List<DataRow> createRowsBalanceGeneral(datos) {
    List<DataRow> renglones = [];

    renglones.add(createRow(['CIRCULANTE', ' ']));
    renglones + createRowsGroup(datos.circulante);

    renglones.add(createRow(['FIJO', ' ']));
    renglones + createRowsGroup(datos.fijo);

    renglones.add(createRow(['DIFERIDO', ' ']));
    renglones + createRowsGroup(datos.diferido);

    return renglones;
  }

  List<DataRow> createRowsBalanceGeneralCapital(datos) {
    List<DataRow> renglones = [];

    renglones.add(createRow(['CAPITAL', ' ']));
    renglones + createRowsGroup(datos.capital);
    
    return renglones;
  }

  List<DataRow> createRowsEstadoGeneral(datos) {
    List<DataRow> renglones = [];

    renglones.add(createRow(['Ingresos', ' ']));
    renglones + createRowsGroup(datos.ingresos);

    renglones.add(createRow(['Egresos', ' ']));
    renglones + createRowsGroup(datos.egresos);

    renglones.add(createRow(['Utilidad (o Pérdida)', ' ']));
    renglones + createRowsGroup(datos.utilidad);

    return renglones;
  }
}