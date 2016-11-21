
#import <Foundation/Foundation.h>

@interface SZG_FBSDKShareContent : NSObject

@property (nonatomic, copy) NSString *link;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *picture;

@property (nonatomic, copy) NSString *describe;

- (instancetype)initWithLinkURL:(NSString *)link
                      withTitle:(NSString *)title
                    withPicture:(NSString *)picture
                   withDescribe:(NSString *)describe;

@end
