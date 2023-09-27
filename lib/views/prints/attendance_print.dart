import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../models/attendace_record_model.dart';
import '../../models/chorus_model.dart';

Future<Uint8List> generateAttendancePdf(PdfPageFormat pageFormat,List<AttendanceRecordModel> attenancesList, bool isPdf) async {

  final chorus = AttendanceModelforPdf(
      title: "Attendance",
      attenancesList: attenancesList
  );

  return await chorus.buildPdf(pageFormat,isPdf);
}

class AttendanceModelforPdf{

  AttendanceModelforPdf({required this.title, required this.attenancesList});
  String? title;
  List<AttendanceRecordModel> attenancesList = [];

  Future<Uint8List> buildPdf(PdfPageFormat pageFormat,bool isPdf) async {

    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.ListView.builder(
            itemCount: attenancesList.length,
            itemBuilder: (ctx,i){
              return pw.Container(
                margin: const pw.EdgeInsets.symmetric(vertical: 10),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(vertical: 10),
                        child:  pw.Text("Date : ${attenancesList[i].date!}")
                    ),
                    _contentTable(context,attenancesList[i].attendance!),
                  ]
                )
              );
            }
          ),
        ],
      ),
    );
    if(!isPdf) {
      Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save(),
      );
    }
    return doc.save();
  }

  pw.Widget _contentTable(pw.Context context,List<Attendance> attendances) {
    const tableHeaders = [
      'Si.NO',
      'Student Id',
      'Student Name',
      'Attendance'
    ];

    return pw.
    TableHelper.fromTextArray(
      border: null,
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: pw.BoxDecoration(
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
        //color: PdfColors.teal
      ),
      headerHeight: 25,
      cellHeight: 40,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.centerLeft,
        4: pw.Alignment.centerRight,
      },
      headerStyle: pw.TextStyle(
        color: PdfColors.amber,
        fontSize: 10,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        fontSize: 10,
      ),
      rowDecoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: PdfColors.black,
            width: .5,
          ),
        ),
      ),
      headers: List<String>.generate(
        tableHeaders.length,
            (col) => tableHeaders[col],
      ),
      data: List<List<String>>.generate(
        attendances.length,
            (row) => List<String>.generate(
          tableHeaders.length,
              (col) => attendances[row].getIndex(col,row),
        ),
      ),
    );
  }
}