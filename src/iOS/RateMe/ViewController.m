//
//  ViewController.m
//  RateMe
//
//  Created by MyFlashLab on 6/27/16.
//  Copyright © 2016 MyFlashLab. All rights reserved.
//

#import "ViewController.h"
#import "iRate.h"

@interface ViewController ()<iRateDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // https://github.com/nicklockwood/iRate
    
    [iRate sharedInstance].verboseLogging = YES;
    [iRate sharedInstance].applicationBundleID = @"com.doitflash.ar.atelier";
    [iRate sharedInstance].onlyPromptIfLatestVersion = NO;
    [iRate sharedInstance].applicationName = @"applicationName";
    //[iRate sharedInstance].appStoreID = 931815325;
    [iRate sharedInstance].daysUntilPrompt = 0.00005f;
    [iRate sharedInstance].usesUntilPrompt = 2;
    //[iRate sharedInstance].eventsUntilPrompt = 10;
    [iRate sharedInstance].remindPeriod = 0;
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
    
}

- (void)iRateCouldNotConnectToAppStore:(NSError *)error
{
    NSLog(@"------- iRateCouldNotConnectToAppStore, error = %@", error.description);
}

- (void)iRateDidDetectAppUpdate
{
    NSLog(@"------- iRateDidDetectAppUpdate");
}

- (BOOL)iRateShouldPromptForRating
{
    NSLog(@"------- iRateShouldPromptForRating");
    
    return YES;
}

- (void)iRateDidPromptForRating
{
    NSLog(@"------- iRateDidPromptForRating");
}

- (void)iRateUserDidAttemptToRateApp
{
    NSLog(@"------- iRateUserDidAttemptToRateApp");
}

- (void)iRateUserDidDeclineToRateApp
{
    NSLog(@"------- iRateUserDidDeclineToRateApp");
}

- (void)iRateUserDidRequestReminderToRateApp
{
    NSLog(@"------- iRateUserDidRequestReminderToRateApp");
}

- (BOOL)iRateShouldOpenAppStore
{
    NSLog(@"------- iRateShouldOpenAppStore");
    
    return YES;
}

- (void)iRateDidOpenAppStore
{
    NSLog(@"------- iRateDidOpenAppStore");
}

@end
