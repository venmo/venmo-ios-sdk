Venmo App Switch iOS SDK Library
==============================

This open-source Cocoa Touch Static Library allows users of your app to pay or charge with Venmo. It switches to the Venmo app if it's installed on the device. Otherwise, it opens Venmo in a web view. When the transaction is complete, it switches back to your app.


Create a Venmo Application
--------------------------

First, create a new Venmo Application by visiting https://venmo.com/ 

Login and go to: Account > Developers > [New Application][1].

![Create new application](https://dl.dropbox.com/u/800/Captured/GbalC.png)


Project Setup
-------------

**NB: Follow these instructions *exactly* unless you know what you're doing.**

### Ensure you have the latest (released or beta) version of Xcode installed.

### Add Venmo as a [Git submodule][2] to the Libraries directory.

This will help you [pull in updates][3] and [make contributions][4].

    cd ~/Projects/DrinksOnMe/ # sample project root directory

    # Let's make a new directory called Libraries for third-party code.
    git submodule add https://github.com/venmo/venmo-your-friends-ios.git Libraries/Venmo
    git submodule update --init
    git commit -m 'Add Libraries/Venmo Git submodule.'


### Add the `Libraries` Directory to Your Xcode Project.

In Xcode, select your project (DrinksOnMe) at the top of the Project Navigator (⌘1), and press ⌥⌘A (File > Add Files to "DrinksOnMe"...). Select the `Libraries` directory (in `~/Projects/DrinksOnMe/`), and confirm that "Copy items..." is unchecked, "Create groups..." is selected, and all targets are unchecked. Then, click Add. Finally, for finess, drag & drop the Libraries group before the Frameworks group.

In Terminal, review and commit your changes:

    git diff -w -M --color-words HEAD
    git commit -am 'Add Libraries/Venmo to Xcode project.'


### Edit Your Target.

In Xcode, select your project (DrinksOnMe) at the top of the Project Navigator (⌘1), and then, select the target (DrinksOnMe) to which you want to add Venmo.

#### Add the Venmo URL Type

Select the "Info" tab. Add a URL Type with Identifier: `Venmo`, Role: `Editor`, and URL Schemes: `venmo1234`, where `1234` is your app ID.

#### [Edit Build Settings][6].

Select the "Build Settings" tab. (Make sure "All" is selected in the top left.)

* Search for "Header Search Paths," click on it, hit enter, paste `Libraries/Venmo`, and hit enter. (non-recursive)
* Do the same for "Other Linker Flags," except paste [`-ObjC -force_load ${BUILT_PRODUCTS_DIR}/libVenmo.a`][7].

#### [Edit Build Phases][5].

Select the "Build Phases" tab.

* Add Venmo to the "Target Dependencies" build phase.
* Add `libVenmo.a` to the "Link Binary With Libraries" build phase.

In Terminal, review and commit your changes:

    git diff -w -M --color-words HEAD
    git commit -am 'Edit target info, settings, and phases for Venmo.'


Using Venmo in Your App
-----------------------

* Import Venmo in any files that use it (and, to [reduce build times][8], in the precompiled header file, e.g., `DrinksOnMe-Prefix.pch`).

        #import <Venmo/Venmo.h>

* [Instantiate a `VenmoClient`][9]. Check out [`VenmoClient.h`][10].
* [Instantiate a `VenmoTransaction`][11]. Check out [`VenmoTransaction.h`][12].
* Call [`-[VenmoClient viewControllerWithTransaction:]`][13], which will open the Venmo app or return a [`VenmoViewController`][14].
* [Handle the redirect back to your app][15].


Troubleshooting
---------------

* `#import <Venmo/Venmo.h>` causes the compile-time error `'Venmo/Venmo.h' file not found`.

   This means the Header Search Path build setting doesn't match the Git submodule path (in `.gitmodules`). Both should be `Libraries/Venmo`. The Project Navigator group structure is irrelevant because it can differ from the file system's [directory structure][18], which is what really matters.


Venmo Sample Apps
-----------------

* [VenmoApp][16] (in this project)
* [Drinks On Me][17]


<a name="update">Updating the Venmo Your Friends iOS Library</a>
-----------------------------------------------

Pull in remote updates by running these commands from your project root directory:

    git submodule foreach 'git checkout master; git pull --rebase'
    git commit -am 'Update submodules to latest commits.'

Some of us find it useful to add an alias (to `~/.gitconfig`) for the first of the two commands above:

    git config --global alias.sup "submodule foreach 'git checkout master; git pull --rebase'"

Then, to pull in remote updates, you can just do:

    git sup


<a name="contribute">Contributing to the Venmo App Switch iOS Library</a>
----------------------------------------------------------

* Commit your changes.

        cd ~/Projects/DrinksOnMe/Libraries/Venmo
        git add -A
        git commit

* Fork this repo on GitHub, add your fork as a remote, and push.

        git remote add myusername git@github.com:myuser/app-switch-ios.git
        git push myusername master

* Send Venmo a pull request on GitHub.


  [1]: https://venmo.com/account/app/new
  [2]: http://book.git-scm.com/5_submodules.html
  [3]: #update
  [4]: #contribute
  [5]: http://j.mp/pBH1KE
  [6]: http://j.mp/mR5Jco
  [7]: http://developer.apple.com/library/mac/#qa/qa1490/_index.html
  [8]: http://disanji.net/iOS_Doc/#documentation/DeveloperTools/Conceptual/XcodeBuildSystem/800-Reducing_Build_Times/bs_speed_up_build.html
  [9]: https://github.com/venmo/app-switch-ios/blob/master/VenmoApp/AppDelegate.m#L18-19
  [10]: https://github.com/venmo/app-switch-ios/blob/master/Venmo/VenmoClient.h
  [11]: https://github.com/venmo/app-switch-ios/blob/master/VenmoApp/WelcomeViewController.m#L28-32
  [12]: https://github.com/venmo/app-switch-ios/blob/master/Venmo/VenmoTransaction.h
  [13]: https://github.com/venmo/app-switch-ios/blob/master/VenmoApp/WelcomeViewController.m#L63-64
  [14]: https://github.com/venmo/app-switch-ios/blob/master/Venmo/VenmoViewController.h
  [15]: https://github.com/venmo/app-switch-iosblob/master/VenmoApp/AppDelegate.m#L39-58
  [16]: https://github.com/venmo/app-switch-ios/tree/master/VenmoApp
  [17]: https://github.com/venmo/drinks-on-me
  [18]: http://en.wikipedia.org/wiki/Directory_structure
