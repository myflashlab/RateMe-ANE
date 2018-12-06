//
//  exRateMe.m
//  exRateMe
//
//  Created by MyFlashLab on 6/27/16.
//  Copyright © 2016 MyFlashLab. All rights reserved.
//

#import "exRateMe.h"
#import "FlashRuntimeExtensions.h"
#import "BaseClassRateMe.h"
#import "MyFlashLabsClass.h"

@interface exRateMe ()

typedef enum
{
    isTestVersion,
    test,
	
	init,
	configPromotion,
	configLayout,
	iOSConfig,
	monitor,
    shouldPromote,
    setAutoPromoteAtLaunch,
    getAutoPromoteAtLaunch,
    promptIfAllCriteriaMet,
    promptRightNow,
    openStoreDirectly,
    
    // getters
    getFirstUsed,
    getLastReminded,
    getUsesCount,
    getEventCount,
    getUsesPerWeek,
    getDeclinedThisVersion,
    getDeclinedAnyVersion,
    getRatedThisVersion,
    getRatedAnyVersion, // readonly
    
    // setters
    setFirstUsed,
    setLastReminded,
    setUsesCount,
    setEventCount,
    setDeclinedThisVersion,
    setRatedThisVersion,
    
    defaultEnum
} commandType;

@end

@implementation exRateMe

FREContext freContextRateMe;
static BaseClassRateMe *base = nil;

commandType getEnumTitleRateMe(NSString *theType)
{
#define CHECK_ENUM(X)   if([theType isEqualToString:@#X]) return X
    
    CHECK_ENUM(isTestVersion);
    CHECK_ENUM(test);
	
    CHECK_ENUM(init);
    CHECK_ENUM(configPromotion);
    CHECK_ENUM(configLayout);
    CHECK_ENUM(iOSConfig);
    CHECK_ENUM(monitor);
    CHECK_ENUM(shouldPromote);
    CHECK_ENUM(setAutoPromoteAtLaunch);
    CHECK_ENUM(getAutoPromoteAtLaunch);
    CHECK_ENUM(promptIfAllCriteriaMet);
    CHECK_ENUM(promptRightNow);
    CHECK_ENUM(openStoreDirectly);
    
    CHECK_ENUM(getFirstUsed);
    CHECK_ENUM(getLastReminded);
    CHECK_ENUM(getUsesCount);
    CHECK_ENUM(getEventCount);
    CHECK_ENUM(getUsesPerWeek);
    CHECK_ENUM(getDeclinedThisVersion);
    CHECK_ENUM(getDeclinedAnyVersion);
    CHECK_ENUM(getRatedThisVersion);
    CHECK_ENUM(getRatedAnyVersion);
    
    CHECK_ENUM(setFirstUsed);
    CHECK_ENUM(setLastReminded);
    CHECK_ENUM(setUsesCount);
    CHECK_ENUM(setEventCount);
    CHECK_ENUM(setDeclinedThisVersion);
    CHECK_ENUM(setRatedThisVersion);
    
    return defaultEnum;
    
#undef CHECK_ENUM
}

/*
 + (id)sharedAppDelegateInstanceRateMe
 {
 return base;
 }
 */

+ (void) dispatchEventEcode:(NSString *) ecode andElevel:(NSString *) elevel
{
    if (freContextRateMe == NULL)
    {
        return;
    }
    
    const uint8_t* enentLevel = (const uint8_t*) [elevel UTF8String];
    const uint8_t* eventCode = (const uint8_t*) [ecode UTF8String];
    FREDispatchStatusEventAsync(freContextRateMe, eventCode, enentLevel);
}


// -------------------------------------------------------------------------
FREObject commandRateMe(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    FREObject retFREObject = nil;
    
    NSString *command = [MyFlashLabsClass AirToIos_String:argv[0]];
    commandType temp = getEnumTitleRateMe(command);
    
    // save the active context from flash
    freContextRateMe = ctx;
    
    switch (temp)
    {
        case isTestVersion:
            
            [base isTestVersion];
            
            break;
        case test:
            
            [base test];
            
            break;
        case init:
            
            [base init:[MyFlashLabsClass AirToIos_Boolean:argv[1]]
				 appId:[MyFlashLabsClass AirToIos_String:argv[2]]];
            
            break;
        case configPromotion:
            
            [base configPromotion:[MyFlashLabsClass AirToIos_Integer:argv[1]] // $daysUntilPrompt
			  launchesUntilPrompt:[MyFlashLabsClass AirToIos_Integer:argv[2]]
					 remindPeriod:[MyFlashLabsClass AirToIos_Integer:argv[3]]];
            
            break;
		case configLayout:
		
			[base configLayout:[MyFlashLabsClass AirToIos_String:argv[1]] // $title
				           msg:[MyFlashLabsClass AirToIos_String:argv[2]]
				  remindBtnTxt:[MyFlashLabsClass AirToIos_String:argv[3]]
				    rateBtnTxt:[MyFlashLabsClass AirToIos_String:argv[4]]
				  cancelBtnTxt:[MyFlashLabsClass AirToIos_String:argv[5]]];
			
			break;
		case iOSConfig:
		
			[base iOSConfig:[MyFlashLabsClass AirToIos_String:argv[1]] // $appUpdateMessage
				    appName:[MyFlashLabsClass AirToIos_String:argv[2]]
	   promptNewIfUserRated:[MyFlashLabsClass AirToIos_Boolean:argv[3]]
	    onlyPromptIfLatestV:[MyFlashLabsClass AirToIos_Boolean:argv[4]]
		         appStoreID:[MyFlashLabsClass AirToIos_Double:argv[5]] // default = 0
            appStoreGenreID:[MyFlashLabsClass AirToIos_Double:argv[6]] // default = 0
                 ratingsUrl:[MyFlashLabsClass AirToIos_String:argv[7]] //default = ""
 useSKStoreReviewController:[MyFlashLabsClass AirToIos_Boolean:argv[8]] // default = false
             ];
			
			break;
		case monitor:
		
			[base monitor];
		
			break;
        case shouldPromote:
            
            retFREObject = [MyFlashLabsClass IosToAir_Boolean:[base shouldPromote]];
            
            break;
        case setAutoPromoteAtLaunch:
            
            [base setAutoPromoteAtLaunch:[MyFlashLabsClass AirToIos_Boolean:argv[1]]];
            
            break;
        case getAutoPromoteAtLaunch:
            
            retFREObject = [MyFlashLabsClass IosToAir_Boolean:[base getAutoPromoteAtLaunch]];
            
            break;
        case promptIfAllCriteriaMet: // not added to Air yet!
            
            [base promptIfAllCriteriaMet];
            
            break;
        case promptRightNow:
            
            [base promptRightNow];
            
            break;
        case openStoreDirectly: // not added to Air yet!
            
            [base openStoreDirectly];
            
            break;
        case getFirstUsed:
            
            retFREObject = [MyFlashLabsClass IosToAir_Double:[base getFirstUsed]];
            
            break;
        case getLastReminded:
            
            retFREObject = [MyFlashLabsClass IosToAir_Double:[base getLastReminded]];
            
            break;
        case getUsesCount:
            
            retFREObject = [MyFlashLabsClass IosToAir_Integer:[base getUsesCount]];
            
            break;
        case getEventCount:
            
            retFREObject = [MyFlashLabsClass IosToAir_Integer:[base getEventCount]];
            
            break;
        case getUsesPerWeek:
            
            retFREObject = [MyFlashLabsClass IosToAir_Double:[base getUsesPerWeek]];
            
            break;
        case getDeclinedThisVersion:
            
            retFREObject = [MyFlashLabsClass IosToAir_Boolean:[base getDeclinedThisVersion]];
            
            break;
        case getDeclinedAnyVersion:
            
            retFREObject = [MyFlashLabsClass IosToAir_Boolean:[base getDeclinedAnyVersion]];
            
            break;
        case getRatedThisVersion:
            
            retFREObject = [MyFlashLabsClass IosToAir_Boolean:[base getRatedThisVersion]];
            
            break;
        case getRatedAnyVersion:
            
            retFREObject = [MyFlashLabsClass IosToAir_Boolean:[base getRatedAnyVersion]];
            
            break;
        case setFirstUsed:
            
            [base setFirstUsed:[MyFlashLabsClass AirToIos_Double:argv[1]]];
            
            break;
        case setLastReminded:
            
            [base setLastReminded:[MyFlashLabsClass AirToIos_Double:argv[1]]];
            
            break;
        case setUsesCount:
            
            [base setUsesCount:[MyFlashLabsClass AirToIos_Integer:argv[1]]];
            
            break;
        case setEventCount:
            
            [base setEventCount:[MyFlashLabsClass AirToIos_Integer:argv[1]]];
            
            break;
        case setDeclinedThisVersion:
            
            [base setDeclinedThisVersion:[MyFlashLabsClass AirToIos_Boolean:argv[1]]];
            
            break;
        case setRatedThisVersion:
            
            [base setRatedThisVersion:[MyFlashLabsClass AirToIos_Boolean:argv[1]]];
            
            break;
        default:
            
            retFREObject = [MyFlashLabsClass IosToAir_String:[[MyFlashLabsClass sharedInstance] retriveCommandNotFound]];
            break;
    }
    
    // Return data back to flash
    return retFREObject;
}

void contextInitializerRateMe(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    // make sure the base class is initialized
    if (!base) base = [[BaseClassRateMe alloc] init];
    *numFunctionsToTest = 1;
    
    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * *numFunctionsToTest);
    
    func[0].name = (const uint8_t*) "command";
    func[0].functionData = NULL;
    func[0].function = &commandRateMe;
    
    *functionsToSet = func;
}

void contextFinalizerRateMe(FREContext ctx)
{
    return;
}

void comMyflashlabRateMeExtensionInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
    *extDataToSet = NULL;
    *ctxInitializerToSet = &contextInitializerRateMe;
    *ctxFinalizerToSet = &contextFinalizerRateMe;
}

void comMyflashlabRateMeExtensionFinalizer(void* extData)
{
    return;
}

@end
