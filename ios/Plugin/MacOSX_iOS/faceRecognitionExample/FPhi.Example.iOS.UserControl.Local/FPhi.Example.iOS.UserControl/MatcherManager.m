#import "MatcherManager.h"
#import "AppDelegate.h"
#import "ETSoftTokenSDK.h"


@interface MatcherManager ()

@end


@implementation MatcherManager

@synthesize users;

+(id) sharedInstance {
    static MatcherManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(id)init {
    if(self == [super init]) {
        users = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(FPBMatcher*) generateStandardMatcher {
    
    NSError *error = nil;
    
    // Create LicenseManager.
    FPBMatcherLicenseManager *mlm = (FPBMatcherLicenseManager*) [ETSoftTokenSDK getFPBMatcherLicenseManager];
    if (mlm==nil){
         NSLog(@"Error: %@", @"Cannot retrieve license manager isntance");
        return nil;
    }
    
    // Set Matcher Configuration and License
    FPBMatcherConfigurationManager *mcm = [[FPBMatcherConfigurationManager alloc] init:FPBMatchingSecurityLevelHigh withTemplateReliability:FPBTemplateReliabilityExtreme withMatcherLicenseManager:mlm];
    
    // Create Matcher instance to return.
    FPBMatcher *matcher = [[FPBMatcher alloc] init:mcm outError:&error];
    
    // TODO: Manage matcher creation error.
    if(error != nil) {
        NSLog(@"Error: %@", error);
        
        if(error.userInfo != nil)
            NSLog(@"Error: %@", error.userInfo.description);
    }
    
    return matcher;
}

-(bool) createUser :(NSString*)userName :(NSData *)templateData {
    
    // Create Matcher instance.
    FPBMatcher *matcher = [self generateStandardMatcher];
    
    if(matcher == nil)
        return false;
    
    NSError *error = nil;
    
    // FacePhi user creation
    NSData * userStructure = [matcher createUser:templateData outError:&error];
    
    // TODO: Manage matcher creation error.
    if(error != nil) {
        NSLog(@"Error: %@", error);
        
        if(error.userInfo != nil)
            NSLog(@"Error: %@", error.userInfo.description);
        
        return false;
    }
    
    // TODO: Store user structure in database.
    // Example: Store in memory.
    DtoUser *dtoUser = [[DtoUser alloc] init];
    dtoUser.idUser = userName;
    dtoUser.name = userName;
    dtoUser.userStructure = userStructure;
    
    [users addObject:dtoUser];
    
    return true;
}

-(bool) authenticate :(NSString*)userName :(NSData *)templateData {
    
    // Create Matcher instance.
    FPBMatcher *matcher = [self generateStandardMatcher];
    
    if(matcher == nil)
        return false;
    
    NSError *error = nil;
    
    // TODO: Retrieve the user from database.
    // Example: Retrieve from memory.
    DtoUser *dtoUser = nil;
    int userIndex = 0;
    for(userIndex = 0; userIndex < users.count; userIndex++) {
        dtoUser = (DtoUser*)[users objectAtIndex:userIndex];
        if([userName isEqualToString:dtoUser.name]){
            break;
        }
    }
    
    // Check if user exists.
    if(userIndex == users.count) {
        NSLog(@"User not found");
        return false;
    }
    
    // FacePhi user validation
    FPBAuthenticationResult* authResult = [matcher authenticateRetrain:dtoUser.userStructure withTemplateData:templateData outError:&error];
    
    // TODO: Manage matcher authentication error.
    if(error != nil) {
        NSLog(@"Error: %@", error);
        
        if(error.userInfo != nil)
            NSLog(@"Error: %@", error.userInfo.description);
        
        return false;
    }
    
    // TODO: Store user structure in database if user is retrained.
    // Example: Store in memory.
    NSData *userRetrained = authResult.retrainedUser;
    if(userRetrained != nil) {
        dtoUser.userStructure = userRetrained;
        
        [users replaceObjectAtIndex:userIndex withObject:dtoUser];
    }
    
    // Return true if user is authenticated and false otherwise.
    return authResult.isPositiveMatch;
}

-(NSMutableArray*) getUsers {
    return users;
}

-(void) deleteUser:(NSString*)userName {
    
    // TODO: Retrieve the user from database.
    // Example: Retrieve from memory.
    DtoUser *dtoUser = nil;
    int userIndex = 0;
    for(userIndex = 0; userIndex < users.count; userIndex++) {
        dtoUser = (DtoUser*)[users objectAtIndex:userIndex];
        if([userName isEqualToString:dtoUser.name]){
            break;
        }
    }
    
    // Check if user exists.
    if(userIndex == users.count) {
        NSLog(@"User not found");
        return;
    }
    
    // TODO: Delete facial user structure in database.
    // Example: Remove in memory.
    [users removeObjectAtIndex:userIndex];
}

@end
