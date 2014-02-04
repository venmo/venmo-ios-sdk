Venmo iOS SDK
=========

The Venmo iOS SDK allows your users to login and pay with Venmo right from your app.

Venmo SDK Apps
----

* [Drinks On Me](https://github.com/venmo/drinks-on-me)
* [Splitwise](http://splitwise.com/)

Installation
----

The easiest way to get started is to use [CocoaPods](http://cocoapods.org/). Just add the following line to your Podfile:

```ruby
pod 'VENAppSwitchSDK'
```

Sample Usage
----
Using the Venmo iOS SDK is an easy as Venmo'ing a friend.

### 1. Register your app on Venmo
1. Go to the [Venmo developer site](https://venmo.com/account/settings/developers).
2. Click 'new' to add a new application.
3. Fill out the form to register your app. You should now be able to see your app under 'view'. Keep this tab open; you'll reference it again soon.

### 2. Set up your app delegate

Make sure to
```obj-c
#import <VENAppSwitchSDK/VenmoSDK.h>
```

First, start the Venmo client in your app delegate's ```application:didFinishLaunchingWithOptions:``` method (or wherever you want to start the Venmo client).

```obj-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [VenmoSDK startWithAppId:@"your venmo app id" secret:@"your venmo app secret" name:@"the name of your app"];
    return YES;
}
```

* ```appId```: ***ID*** from your registered app on the Venmo developer site
* ```appSecret```: ***Secret*** from your registered app on the Venmo developer site
* ```appName```: The app name that will show up in the Venmo app (like "sent via My App Name")

Next, add ```[[VenmoSDK sharedClient] handleOpenURL:url]``` to your app delegate's ```application:openURL:sourceApplication:annotation:``` method (add the method too if it doesn't already exist).

```obj-c
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([[VenmoSDK sharedClient] handleOpenURL:url]) {
        return YES;
    }
    return NO;
}
```

### 3. Send a payment

Wherever you want to send a payment:

```obj-c
VDKTransaction *transaction = [VDKTransaction transactionWithType:VDKTransactionTypePay // or VDKTransactionTypeCharge
                                                           amount:100 // in pennies
                                                             note:@"This is my payment note."
                                                        recipient:@"username_or_email_or_phone"];
[[VenmoSDK sharedClient] sendTransaction:transaction withCompletionHandler:^(VDKTransaction *transaction, BOOL success, NSError *error) {
    if (success) {
        // Handle success case here.
        NSLog(@"Transaction succeeded!");
    } else {
        // Handle error case here.
        NSLog(@"Transaction failed with error: %@", [error localizedDescription]);
    }
}];
```

Make sure to ```#import <VENAppSwitchSDK/VenmoSDK.h>``` wherever you do this!

Version
----

1.0.0

License
----

MIT
