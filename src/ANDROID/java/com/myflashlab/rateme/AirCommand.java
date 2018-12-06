package com.myflashlab.rateme;


import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.myflashlab.Conversions;

import hotchemi.android.rate.AppRate;
import hotchemi.android.rate.OnClickButtonListener;
import hotchemi.android.rate.StoreType;
import nativeTestRateMe.ExConsts;

/**
 * Source modification:
 * hotchemi.android.rate.IntentHelper
 *
 *
 * @author Hadi Tavakoli
 */
public class AirCommand implements FREFunction
{
	private boolean isDialogCalled = false;
	private boolean isDialogClicked = false;

	private Activity _activity;

	private AppRate _rateMe;
	private boolean _autoPromote = true;
	private boolean _isDialogOpen = false;

	public static String APP_ID;

	private enum commands
	{
		isTestVersion,
		test,

		init,
		configPromotion,
		configLayout,
		androidConfig,
		monitor,
		setAutoPromoteAtLaunch,
		getAutoPromoteAtLaunch,
		promptIfAllCriteriaMet,
		shouldPromote,
		promptRightNow,
	}

	private void showTestVersionDialog()
	{
		// If we know at least one ANE is DEMO, we don't need to show demo dialog again. It's already shown once.
		if(com.myflashlab.dependency.overrideAir.MyExtension.hasAnyDemoAne()) return;

		// Check if this ANE is registered?
		if(com.myflashlab.dependency.overrideAir.MyExtension.isAneRegistered(ExConsts.ANE_NAME)) return;

		// Otherwise, show the demo dialog.

		AlertDialog.Builder dialogBuilder = new AlertDialog.Builder(_activity);
		dialogBuilder.setTitle("DEMO ANE!");
		dialogBuilder.setMessage("The library '"+ExConsts.ANE_NAME+"' is not registered!");
		dialogBuilder.setCancelable(false);
		dialogBuilder.setPositiveButton("OK", new DialogInterface.OnClickListener()
		{
			public void onClick(DialogInterface dialog, int id)
			{
				dialog.dismiss();
				isDialogClicked = true;
			}
		});

		AlertDialog myAlert = dialogBuilder.create();
		myAlert.show();

		isDialogCalled = true;
	}

	public FREObject call(FREContext $context, FREObject[] $params)
	{
		String command = Conversions.AirToJava_String($params[0]);
		FREObject result = null;

		if (_activity == null)
		{
			_activity = $context.getActivity();
		}

		switch (commands.valueOf(command))
		{
			case isTestVersion:

				showTestVersionDialog();

				break;
			case test:

				test();

				break;
			case init:

				init(Conversions.AirToJava_Boolean($params[1]), // $debugMode
						Conversions.AirToJava_String($params[2])); // $appId

				break;
			case configPromotion:

				configPromotion(Conversions.AirToJava_Integer($params[1]), // $daysUntilPrompt
						Conversions.AirToJava_Integer($params[2]), // $launchesUntilPrompt
						Conversions.AirToJava_Integer($params[3])); // $remindPeriod

				break;
			case configLayout:

				configLayout(Conversions.AirToJava_String($params[1]), // $title
						Conversions.AirToJava_String($params[2]), // $msg
						Conversions.AirToJava_String($params[3]), // $remindBtnTxt
						Conversions.AirToJava_String($params[4]), // $rateBtnTxt
						Conversions.AirToJava_String($params[5])); // $cancelBtnTxt

				break;
			case androidConfig:

				androidConfig(Conversions.AirToJava_Integer($params[1])); // $storeType

				break;
			case monitor:

				monitor();

				break;
			case setAutoPromoteAtLaunch:

				_autoPromote = Conversions.AirToJava_Boolean($params[1]);

				break;
			case getAutoPromoteAtLaunch:

				result = Conversions.JavaToAir_Boolean(_autoPromote);

				break;
			case promptIfAllCriteriaMet:

				if (!_isDialogOpen)
				{
					if(AppRate.showRateDialogIfMeetsConditions(_activity))
					{
						_isDialogOpen = true;
						MyExtension.AS3_CONTEXT.dispatchStatusEventAsync(ExConsts.RATE_ME_DID_PROMOTE_FOR_RATING, "");
					}
				}


				break;
			case shouldPromote:

				if(_rateMe.isDebug())
				{
					result = Conversions.JavaToAir_Boolean(true);
				}
				else
				{
					result = Conversions.JavaToAir_Boolean(_rateMe.shouldShowRateDialog());
				}

				// I don't know what I'm adding this but for some unknown reasons, listeners on the
				// rate dialog gets lost! so this flag won't be fixed. so, here I'm removing it manually
				_isDialogOpen = false;

				break;
			case promptRightNow:

				if(ExConsts.DEBUGGING) Log.i(ExConsts.TAG, "_isDialogOpen = " + _isDialogOpen);

				if (!_isDialogOpen)
				{
					_rateMe.clearAgreeShowDialog();
					_rateMe.showRateDialog(_activity);
					_isDialogOpen = true;

					MyExtension.AS3_CONTEXT.dispatchStatusEventAsync(ExConsts.RATE_ME_DID_PROMOTE_FOR_RATING, "");
				}

				break;
		}

		return result;
	}

	// ------------------------------------------------------------------------------------------------------------------------ general funcs

	private void init(boolean $isDebugging, String $appId)
	{
		AirCommand.APP_ID = $appId;

		_rateMe = AppRate.with(_activity);
		_rateMe.setDebug($isDebugging);
	}

	private void configPromotion(int $daysUntilPrompt, int $launchesUntilPrompt, int $remindPeriod)
	{
		_rateMe.setInstallDays($daysUntilPrompt);
		_rateMe.setLaunchTimes($launchesUntilPrompt);
		_rateMe.setRemindInterval($remindPeriod);
	}

	private void configLayout(String $title, String $msg, String $remindBtnTxt, String $rateBtnTxt, String $cancelBtnTxt)
	{
		if($title.length() < 1)
		{
			_rateMe.setShowTitle(false);
		}
		else
		{
			_rateMe.setShowTitle(true);
			_rateMe.setTitle($title);
		}

		if($remindBtnTxt.length() < 1)
		{
			_rateMe.setShowLaterButton(false);
		}
		else
		{
			_rateMe.setShowLaterButton(true);
			_rateMe.setTextLater($remindBtnTxt);
		}

		if($cancelBtnTxt.length() < 1)
		{
			_rateMe.setShowNeverButton(false);
		}
		else
		{
			_rateMe.setShowNeverButton(true);
			_rateMe.setTextNever($cancelBtnTxt);
		}

		_rateMe.setMessage($msg);
		_rateMe.setTextRateNow($rateBtnTxt);
	}

	private void androidConfig(int $store)
	{
		if($store == 1) _rateMe.setStoreType(StoreType.GOOGLEPLAY);
		else if($store == 2) _rateMe.setStoreType(StoreType.AMAZON);
	}

	private void monitor()
	{
		_rateMe.setOnClickButtonListener(new OnClickButtonListener()
		{
			@Override
			public void onClickButton(int which)
			{
				// -1 = go rate
				// -2 = no thanks
				// -3 = remind me later

				switch (which)
				{
					case -1:

						MyExtension.AS3_CONTEXT.dispatchStatusEventAsync(ExConsts.RATE_ME_USER_ATTEMPT_TO_RATE, "");
						MyExtension.AS3_CONTEXT.dispatchStatusEventAsync(ExConsts.RATE_ME_DID_OPEN_STORE, "");

						break;
					case -2:

						MyExtension.AS3_CONTEXT.dispatchStatusEventAsync(ExConsts.RATE_ME_USER_DECLINE_TO_RATE, "");

						break;
					case -3:

						MyExtension.AS3_CONTEXT.dispatchStatusEventAsync(ExConsts.RATE_ME_USER_REMIND_TO_RATE, "");

						break;
				}

				_isDialogOpen = false;
				if(ExConsts.DEBUGGING)Log.d(ExConsts.TAG, "appRate.setOnClickButtonListener = " + Integer.toString(which));
			}
		});

		_rateMe.monitor();
	}














	private void test()
	{
		/*AppRate appRate = AppRate.with(_activity);
		appRate.setDebug(true);
		appRate.setInstallDays(1);
		appRate.setLaunchTimes(2);
		appRate.setRemindInterval(1);


		appRate.setShowTitle(true);
		//appRate.setMessage("msg");
		//appRate.setTitle("msg");
		//appRate.setTextLater("msg");
		//appRate.setTextRateNow("msg");
		//appRate.setTextNever("msg");
		appRate.setOnClickButtonListener(new OnClickButtonListener()
		{ // callback listener.
			@Override
			public void onClickButton(int which)
			{
				// -1 = go rate
				// -2 = no thanks
				// -3 = remind me later

				if(ExConsts.DEBUGGING)Log.d(ExConsts.TAG, "appRate.setOnClickButtonListener = " + Integer.toString(which));
			}
		});

		appRate.monitor();
		//		appRate.shouldShowRateDialog();
		// Show a dialog if meets conditions
		AppRate.showRateDialogIfMeetsConditions(_activity);
		//appRate.showRateDialog(this);*/
	}


}

// ------------------------------------------------------------------------------------------------------------------------ Internal classes

