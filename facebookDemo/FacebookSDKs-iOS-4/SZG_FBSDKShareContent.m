
#import "SZG_FBSDKShareContent.h"

@implementation SZG_FBSDKShareContent

- (instancetype)initWithLinkURL:(NSString *)link
                      withTitle:(NSString *)title
                    withPicture:(NSString *)picture
                   withDescribe:(NSString *)describe
{
    self = [super init];
    if (self)
    {
        self.link = link;
        self.title = title;
        self.picture = picture;
        self.describe = describe;
    }
    return self;
}

@end
