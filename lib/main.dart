import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'page/details.dart';
import 'widget/button_widget.dart';

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
  String qrCode = '-infinity';
  bool _scanned = false;
  final invalidQr = SnackBar(content: Text('Invalid QR Code. Try again...'));
  final snackBar = SnackBar(
      content: Text('Your car has been Unlocked. Have a safe journey.'));
  final wrongQr = SnackBar(
      content: Text(
          'This is not the correct QR code. Scan the QR code of your parking spot.'));

  Future<void> scanQRCode() async {
    final String qrCode = await FlutterBarcodeScanner.scanBarcode(
      'white',
      'Cancel',
      true,
      ScanMode.QR,
    );

    if (!mounted) return;

    setState(() {
      if (!_scanned) {
        if (qrCode.contains('assign_phoenix_code')) {
          this.qrCode = qrCode;
          _scanned = true;
          showDetails(qrCode);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(invalidQr);
        }
      }
      if (_scanned) {
        if (qrCode.replaceFirst('resign', '') ==
            this.qrCode.replaceFirst('assign', '')) {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Phoenix Parking Assistant'),
        ),
        body: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
