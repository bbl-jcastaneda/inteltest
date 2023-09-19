//
//  SDKCommandLineExample.m
//  Entrust IdentityGuard Mobile SDK
//  Command Line Example
//
//  Copyright (c) 2013 Entrust, Inc. All rights reserved.
//  Use is subject to the terms of the accompanying license agreement. Entrust Confidential.
//

#import <Foundation/Foundation.h>
#import "SDKCommandLineApp.h"

/*
 This is a command line example showing the usage
 of the Entrust IdentityGuard Mobile SDK. It prompts for all the
 information required to create a new soft token identity,
 then displays a one-time password (OTP). It also supports
 registering automatically with Entrust IdentityGuard and
 polling, fetching and confirming transactions.
 
 To quickly run this program without requiring Entrust IdentityGuard,
 the serial number 00000-00000 and activation code 0000-0000-0000-0000
 can be used to create a soft token that outputs 6 digit OTPs.
*/
#import "ETIdentityProvider.h"
#import "ETIdentity.h"

BOOL askYesNoQuestion(char question[]);
void doClassicActivation();

int main (int argc, const char * argv[]) {
    @autoreleasepool {

        // Launch the application
        SDKCommandLineApp *app = [[SDKCommandLineApp alloc] init];
        [app startApp];
    }
    return 0;
}
