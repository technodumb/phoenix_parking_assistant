import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DetailsPage extends StatelessWidget {
  String qrCode, floor, spot, assign;
  var decoded;
  DetailsPage({qrCode}) {
    this.qrCode = qrCode;
    decoded = this.qrCode.replaceFirst('assign_phoenix_code = ', '').split(' ');

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
            Row(
              children: [
                Text('FLOOR: ',
                    style: TextStyle(fontSize: 40, fontFamily: 'Arial')),
                Text('$floor',
                    style: TextStyle(fontSize: 50, color: Colors.deepOrange))
              ],
            ),
            Text('SPOT: $spot'),
          ],
        ),
      ),
    );
  }
}
