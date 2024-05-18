import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfAPI {
  static Future<File> saveDocument({
    required String name,
    required pw.Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getDownloadsDirectory();
    final file = File('${dir!.path}/$name');

    await file.writeAsBytes(bytes);
    print(file.path);

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

  static Future<File> generate(String url, String name, String id, String email, String major) async {
    final pdf = pw.Document();
    final cardPageFormat =
        PdfPageFormat(3.375 * PdfPageFormat.inch, 2.125 * PdfPageFormat.inch);
    final myColor = PdfColor(250 / 255, 112 / 255, 112 / 255);

    final imageBytes = await rootBundle.load('assets/yapple.png');

    final response = await http.get(Uri.parse(
        url));

    pw.MemoryImage? profile;

    if (response.statusCode == 200) {
      profile = pw.MemoryImage(
        response.bodyBytes,
      );
    } else {
      print('Could not load image');
    }

// Create a PdfImage object
    final image = pw.MemoryImage(
      imageBytes.buffer.asUint8List(),
    );

    // pdf.addPage(pw.MultiPage(
    //   build: (context) => [
    //     buildHeader(invoice),
    //     pw.SizedBox(height: 3 * PdfPageFormat.cm),
    //     buildTitle(invoice),
    //     buildInvoice(invoice),
    //     pw.Divider(),
    //     buildTotal(invoice),
    //   ],
    //   footer: (context) => buildFooter(invoice),
    // ));
    pdf.addPage(
      pw.Page(
        pageFormat: cardPageFormat,
        //orientation: pw.PageOrientation.landscape,
        build: (context) {
          return pw.Container(
            height: cardPageFormat.height,
            width: cardPageFormat.width,
            padding: pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              borderRadius: pw.BorderRadius.circular(10),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('STUDENT',
                        style: pw.TextStyle(
                            fontSize: 12, fontWeight: pw.FontWeight.bold)),
                    pw.Image(image, width: 70, height: 20),
                  ],
                ),
                pw.Divider(
                  color: myColor,
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'IDENTITY CARD',
                        ),
                        pw.SizedBox(height: 10),
                        pw.Row(
                          children: [
                            pw.Text(
                              'ID: ',
                              style: pw.TextStyle(color: myColor, fontSize: 10),
                            ),
                            pw.Text(
                              id,
                              style: pw.TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 6),
                        pw.Row(
                          children: [
                            pw.Text(
                              'Name: ',
                              style: pw.TextStyle(color: myColor, fontSize: 10),
                            ),
                            pw.Text(
                              name,
                              style: pw.TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 6),
                        pw.Row(
                          children: [
                            pw.Text(
                              'Email: ',
                              style: pw.TextStyle(color: myColor, fontSize: 10),
                            ),
                            pw.Text(
                              email,
                              style: pw.TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 6),
                        pw.Row(
                          children: [
                            pw.Text(
                              'Major: ',
                              style: pw.TextStyle(color: myColor, fontSize: 10),
                            ),
                            pw.Text(
                              major,
                              style: pw.TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                    pw.Container(
                      height: 70,
                      width: 70,
                      decoration: pw.BoxDecoration(
                        color: myColor,
                        borderRadius: pw.BorderRadius.circular(10),
                        border: pw.Border.all(
                          width: 2,
                        ),
                      ),
                      child: profile != null
                          ? pw.ClipRRect(
                              horizontalRadius: 10,
                              verticalRadius: 10,
                              child: pw.Image(profile),
                            )
                          : pw.Container(),
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );

    return saveDocument(name: 'StudentCard.pdf', pdf: pdf);
  }

}