package 
{
	import com.doitflash.consts.Direction;
	import com.doitflash.consts.Orientation;
	import com.doitflash.mobileProject.commonCpuSrc.DeviceInfo;
	import com.doitflash.starling.utils.list.List;
	import com.doitflash.text.modules.MySprite;
	
	import com.luaye.console.C;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.StatusEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import com.myflashlab.air.extensions.rateme.RateMe;
	import com.myflashlab.air.extensions.rateme.RateMeEvents;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 6/29/2016 11:46 AM
	 */
	public class Main extends Sprite 
	{
		private const BTN_WIDTH:Number = 150;
		private const BTN_HEIGHT:Number = 60;
		private const BTN_SPACE:Number = 2;
		private var _txt:TextField;
		private var _body:Sprite;
		private var _list:List;
		private var _numRows:int = 1;
		
		public function Main():void 
		{
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, handleActivate);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, handleDeactivate);
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke);
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, handleKeys);
			
			stage.addEventListener(Event.RESIZE, onResize);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			C.startOnStage(this, "`");
			C.commandLine = false;
			C.commandLineAllowed = false;
			C.x = 20;
			C.width = 250;
			C.height = 150;
			C.strongRef = true;
			C.visible = true;
			C.scaleX = C.scaleY = DeviceInfo.dpiScaleMultiplier;
			
			_txt = new TextField();
			_txt.autoSize = TextFieldAutoSize.LEFT;
			_txt.antiAliasType = AntiAliasType.ADVANCED;
			_txt.multiline = true;
			_txt.wordWrap = true;
			_txt.embedFonts = false;
			_txt.htmlText = "<font face='Arimo' color='#333333' size='20'><b>Smart RateMe ANE for Adobe Air V"+RateMe.VERSION+"</font>";
			_txt.scaleX = _txt.scaleY = DeviceInfo.dpiScaleMultiplier;
			this.addChild(_txt);
			
			_body = new Sprite();
			this.addChild(_body);
			
			_list = new List();
			_list.holder = _body;
			_list.itemsHolder = new Sprite();
			_list.orientation = Orientation.VERTICAL;
			_list.hDirection = Direction.LEFT_TO_RIGHT;
			_list.vDirection = Direction.TOP_TO_BOTTOM;
			_list.space = BTN_SPACE;
			
			init();
			onResize();
		}
		
		private function onInvoke(e:InvokeEvent):void
		{
			NativeApplication.nativeApplication.removeEventListener(InvokeEvent.INVOKE, onInvoke);
		}
		
		private function handleActivate(e:Event):void
		{
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
		}
		
		private function handleDeactivate(e:Event):void
		{
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;
		}
		
		private function handleKeys(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.BACK)
            {
				e.preventDefault();
				NativeApplication.nativeApplication.exit();
            }
		}
		
		private function onResize(e:*=null):void
		{
			if (_txt)
			{
				_txt.width = stage.stageWidth * (1 / DeviceInfo.dpiScaleMultiplier);
				
				C.x = 0;
				C.y = _txt.y + _txt.height + 0;
				C.width = stage.stageWidth * (1 / DeviceInfo.dpiScaleMultiplier);
				C.height = 300 * (1 / DeviceInfo.dpiScaleMultiplier);
			}
			
			if (_list)
			{
				_numRows = Math.floor(stage.stageWidth / (BTN_WIDTH * DeviceInfo.dpiScaleMultiplier + BTN_SPACE));
				_list.row = _numRows;
				_list.itemArrange();
			}
			
			if (_body)
			{
				_body.y = stage.stageHeight - _body.height;
			}
		}
		
		private function init():void
		{
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
			
			// configure Android specific settings
			RateMe.api.storeType = RateMe.GOOGLEPLAY; // or RateMe.AMAZON
			
			// RateMe configurations will be effective only after you call the monitor method
			RateMe.api.monitor();
			
			//----------------------------------------------------------------------
			
			var btn0:MySprite = createBtn("shouldPromote");
			btn0.addEventListener(MouseEvent.CLICK, shouldPromote);
			_list.add(btn0);
			
			function shouldPromote(e:MouseEvent):void
			{
				// Always returns true when debugging mode is ON
				trace("shouldPromote = " + RateMe.api.shouldPromote)
				
				if (RateMe.api.shouldPromote)
				{
					RateMe.api.promote();
				}
			}
			
			//----------------------------------------------------------------------
			
			
		}
		
		private function onUserAttemptToRate(e:RateMeEvents):void
		{
			C.log("onUserAttemptToRate");
		}
		
		private function onUserDeclineToRate(e:RateMeEvents):void
		{
			C.log("onUserDeclineToRate");
		}
		
		private function onUserRemindedToRate(e:RateMeEvents):void
		{
			C.log("onUserRemindedToRate");
		}
		
		
		private function onRateMeError(e:RateMeEvents):void
		{
			C.log("onRateMeError: " + e.msg);
		}
		
		private function onRateMeDetectediOSAppUpdate(e:RateMeEvents):void
		{
			C.log("onRateMeDetectediOSAppUpdate");
		}
		
		private function onRateMeOpenedStore(e:RateMeEvents):void
		{
			C.log("onRateMeOpenedStore");
		}
		
		private function onRateMeDialogShown(e:RateMeEvents):void
		{
			C.log("onRateMeDialogShown");
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		private function createBtn($str:String):MySprite
		{
			var sp:MySprite = new MySprite();
			sp.addEventListener(MouseEvent.MOUSE_OVER,  onOver);
			sp.addEventListener(MouseEvent.MOUSE_OUT,  onOut);
			sp.addEventListener(MouseEvent.CLICK,  onOut);
			sp.bgAlpha = 1;
			sp.bgColor = 0xDFE4FF;
			sp.drawBg();
			sp.width = BTN_WIDTH * DeviceInfo.dpiScaleMultiplier;
			sp.height = BTN_HEIGHT * DeviceInfo.dpiScaleMultiplier;
			
			function onOver(e:MouseEvent):void
			{
				sp.bgAlpha = 1;
				sp.bgColor = 0xFFDB48;
				sp.drawBg();
			}
			
			function onOut(e:MouseEvent):void
			{
				sp.bgAlpha = 1;
				sp.bgColor = 0xDFE4FF;
				sp.drawBg();
			}
			
			var format:TextFormat = new TextFormat("Arimo", 16, 0x666666, null, null, null, null, null, TextFormatAlign.CENTER);
			
			var txt:TextField = new TextField();
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.antiAliasType = AntiAliasType.ADVANCED;
			txt.mouseEnabled = false;
			txt.multiline = true;
			txt.wordWrap = true;
			txt.scaleX = txt.scaleY = DeviceInfo.dpiScaleMultiplier;
			txt.width = sp.width * (1 / DeviceInfo.dpiScaleMultiplier);
			txt.defaultTextFormat = format;
			txt.text = $str;
			
			txt.y = sp.height - txt.height >> 1;
			sp.addChild(txt);
			
			return sp;
		}
	}
	
}