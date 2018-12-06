//
//  exRateMe.h
//  exRateMe
//
//  Created by MyFlashLab on 6/27/16.
//  Copyright © 2016 MyFlashLab. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ANE_NAME @"com.myflashlab.air.extensions.rateMe"

// dispatch events
#define RATE_ME_ERROR                   @"onRateMeError"
#define RATE_ME_DETECT_APP_UPDATE       @"onRateMeDetectAppUpdate"
#define RATE_ME_DID_PROMOTE_FOR_RATING  @"onRateMeDidPromoteForRating"
#define RATE_ME_USER_ATTEMPT_TO_RATE    @"onRateMeUserAttemptToRate"
#define RATE_ME_USER_DECLINE_TO_RATE    @"onRateMeUserDeclineToRate"
#define RATE_ME_USER_REMIND_TO_RATE     @"onRateMeUserRemindToRate"
#define RATE_ME_DID_OPEN_STORE          @"onRateMeDidOpenStore"

@interface exRateMe : NSObject

+ (void) dispatchEventEcode:(NSString *) ecode andElevel:(NSString *) elevel;
//+ (id)sharedAppDelegateInstanceRateMe;

@end
