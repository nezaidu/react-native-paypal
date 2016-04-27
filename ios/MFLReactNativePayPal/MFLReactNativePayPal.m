//
//  MFLReactNativePayPal.m
//  ReactPaypal
//
//  Created by Tj on 6/22/15.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

#import "MFLReactNativePayPal.h"
#import "RCTBridge.h"
#import "PayPalMobile.h"

NSString * const kPayPalPaymentStatusKey              = @"status";
NSString * const kPayPalPaymentConfirmationKey        = @"confirmation";

@interface MFLReactNativePayPal () <PayPalPaymentDelegate, RCTBridgeModule>

@property (copy) RCTResponseSenderBlock flowCompletedCallback;
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;

@end

@implementation MFLReactNativePayPal

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(presentPaymentViewControllerForPreparedPurchase:(RCTResponseSenderBlock)flowCompletedCallback)
{
  _payPalConfig = [[PayPalConfiguration alloc] init];

  _payPalConfig.acceptCreditCards = YES;
  _payPalConfig.merchantName = @"Awesome Shirts, Inc.";
  _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
  _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];

  self.flowCompletedCallback = flowCompletedCallback;

  PayPalFuturePaymentViewController *vc = [[PayPalFuturePaymentViewController alloc] initWithConfiguration:_payPalConfig delegate:self];

  UIViewController *visibleVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
  do {
    if ([visibleVC isKindOfClass:[UINavigationController class]]) {
      visibleVC = [(UINavigationController *)visibleVC visibleViewController];
    } else if (visibleVC.presentedViewController) {
      visibleVC = visibleVC.presentedViewController;
    }
  } while (visibleVC.presentedViewController);

  [visibleVC presentViewController:vc animated:YES completion:^{
    // self.flowCompletedCallback(@[[NSNull null]]);
  }];
}

- (void)payPalFuturePaymentViewController:(PayPalFuturePaymentViewController *)futurePaymentViewController
                 didAuthorizeFuturePayment:(NSDictionary *)futurePaymentAuthorization
{
  [futurePaymentViewController.presentingViewController dismissViewControllerAnimated:YES completion:^{
    if (self.flowCompletedCallback) {
      self.flowCompletedCallback(@[futurePaymentAuthorization]);
    }
  }];
}

- (void)payPalFuturePaymentDidCancel:(PayPalFuturePaymentViewController *)futurePaymentViewController {
  [futurePaymentViewController.presentingViewController dismissViewControllerAnimated:YES completion:^{
    self.flowCompletedCallback(@[[NSNull null]]);
  }];
}

@end