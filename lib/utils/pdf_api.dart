import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

class PdfAPI {
  static Future<File> generatePdf(String name) async {
    final pdf = Document();

    pdf.addPage(
      Page(
        build: (context) {
          return Center(
            child: Text('Hello World'),
          );
        },
      ),
    );

    // pdf.addPage(
    //   pw.Page(
    //     orientation: pw.PageOrientation.landscape,
    //     build: (context) {
    //       return pw.Center(
    //         child: pw.Container(
    //           width: 350,
    //           height: 220,
    //           padding: pw.EdgeInsets.all(12),
    //           decoration: pw.BoxDecoration(
    //             borderRadius: pw.BorderRadius.circular(10),
    //           ),
    //           child: pw.Column(
    //             crossAxisAlignment: pw.CrossAxisAlignment.start,
    //             children: [
    //               pw.Row(
    //                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    //                 crossAxisAlignment: pw.CrossAxisAlignment.end,
    //                 children: [
    //                   pw.Text('STUDENT',
    //                       style: pw.TextStyle(
    //                           fontSize: 22, fontWeight: pw.FontWeight.bold)),
    //                 ],
    //               ),
    //               pw.Divider(
    //                   color: PdfColor.fromInt(
    //                       Color.fromRGBO(250, 112, 112, 1).value)),
    //               pw.Row(
    //                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    //                 crossAxisAlignment: pw.CrossAxisAlignment.end,
    //                 children: [
    //                   pw.Column(
    //                     crossAxisAlignment: pw.CrossAxisAlignment.start,
    //                     children: [
    //                       pw.Text(
    //                         'IDENTITY CARD',
    //                       ),
    //                       pw.SizedBox(height: 10),
    //                       pw.Row(
    //                         children: [
    //                           pw.Text(
    //                             'ID: ',
    //                             style: pw.TextStyle(
    //                                 color: PdfColor.fromInt(
    //                                     Color.fromRGBO(250, 112, 112, 1)
    //                                         .value)),
    //                           ),
    //                           pw.Text('st20245452'),
    //                         ],
    //                       ),
    //                       pw.SizedBox(height: 3),
    //                       pw.Row(
    //                         children: [
    //                           pw.Text(
    //                             'Name: ',
    //                             style: pw.TextStyle(
    //                               color: PdfColor.fromInt(
    //                                   Color.fromRGBO(97, 54, 54, 1).value),
    //                             ),
    //                           ),
    //                           pw.Text('Sara'),
    //                         ],
    //                       ),
    //                       pw.SizedBox(height: 3),
    //                       pw.Row(
    //                         children: [
    //                           pw.Text(
    //                             'Email: ',
    //                             style: pw.TextStyle(
    //                               color: PdfColor.fromInt(
    //                                   Color.fromRGBO(250, 112, 112, 1).value),
    //                             ),
    //                           ),
    //                           pw.Text('s@gmail.com'),
    //                         ],
    //                       ),
    //                       pw.SizedBox(height: 3),
    //                       pw.Row(
    //                         children: [
    //                           pw.Text(
    //                             'Major: ',
    //                             style: pw.TextStyle(
    //                               color: PdfColor.fromInt(
    //                                   Color.fromRGBO(250, 112, 112, 1).value),
    //                             ),
    //                           ),
    //                           pw.Text('Computer Science'),
    //                         ],
    //                       ),
    //                     ],
    //                   ),
    //                   pw.Container(
    //                     height: 50,
    //                     width: 50,
    //                     decoration: pw.BoxDecoration(
    //                       border: pw.Border.all(
    //                         color: PdfColor.fromInt(
    //                             Color.fromRGBO(250, 112, 112, 1).value),
    //                         width: 2,
    //                       ),
    //                     ),
    //                   )
    //                 ],
    //               )
    //             ],
    //           ),
    //         ),
    //       );
    //     },
    //   ),
    // );

    return saveDocument(name, pdf);
  }

  static Future<File> saveDocument(String name, Document pdf) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name.pdf');
    print('asdsad');
    await file.writeAsBytes(bytes);
    final files = File(file.path);
    final externalDir = await getExternalStorageDirectory();
    final newFilePath = '${externalDir!.path}/$name.pdf';

    await files.copy(newFilePath);

    print('File moved to: $newFilePath');
    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;
    await OpenFile.open(url);
  }
}
