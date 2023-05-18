package com.template.foodexplorer;

import io.flutter.embedding.android.FlutterActivity;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;
//
//import com.paypal.android.sdk.payments.PayPalConfiguration;
//import com.paypal.android.sdk.payments.PayPalPayment;
//import com.paypal.android.sdk.payments.PayPalService;
//import com.paypal.android.sdk.payments.PaymentActivity;
//import com.paypal.android.sdk.payments.PaymentConfirmation;

import org.json.JSONException;

import java.math.BigDecimal;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;


public class MainActivity extends FlutterActivity {

//    private static PayPalConfiguration config;
//    String paymentDetail = null;
//    boolean done = false;
//    MethodChannel.Result resultGlobal;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {

        GeneratedPluginRegistrant.registerWith(flutterEngine);


        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), "paypal_payment")
                .setMethodCallHandler(new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
//                        if(call.method.equals("doPayment")){
//                            resultGlobal = result;
//                            String clientId = call.argument("clientId");
//                            String amount = call.argument("amount");
//                            String currency = call.argument("currency");
//                            boolean callDoPayement = call.argument("callDoPayment");
//                            //Toast.makeText(MainActivity.this, clientId, Toast.LENGTH_SHORT).show();
//                            if(callDoPayement){
//                                doPayment(clientId, amount, result, currency);
//                            }
//                            //result.success(paymentDetail);
//                        }
                    }
                });
    }

//    public void doPayment(String clientId, String amount, MethodChannel.Result result,String currency){
//        config = new PayPalConfiguration()
//                // Start with mock environment.  When ready, switch to sandbox (ENVIRONMENT_SANDBOX)
//                // or live (ENVIRONMENT_PRODUCTION)
//                .environment(PayPalConfiguration.ENVIRONMENT_SANDBOX)
//                .clientId(clientId);
//
//        Intent intent = new Intent(getApplicationContext(), PayPalService.class);
//        intent.putExtra(PayPalService.EXTRA_PAYPAL_CONFIGURATION, config);
//        startService(intent);
//
//        //paymentAmount = editTextAmount.getText().toString();
//
//        //Creating a paypalpayment
//        PayPalPayment payment = new PayPalPayment(new BigDecimal(String.valueOf(amount)), currency, "Order Charges",
//                PayPalPayment.PAYMENT_INTENT_SALE);
//
//        //Creating Paypal Payment activity intent
//        Intent intent2 = new Intent(this, PaymentActivity.class);
//
//        //putting the paypal configuration to the intent
//        intent2.putExtra(PayPalService.EXTRA_PAYPAL_CONFIGURATION, config);
//
//        //Puting paypal payment to the intent
//        intent2.putExtra(PaymentActivity.EXTRA_PAYMENT, payment);
//
//        startActivityForResult(intent2,7171);
//
//    }
//
//    @Override
//    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
//        //If the result is from paypal
//        if (requestCode == 7171) {
//
//            //If the result is OK i.e. user has not canceled the payment
//            if (resultCode == Activity.RESULT_OK) {
//                //Getting the payment confirmation
//                Toast.makeText(this, "Processing...", Toast.LENGTH_SHORT).show();
//                PaymentConfirmation confirm = data.getParcelableExtra(PaymentActivity.EXTRA_RESULT_CONFIRMATION);
//
//                //if confirmation is not null
//                if (confirm != null) {
//                    //Toast.makeText(this, "confirm != null", Toast.LENGTH_SHORT).show();
//                    try {
//                        //Getting the payment details
//                        String paymentDetails = confirm.toJSONObject().toString(4);
//                        Log.i("paymentExample", paymentDetails);
//                        paymentDetail = paymentDetails;
////                        SharedPreferences.Editor editor = getSharedPreferences("profile", MODE_PRIVATE).edit();
////                                editor.putString("details", paymentDetail);
////                                editor.apply();
//                        //SharedPreferences.Editor = SharedPreferences.OnSharedPreferenceChangeListener
//                        resultGlobal.success(paymentDetails);
//
//                    } catch (JSONException e) {
//                        Log.e("paymentExample", "an extremely unlikely failure occurred: ", e);
//                    }
//                }
//                else{
//                    Toast.makeText(this, "Error !", Toast.LENGTH_SHORT).show();
//                }
//            } else if (resultCode == Activity.RESULT_CANCELED) {
//                Log.i("paymentExample", "The user canceled.");
//            } else if (resultCode == PaymentActivity.RESULT_EXTRAS_INVALID) {
//                Log.i("paymentExample", "An invalid Payment or PayPalConfiguration was submitted. Please see the docs.");
//            }
//        }
//    }


}