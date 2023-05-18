import 'package:credit_card/credit_card_model.dart';
import 'package:credit_card/flutter_credit_card.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/AllText.dart';
import 'package:food_delivery/main.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:toast/toast.dart';

class MyCardDetails extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyCardDetailsState();
  }
}

class MyCardDetailsState extends State<MyCardDetails> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  Token _paymentToken = Token();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StripePayment.setOptions(
        StripeOptions(publishableKey: STRIPE_KEY,
            merchantId: STRIPE_MERCHANT_ID,
            androidPayMode: STRIPE_PAYMENT_MODE));
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //title: 'Flutter Credit Card View Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: <Widget>[
                  CreditCardWidget(
                    width: MediaQuery.of(context).size.width,
                    height: 190,
                    cardNumber: cardNumber,
                    expiryDate: expiryDate,
                    cardHolderName: cardHolderName,
                    cvvCode: cvvCode,
                    showBackView: isCvvFocused,
                  ),
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: CreditCardForm(
                        onCreditCardModelChange: onCreditCardModelChange,
                        cursorColor: THEME_COLOR,
                        themeColor: THEME_COLOR,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: THEME_COLOR,
                            padding: EdgeInsets.all(15),
                            onPressed: () async{
                              if(cardNumber.length < 12 && expiryDate.isEmpty && cvvCode.isEmpty){
                                Toast.show(INVALID_DETAILS, context);
                              }else{
                                CreditCard testCard = CreditCard(
                                  number: cardNumber,
                                  expMonth: int.parse(expiryDate.substring(0,2)),
                                  expYear: int.parse(expiryDate.substring(3),
                                  ),
                                );
                                await StripePayment.createTokenWithCard(
                                  testCard,
                                ).then((token) {
                                  print(token.tokenId);
                                  Navigator.pop(context,token.tokenId);
                                  //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Received ${token.tokenId}')));
                                  setState(() {
                                    _paymentToken = token;
                                  });
                                }).catchError((e){
                                  print("Error --> $e");
                                });
                              }
                            },
                            child: Text(SUBMIT),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}