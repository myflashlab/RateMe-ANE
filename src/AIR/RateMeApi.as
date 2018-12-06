package com.myflashlab.air.extensions.rateme
{
	import flash.display.Stage;
	import flash.events.StatusEvent;
	import flash.events.Event;
	import flash.external.ExtensionContext;
	import flash.events.EventDispatcher;
	import flash.desktop.NativeApplication;
	
	/**
	 * This class is the entry point for using the RateMe ANE and must be accessed only through <code>RateMe.api.</code>
	 * after you initialized the ANE with <code>RateMe.init()</code> 
	 * 
	 * @author Hadi Tavakoli - 6/28/2016 11:00 AM
	 */
	public class RateMeApi extends EventDispatcher
	{
		private var _main:RateMe;
		private var _context:ExtensionContext;
		private var _os:String;
		
		// configPromotion
		private var _daysUntilPrompt:int = 10;
		private var _launchesUntilPrompt:int = 10;
		private var _remindPeriod:int = 1;
		
		// configLayout
		private var _title:String = "Promotion Title";
		private var _message:String = "Promotion Message";
		private var _remindBtnLabel:String = "Remind me later";
		private var _rateBtnLabel:String = "Rate Now";
		private var _cancelBtnLabel:String = "Don't ask again";
		
		// iOSConfig
		private var _messageUpdate:String = "";
		private var _appName:String = "";
		private var _promptForNewVersionIfUserRated:Boolean = true;
		private var _onlyPromptIfLatestVersion:Boolean = true;
		private var _appStoreID:Number = 0;
		private var _appStoreGenreID:Number = 0;
		private var _ratingsURL:String = "";
		private var _useSKStoreReviewController:Boolean = false;
		
		// AndroidConfig
		private var _storeType:int = RateMe.GOOGLEPLAY;
		
		private var _isMonitoring:Boolean;
		
		
		/** @private */
		public function RateMeApi($main:RateMe, $context:ExtensionContext, $os:String, $debugMode:Boolean, $appId:String):void
		{
			_main = $main;
			_context = $context;
			_os = $os;
			
			// add listener to the ANE
			_context.addEventListener(StatusEvent.STATUS, onStatus);
			
			// show a dialog on the test version of the extension
			if (RateMe.DEMO_ANE) _context.call("command", "isTestVersion");
			
			var appId:String = $appId;
			if (!appId) appId = NativeApplication.nativeApplication.applicationID;
			
			if (_os == RateMe.ANDROID && appId.indexOf("air.") != 0) appId = "air." + appId;
			
			_context.call("command", "init", $debugMode, appId);
		}
		
		private function onStatus(e:StatusEvent):void
		{
			_main.dispatchEvent(new StatusEvent(e.type, e.bubbles, e.cancelable, e.code, e.level));
			
			var arr:Array;
			
			switch (e.code) 
			{
				case RateMeEvents.ERROR:
					
					dispatchEvent(new RateMeEvents(RateMeEvents.ERROR, e.level));
					
					break;
				case RateMeEvents.DID_PROMOTE_FOR_RATING:
					
					dispatchEvent(new RateMeEvents(RateMeEvents.DID_PROMOTE_FOR_RATING));
					
					break;
				case RateMeEvents.DID_OPEN_STORE:
					
					dispatchEvent(new RateMeEvents(RateMeEvents.DID_OPEN_STORE));
					
					break;
				case RateMeEvents.DETECT_APP_UPDATE:
					
					dispatchEvent(new RateMeEvents(RateMeEvents.DETECT_APP_UPDATE));
					
					break;
				case RateMeEvents.USER_ATTEMPT_TO_RATE:
					
					dispatchEvent(new RateMeEvents(RateMeEvents.USER_ATTEMPT_TO_RATE));
					
					break;
				case RateMeEvents.USER_DECLINE_TO_RATE:
					
					dispatchEvent(new RateMeEvents(RateMeEvents.USER_DECLINE_TO_RATE));
					
					break;
				case RateMeEvents.USER_REMIND_TO_RATE:
					
					dispatchEvent(new RateMeEvents(RateMeEvents.USER_REMIND_TO_RATE));
					
					break;
			}
		}
		
		private function handleActivate(e:Event):void
		{
			_context.call("command", "promptIfAllCriteriaMet");
		}
		
// ------------------------------------------------------------------------------------------------------------------------------- override methods

		
	
// ---------------------------------------------------------------------------------------------------------------------------- Methods

		/** @private */
		internal function dispose():void
		{
			_daysUntilPrompt = 10;
			_launchesUntilPrompt = 10;
			_remindPeriod = 1;
			_title = "Promotion Title";
			_message = "Promotion Message";
			_remindBtnLabel = "Remind me later";
			_rateBtnLabel = "Rate Now";
			_cancelBtnLabel = "Don't ask again";
			_messageUpdate = "";
			_appName = "";
			_promptForNewVersionIfUserRated = true;
			_onlyPromptIfLatestVersion = true;
			_appStoreID = 0;
			_appStoreGenreID = 0;
			_ratingsURL = "";
			_useSKStoreReviewController = false;
			
			_storeType = RateMe.GOOGLEPLAY;
			
			_isMonitoring = false;
			
			_context.removeEventListener(StatusEvent.STATUS, onStatus);
			_context.call("command", "dispose");
			_context.dispose();
			_context = null;
		}
		
		/**
		 * starts monitoring your app <b>launch</b> and <b>installed</b> times to know if it should promote the rating dialog or not. You must call this
		 * method like <code>RateMe.api.monitor();</code> only after you have configured all the settings. If you ever needed to the RateMe
		 * settings inside your app, you have to call this method again after applying those changes to make sure the changes are effective.
		 */
		public function monitor():void
		{
			_context.call("command", "configPromotion", _daysUntilPrompt, _launchesUntilPrompt, _remindPeriod);
			_context.call("command", "configLayout", _title, _message, _remindBtnLabel, _rateBtnLabel, _cancelBtnLabel);
			if (_os == RateMe.IOS) _context.call("command", "iOSConfig", _messageUpdate, _appName, _promptForNewVersionIfUserRated, _onlyPromptIfLatestVersion, _appStoreID, _appStoreGenreID, _ratingsURL, _useSKStoreReviewController);
			else if (_os == RateMe.ANDROID) _context.call("command", "androidConfig", _storeType);
			
			if (!_isMonitoring) 
			{
				_context.call("command", "monitor");
				_isMonitoring = true;
			}
			
			if (autoPromote)
			{
				_context.call("command", "promptIfAllCriteriaMet");
				
				if (_os == RateMe.ANDROID) 
				{
					// to make the Android side work similar to the iOS side where the dialog is shown when user opens the app from background.
					NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, handleActivate);
				}
			}
			else
			{
				if(_os == RateMe.ANDROID) NativeApplication.nativeApplication.removeEventListener(Event.ACTIVATE, handleActivate);
			}
		}
		
		/**
		 * <p>
		 * This method will immediately trigger the rating prompt. If you are handeling RateMe manually, i.e you have set <code>
		 * RateMe.api.autoPromote = false;</code>, you can use this method to show the dialog when appropriate. To know when is the appropriate
		 * time, the <code>RateMe.api.shouldPromote</code> property can help you.
		 * </p>
		 * 
		 * <p>
		 * <b>Notice on iOS</b> This method depends on the <code>appStoreID</code> and <code>appStoreGenreID</code> properties, which are 
		 * only retrieved after polling the iTunes server, so if you intend to call this method directly, you will need to set these properties 
		 * yourself beforehand.
		 * </p>
		 * 
		 * @see #shouldPromote
		 */
		public function promote():void
		{
			_context.call("command", "promptRightNow");
		}

// ---------------------------------------------------------------------------------------------------------------------------- properties
		
		/**
		 * Returns <code>true</code> if the prompt criteria have been met, and <code>false</code> if they have not. You can use this to decide when to 
		 * display a rating prompt if you have disabled the automatic display at app launch.
		 */
		public function get shouldPromote():Boolean
		{
			return _context.call("command", "shouldPromote") as Boolean;
		}
		
		/**
		 * Set this to <code>false</code> to disable the rating prompt appearing automatically when the application launches or returns from the background. 
		 * The rating criteria will continue to be tracked, but the prompt will not be displayed automatically while this setting is in effect. You can use 
		 * this option if you wish to manually control display of the rating prompt.
		 */
		public function set autoPromote(a:Boolean):void
		{
			_context.call("command", "setAutoPromoteAtLaunch", a);
		}
		
		/** @private */
		public function get autoPromote():Boolean
		{
			return _context.call("command", "getAutoPromoteAtLaunch");
		}
		
		// ------------------------------------------------------- configPromotion
		
		/**
		 * This is the number of days the user must have had the app installed before they are prompted to rate it. 
		 * The time is measured from the first time the app is launched. The default value is 10 days.
		 */
		public function get daysUntilPrompt():int{return _daysUntilPrompt;}
		/** @private */
		public function set daysUntilPrompt(a:int):void{_daysUntilPrompt = a;}
		
		/**
		 * This is the minimum number of times the user must launch the app before they are prompted to rate it. 
		 * This avoids the scenario where a user runs the app once, doesn't look at it for weeks and then launches 
		 * it again, only to be immediately prompted to rate it. The minimum use count ensures that only frequent 
		 * users are prompted. The prompt will appear only after the specified number of days AND uses has been reached. 
		 * This defaults to 10 uses.
		 */
		public function get launchesUntilPrompt():int{return _launchesUntilPrompt;}
		/** @private */
		public function set launchesUntilPrompt(a:int):void{_launchesUntilPrompt = a;}	
		
		/**
		 * How long the app should wait before reminding a user to rate after they select the "remind me later" option 
		 * (measured in days). A value of zero means the app will remind the user next launch. Note that this value supersedes 
		 * the other criteria, so the app won't prompt for a rating during the reminder period, even if a new version is 
		 * released in the meantime. This defaults to 1 day.
		 */
		public function get remindPeriod():int{return _remindPeriod;}
		/** @private */
		public function set remindPeriod(a:int):void{_remindPeriod = a;}	
		
		// ------------------------------------------------------- configLayout
		
		/**
		 * The title displayed for the rating prompt. If you don't want to display a title then set this to "";
		 */
		public function get title():String{return _title;}
		/** @private */
		public function set title(a:String):void{_title = a;}
		
		/**
		 * The rating prompt message. This should be polite and courteous, but not too wordy.
		 */
		public function get message():String{return _message;}
		/** @private */
		public function set message(a:String):void{_message = a;}
		
		/**
		 * The button label for the button the user presses if they don't want to rate the app immediately, but do want 
		 * to be reminded about it in future. Set this to "" if you don't want to display the remind me button - e.g. 
		 * if you don't have space on screen.
		 */
		public function get remindBtnLabel():String{return _remindBtnLabel;}
		/** @private */
		public function set remindBtnLabel(a:String):void{_remindBtnLabel = a;}
		
		/**
		 * The button label for the button the user presses if they do want to rate the app.
		 */
		public function get rateBtnLabel():String{return _rateBtnLabel;}
		/** @private */
		public function set rateBtnLabel(a:String):void{_rateBtnLabel = a;}
		
		/**
		 * The button label for the button to dismiss the rating prompt without rating the app.
		 */
		public function get cancelBtnLabel():String{return _cancelBtnLabel;}
		/** @private */
		public function set cancelBtnLabel(a:String):void{_cancelBtnLabel = a;}
		
		
		// ------------------------------------------------------- iOSConfig
		
		/**
		 * (used in iOS only) This is a message to be used for users who have previously rated the app, encouraging them to re-rate. 
		 * This allows you to customise the message for these users. If you do not supply a custom message for this case, the standard 
		 * message will be used.
		 */
		public function get messageUpdate():String{return _messageUpdate;}
		/** @private */
		public function set messageUpdate(a:String):void{_messageUpdate = a;}
		
		/**
		 * @private
		 * (used in iOS only) This is the name of the app displayed in the RateMe alert box. It is set automatically from the application's 
		 * info.plist, but you may wish to override it with a shorter or longer version.
		 */
		public function get appName():String{return _appName;}
		/** @private */
		public function set appName(a:String):void{_appName = a;}
		
		/**
		 * (used in iOS only) Because iTunes ratings are version-specific, you ideally want users to rate each new version of your app. Users who really love 
		 * your app may be willing to update their review for new releases. Set promptForNewVersionIfUserRated to <code>true</code>, and RateMe 
		 * will prompt the user again each time they install an update until they decline to rate the app. If they decline, they will not be asked again.
		 */
		public function get promptForNewVersionIfUserRated():Boolean{return _promptForNewVersionIfUserRated;}
		/** @private */
		public function set promptForNewVersionIfUserRated(a:Boolean):void{_promptForNewVersionIfUserRated=a;}
		
		/**
		 * (used in iOS only) Set this to <code>false</code> to enabled the rating prompt to be displayed even if the user is not running the latest version of the app. 
		 * This defaults to <code>true</code> because that way users won't leave bad reviews due to bugs that you've already fixed, etc.
		 */
		public function get onlyPromptIfLatestVersion():Boolean{return _onlyPromptIfLatestVersion;}
		/** @private */
		public function set onlyPromptIfLatestVersion(a:Boolean):void{_onlyPromptIfLatestVersion=a;}
		
		/**
		 * (used in iOS only) This should match the iTunes app ID of your application, which you can get from iTunes connect after setting up your app. This value is not 
		 * normally necessary and is generally only required if you have the aforementioned conflict between bundle IDs for your Mac and iOS apps, 
		 * or in the case of Sandboxed Mac apps, if your app does not have network permission because it won't be able to fetch the appStoreID automatically 
		 * using iTunes services.
		 */
		public function get appStoreID():Number{return _appStoreID;}
		/** @private */
		public function set appStoreID(a:Number):void{_appStoreID=a;}
		
		/**
		 * (used in iOS only) This is the type of app, This is set automatically by calling an iTunes service, so you shouldn't need to set it manually for most purposes.
		 */
		public function get appStoreGenreID():Number{return _appStoreGenreID;}
		/** @private */
		public function set appStoreGenreID(a:Number):void{_appStoreGenreID=a;}
		
		/**
		 * (used in iOS only) The URL that the app will direct the user to so they can write a rating for the app. This is set to the correct value automatically.
		 */
		public function get ratingsURL():String{return _ratingsURL;}
		/** @private */
		public function set ratingsURL(a:String):void{_ratingsURL = a; }
		
		/**
		 * <p>
		 * (used in iOS only) indicates if the ANE should use the new in-app API for ratings. If set to true,
		 * the rating window will open inside your app without leaving your app at all.
		 * </p>
		 *
		 * <p> if you are using the new API, you can prompt for ratings up to three times in a 365-day period. Users
		 * will submit a rating through the standardized prompt, and can authenticate with Touch ID to write and submit
		 * a review. For more information about SKStoreReviewController API, read here:
		 * https://developer.apple.com/app-store/ratings-and-reviews/
		 * </p>
		 */
		public function get useSKStoreReviewController():Boolean{return _useSKStoreReviewController;}
		
		/** @private */
		public function set useSKStoreReviewController(a:Boolean):void{_useSKStoreReviewController = a;}
		
		// ------------------------------------------------------- AndroidConfig
		
		/**
		 * (used in Android only) Set the store type you wish to use for your rating. it's either <code>RateMe.GOOGLEPLAY</code> or <code>RateMe.AMAZON</code>
		 */
		public function get storeType():int{return _storeType;}
		/** @private */
		public function set storeType(a:int):void{_storeType = a;}
	}
}