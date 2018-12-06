package com.myflashlab.air.extensions.rateme
{
	import flash.events.EventDispatcher;
	import flash.external.ExtensionContext;
	import flash.events.StatusEvent;
	import flash.desktop.NativeApplication;
	import flash.system.Capabilities;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * <p>
	 * RateMe ANE lets you ask your users to rate your app in the most efficient way. i.e you can make sure you are asking for
	 * users feedback only when you are sure that they have found your app interesting and are using it frequently. RateMe ANE
	 * will let you set the number of days before the rating dialog should be promoted and also lets you set the number of 
	 * app launches plus many more configurations that will help you promote the rating dialog to only those who might leave
	 * a positive feedback.
	 * </p>
	 * 
	 * <p>
	 * This ANE has been built based on the following two Libraries:
	 * <ul>
	 * 	<li>https://github.com/hotchemi/Android-Rate</li>
	 * 	<li>https://github.com/nicklockwood/iRate</li>
	 * </ul>
	 * </p>
	 * 
	 * <p>
	 * Make sure to take care of the permissions manually if you are targeting AIR SDK 24+: 
	 * <b>https://github.com/myflashlab/RateMe-ANE/#permissions</b>
	 * </p>
	 * 
	 * @author Hadi Tavakoli - 6/29/2016 10:50 AM
	 */
	public class RateMe extends EventDispatcher
	{
		/** You don't have to set the <code>RateMe.api.storeType</code> for the iOS side because iOS has only one store anyway. */
		public static const APPLE:int = 0;
		
		/** set <code>RateMe.api.storeType</code> to GOOGLEPLAY so the ANE knows which store it should open */
		public static const GOOGLEPLAY:int = 1;
		
		/** set <code>RateMe.api.storeType</code> to AMAZON so the ANE knows which store it should open */
		public static const AMAZON:int = 2;
		
		public static const ANDROID:String = "android";
		public static const IOS:String = "ios";
		
		public static const EXTENSION_ID:String = "com.myflashlab.air.extensions.rateMe";
		public static const VERSION:String = "1.2.3";
		private var _context:ExtensionContext;
		
		private var _os:String;
		private static var _ex:RateMe;
		private var _api:RateMeApi;
		
		private var OverrideClass:Class;
		
		/** @private */
		public function RateMe($debugMode:Boolean, $appId:String):void
		{
			OverrideClass = getDefinitionByName("com.myflashlab.air.extensions.dependency.OverrideAir") as Class;
		
			// Tell Override ANE to read the ANE-LAB ID from the manifest. This must happen on Android and iOS.
			// Pass id/version of this ANE to Override ANE so it can check its validity.
			OverrideClass["applyToAneLab"](getQualifiedClassName(this));
			
			// initialize the context
			_context = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
			
			// find the current running OS
			if((Capabilities.os.indexOf("iPhone") > -1) || (Capabilities.os.indexOf("iPad") > -1)) _os = IOS;
			else _os = ANDROID;
			
			_api = new RateMeApi(this, _context, _os, $debugMode, $appId);
		}
		
// ------------------------------------------------------------------------------------------------------------------------------------ methods

		/**
		 * Call this method to initialize the RateMe ANE.
		 * 
		 * @param	$debugMode	set it to <code>true</code> and the rating dialog will always be shown. This is useful for debugging reasons.
		 * @param	$appId		Leave it as <code>null</code> and the extension will automatically find your package ID. Setting this parameter 
		 * is useful when you are debugging your app and it's not yet uploaded to the stores! This way, you can point it to another app just 
		 * for debugging reasons.
		 */
		public static function init($debugMode:Boolean=false, $appId:String=null):RateMe
		{
			if(!_ex) _ex = new RateMe($debugMode, $appId);
			
			return _ex;
		}
		
		/** @private */
		public static function dispose():void
		{
			if (!_ex) return;
			
			// dispose the api
			_ex._api.dispose();
			
			
			// And finally remove the instance
			_ex = null;
		}

// ------------------------------------------------------------------------------------------------------------------------------------ properties

		/** @private */
		public function get os():String
		{
			return _os;
		}
		
		/** @private */
		public function get context():ExtensionContext
		{
			return _context;
		}
		
		/**
		 * indicates if you are running this extension on an Android or an iOS device.
		 */
		public static function get os():String
		{
			if (!_ex) return null;
			
			return _ex._os;
		}
		
		/**
		 * Access to the RateMe API 
		 */
		public static function get api():RateMeApi
		{
			if (!_ex) return null;
			
			return _ex._api;
		}
		
// ------------------------------------------------------------------------------------------------------------------------------------ Check Club Member
		
		/** @private */
		public static const DEMO_ANE:Boolean = false;
	}
}