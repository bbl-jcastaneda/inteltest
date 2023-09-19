//
//  OTPSDKCommand.m
//  Entrust IdentityGuard Mobile SDK
//  Command Line Example
//
//  Copyright (c) 2013 Entrust, Inc. All rights reserved.
//  Use is subject to the terms of the accompanying license agreement. Entrust Confidential.
//

#import "OTPSDKCommand.h"
#import "ETIdentityProvider.h"

/**
 * This command generates a one-time password, also
 * known as a security code, and displays it to the
 * user.
 *
 * Note: A one-time password is generated using the
 * current time (in 30 second intervals).  Calling
 * this command multiple times during the same
 * time interval will return the same one-time
 * password.
 */
@implementation OTPSDKCommand

/**
 * Initialize the command.
 * @param app The main application class.
 * @return The initialized instance.
 */
-(id)initWithApp:(SDKCommandLineApp *)theApp
{
    if (self = [super initWithApp:theApp]) {
        name = @"otp";
        description = @"Prints the current OTP value.";
    }
    return self;
}

/**
 * Performs the command action.
 */
- (void) performCommand
{
    NSString *otpString = [app.identity getOTP:[NSDate date]];
    printf("The Security Code for the current time is: %s\n", [otpString UTF8String]);
}

/**
 * Returns whether the command is applicable to the
 * current application state.
 * @return YES if the command can be run, NO otherwise.
 */
- (BOOL) isApplicable
{
    return app.identity != nil;
}

@end
