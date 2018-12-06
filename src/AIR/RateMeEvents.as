package com.myflashlab.air.extensions.rateme
{
	import flash.events.Event;
	
	/**
	 * 
	 * @author Hadi Tavakoli - 6/28/2016 11:06 AM
	 */
	public class RateMeEvents extends Event
	{
		public static const ERROR:String = 					"onRateMeError";
		public static const DETECT_APP_UPDATE:String = 		"onRateMeDetectAppUpdate";
		public static const DID_PROMOTE_FOR_RATING:String = "onRateMeDidPromoteForRating";
		public static const USER_ATTEMPT_TO_RATE:String = 	"onRateMeUserAttemptToRate";
		public static const USER_DECLINE_TO_RATE:String = 	"onRateMeUserDeclineToRate";
		public static const USER_REMIND_TO_RATE:String = 	"onRateMeUserRemindToRate";
		public static const DID_OPEN_STORE:String = 		"onRateMeDidOpenStore";
		
		private var _msg:String;
		
		/**
		 * @private
		 * 
		 * @param	$type
		 * @param	$msg
		 */
		public function RateMeEvents($type:String, $msg:String=null):void
		{
			_msg = $msg;
			
			super($type, false, false);
		}
		
		public function get msg():String
		{
			return _msg;
		}
	}
	
}