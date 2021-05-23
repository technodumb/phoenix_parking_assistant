import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../widget/button_widget.dart';
// import '../main.dart';

var resignQR;

// ignore: must_be_immutable
class DetailsPage extends StatelessWidget {
  String qrCode, floor, spot, assign;
  var decoded;
  DetailsPage({qrCode}) {
    this.qrCode = qrCode;
    decoded = this.qrCode.replaceFirst('assign_phoenix_code = ', '').split(' ');
    resignQR = this.qrCode.replaceFirst('assign', 'resign');
    floor = decoded[0];
    spot = decoded[1];
    // assign = decoded[2];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),
      body: Container(
        alignment: Alignment.center,
        // decoration: BoxDecoration(gradient: Gradient(colors: [])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  color: Colors.black,
                  data: resignQR ?? 'Hello world',
                  width: 200,
                  height: 200,
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$spot',
                    style: TextStyle(fontSize: 100, color: Colors.green))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('FLOOR: ',
                    style: TextStyle(fontSize: 30, fontFamily: 'Arial')),
                Text('$floor',
                    style: TextStyle(fontSize: 50, color: Colors.deepOrange))
              ],
            ),
            ButtonWidget(
              text: 'Go Back',
              onClicked: () => Navigator.pop(context),
            )
          ],
        ),
      ),
    );
  }
}
