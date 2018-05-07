# RateMe ANE V1.2.0 for Android+iOS
Rate AIR Native Extension lets you ask your users to rate your app in the most efficient way. i.e you can make sure you are asking for users feedback only when you are sure that they have found your app interesting and are using it frequently. This will help you avoid bad reviews as much as possible.

**Main Features:**
* Set the number of days from your app install time before promoting the rating dialog
* Set the number of app launches before promoting the rating dialog
* Set the number of days to remind a user to rate
* Customize the messages shown in the rating dialog
* Supports iOS app versioning rating system
* Choose between GooglePlay or Amazon stores.
* debug mode lets you point to other apps when you hit the *Rate Now!* button
* Optionally use the new iOS API **SKStoreReviewController**

# asdoc
[find the latest asdoc for this ANE here.](http://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/rateme/package-detail.html)  

[Download demo ANE](https://github.com/myflashlab/RateMe-ANE/tree/master/AIR/lib)

# AIR Usage
For more detailed usage sample [check the demo project](https://github.com/myflashlab/RateMe-ANE/blob/master/AIR/src/Main.as)
```actionscript
import com.myflashlab.air.extensions.rateme.RateMe;
import com.myflashlab.air.extensions.rateme.RateMeEvents;

// when releasing your app, make sure to initialize the ANE like: RateMe.init();
// setting the application id is not required. This will be done automatically but
// when debugging, considering that your app might not be available on app stores,
// this option here, lets you put ANY other application id so the rate dialog will
// take you to that page. This is just to make the debugging progress easier.
// NOTE: Android apps have an extra "air." at the beginning of their package name.
// you know that already, yes, but you don't need to add it here because the ANE will
// add that automatically. so if your package ID is "your.app", ANE will change it to 
// "air.your.app". Yet, if you enter "air.your.app", the ANE will not change it.
RateMe.init(true, "com.myflashlabs.app");

// add listeners to know user interaction with the RateMe dialog
RateMe.api.addEventListener(RateMeEvents.USER_ATTEMPT_TO_RATE, onUserAttemptToRate);
RateMe.api.addEventListener(RateMeEvents.USER_DECLINE_TO_RATE, onUserDeclineToRate);
RateMe.api.addEventListener(RateMeEvents.USER_REMIND_TO_RATE, onUserRemindedToRate);

// add other useful listeners
RateMe.api.addEventListener(RateMeEvents.ERROR, onRateMeError);
RateMe.api.addEventListener(RateMeEvents.DETECT_APP_UPDATE, onRateMeDetectediOSAppUpdate);
RateMe.api.addEventListener(RateMeEvents.DID_OPEN_STORE, onRateMeOpenedStore);
RateMe.api.addEventListener(RateMeEvents.DID_PROMOTE_FOR_RATING, onRateMeDialogShown);

// configure the RateMe ANE
RateMe.api.daysUntilPrompt = 10;
RateMe.api.launchesUntilPrompt = 10;
RateMe.api.remindPeriod = 1;
RateMe.api.autoPromote = false;

// configure the layout
RateMe.api.title = "title";
RateMe.api.message = "message!";
RateMe.api.remindBtnLabel = "rate me later";
RateMe.api.cancelBtnLabel = "Don't ask again";
RateMe.api.rateBtnLabel = "Rate Now!";

// configure iOS specific settings
RateMe.api.messageUpdate = "";
RateMe.api.promptForNewVersionIfUserRated = true;
RateMe.api.onlyPromptIfLatestVersion = false;
RateMe.api.appStoreID = 0;
RateMe.api.appStoreGenreID = 0;
RateMe.api.ratingsURL = "";
RateMe.api.useSKStoreReviewController = true;

// configure Android specific settings
RateMe.api.storeType = RateMe.GOOGLEPLAY; // or RateMe.AMAZON

// RateMe configurations will be effective only after you call the monitor method
RateMe.api.monitor();
```

# AIR .xml manifest
```xml
<!--
FOR ANDROID:
-->
<uses-permission android:name="android.permission.INTERNET" />



<!--
FOR iOS:
-->
<!--iOS 8.0 or higher can support this ANE-->
<key>MinimumOSVersion</key>
<string>8.0</string>



<!--
Embedding the ANE:
-->
  <extensions>

	<extensionID>com.myflashlab.air.extensions.rateMe</extensionID>
	
	<!-- download the dependency ANEs from https://github.com/myflashlab/common-dependencies-ANE -->
	<extensionID>com.myflashlab.air.extensions.dependency.androidSupport</extensionID>
	<extensionID>com.myflashlab.air.extensions.dependency.overrideAir</extensionID>
	
  </extensions>
-->
```

# Requirements 
* This ANE is dependent on **androidSupport.ane** and **overrideAir.ane**. Download them from [here](https://github.com/myflashlab/common-dependencies-ANE).
* Android API 15 or higher
* iOS SDK 8.0 or higher
* AIR SDK 20 or higher

# Commercial Version
http://www.myflashlabs.com/product/rate-app-air-native-extension/

![RateMe ANE](http://www.myflashlabs.com/wp-content/uploads/2016/06/product_adobe-air-ane-extension-rate-me-1-595x738.jpg)

# Tutorials
[How to embed ANEs into **FlashBuilder**, **FlashCC** and **FlashDevelop**](https://www.youtube.com/watch?v=Oubsb_3F3ec&list=PL_mmSjScdnxnSDTMYb1iDX4LemhIJrt1O)  

# Changelog
*May 7, 2018 - V1.2.0*
* Added support for iOS *SKStoreReviewController* API. enable it by setting the following property. ```RateMe.api.useSKStoreReviewController = true;```

*Dec 15, 2017 - V1.1.2*
* Optimized for [ANE-LAB software](https://github.com/myflashlab/ANE-LAB).

*Mar 27, 2017 - V1.1.1*
* Updated with the latest version of the OverrideAir and from now on you will need this dependency even if you are building for iOS
* min iOS version to support this ANE is 8.0 from now on.
* min Android version to support this ANE is 15 from now on.

*Nov 09, 2016 - V1.1.0*
* Optimized for Android manual permissions if you are targeting AIR SDK 24+
* From now on, this ANE will depend on androidSupport.ane and overrideAir.ane on the Android side


*Jun 29, 2016 - V1.0.0*
* beginning of the journey!

# DISCLAIMER
This ANE has been built based on the following two Libraries:
* https://github.com/hotchemi/Android-Rate
* https://github.com/nicklockwood/iRate