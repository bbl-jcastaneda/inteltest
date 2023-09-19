#import "AppDelegate.h"
#import "ETSoftTokenSDK.h"
#import "ETIdentity.h"

NSArray *identities;

@interface AppDelegate ()

@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    NSError *error;
    [ETSoftTokenSDK setLogLevel:ETLogLevelInfo];
    
    //IG server call. Make sure to invoke this call asynchronously if UI should not be blocked.
    NSArray *modifiedIdentities = [ETSoftTokenSDK initializeFaceRecognitionLicense:@"https://sedemoidg2.yourcorp.com:8445/igst" forTokens:[self generateIdentities] error:&error];
    
    //Save the modifiedIdentities for offline validation capability. initializeFaceRecognitionLicense updates the identities with facerecognition flag.
    if (error){
        NSLog(@"Failed Facephi SDK initialized due to:%@", [error localizedDescription]);
    } else {
        NSLog(@"%@", @"Facephi SDK successfully initialized");
        /*Only for testing purposes, use unreachable host and modified identities from initializeFaceRecognitionLicense call for offline face recognition validation.
        Initialization is successful considering token is valid for face recognition even though server is not reachable.*/
       /* [ETSoftTokenSDK initializeFaceRecognitionLicense:@"https://wronghost.com:8445/igst" forTokens:modifiedIdentities error:&error];
        if (error){
            NSLog(@"Failed Facephi SDK initialized due to:%@", [error localizedDescription]);
        } else {
            NSLog(@"%@", @"Facephi SDK successfully initialized");
        }*/
    }
    
    return YES;
}

-(NSArray*) generateIdentities{
    NSMutableArray *tokens = [[NSMutableArray alloc]init];
    ETIdentity *identity1 = [[ETIdentity alloc]init];
    [identity1 setSerialNumber:@"60598-03616"];
    ETIdentity *identity2 = [[ETIdentity alloc]init];
    [identity2 setSerialNumber:@"06311-78357"];
    [tokens addObject:identity1];
    [tokens addObject:identity2];
    return tokens;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
