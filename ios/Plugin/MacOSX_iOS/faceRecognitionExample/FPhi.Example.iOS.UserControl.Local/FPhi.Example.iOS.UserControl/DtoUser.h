#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIImage.h>


@interface DtoUser : NSObject

@property (nonatomic) NSString *idUser;
@property (nonatomic) NSString *name;
@property (nonatomic) NSData *userStructure;

-(instancetype)initWithData :(NSString*) idUser name:(NSString*)name;

@end
