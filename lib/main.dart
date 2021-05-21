import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'page/details.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phoenix Parking Assist',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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
  String qrCode = '-infinity';
  bool _scanned = false;

  Future<void> scanQRCode() async {
    final qrCode = await FlutterBarcodeScanner.scanBarcode(
      'white',
      'Cancel',
      true,
      ScanMode.QR,
    );

    if (!mounted) return;

    setState(() {
      this.qrCode = qrCode;
      if (this._scanned)
        _scanned = false;
      else
        _scanned = true;
      print(qrCode);
    });
  }

  void _show_details() {
    print('details');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Phoenix Parking Assistant'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => scanQRCode(),
                child: Image(
                  image: AssetImage('lib/image/scan-button.png'),
                ),
              ),
              Visibility(
                child: Text(
                  'Scan the QR code to assign your parking spot.',
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.center,
                ),
                visible: !_scanned,
              ),
              Visibility(
                child: ElevatedButton(
                  onPressed: () => _show_details(),
                  child: Text(
                    'Show parking details',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                visible: _scanned,
              )
            ],
          ),
        ));
  }
}
