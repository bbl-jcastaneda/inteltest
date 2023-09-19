/********* Intellitrust.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import "ETIdentity.h"
#import "ETIdentityProvider.h"
#import "ETSoftTokenSDK.h"
#import "ETTransaction.h"
#define transactionURL @"https://belizebank.us.trustedauth.com/api/mobile"
@interface Intellitrust : CDVPlugin {
  // Member variables go here.
}

 - (void)createNewSoftTokenIdentity:(CDVInvokedUrlCommand*)command;
 - (void)getOTP:(CDVInvokedUrlCommand*)command;
 - (void)deleteIdentity:(CDVInvokedUrlCommand*)command;
 - (void)parseNotification:(CDVInvokedUrlCommand*)command;

 /**
 * Saves the current identity to disk.
 * @param identity The identity to save.
 * @return YES on success, NO otherwise.
 */
- (BOOL) saveIdentity:(ETIdentity *)identity;

/**
 * Loads the identity from disk.
 * @return The identity from disk or nil if no identity exists.
 */
- (ETIdentity *)loadIdentity;

/**
 * Deletes the current identity file from disk.
 * @return YES on success, false otherwise.
 */
- (BOOL) deleteIdentityFile;

 @end

@implementation Intellitrust

static NSString *dataFileName;
static NSString *fileName;
 
- (void)createNewSoftTokenIdentity:(CDVInvokedUrlCommand*)command
{
    NSString *serialNumberArg = [[command.arguments objectAtIndex:0] valueForKey:@"serialNumber"];
    NSString *activationCodeArg = [[command.arguments objectAtIndex:0] valueForKey:@"activationCode"];
    NSString *deviceId = [[command.arguments objectAtIndex:0] valueForKey:@"deviceId"];
    fileName = [[command.arguments objectAtIndex:0] valueForKey:@"fileName"];
    // Initialize the SDK engine which sets up the encryption key.
    BOOL wasReset = [ETSoftTokenSDK initializeSDK];
    if (wasReset) {
        // Clean up any existing identities because we can't decrypt them.
        [self deleteIdentityFile];
    }

    // Needed to use push notifications
    [ETSoftTokenSDK setApplicationId:@"com.belizebank.mobile"];
    [ETSoftTokenSDK setApplicationVersion:@"1.8.3"];
    [ETSoftTokenSDK setApplicationScheme:@"belizebank"];
    CDVPluginResult* pluginResult = nil;

    // Validate serialNumber
    @try {
      [ETIdentityProvider validateSerialNumber:serialNumberArg];
    }
    @catch (NSException *e) {
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:e.reason];
      [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }

    // Validate activationCode
    @try {
      [ETIdentityProvider validateActivationCode:activationCodeArg];
    }
    @catch (NSException *e) {
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:e.reason];
      [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }

    @try {
      // Generate new Identity
      ETIdentity *identity = [ETIdentityProvider generate:deviceId serialNumber:serialNumberArg activationCode:activationCodeArg];
      NSError *error = nil;
      // Initialize Identity Provider, using Transaction URL
      ETIdentityProvider *provider = [[ETIdentityProvider alloc] initWithURLString:transactionURL];
      BOOL success = [provider registerIdentity:identity deviceId:deviceId transactions:YES onlineTransactions:YES offlineTransactions:YES notifications:YES callback:nil error:&error];

      NSString *returnMessage = nil;

      // Save Identity to a file on the user's mobile phone
      [self saveIdentity:identity];

      if(success){
        // Return a successful message
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Successfully Registered!"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
      }else{
        // Return a successful message
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:error.localizedDescription];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
      }

    }
    @catch (NSException *e) {
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:e.reason];
      [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

- (void)getOTP:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    
    @try {
      // Attempt to load a previously saved identity.
      fileName = [[command.arguments objectAtIndex:0] valueForKey:@"fileName"];
      ETIdentity *identity = [self loadIdentity];
      // Get OTP value
      NSString *otp = [identity getOTP:[NSDate date]];
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:otp];
      [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
    @catch (NSException *e) {
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:e.reason];
      [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

- (void)deleteIdentity:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    
    @try {
      fileName = [[command.arguments objectAtIndex:0] valueForKey:@"fileName"];
      // Clean up any existing identities because the token no longer exists in Intellitrust
      [self deleteIdentityFile];
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Successfully Deleted!"];
      [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
    @catch (NSException *e) {
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:e.reason];
      [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

- (void)parseNotification:(CDVInvokedUrlCommand*)command
{
  CDVPluginResult* pluginResult = nil;
  BOOL isTransactionAuthenticated = false;

  @try {
    fileName = [[command.arguments objectAtIndex:0] valueForKey:@"fileName"];
    ETIdentity *identity = [self loadIdentity];
    NSString *txnid = [[command.arguments objectAtIndex:0] valueForKey:@"txnid"];
    NSString *response = [[command.arguments objectAtIndex:0] valueForKey:@"response"];
    NSError *error = nil;
    ETTransactionResponse txnResponse = ETTransactionResponseNone;

    ETIdentityProvider *provider = [[ETIdentityProvider alloc] initWithURLString: transactionURL];
    ETTransaction *transaction = [provider poll:identity callback:nil error:&error];

    error = nil;
    txnResponse = [ETTransaction transactionResponseFromString:response];

    // Send the response back to Entrust IdentityGuard.
    isTransactionAuthenticated = [provider authenticateTransaction:transaction forIdentity:identity withResponse:txnResponse callback:nil error:&error];
    if (isTransactionAuthenticated) {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"true"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    } else {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"false"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
  }
  @catch (NSException *e) {
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:e.reason];
      [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
  }
}

/**
 * Gets the file name where the soft token identity will be stored.
 * @return The file name where the soft token identity will be stored.
 */
- (NSString *)getIdentityFileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    dataFileName = [documentsDirectory stringByAppendingPathComponent:fileName];
    return dataFileName;
}

/**
 * Saves the current identity to disk.
 * @param identity The identity to save.
 * @return YES on success, NO otherwise.
 */
- (BOOL) saveIdentity:(ETIdentity *)identity
{
    NSData *serialized = [NSKeyedArchiver archivedDataWithRootObject:identity];
    NSData *encrypted = [ETSoftTokenSDK encryptData:serialized];
    return [encrypted writeToFile:[self getIdentityFileName] atomically:YES];
}

/**
 * Loads the identity from disk.
 * @return The identity from disk or nil if no identity exists.
 */
- (ETIdentity *)loadIdentity
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self getIdentityFileName]]) {
        return nil;
    }
    NSData *encrypted = [[NSData alloc] initWithContentsOfFile:[self getIdentityFileName]];
    NSData *serialized = [ETSoftTokenSDK decryptData:encrypted];
    return [NSKeyedUnarchiver unarchiveObjectWithData:serialized];
}

/**
 * Deletes the current identity file from disk.
 * @return YES on success, false otherwise.
 */
- (BOOL) deleteIdentityFile
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self getIdentityFileName]]) {
        return [[NSFileManager defaultManager] removeItemAtPath:[self getIdentityFileName] error:nil];
    }
    return NO;
}

@end
