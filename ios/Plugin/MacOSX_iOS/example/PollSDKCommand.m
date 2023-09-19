//
//  PollSDKCommand.m
//  Entrust IdentityGuard Mobile SDK
//  Command Line Example
//
//  Copyright (c) 2013 Entrust, Inc. All rights reserved.
//  Use is subject to the terms of the accompanying license agreement. Entrust Confidential.
//

#import "PollSDKCommand.h"
#import "ETIdentityProvider.h"
#import "ETTransaction.h"

/**
 * This command polls Entrust IdentityGuard for pending transactions.
 * If it finds a pending classic transaction, it will generate a
 * confirmation code and display it to the user.  If it finds an
 * online transaction it will prompt the user to confirm, cancel,
 * or concern the transaction and send the user choice back to the
 * server automatically.
 */
@implementation PollSDKCommand

/**
 * Initialize the command.
 * @param app The main application class.
 * @return The initialized instance.
 */
-(id)initWithApp:(SDKCommandLineApp *)theApp
{
    if (self = [super initWithApp:theApp]) {
        name = @"poll";
        description = @"Polls Entrust IdentityGuard for pending transactions.";
    }
    return self;
}

/**
 * Performs the command action.
 */
- (void) performCommand
{
    // Poll Entrust IdentityGuard for a transaction.
    ETIdentityProvider *identityProvider = [[ETIdentityProvider alloc] initWithURLString:[SDKUtils loadTransactionUrl]];
    NSError *error;
    
    // Check for the API version
    if (identityProvider.apiVersion != nil) {
        if ([identityProvider.apiVersion intValue] > 5) {
        //If API version is greater than 5 then call pollQueue for transaction.
            [self pollQueueIdentity:identityProvider error:error];
        }
        else {
        //If API version is less than 5 then call poll for transaction.
            [self pollIdentity:identityProvider error:error];
        }
    }
    else {
        // If API version is not there directly call pollQueue. It will call highest api version and then It will give us correct reponse or error with exact api version.
         [self pollQueueIdentity:identityProvider error:error];
    }
    
}


- (void)pollQueueIdentity: ( ETIdentityProvider*)identityProvider error: (NSError*)error {
    NSMutableArray *transactions = [identityProvider pollQueue:app.identity callback:nil error:&error];
    
    for (ETTransaction *transaction in transactions) {
        
        if (transaction == nil) {
            // No transaction found. Nothing to do.
            if (error) {
                printf("Error polling for transactions: %s\n", [[error localizedDescription] UTF8String]);
            } else {
                printf("There are no transactions available.\n");
            }
            return;
        }
        
        // Print out the transaction information.
        printf("Found transaction with the following information.\n");
        printf("Transaction Id: %s\n", [transaction.transactionId UTF8String]);
        printf("Transaction Mode: %s\n", [[ETTransaction stringFromTransactionMode:transaction.transactionMode] UTF8String]);
        if (transaction.summary) {
            printf("Summary: %s\n", [transaction.summary UTF8String]);
        }
        if (transaction.appName) {
            printf("App Name: %s\n", [transaction.appName UTF8String]);
        }
        if (transaction.userId) {
            printf("User ID: %s\n", [transaction.userId UTF8String]);
        }
        if (transaction.details && [transaction.details count] > 0) {
            printf("Transaction Details:\n");
            for (ETTransactionDetail* detail in transaction.details) {
                printf(" %-25s = %s\n", [detail.detail UTF8String], [detail.value UTF8String]);
            }
        }
        printf("\n");
        
        if (transaction.transactionMode == ETTransactionModeClassic || transaction.transactionMode == ETTransactionModeOffline) {
            // In classic mode, display the confirmation code to the user.
            printf("The confirmation code you must enter to confirm this transaction is:\n");
            printf("%s", [[app.identity getConfirmationCode:transaction] UTF8String]);
        } else  if (transaction.transactionMode == ETTransactionModeOnline) {
            // In online mode, prompt the user to confirm, cancel or concern the transaction.
            ETTransactionResponse txnResponse = ETTransactionResponseNone;
            while (txnResponse == ETTransactionResponseNone) {
                NSString *response = [SDKUtils promptForString:@"Would you like to send a confirm, cancel or concern response to this transaction?" maxLength:15];
                txnResponse = [ETTransaction transactionResponseFromString:response];
                if (txnResponse == ETTransactionResponseNone) {
                    printf("An invalid response '%s' was entered.\n", [response UTF8String]);
                }
            }
            // Send the response back to Entrust IdentityGuard.
            BOOL success = [identityProvider authenticateTransaction:transaction forIdentity:app.identity withResponse:txnResponse callback:nil error:&error];
            if (success) {
                printf("You have successfully sent a %s response to transaction with id %s.\n", [[ETTransaction stringFromTransactionResponse:txnResponse] UTF8String], [transaction.transactionId UTF8String]);
            } else {
                printf("There was an error sending the transaction response.\n");
                if (error) {
                    printf("Error: %s\n", [[error localizedDescription] UTF8String]);
                }
            }
        }
    }
    
}


- (void)pollIdentity: ( ETIdentityProvider*)identityProvider error: (NSError*)error {
    {
        ETTransaction *transaction = [identityProvider poll:app.identity callback:nil error:&error];
        
        if (transaction == nil) {
            // No transaction found. Nothing to do.
            if (error) {
                printf("Error polling for transactions: %s\n", [[error localizedDescription] UTF8String]);
            } else {
                printf("There are no transactions available.\n");
            }
            return;
        }
        
        // Print out the transaction information.
        printf("Found transaction with the following information.\n");
        printf("Transaction Id: %s\n", [transaction.transactionId UTF8String]);
        printf("Transaction Mode: %s\n", [[ETTransaction stringFromTransactionMode:transaction.transactionMode] UTF8String]);
        if (transaction.summary) {
            printf("Summary: %s\n", [transaction.summary UTF8String]);
        }
        if (transaction.appName) {
            printf("App Name: %s\n", [transaction.appName UTF8String]);
        }
        if (transaction.userId) {
            printf("User ID: %s\n", [transaction.userId UTF8String]);
        }
        if (transaction.details && [transaction.details count] > 0) {
            printf("Transaction Details:\n");
            for (ETTransactionDetail* detail in transaction.details) {
                printf(" %-25s = %s\n", [detail.detail UTF8String], [detail.value UTF8String]);
            }
        }
        printf("\n");
        
        if (transaction.transactionMode == ETTransactionModeClassic || transaction.transactionMode == ETTransactionModeOffline) {
            // In classic mode, display the confirmation code to the user.
            printf("The confirmation code you must enter to confirm this transaction is:\n");
            printf("%s", [[app.identity getConfirmationCode:transaction] UTF8String]);
        } else  if (transaction.transactionMode == ETTransactionModeOnline) {
            // In online mode, prompt the user to confirm, cancel or concern the transaction.
            ETTransactionResponse txnResponse = ETTransactionResponseNone;
            while (txnResponse == ETTransactionResponseNone) {
                NSString *response = [SDKUtils promptForString:@"Would you like to send a confirm, cancel or concern response to this transaction?" maxLength:15];
                txnResponse = [ETTransaction transactionResponseFromString:response];
                if (txnResponse == ETTransactionResponseNone) {
                    printf("An invalid response '%s' was entered.\n", [response UTF8String]);
                }
            }
            // Send the response back to Entrust IdentityGuard.
            BOOL success = [identityProvider authenticateTransaction:transaction forIdentity:app.identity withResponse:txnResponse callback:nil error:&error];
            if (success) {
                printf("You have successfully sent a %s response to transaction with id %s.\n", [[ETTransaction stringFromTransactionResponse:txnResponse] UTF8String], [transaction.transactionId UTF8String]);
            } else {
                printf("There was an error sending the transaction response.\n");
                if (error) {
                    printf("Error: %s\n", [[error localizedDescription] UTF8String]);
                }
            }
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
    return app.identity != nil && app.identity.registeredForTransactions == YES && [SDKUtils loadTransactionUrl] != nil;
}

@end
