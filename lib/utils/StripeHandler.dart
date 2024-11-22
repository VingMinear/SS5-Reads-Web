import 'dart:convert';
import 'dart:js' as js;

import 'package:homework3/utils/api_base_helper.dart';
import 'package:http/http.dart' as http;

class StripeService {
  // Function to initiate the payment
  static Future<void> makePayment() async {
    try {
      // 1. Fetch the client secret from your Flask backend
      final response = await http.get(
        Uri.parse(
            '${baseurl}create-payment-intent?amount=1000'), // Flask backend URL
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final clientSecret = data['clientSecret'];
        // Step 2: Initialize Stripe correctly
        final stripeJsObject =
            js.JsObject.fromBrowserObject(js.context['Stripe']);
        final stripe = stripeJsObject.callMethod('apply', [
          'pk_test_51PVAzHLRxnMedF0lJIyzjwMxm4VbYhbNQTIag4V8jcRP3cZyC0VwADRMvFbEsXY34gGpDvQ6Eln56qv60l68ZfaO00npQFRFMF'
        ]);

        // Step 3: Create Stripe Elements
        final elements = stripe.callMethod('elements', []);

        // Step 4: Create a card element using Stripe Elements
        final card = elements.callMethod('create', ['card']);

        // Step 5: Mount the card element into your HTML element
        card.callMethod('mount', [
          '#card-element'
        ]); // Make sure you have a div with id 'card-element'

        // Step 6: Handle the payment confirmation
        stripe.callMethod('confirmCardPayment', [clientSecret, card]).then(
            (result) {
          if (result['error'] != null) {
            print('Payment failed: ${result['error']['message']}');
          } else {
            print('Payment successful!');
          }
        });
      } else {
        print('Error creating payment intent: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
