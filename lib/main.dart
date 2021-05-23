import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:phoenix_parking_assistant/data_model.dart';
import 'page/details.dart';
import 'widget/button_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phoenix Parking Assist',
      theme: ThemeData.dark(),
      home: MyHomePage(
        title: 'Phoenix Parking Assistant',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var database = [];
  var spots = '';
  var filled = [];
  var parked;
  var condParked;

  String qrCode = '-infinity';
  bool _scanned = false;
  final invalidQr = SnackBar(content: Text('Invalid QR Code. Try again...'));
  final snackBar = SnackBar(
      content: Text('Your car has been Unlocked. Have a safe journey.'));
  final wrongQr = SnackBar(
      content: Text(
          'This is not the correct QR code. Scan the QR code of your parking spot.'));

  Future<void> getDataFromSheet() async {
    http.Response server = await http.get(Uri.parse(
        "https://script.google.com/macros/s/AKfycbzsY2uK3ml_3ofAG6FVn09g0YcmbQ2WOyo-8y4l4A/exec"));
    var jsonData = convert.jsonDecode(server.body);
    database.removeRange(0, database.length);
    jsonData.forEach((element) {
      DataModel model = new DataModel();
      model.spot = spots = element['spot'];
      model.parked = parked = element['parked'];
      model.condParked = condParked = element['condParked'];
      spots = model.spot;

      database.add(model);
    });
    print(database);
    setState(() {});
  }

  Future<void> scanQRCode() async {
    final String qrCode = await FlutterBarcodeScanner.scanBarcode(
      'white',
      'Cancel',
      true,
      ScanMode.QR,
    );
    getDataFromSheet();
    if (!mounted) return;

    setState(() {
      if (!_scanned) {
        if (qrCode.contains('assign_phoenix_code = ') &&
            qrCode.replaceFirst('assign_phoenix_code = ', '') == spots) {
          this.qrCode = qrCode;
          filled.add(qrCode.replaceFirst('assign_phoenix_code = ', ''));
          _scanned = true;
          showDetails(qrCode);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(invalidQr);
        }
      } else {
        if (qrCode.replaceFirst('resign', '') ==
            this.qrCode.replaceFirst('assign', '')) {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          filled.remove(qrCode.replaceFirst('resign_phoenix_code = ', ''));
          _scanned = false;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(wrongQr);
        }
      }
      print(qrCode);
    });
  }

  void showDetails(qrCode) {
    // print(qrCode);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DetailsPage(qrCode: qrCode.toString());
    }));
  }

  // void popup(){
  //   x =

  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Phoenix Parking Assistant'),
          actions: [
            IconButton(
                icon: Icon(Icons.refresh_outlined),
                onPressed: () => {getDataFromSheet()}),
            SizedBox(width: 20),
          ],
        ),
        body: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  'No. of spots avaliable - ${database.length - filled.length} of ${database.length}'),
              SizedBox(
                height: 50,
              ),
              IButtonWidget(
                imagepath: 'lib/image/scan-button.png',
                onClicked: () => scanQRCode(),
              ),
              SizedBox(
                height: 50,
              ),
              Visibility(
                child: Text(
                  'Click here\n to scan the QR Code',
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.center,
                ),
                visible: !_scanned,
              ),
              Visibility(
                child: ElevatedButton(
                  onPressed: () => showDetails(qrCode),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Parking Details ->',
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                visible: _scanned,
              )
            ],
          ),
        ));
  }
}
