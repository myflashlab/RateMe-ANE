//
//  BaseClassRateMe.m
//  RateMe
//
//  Created by MyFlashLab on 6/27/16.
//  Copyright © 2016 MyFlashLab. All rights reserved.
//

#import "BaseClassRateMe.h"
#import "exRateMe.h"
#import "iRate.h"
#import "MyFlashLabsClass.h"

@implementation BaseClassRateMe

@synthesize okIsTouch;

- (id) init
{
    self = [super init];
    
    return  self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        self.okIsTouch = YES;
    }
}

// --------------------------------------------------------------------------------------------------------------------------------- commands

- (void) isTestVersion
{
    // If we know at least one ANE is DEMO, we don't need to show demo dialog again. It's already shown once.
    if([[MyFlashLabsClass sharedInstance] hasAnyDemoAne]) return;
    
    // Check if this ANE is registered?
    if([[MyFlashLabsClass sharedInstance] isAneRegistered:ANE_NAME]) return;
    
    // Otherwise, show the demo dialog.
    
    self.okIsTouch = NO;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DEMO ANE!"
                                                    message:[NSString stringWithFormat:@"The library '%@' is not registered!", ANE_NAME]
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(void)init:(BOOL)isDebugging appId:(NSString*)appId
{
	[iRate sharedInstance].verboseLogging = isDebugging;
	[iRate sharedInstance].previewMode = isDebugging;
	[iRate sharedInstance].useAllAvailableLanguages = NO;
	[iRate sharedInstance].applicationBundleID = appId;
}

-(void)configPromotion:(int)daysUntilPrompt launchesUntilPrompt:(int)launchesUntilPrompt remindPeriod:(int)remindPeriod
{
	[iRate sharedInstance].daysUntilPrompt = (float)daysUntilPrompt;
	[iRate sharedInstance].usesUntilPrompt = launchesUntilPrompt;
	[iRate sharedInstance].remindPeriod = (float)remindPeriod;
}

-(void)configLayout:(NSString*)title msg:(NSString*)msg remindBtnTxt:(NSString*)remindBtnTxt rateBtnTxt:(NSString*)rateBtnTxt cancelBtnTxt:(NSString*)cancelBtnTxt
{
	[iRate sharedInstance].messageTitle = title;
	[iRate sharedInstance].message = msg;
	[iRate sharedInstance].remindButtonLabel = remindBtnTxt;
	[iRate sharedInstance].rateButtonLabel = rateBtnTxt;
	[iRate sharedInstance].cancelButtonLabel = cancelBtnTxt;
}

-(void)iOSConfig:(NSString*)appUpdateMessage appName:(NSString*)appName promptNewIfUserRated:(BOOL)promptNewIfUserRated onlyPromptIfLatestV:(BOOL)onlyPromptIfLatestV appStoreID:(double)appStoreID appStoreGenreID:(double)appStoreGenreID ratingsUrl:(NSString*)ratingsUrl useSKStoreReviewController:(BOOL)useSKStoreReviewController
{
	if(appUpdateMessage.length > 0)[iRate sharedInstance].updateMessage = appUpdateMessage;
	if(appName.length > 0)[iRate sharedInstance].applicationName = appName;
	[iRate sharedInstance].promptForNewVersionIfUserRated = promptNewIfUserRated;
	[iRate sharedInstance].onlyPromptIfLatestVersion = onlyPromptIfLatestV;
	if(appStoreID > 0)[iRate sharedInstance].appStoreID = appStoreID;
    if(appStoreGenreID > 0)[iRate sharedInstance].appStoreGenreID = appStoreGenreID;
    if(ratingsUrl.length > 0)[iRate sharedInstance].ratingsURL = [NSURL URLWithString:[ratingsUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [iRate sharedInstance].useSKStoreReviewControllerIfAvailable = useSKStoreReviewController;
}

-(void)monitor
{
	[iRate sharedInstance].delegate = self;
}

-(BOOL)shouldPromote
{
    return [iRate sharedInstance].shouldPromptForRating;
}

-(BOOL)getAutoPromoteAtLaunch
{
    return [iRate sharedInstance].promptAtLaunch;
}

-(void)setAutoPromoteAtLaunch:(BOOL)value
{
    [iRate sharedInstance].promptAtLaunch = value;
}

-(void)promptIfAllCriteriaMet
{
    [[iRate sharedInstance] promptIfAllCriteriaMet];
}

-(void)promptRightNow
{
    [[iRate sharedInstance] promptForRating];
}

-(void)openStoreDirectly
{
    [[iRate sharedInstance] openRatingsPageInAppStore];
}

-(double)getFirstUsed
{
    return [[iRate sharedInstance].firstUsed timeIntervalSince1970]*1000;
}

-(double)getLastReminded
{
    return [[iRate sharedInstance].lastReminded timeIntervalSince1970]*1000;
}

-(int)getUsesCount
{
    return (int)[iRate sharedInstance].usesCount;
}

-(int)getEventCount
{
    return (int)[iRate sharedInstance].eventCount;
}

-(double)getUsesPerWeek
{
    return [iRate sharedInstance].usesPerWeek;
}

-(BOOL)getDeclinedThisVersion
{
    return [iRate sharedInstance].declinedThisVersion;
}

-(BOOL)getDeclinedAnyVersion
{
    return [iRate sharedInstance].declinedAnyVersion;
}

-(BOOL)getRatedThisVersion
{
    return [iRate sharedInstance].ratedThisVersion;
}

-(BOOL)getRatedAnyVersion
{
    return [iRate sharedInstance].ratedAnyVersion;
}

-(void)setFirstUsed:(double)value
{
    [iRate sharedInstance].firstUsed = [[NSDate alloc] initWithTimeIntervalSince1970:value/1000];
}

-(void)setLastReminded:(double)value
{
    [iRate sharedInstance].lastReminded = [[NSDate alloc] initWithTimeIntervalSince1970:value/1000];
}

-(void)setUsesCount:(int)value
{
    [iRate sharedInstance].usesCount = value;
}

-(void)setEventCount:(int)value
{
    [iRate sharedInstance].eventCount = value;
}

-(void)setDeclinedThisVersion:(BOOL)value
{
    [iRate sharedInstance].declinedThisVersion = value;
}

-(void)setRatedThisVersion:(BOOL)value
{
    [iRate sharedInstance].ratedThisVersion = value;
}




-(void)test
{
    /*
    // https://github.com/nicklockwood/iRate
    
    [iRate sharedInstance].verboseLogging = YES;
	[iRate sharedInstance].daysUntilPrompt = 0.00005f;
	[iRate sharedInstance].usesUntilPrompt = 2;
	[iRate sharedInstance].remindPeriod = 1;
	
	
	
    
	
    [iRate sharedInstance].applicationName = @"applicationName";
    [iRate sharedInstance].messageTitle = @"message title!";
    [iRate sharedInstance].message = @"message";
    [iRate sharedInstance].updateMessage = @"update message";
    [iRate sharedInstance].cancelButtonLabel = @"cancel btn";
    [iRate sharedInstance].rateButtonLabel = @"rate btn";
    [iRate sharedInstance].remindButtonLabel = @"remind btn";
    [iRate sharedInstance].useAllAvailableLanguages = NO;
    [iRate sharedInstance].promptForNewVersionIfUserRated = YES;
    [iRate sharedInstance].onlyPromptIfLatestVersion = NO;
    [iRate sharedInstance].delegate = self;
	
	// must be set automatically from Air
	[iRate sharedInstance].applicationBundleID = @"com.doitflash.ar.atelier";
	//[iRate sharedInstance].appStoreID = 931815325;
    //[iRate sharedInstance].eventsUntilPrompt = 10;
    
    
    //enable preview mode
    [iRate sharedInstance].previewMode = NO;
    
    if([iRate sharedInstance].shouldPromptForRating)
    {
        NSLog(@"shouldPromptForRating = YES");
    }
    else
    {
        NSLog(@"shouldPromptForRating = NO");
    }
    
    //[[iRate sharedInstance] promptForRating];
    //[[iRate sharedInstance] promptIfNetworkAvailable];
     */
}

// --------------------------------------------------------------------------------------------------------------------------------- iRateDelegate

- (void)iRateCouldNotConnectToAppStore:(NSError *)error
{
    [exRateMe dispatchEventEcode:RATE_ME_ERROR andElevel:error.description];
}

- (void)iRateDidDetectAppUpdate
{
    [exRateMe dispatchEventEcode:RATE_ME_DETECT_APP_UPDATE andElevel:@""];
}

- (BOOL)iRateShouldPromptForRating
{
    return YES;
}

- (void)iRateDidPromptForRating
{
    [exRateMe dispatchEventEcode:RATE_ME_DID_PROMOTE_FOR_RATING andElevel:@""];
}

- (void)iRateUserDidAttemptToRateApp
{
    [exRateMe dispatchEventEcode:RATE_ME_USER_ATTEMPT_TO_RATE andElevel:@""];
}

- (void)iRateUserDidDeclineToRateApp
{
    [exRateMe dispatchEventEcode:RATE_ME_USER_DECLINE_TO_RATE andElevel:@""];
}

- (void)iRateUserDidRequestReminderToRateApp
{
    [exRateMe dispatchEventEcode:RATE_ME_USER_REMIND_TO_RATE andElevel:@""];
}

- (BOOL)iRateShouldOpenAppStore
{
    return YES;
}

- (void)iRateDidOpenAppStore
{
    [exRateMe dispatchEventEcode:RATE_ME_DID_OPEN_STORE andElevel:@""];
}

// --------------------------------------------------------------------------------------------------------------------------------- private methods



@end
