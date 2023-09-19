#ifndef MatcherManager_h
#define MatcherManager_h

#import <UIKit/UIKit.h>
#import "DtoUser.h"
#import "FPhi.Matcher.ios/FPhi.Matcher.ios.h"

@interface MatcherManager : NSObject

@property (nonatomic, retain) NSMutableArray* users;

/**
 Creates a new instance of MatcherManager withSingleton pattern.
 */
+(id) sharedInstance;

/**
 Generates a FacePhi Matcher with default configuration.
 */
-(FPBMatcher*) generateStandardMatcher;

/**
 Creates a new facial FacePhi user.
 */
-(bool) createUser :(NSString*)userName :(NSData *)templateData;

/**
 Authenticates a facial user template with the stored facial structure in database
 */
-(bool) authenticate :(NSString*)userName :(NSData *)templateData;

/**
 Gets a list of the users stored in database.
 */
-(NSMutableArray*) getUsers;

/**
 Deletes a user stored in database.
 */
-(void) deleteUser :(NSString*)userName;

@end


#endif /* MatcherManager_h */
