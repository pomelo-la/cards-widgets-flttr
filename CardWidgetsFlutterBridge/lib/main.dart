import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const platform = const MethodChannel('com.example.app/message');
  TextEditingController _messageController = TextEditingController();
  String _responseMessage = 'No message sent yet';

  void _launchActivationWidget() async {
    String responseMessage = "";
    try {
      responseMessage = await platform.invokeMethod('launchActivationWidget');
    } on PlatformException catch (e) {
      print("Failed to send message: '${e.message}'.");
    }
    setState(() {
      _responseMessage = responseMessage;
    });
  }

  void _launchPinWidget() async {
    String responseMessage = "";
    try {
      responseMessage = await platform.invokeMethod('launchPinWidget');
    } on PlatformException catch (e) {
      print("Failed to send message: '${e.message}'.");
    }
    setState(() {
      _responseMessage = responseMessage;
    });
  }

  void _launchBottomSheet() async {
    String responseMessage = "";
    try {
      responseMessage = await platform.invokeMethod('launchBottomSheetWidget');
    } on PlatformException catch (e) {
      print("Failed to send message: '${e.message}'.");
    }
    setState(() {
      _responseMessage = responseMessage;
    });
  }

  void _launchCardView() async {
    String responseMessage = "";
    try {
      responseMessage = await platform.invokeMethod('launchCardViewWidget');
    } on PlatformException catch (e) {
      print("Failed to send message: '${e.message}'.");
    }
    setState(() {
      _responseMessage = responseMessage;
    });
  }

  void _sendMessageToiOS(String message) async {
    String responseMessage = "";
    try {
      responseMessage =
          await platform.invokeMethod('sendMessageToiOS', {"message": message});
    } on PlatformException catch (e) {
      print("Failed to send message: '${e.message}'.");
    }
    setState(() {
      _responseMessage = responseMessage;
    });
  }

  @override
  void initState() {
    super.initState();

    platform.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case 'receivedMessageFromiOSSide':
          final result = await _cameFromIOSSide();
          return result;
        default:
          throw PlatformException(
            code: 'UNSUPPORTED_METHOD',
            message: 'Method ${call.method} not supported',
          );
      }
    });
  }

  void _onRowSelected(int index) {
    switch (index) {
      case 0:
        _launchCardView();
        break;
      case 1:
        _launchBottomSheet();
        break;
      case 2:
        _launchPinWidget();
        break;
      case 3:
        _launchActivationWidget();
        break;
    }
  }

  Future<String> _cameFromIOSSide() async {
    // Do something asynchronously
    return 'came from iOS';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter and iOS communication'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 16.0),
              DataTable(showCheckboxColumn: false, columns: [
                DataColumn(label: Text('Widgets'))
              ], rows: [
                DataRow(
                  cells: [DataCell(Text("CardView"))],
                  onSelectChanged: (newValue) {
                    _onRowSelected(0);
                  },
                ),
                DataRow(
                  cells: [DataCell(Text("Bottom Sheet"))],
                  onSelectChanged: (newValue) {
                    _onRowSelected(1);
                  },
                ),
                DataRow(
                  cells: [DataCell(Text("Pin"))],
                  onSelectChanged: (newValue) {
                    _onRowSelected(2);
                  },
                ),
                DataRow(
                  cells: [DataCell(Text("Activation"))],
                  onSelectChanged: (newValue) {
                    _onRowSelected(3);
                  },
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
