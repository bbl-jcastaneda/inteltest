#import "DtoUser.h"


@implementation DtoUser


-(instancetype)initWithData :(NSString*) idUser name:(NSString*)name {
    self = [super init];
    if(!self)
        return nil;
    
    self.idUser = idUser;
    self.name = name;
    
    return self;
}

@end
