## Venmo iOS SDK

The Venmo AppSwitch SDK allows you to send Venmo payments & charges to any email, phone number or Venmo username from within your iOS App.

<img src="http://f.cl.ly/items/002c2V1v0b1A3S3Y1V0P/VenmoAPIDemo.png" width="100%" />

### Installation

The easiest way to get started is to use [CocoaPods](http://cocoapods.org/). Just add the following line to your Podfile:

```ruby
pod 'VENAppSwitchSDK', '~> 1.0.0'
```

### Usage

Using the Venmo iOS SDK is as easy as `Venmo`ing a friend.

#### 1. Create your app on Venmo
1. Create a new application on the [Venmo developer site](https://venmo.com/account/settings/developers).
2. Make a note of your Venmo developer ```app id``` and ```app secret```.

#### 2. Set up your Application URL Types

1. In your App target's ```Info``` section, scroll down to ```URL Types```.
2. Add a new URL Type with the following properties:

	```Identifier``` ==> ```venmo<<YOUR_APP_ID>>```
 
	```URL Schemes``` ==> ```venmo<<YOUR_APP_ID>>```

For example, if your app ID is ```1234```, put ```venmo1234```. Incase you lost it, you can find your app ID on the [Venmo developer site](https://venmo.com/account/settings/developers).

![Set URL Types](http://i.imgur.com/8rUXlFB.png)


#### 3. Initialize the Venmo AppSwitch SDK

Import the Venmo AppSwitch SDK main header in your ```AppDelegate```.

```obj-c
#import <VENAppSwitchSDK/VenmoSDK.h>
```

In your ```AppDelegate```, add the following code to initialize the SDK to the ```application:didFinishLaunchingWithOptions:``` method.

```obj-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
- 
    [VenmoSDK startWithAppId:@"VENMO_APP_ID" secret:@"VENMO_APP_SECRET" name:@"VENMO_APP_NAME"];
    
    return YES;
}
```

* ```VENMO_APP_ID```: ***ID*** from your registered app on the [Venmo developer site](https://venmo.com/account/settings/developers)
* ```VENMO_APP_SECRET```: ***Secret*** from your registered app on the [Venmo developer site](https://venmo.com/account/settings/developers)
* ```VENMO_APP_NAME```: The app name that will show up in the Venmo app (e.g. "sent via My Supercool App")

Next, tell the Venmo AppSwitch SDK when the App receives a url by adding the line ```[[VenmoSDK sharedClient] handleOpenURL:url];``` to the ```application:openURL:sourceApplication:annotation:``` method in your ```AppDelegate``` (if this method doesn't exist, create it).

```obj-c
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([[VenmoSDK sharedClient] handleOpenURL:url]) {
        return YES;
    }
    return NO;
}
```

Note: If you are using the old ```application:handleOpenURL:``` method, that's fine, but now may be a good time to migrate to ```application:openURL:sourceApplication:annotation:``` as it has now been deprecated.

#### 4. Send a payment

Sending a payment is achieved by constructing a ```VDKTransaction``` object with some basic properties. There is an initializer which will construct a valid, sendable payment: ```transactionWithType:amount:note:recipient:```.

This is then posted by calling the ```sendTransaction:withCompletionHandler:``` on the shared instance of ```VenmoSDK```. 

If the user has the Venmo app installed, they will be switched across to the Venmo app to complete the experience natively, otherwise a web experience will be shown.

 ```objc
 #import <VENAppSwitchSDK/VenmoSDK.h>
 ```
 
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

### Contributing
We welcome bugfixes and features in the AppSwitch SDK from the community. Feel free to make feature requests in the form of `Issues` or 

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
