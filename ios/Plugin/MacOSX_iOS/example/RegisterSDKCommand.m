//
//  RegisterSDKCommand.m
//  Entrust IdentityGuard Mobile SDK
//  Command Line Example
//
//  Copyright (c) 2013 Entrust, Inc. All rights reserved.
//  Use is subject to the terms of the accompanying license agreement. Entrust Confidential.
//

#import "RegisterSDKCommand.h"
#import "ETIdentityProvider.h"

/**
 * The register command allows a user to register their
 * soft token with Entrust IdentityGuard for transactions
 * if they skipped that step while creating the soft token.
 */
@implementation RegisterSDKCommand

/**
 * Initialize the command.
 * @param app The main application class.
 * @return The initialized instance.
 */
-(id)initWithApp:(SDKCommandLineApp *)theApp
{
    if (self = [super initWithApp:theApp]) {
        name = @"register";
        description = @"Registers the soft token with Entrust IdentityGuard.";
    }
    return self;
}

/**
 * Performs the command action.
 */
- (void) performCommand
{
    NSString *txnUrl = [SDKUtils loadTransactionUrl];
    if (txnUrl == nil) {
        // If we don't have a transaction url, promp the user for one.
        ETConfigurationFile *config = [SDKUtils promptAndFetchIdentityProviderAddressAndIsOptional:NO];
        if (config == nil || [config transactionUrl] == nil) {
            printf("Identity Provider doesn't support registration.\n");
            return;
        }
    }
    
    // Perform the soft token registration.
    NSError * regError;
    ETIdentityProvider *identityProvider = [[ETIdentityProvider alloc] initWithURLString:txnUrl];
    BOOL success = [identityProvider registerIdentity:app.identity deviceId:@"0" transactions:YES onlineTransactions:YES offlineTransactions:YES notifications:NO callback:nil error:&regError];
    if (success) {
        printf("Registration with identity provider was successful.\n");
        [SDKUtils saveTransactionUrl:txnUrl];
    } else {
        printf("Registration with identity provider failed.\n");
        if (regError) {
            printf("Error: %s\n", [[regError localizedDescription] UTF8String]);
        }
    }
}

/**
 * Returns whether the command is applicable to the
 * current application state.
 * @return YES if the command can be run, NO otherwise.
 */
- (BOOL) isApplicable
{
    return app.identity != nil && !app.identity.registeredForTransactions;
}

@end
