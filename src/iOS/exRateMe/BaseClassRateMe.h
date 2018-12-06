//
//  BaseClassRateMe.h
//  RateMe
//
//  Created by MyFlashLab on 6/27/16.
//  Copyright © 2016 MyFlashLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "iRate.h"

@interface BaseClassRateMe : NSObject <UIAlertViewDelegate, iRateDelegate>
{
    BOOL okIsTouch;
}

@property (nonatomic) BOOL okIsTouch;

-(void)isTestVersion;
-(void)test;

-(void)init:(BOOL)isDebugging appId:(NSString*)appId;
-(void)configPromotion:(int)daysUntilPrompt launchesUntilPrompt:(int)launchesUntilPrompt remindPeriod:(int)remindPeriod;
-(void)configLayout:(NSString*)title msg:(NSString*)msg remindBtnTxt:(NSString*)remindBtnTxt rateBtnTxt:(NSString*)rateBtnTxt cancelBtnTxt:(NSString*)cancelBtnTxt;
-(void)iOSConfig:(NSString*)appUpdateMessage appName:(NSString*)appName promptNewIfUserRated:(BOOL)promptNewIfUserRated onlyPromptIfLatestV:(BOOL)onlyPromptIfLatestV appStoreID:(double)appStoreID appStoreGenreID:(double)appStoreGenreID ratingsUrl:(NSString*)ratingsUrl useSKStoreReviewController:(BOOL)useSKStoreReviewController;
-(void)monitor;
-(BOOL)shouldPromote;
-(BOOL)getAutoPromoteAtLaunch;
-(void)setAutoPromoteAtLaunch:(BOOL)value;
-(void)promptIfAllCriteriaMet;
-(void)promptRightNow;
-(void)openStoreDirectly;

-(double)getFirstUsed;
-(double)getLastReminded;
-(int)getUsesCount;
-(int)getEventCount;
-(double)getUsesPerWeek;
-(BOOL)getDeclinedThisVersion;
-(BOOL)getDeclinedAnyVersion;
-(BOOL)getRatedThisVersion;
-(BOOL)getRatedAnyVersion;

-(void)setFirstUsed:(double)value;
-(void)setLastReminded:(double)value;
-(void)setUsesCount:(int)value;
-(void)setEventCount:(int)value;
-(void)setDeclinedThisVersion:(BOOL)value;
-(void)setRatedThisVersion:(BOOL)value;

@end
