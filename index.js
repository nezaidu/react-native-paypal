'use strict';

var {PayPal} = require('react-native').NativeModules;

var constants = {};
var constantNames = Object.keys(PayPal).filter(p => p == p.toUpperCase());
constantNames.forEach(c => constants[c] = PayPal[c]);

var functions = {
  paymentRequest(payPalParameters) {
    return new Promise(function(resolve, reject) {
      PayPal.paymentRequest(payPalParameters, resolve, reject);
    });
  },

  futurePayment(payPalParameters) {
    return new Promise(function(resolve, reject) {
      PayPal.futurePayment(payPalParameters, resolve, reject);
    });
  },

  getMetadataId() {
    return new Promise(function(resolve, reject) {
      PayPal.getMetadataId(resolve, reject);
    });
  },
};

var exported = {};
Object.assign(exported, constants, functions);

module.exports = exported;
