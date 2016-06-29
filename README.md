# RateMe ANE V1.0.0 for Android+iOS
Rate Air Native Extension lets you ask your users to rate your app in the most efficient way. i.e you can make sure you are asking for users feedback only when you are sure that they have found your app interesting and are using it frequently. This will help you avoid bad reviews as much as possible.

**Main Features:**
* Set the number of days from your app install time before promoting the rating dialog
* Set the number of app launches before promoting the rating dialog
* Set the number of days to remind a user to rate
* Customize the messages shown in the rating dialog
* Supports iOS app versioning rating system
* Choose between GooglePlay or Amazon stores.
* debug mode lets you point to other apps when you hit the *Rate Now!* button

# asdoc
[find the latest asdoc for this ANE here.](http://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/rateme/package-detail.html)  

**NOTICE**: the demo ANE works only after you hit the "OK" button in the dialog which opens. in your tests make sure that you are NOT calling other ANE methods prior to hitting the "OK" button.
[Download the ANE](https://github.com/myflashlab/RateMe-ANE/tree/master/FD/lib)

# Air Usage
For more detailed usage sample [check the demo project](https://github.com/myflashlab/RateMe-ANE/blob/master/FD/src/Main.as)
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
RateMe.init(true, "com.site.app");

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

// configure Android specific settings
RateMe.api.storeType = RateMe.GOOGLEPLAY; // or RateMe.AMAZON

// RateMe configurations will be effective only after you call the monitor method
RateMe.api.monitor();
```

# Air .xml manifest
```xml
<!--
FOR ANDROID:
-->
<uses-permission android:name="android.permission.INTERNET" />



<!--
FOR iOS:
-->
<!--iOS 7.0 or higher can support this ANE-->
<key>MinimumOSVersion</key>
<string>7.0</string>



<!--
Embedding the ANE:
-->
  <extensions>
	<extensionID>com.myflashlab.air.extensions.rateMe</extensionID>
  </extensions>
-->
```

# Requirements 
1. Android API 10 or higher
2. iOS SDK 7.0 or higher
3. Air SDK 20 or higher

# Commercial Version
http://www.myflashlabs.com/product/rate-app-air-native-extension/

![RateMe ANE](http://www.myflashlabs.com/wp-content/uploads/2016/06/product_adobe-air-ane-extension-rateme-595x738.jpg)

# Tutorials
[How to embed ANEs into **FlashBuilder**, **FlashCC** and **FlashDevelop**](https://www.youtube.com/watch?v=Oubsb_3F3ec&list=PL_mmSjScdnxnSDTMYb1iDX4LemhIJrt1O)  

# Changelog
*Jun 29, 2016 - V1.0.0*
* beginning of the journey!

# DISCLAIMER
This ANE has been built based on the following two Libraries:
* https://github.com/hotchemi/Android-Rate
* https://github.com/nicklockwood/iRate