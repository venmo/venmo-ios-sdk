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
    git commit -am 'Add Venmo as a submodule & update --init.'


### Add Venmo to Your Xcode Project

In Xcode, select your project at the top of the Project Navigator (⌘1), and press Option-Command-N to create a new group. Name it, e.g., "Libraries." Then, with the Libraries group selected, press Option-Command-A to add files to your project, select `Venmo.xcodeproj` in `Libraries/Venmo/Venmo`, and confirm that "Copy items into destination group's folder (if needed)" is unchecked, "Create groups for any added folders" is selected, and all targets are unchecked. Then, click Add.

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

* Include Venmo in your app's prefix header file, e.g., `AppName-Prefix.pch`:

        #import <Venmo/Venmo.h>

* [Instantiate a `VenmoClient`][8]. Check out [`VenmoClient.h`][9].
* [Instantiate a `VenmoTransaction`][10]. Check out [`VenmoTransaction.h`][11].
* Call [`-[VenmoClient viewControllerWithTransaction:]`][12], which will open the Venmo app or return a [`VenmoViewController`][13].
* [Handle the redirect back to your app][14].


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
  [9]: https://github.com/venmo/venmo-ios-sdk/blob/master/Venmo/VenmoClient.h
  [10]: https://github.com/venmo/venmo-ios-sdk/blob/master/VenmoApp/WelcomeViewController.m#L28-32
  [11]: https://github.com/venmo/venmo-ios-sdk/blob/master/Venmo/VenmoTransaction.h
  [12]: https://github.com/venmo/venmo-ios-sdk/blob/master/VenmoApp/WelcomeViewController.m#L63-64
  [13]: https://github.com/venmo/venmo-ios-sdk/blob/master/Venmo/VenmoViewController.h
  [14]: https://github.com/venmo/venmo-ios-sdk/blob/master/VenmoApp/AppDelegate.m#L39-58