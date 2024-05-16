
// import 'package:file_picker/file_picker.dart';
// import 'package:excel/excel.dart';

// Future<List<Map<String, dynamic>>> uploadAndConvertExcel() async {
//   List<Map<String, dynamic>> mapList = [];

//   // Pick the Excel file
//   FilePickerResult result = await FilePicker.platform
//       .pickFiles(type: FileType.custom, allowedExtensions: ['xlsx', 'xls']);

//   if (result != null) {
//     var bytes = result.files.single.bytes;
//     var excel = Excel.decodeBytes(bytes);

//     // Get the first sheet
//     var sheet = excel.tables.values.first;

//     // Get the column names
//     List<String> columnNames =
//         sheet.rows[0].map((cell) => cell.value.toString()).toList();

//     // Convert each row to a map
//     for (var row in sheet.rows.skip(1)) {
//       Map<String, dynamic> rowMap = {};
//       for (var i = 0; i < row.length; i++) {
//         rowMap[columnNames[i]] = row[i].value;
//       }
//       mapList.add(rowMap);
//     }
//   }

//   return mapList;
// }
