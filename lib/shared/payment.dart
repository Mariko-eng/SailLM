import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterwave/flutterwave.dart';
import 'package:flutterwave/models/responses/charge_response.dart';
import 'package:sail_live_mobile/models/events.dart';
import 'package:sail_live_mobile/models/user.dart';
import 'package:sail_live_mobile/screens/home/create_event.dart';
import 'package:sail_live_mobile/services/database.dart';
import 'package:sail_live_mobile/shared/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class PaymentWidget extends StatefulWidget {
  final SailLiveEvent event;
  final SailLiveUser user;

  PaymentWidget({this.event, this.user});

  @override
  _PaymentWidgetState createState() => _PaymentWidgetState();
}

class _PaymentWidgetState extends State<PaymentWidget> {
  final String txref = Uuid().v4();
  final String currency = FlutterwaveCurrency.UGX;
  final _database = Database();

  String amount = '';
  String fullName = '';
  String phoneNumber = '';

  Future launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Failed to launch URL');
    }
  }

  @override
  Widget build(BuildContext context) {
    amount = widget.event.eventType != 'meeting'
        ? widget.event.price
        : (widget.event.emails.length * 5000)
            .toString()
            .replaceAllMapped(numReg, mathFunc);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Make Payment',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  'Full Name',
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: TextFormField(
                  onChanged: (value) => fullName = value,
                  validator: (value) =>
                      value.length > 0 ? null : 'Name can not be empty',
                  decoration:
                      textInputDecoration.copyWith(hintText: 'Full Name'),
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  'Phone Number',
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                  onChanged: (value) => phoneNumber = value,
                  validator: (value) => value.length != 10
                      ? null
                      : 'Phone Number can not be empty',
                  decoration:
                      textInputDecoration.copyWith(hintText: 'Phone Number'),
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  'TOTAL: UGX. $amount',
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: ButtonTheme(
                  child: RaisedButton(
                    onPressed: () async {
                      await beginPayment();
                      print('Done.');
                    },
                    color: Colors.green,
                    child: Text(
                      'Confirm Payment',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  beginPayment() async {
    final Flutterwave flutterwave = Flutterwave.forUIPayment(
        context: this.context,
        encryptionKey: "81d0f49ec9da0076f68abe6e",
        publicKey: "FLWPUBK-a32fa4ee5f8627b1876e5c84ece98d3b-X",
        currency: this.currency,
        amount: this.amount,
        email: widget.user.email,
        fullName: this.fullName,
        txRef: this.txref,
        isDebugMode: false,
        phoneNumber: this.phoneNumber,
        acceptCardPayment: true,
        acceptUSSDPayment: false,
        acceptAccountPayment: false,
        acceptFrancophoneMobileMoney: false,
        acceptGhanaPayment: false,
        acceptMpesaPayment: false,
        acceptRwandaMoneyPayment: false,
        acceptUgandaPayment: true,
        acceptZambiaPayment: false);

    try {
      final ChargeResponse response =
          await flutterwave.initializeForUiPayments();
      if (response == null) {
        // user didn't complete the transaction. Payment wasn't successful.
      } else {
        final isSuccessful = checkPaymentIsSuccessful(response);
        if (isSuccessful) {
          // provide value to customer
          if (widget.event.eventType == 'meeting') {
            await _database.createEvent(widget.event);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CreateEvent()));
            return;
          } else {
            await launchUrl(widget.event.broadcastURL);
            return;
          }
        } else {}
      }
    } catch (error) {
      print(error);
    }
  }

  bool checkPaymentIsSuccessful(final ChargeResponse response) {
    return response.data.status == FlutterwaveConstants.SUCCESSFUL &&
        response.data.currency == this.currency &&
        response.data.amount == this.amount &&
        response.data.txRef == this.txref;
  }
}
