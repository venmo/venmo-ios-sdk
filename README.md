Venmo App Switch iOS SDK Library
==============================

This open-source Cocoa Touch Static Library allows users of your app to pay or charge with Venmo. It switches to the Venmo app if it's installed on the device. Otherwise, it opens Venmo in a web view. When the transaction is complete, it switches back to your app.

If you just want to integrate the SDK, follow the directions [here](https://github.com/venmo/app-switch-ios-framework).

How to get up and running
-----------------
This framework uses https://github.com/kstenerud/iOS-Universal-Framework to build the framework. You should follow its directions to install dependencies.

Once you are finished, open the Venmo.xcodeproj file in Xcode. 

When you want to export the new version of the framework, go to Product > Archive, and it will open a Finder window showing you where it was exported so you can use it in another project.

If you need to debug the code, drag the whole project into the one you are working on.


Venmo SDK Apps
-----------------

* [Drinks On Me](https://github.com/venmo/drinks-on-me)
* [Splitwise](http://splitwise.com/)

<a name="contribute">Contributing to the Venmo App Switch iOS Library</a>
----------------------------------------------------------

* Fork this repo on GitHub, add your fork as a remote, add your changes and push.

        git remote add myusername git@github.com:myuser/app-switch-ios.git
        git push myusername master

* Send Venmo a pull request on GitHub.
