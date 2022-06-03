import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_frontend_test/model/value_objects/relaciones_analiticas.dart';
import 'package:flutter_frontend_test/model/tools/convertidor_data_table.dart';
import 'package:flutter_frontend_test/model/widgets/simple_elevated_button.dart';
import 'package:flutter_frontend_test/screens/elegir_empresas.dart';
import 'package:flutter_frontend_test/screens/home.dart';
import 'package:flutter_frontend_test/screens/login_signin/BackgroundPage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import '../env.sample.dart';
import 'package:flutter_frontend_test/model/widgets/progress_bar.dart';
import 'dart:developer' as developer;
import 'dart:html'; //Para PDF
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../model/widgets/general_app_bar.dart'; //Para PDF

class MRelacionesAnaliticas extends StatefulWidget {
  const MRelacionesAnaliticas({Key? key}) : super(key: key);
  @override
  State<MRelacionesAnaliticas> createState() => RelacionesAnaliticasState();
}

class RelacionesAnaliticasState extends State<MRelacionesAnaliticas> {
  late Future<RelacionesAnaliticas> relacionesAnaliticas;
  late RelacionesAnaliticas relacionesAnaliticas2;
  late String nombreEmpresa;
  late ConvertidorDataTable convertidor;
  ElegirEmpresaState elegirEmpresaData = ElegirEmpresaState();

  @override
  void initState() {
    super.initState();
    relacionesAnaliticas = getRelacionesAnaliticas();
    getNombreDeEmpresa();
  }

  Future<void> getNombreDeEmpresa() async {
    nombreEmpresa = await elegirEmpresaData.getNombreEmpresa();
  }

  Future<RelacionesAnaliticas> getRelacionesAnaliticas() async {
    var idEmpresa = await elegirEmpresaData.getIdEmpresa();
    final response = await http.get(Uri.parse(
        "${Env.URL_PREFIX}/contabilidad/reportes/empresas/$idEmpresa/relaciones-analiticas"));

    developer.log(jsonDecode(response.body).toString(),
        name: "RelacionesAnaliticas");

    developer.log(jsonDecode(response.body).runtimeType.toString(),
        name: "RelacionesAnaliticasTipo");

    final relacionesAnaliticas =
        RelacionesAnaliticas.fromJson(jsonDecode(response.body));

    developer.log(relacionesAnaliticas.movimientos[0][0].toString(),
        name: "RelacionesAnaliticasMovimiento");

    return relacionesAnaliticas;
  }

  List<DataCell> _createCells(datos) {
    List<DataCell> celdas = [];

    String type = datos[6].toString();
    // String type = "n";
    String acrdeud = datos[7].toString();
    // String acrdeud = "a";

    for (int i = 0; i < 6; i++) {
      Text text = Text(
        datos[i].toString(),
        textAlign: TextAlign.left,
      );
      if (type == "n") {
        if (acrdeud == "a") {
          text = Text(datos[i].toString(),
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.bold));
        } else {
          text = Text(datos[i].toString(),
              textAlign: TextAlign.left,
              style: const TextStyle(fontWeight: FontWeight.bold));
        }
      } else {
        if (acrdeud == "a") {
          text = Text(datos[i].toString(), textAlign: TextAlign.right);
        }
      }

      developer.log(text.textAlign.toString(), name: "texAlign");
      celdas.add(DataCell(text));
    }

    return celdas;
  }

  List<DataRow> _createRows(movimientos, totalCuentas, sumasIguales) {
    List<DataRow> renglon = [];

    renglon += movimientos.map<DataRow>((movimiento) {
      return DataRow(cells: _createCells(movimiento));
    }).toList();

    return renglon;
  }

  gridsillo(data) {
    //Create a new PDF document
    PdfDocument document = PdfDocument();
//Create a PdfGrid class
    PdfGrid grid = PdfGrid(); // Creación de la tabla

//Add the columns to the grid
    grid.columns
        .add(count: 6); //Poner el número de columnas (RelacionesAnaliticas: 6)

    grid.columns[0].width = 66;
    grid.columns[1].width = 130;
    grid.columns[2].width = 84;
    grid.columns[3].width = 76;
    grid.columns[4].width = 76;
    grid.columns[5].width = 84;
//Add header to the grid
    // grid.headers.add(2);
    // grid.headers.add(1);

//Add values to header
    PdfGridRow header = grid.headers.add(1)[0];
    header.cells[0].value = 'Cuenta';
    header.cells[1].value = 'Nombre';
    header.cells[2].value = 'Saldos iniciales\nDeudor Acreedor';
    header.cells[3].value = 'Cargos';
    header.cells[4].value = 'Abonos';
    header.cells[5].value = 'Saldos Actuales\nDeudor Acreedor';

//Format cells
    header.cells[0].style.stringFormat = PdfStringFormat(
        alignment: PdfTextAlignment.left,
        lineAlignment: PdfVerticalAlignment.top);

    header.cells[1].style.stringFormat = PdfStringFormat(
        alignment: PdfTextAlignment.left,
        lineAlignment: PdfVerticalAlignment.top);

    header.cells[1].style.textPen = PdfPens.mediumVioletRed;
    header.cells[2].style.backgroundBrush = PdfBrushes.yellow;
    header.cells[2].style.textBrush = PdfBrushes.darkOrange;

    PdfGridRow row1 = grid.rows.add();
    PdfGridRow row2 = grid.rows.add();

    row1.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightYellow,
      cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
      font: PdfStandardFont(PdfFontFamily.timesRoman, 17),
      textBrush: PdfBrushes.white,
      textPen: PdfPens.orange,
    );

    row2.cells[2].style.borders = PdfBorders(
        left: PdfPen(PdfColor(240, 0, 0), width: 2),
        top: PdfPen(PdfColor(0, 240, 0), width: 3),
        bottom: PdfPen(PdfColor(0, 0, 240), width: 4),
        right: PdfPen(PdfColor(240, 100, 240), width: 5));
    //data.ingreso.length
    for (int i = 0; i < data.movimientos.length; i++) {
      PdfGridRow curRow = grid.rows.add();
      //data.ingreso[i][0] data.ingreso[i][1] data.ingreso[i][2]
      curRow.cells[0].value = data.movimientos[i][0].toString();
      curRow.cells[1].value = data.movimientos[i][1].toString();
      curRow.cells[2].value = data.movimientos[i][2].toString();
      curRow.cells[3].value = data.movimientos[i][3].toString();
      curRow.cells[4].value = data.movimientos[i][4].toString();
      curRow.cells[5].value = data.movimientos[i][5].toString();

      //Si la linea va en negritas
      if (data.movimientos[i][6] == 'n') {
        curRow.style = PdfGridRowStyle(
            font: PdfStandardFont(PdfFontFamily.timesRoman, 10,
                style: PdfFontStyle.bold));
      }

      //Alineacion de lineas de saldos
      curRow.cells[2].style.stringFormat =
          PdfStringFormat(alignment: PdfTextAlignment.right);
      curRow.cells[5].style.stringFormat =
          PdfStringFormat(alignment: PdfTextAlignment.right);
      //Set de padding de lineas de saldos
      curRow.cells[2].style.cellPadding = PdfPaddings(right: 10);
      curRow.cells[5].style.cellPadding = PdfPaddings(right: 10);
      // Si es acreedora o deudora
      if (data.movimientos[i][7] == 'a') {
        curRow.cells[2].style.cellPadding = PdfPaddings(right: 20);
        curRow.cells[5].style.cellPadding = PdfPaddings(right: 20);
      }
    }
    //LO DE  ANGEL SE QUEDA HASTA AQUI
    /*
//Add rows to grid
    PdfGridRow row = grid.rows.add();
    row.cells[0].value = activoGrid;
    row.cells[1].value = pasivoGrid;
    row = grid.rows.add();
    row.cells[0].value = '';
    row.cells[1].value = capitalGrid;
 */
//Set the grid style
//AQUI VUELVES A GUIARTE

    grid.style = PdfGridStyle(
        cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 0),
        backgroundBrush: PdfBrushes.white,
        textBrush: PdfBrushes.black,
        borderOverlapStyle: PdfBorderOverlapStyle.overlap,
        font: PdfStandardFont(PdfFontFamily.timesRoman, 10));
//Draw the grid
    grid.draw(page: document.pages.add(), bounds: Rect.zero);
//Save the document.
    List<int> bytes = document.save();
//Dispose the document.
    document.dispose();

    AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
      ..setAttribute("download", "RelacionesAnaliticas.pdf")
      ..click();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      title: 'FinRep',
      home: Scaffold(
          appBar: GeneralAppBar(),
          floatingActionButton: FloatingActionButton(
            onPressed: () => gridsillo(relacionesAnaliticas2),
            backgroundColor: Colors.blue,
            child: const Icon(Icons.download),
          ),
          body: FutureBuilder<RelacionesAnaliticas>(
              future: relacionesAnaliticas,
              builder: (context, snapshot) {
                RelacionesAnaliticas datos = snapshot.data ??
                    RelacionesAnaliticas(movimientos: [
                      ['', '', '', '', '', '', '', '']
                    ], totalCuentas: [
                      ['', '', '', '', '', '', '', '']
                    ], sumasIguales: [
                      ['', '', '', '', '', '', '', '']
                    ]);
                relacionesAnaliticas2 = datos;
                if (snapshot.hasData) {
                  developer.log('Uno', name: 'TieneData');

                  return ListView(
                      children: [
                            SizedBox(height: screenHeight * .05),
                            Center(
                                child: Text(
                              "Relaciones Analiticas",
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade800,
                                  decoration: TextDecoration.none),
                            )),
                            SizedBox(height: screenHeight * .05),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(children: const [
                                  Text('FinRep',
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 16))
                                ]),
                                Column(children: const [Text('Empresa 1 S.C')]),
                                Column(children: const [
                                  Text('Fecha: 29/Abr/2022')
                                ]),
                              ],
                            ),
                            SizedBox(height: screenHeight * .12),
                            Expanded(
                              child: DataTable(
                                  columns: const <DataColumn>[
                                    DataColumn(
                                      label: Text(
                                        'Cuenta',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Nombre',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Saldos Iniciales \n Deudor  Acreedor',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        '\n Cargos',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        '\n Abonos',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Saldos Actuales \n Deudor  Acreedor',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                  rows: _createRows(datos.movimientos,
                                      datos.totalCuentas, datos.sumasIguales)
                                  //rows: createRows(snapshot.data?.ingresos),
                                  ),
                            )
                          ] +
                          [
                            const SizedBox(height: 25),
                            /*Center(
                                child: SimpleElevatedButton(
                              child:
                                  const Text("Descargar relaciones analiticas"),
                              color: Colors.blue,
                              onPressed: () => gridsillo(snapshot.data),
                              //getPDF(screenHeight, snapshot),
                            )),
                            const SizedBox(height: 25),
                            Center(
                                child: SimpleElevatedButton(
                              child: const Text("Volver"),
                              color: Colors.green,
                              onPressed: () => Get.back(),
                              //getPDF(screenHeight, snapshot),
                            )),
                            const SizedBox(height: 25),*/
                          ]);
                } else {
                  // developer.log('${snapshot.error}', name: 'NoTieneData55');
                  return const ProgressBar();
                  // return const ProgressBar();
                }
              })),
    );
  }
}
