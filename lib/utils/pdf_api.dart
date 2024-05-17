import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:yapple/utils/customer.dart';
import 'package:yapple/utils/invoice.dart';
import 'package:yapple/utils/supplier.dart';

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

  static pw.Widget buildHeader(Invoice invoice) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(height: 1 * PdfPageFormat.cm),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              buildSupplierAddress(invoice.supplier),
              pw.Container(
                height: 50,
                width: 50,
                child: pw.BarcodeWidget(
                  barcode: pw.Barcode.qrCode(),
                  data: invoice.info.number,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 1 * PdfPageFormat.cm),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              buildCustomerAddress(invoice.customer),
              buildInvoiceInfo(invoice.info),
            ],
          ),
        ],
      );

  static pw.Widget buildCustomerAddress(Customer customer) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(customer.name,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text(customer.address),
        ],
      );

  static pw.Widget buildInvoiceInfo(InvoiceInfo info) {
    final paymentTerms = '${info.dueDate.difference(info.date).inDays} days';
    final titles = <String>[
      'Invoice Number:',
      'Invoice Date:',
      'Payment Terms:',
      'Due Date:'
    ];
    final data = <String>[
      info.number,
      Utils.formatDate(info.date),
      paymentTerms,
      Utils.formatDate(info.dueDate),
    ];

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

  static pw.Widget buildSupplierAddress(Supplier supplier) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(supplier.name,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 1 * PdfPageFormat.mm),
          pw.Text(supplier.address),
        ],
      );

  static pw.Widget buildTitle(Invoice invoice) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Fist PDF',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 0.8 * PdfPageFormat.cm),
          pw.Text(invoice.info.description),
          pw.SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static pw.Widget buildInvoice(Invoice invoice) {
    final headers = [
      'Description',
      'Date',
      'Quantity',
      'Unit Price',
      'VAT',
      'Total'
    ];
    final data = invoice.items.map((item) {
      final total = item.unitPrice * item.quantity * (1 + item.vat);

      return [
        item.description,
        Utils.formatDate(item.date),
        '${item.quantity}',
        '\$ ${item.unitPrice}',
        '${item.vat} %',
        '\$ ${total.toStringAsFixed(2)}',
      ];
    }).toList();

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerRight,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
        4: pw.Alignment.centerRight,
        5: pw.Alignment.centerRight,
      },
    );
  }

  static pw.Widget buildTotal(Invoice invoice) {
    final netTotal = invoice.items
        .map((item) => item.unitPrice * item.quantity)
        .reduce((item1, item2) => item1 + item2);
    final vatPercent = invoice.items.first.vat;
    final vat = netTotal * vatPercent;
    final total = netTotal + vat;

    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.Row(
        children: [
          pw.Spacer(flex: 6),
          pw.Expanded(
            flex: 4,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Net total',
                  value: Utils.formatPrice(netTotal),
                  unite: true,
                ),
                buildText(
                  title: 'Vat ${vatPercent * 100} %',
                  value: Utils.formatPrice(vat),
                  unite: true,
                ),
                pw.Divider(),
                buildText(
                  title: 'Total amount due',
                  titleStyle: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  value: Utils.formatPrice(total),
                  unite: true,
                ),
                pw.SizedBox(height: 2 * PdfPageFormat.mm),
                pw.Container(height: 1, color: PdfColors.grey400),
                pw.SizedBox(height: 0.5 * PdfPageFormat.mm),
                pw.Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget buildFooter(Invoice invoice) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Divider(),
          pw.SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(title: 'Address', value: invoice.supplier.address),
          pw.SizedBox(height: 1 * PdfPageFormat.mm),
          buildSimpleText(title: 'Paypal', value: invoice.supplier.paymentInfo),
        ],
      );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = pw.TextStyle(fontWeight: pw.FontWeight.bold);

    return pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Text(title, style: style),
        pw.SizedBox(width: 2 * PdfPageFormat.mm),
        pw.Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    pw.TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? pw.TextStyle(fontWeight: pw.FontWeight.bold);

    return pw.Container(
      width: width,
      child: pw.Row(
        children: [
          pw.Expanded(child: pw.Text(title, style: style)),
          pw.Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}

class Utils {
  static formatPrice(double price) => '\$ ${price.toStringAsFixed(2)}';
  static formatDate(DateTime date) => DateFormat.yMd().format(date);
}
