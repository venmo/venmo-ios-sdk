Venmo iOS SDK
=============

This open-source Cocoa Touch Static Library allows users of your app to pay with Venmo.


[Create a Venmo Application][1]
-------------------------------


Project Setup
-------------

### Add Venmo as a [Git submodule][2]

This will help you [pull in updates][3] and [make contributions][4].

    cd ~/Projects/DrinksOnMe/ # sample project root directory

    # Let's make a new directory called Libraries for third-party code.
    git submodule add https://github.com/venmo/venmo-ios-sdk.git Libraries/Venmo
    git submodule update --init
    git commit -am 'Add Venmo as a submodule.'


### Add Venmo to Your Xcode Project

In Xcode, select your project at the top of the Project Navigator (⌘1), and press ⌥⌘N to create a new group. Name it, e.g., "Libraries." Then, select the Libraries group, press ⌥⌘0 to Show Utilities, click the small icon to the right just below Path, choose the Libraries directory. Drag the Libraries group to move it before the Frameworks group.

With the Libraries group selected, press ⌥⌘A to add files, select `Venmo.xcodeproj` in `Libraries/Venmo`, and confirm that "Copy items into destination group's folder (if needed)" is unchecked, "Create groups for any added folders" is selected, and all targets are unchecked. Then, click Add.

In Terminal, review and commit your changes:

    git diff -w -M --color-words HEAD
    git commit -am 'Add Libraries/Venmo group & Venmo project.'


### Edit Your Application Target's Settings

In Xcode, select your main Xcode project at the top of the Project Navigator (⌘1), and then, select the target to which you want to add Venmo.

#### [Edit Build Phases][5]

Select the "Build Phases" tab.

* Under the "Target Dependencies" group, click the plus button, select Venmo from the menu, and click Add.
* Under the "Link Binary With Libraries" group, click the plus button, select `libVenmo.a` from the menu, and click Add.

#### [Edit Build Settings][6]

Select the "Build Settings" tab. Make sure "All" is selected in the top left of the bar under the tabs.

* Search for "Header Search Paths," click on it, hit enter, paste `Libraries/Venmo`, and hit enter. (This leaves "Recursive" unchecked.)
* Do the same for "Other Linker Flags," except paste [`-ObjC -force_load ${BUILT_PRODUCTS_DIR}/libVenmo.a`][7]

#### Add the Venmo URL Type

Select the "Info" tab. Add a URL Type with Identifier: `Venmo`, Role: `Editor`, and URL Schemes: `venmo1234`, where `1234` is your app ID.

In Terminal, review and commit your changes:

    git diff -w -M --color-words HEAD
    git commit -am 'Edit target info, phases & settings for Venmo.'


Using Venmo in Your App
-----------------------

* Include Venmo in any files that use it:

        #import <Venmo/Venmo.h>
        
* To [reduce build times][8], create a precompiled header file. E.g., `AppName-Prefix.pch`:

        #include "AppName-Prefix.pch"

        #ifdef __OBJC__

        // Frameworks
        #import <Foundation/Foundation.h>

        // Libraries
        #import <Venmo/Venmo.h>

        #endif
        
    Specify the path to this precompiled header in your test target's Build Settings under Prefix Header.

* [Instantiate a `VenmoClient`][9]. Check out [`VenmoClient.h`][10].
* [Instantiate a `VenmoTransaction`][11]. Check out [`VenmoTransaction.h`][12].
* Call [`-[VenmoClient viewControllerWithTransaction:]`][13], which will open the Venmo app or return a [`VenmoViewController`][14].
* [Handle the redirect back to your app][15].


Venmo Sample App
----------------

Check out [Drinks On Me][16] for a sample iPhone app that uses the Venmo.


<a name="update">Updating the Venmo iOS SDK</a>
-----------------------------------------------

Pull in remote updates by running these commands from your project root directory:

    git submodule foreach 'git pull --rebase'
    git commit -am 'Update submodules to latest commit.'

You can add an alias (to `~/.gitconfig`) for the first of the two commands above:

    git config --global alias.sup "submodule foreach 'git pull --rebase'"

Then, to pull in remote updates, you can just do:

    git sup


<a name="contribute">Contributing to the Venmo iOS SDK</a>
----------------------------------------------------------

* Commit your changes.

        cd ~/Projects/DrinksOnMe/Libraries/Venmo
        git add -A
        git commit

* Fork this repo on GitHub, add your fork as a remote, and push.

        git remote add myuser git@github.com:myuser/venmo-ios-sdk.git
        git push myuser master

* Send Venmo a pull request on GitHub.


  [1]: https://venmo.com/account/app/new
  [2]: http://book.git-scm.com/5_submodules.html
  [3]: #update
  [4]: #contribute
  [5]: http://j.mp/pBH1KE
  [6]: http://j.mp/mR5Jco
  [7]: http://developer.apple.com/library/mac/#qa/qa1490/_index.html
  [8]: https://github.com/venmo/venmo-ios-sdk/blob/master/VenmoApp/AppDelegate.m#L18-19
  [9]: https://github.com/venmo/venmo-ios-sdk/blob/master/VenmoApp/AppDelegate.m#L18-19
  [10]: https://github.com/venmo/venmo-ios-sdk/blob/master/Venmo/VenmoClient.h
  [11]: https://github.com/venmo/venmo-ios-sdk/blob/master/VenmoApp/WelcomeViewController.m#L28-32
  [12]: https://github.com/venmo/venmo-ios-sdk/blob/master/Venmo/VenmoTransaction.h
  [13]: https://github.com/venmo/venmo-ios-sdk/blob/master/VenmoApp/WelcomeViewController.m#L63-64
  [14]: https://github.com/venmo/venmo-ios-sdk/blob/master/Venmo/VenmoViewController.h
  [15]: https://github.com/venmo/venmo-ios-sdk/blob/master/VenmoApp/AppDelegate.m#L39-58
  [16]: https://github.com/venmo/drinks-on-me
