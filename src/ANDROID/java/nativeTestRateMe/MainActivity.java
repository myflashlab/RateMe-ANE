package nativeTestRateMe;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;

import com.myflashlab.rateme.R;

import hotchemi.android.rate.AppRate;
import hotchemi.android.rate.OnClickButtonListener;

public class MainActivity extends Activity
{

	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);

		// https://github.com/myflashlabs/Android-Rate

		AppRate appRate = AppRate.with(this);
		appRate.setInstallDays(0);
		appRate.setLaunchTimes(0);
		appRate.setRemindInterval(0);
		appRate.setShowLaterButton(true);
		appRate.setDebug(true);
		appRate.setShowLaterButton(true);
		appRate.setShowNeverButton(true);
		appRate.setShowTitle(true);
		appRate.setCancelable(false);
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

				Log.d(MainActivity.class.getName(), Integer.toString(which));
			}
		});

		appRate.monitor();
//		appRate.shouldShowRateDialog();
		// Show a dialog if meets conditions
		AppRate.showRateDialogIfMeetsConditions(this);
		//appRate.showRateDialog(this);

	}
}
