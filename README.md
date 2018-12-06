# RateMe ANE for Adobe AIR apps #
Rate AIR Native Extension lets you ask your users to rate your app in the most efficient way. i.e you can make sure you are asking for users feedback only when you are sure that they have found your app interesting and are using it frequently. This will help you avoid bad reviews as much as possible.

**Main Features:**
1. Set the number of days from your app install time before promoting the rating dialog
1. Set the number of app launches before promoting the rating dialog
1. Set the number of days to remind a user to rate
1. Customize the messages shown in the rating dialog
1. Supports iOS app versioning rating system
1. Choose between GooglePlay or Amazon stores.
1. debug mode lets you point to other apps when you hit the *Rate Now!* button
1. Optionally use the new iOS API **SKStoreReviewController**


* [Click here for ASDOC](https://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/rateme/package-detail.html)
* [See the ANE setup requirements](https://github.com/myflashlab/RateMe-ANE/blob/master/src/ANE/extension.xml)

**IMPORTANT:** Implementing ANEs in your AIR projects means you may be required to add some [dependencies](https://github.com/myflashlab/common-dependencies-ANE) or copy some frameworks or editing your app's manifest file. Our ANE setup instruction is designed in a human-readable format but you may still need to familiarize yourself with this format. [Read this post for more information](https://www.myflashlabs.com/understanding-ane-setup-instruction/)

If you think manually setting up ANEs in your projects is confusing or time-consuming, you better check the [ANELAB Software](https://github.com/myflashlab/ANE-LAB/).

[![The ANE-LAB Software](https://www.myflashlabs.com/wp-content/uploads/2017/12/myflashlabs-ANE-LAB_features.jpg)](https://github.com/myflashlab/ANE-LAB/)

# Tech Support #
If you need our professional support to help you with implementing and using the ANE in your project, you can join [MyFlashLabs Club](https://www.myflashlabs.com/product/myflashlabs-club-membership/) or buy a [premium support package](https://www.myflashlabs.com/product/myflashlabs-support/). Otherwise, you may create new issues at this repository and the community might help you.

# DISCLAIMER #
This ANE has been built based on the following two Libraries:
* https://github.com/hotchemi/Android-Rate
* https://github.com/nicklockwood/iRate

# AIR Usage #
```actionscript
import com.myflashlab.air.extensions.rateme.*;

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

Are you using this ANE in your project? Maybe you'd like to buy us a beer :beer:?

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=payments@myflashlabs.com&lc=US&item_name=Donation+to+RateMe+ANE&no_note=0&cn=&currency_code=USD&bn=PP-DonationsBF:btn_donateCC_LG.gif:NonHosted)

Add your name to the below list? Donate anything more than $100 and it will be.

## Sponsored by... ##
<table align="left">
    <tr>
        <td align="left"><img src="https://via.placeholder.com/128?text=LOGO" width="60" height="60"></td>
        <td align="left"><a href="#">your_website.com</a><br>Your company motto can be here!</td>
    </tr>
</table>