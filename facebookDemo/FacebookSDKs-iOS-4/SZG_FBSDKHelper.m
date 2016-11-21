
#import "SZG_FBSDKHelper.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

#import "SZG_FBSDKShareContent.h"

#define MY_KEYWINDOW_ROOTVC  [[[UIApplication sharedApplication] keyWindow] rootViewController]

@interface SZG_FBSDKHelper () <FBSDKSharingDelegate, FBSDKAppInviteDialogDelegate, FBSDKGameRequestDialogDelegate>

@property (nonatomic, weak) void(^shareSuccess)(void);
@property (nonatomic, weak) void(^shareCancel)(void);
@property (nonatomic, weak) void(^shareFailure)(NSError *error);

@property (nonatomic, weak) void(^inviteSuccess)(void);
@property (nonatomic, weak) void(^inviteCancel)(void);
@property (nonatomic, weak) void(^inviteFailure)(NSError *error);

@property (nonatomic, weak) void(^requestSuccess)(void);
@property (nonatomic, weak) void(^requestCancel)(void);
@property (nonatomic, weak) void(^requestFailure)(NSError *error);

@end

@implementation SZG_FBSDKHelper

static SZG_FBSDKHelper *instance = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

+ (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
}

+ (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

+ (void)facebookLoginSuccess:(void (^)(void))success
                      cancel:(void (^)(void))cancel
                     failure:(void (^)(NSError *))failure
{
    FBSDKLoginManager *manager = [[FBSDKLoginManager alloc] init];
    manager.loginBehavior = FBSDKLoginBehaviorWeb;
    NSArray *permissions = @[
                             @"public_profile",
                             @"user_friends",
                             ];
    [manager logInWithReadPermissions:permissions
                   fromViewController:MY_KEYWINDOW_ROOTVC
                              handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
     {
         if (error)
         {
             failure(error);
         }
         else if (result.isCancelled)
         {
             cancel();
         }
         else if (result.token)
         {
             FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                                                            parameters:nil];
             
             [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id reqResult, NSError *error)
              {
                  if (!error)
                  {
                      NSLog(@"Facebook Account Info : %@", reqResult);
                      success();
                  }
                  else
                  {
                      failure(error);
                  }
              }];
         }
         else
        {
            cancel();
         }
     }];
}

+ (void)facebookShareWithContent:(SZG_FBSDKShareContent *)content
                         success:(void (^)(void))success
                          cancel:(void (^)(void))cancel
                         failure:(void (^)(NSError *))failure
{
    SZG_FBSDKHelper *helper = [SZG_FBSDKHelper sharedInstance];
    helper.shareSuccess = success;
    helper.shareCancel = cancel;
    helper.shareFailure = failure;
    
    FBSDKShareLinkContent *linkContent = [[FBSDKShareLinkContent alloc] init];
    linkContent.contentURL = [NSURL URLWithString:content.link];
    linkContent.contentTitle = content.title;
    linkContent.imageURL = [NSURL URLWithString:content.picture];
    linkContent.contentDescription = content.describe;
    
    FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
    dialog.shareContent = linkContent;
//    dialog.mode = FBSDKShareDialogModeFeedWeb;
    dialog.mode = FBSDKShareDialogModeAutomatic;

    
    dialog.fromViewController = MY_KEYWINDOW_ROOTVC;
    dialog.delegate = helper;
    [dialog show];
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer
{
    [SZG_FBSDKHelper sharedInstance].shareCancel();
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
    [SZG_FBSDKHelper sharedInstance].shareFailure(error);
}

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    if (results[@"postId"])
    {
        [SZG_FBSDKHelper sharedInstance].shareSuccess();
        return;
    }
    [SZG_FBSDKHelper sharedInstance].shareCancel();
}

+ (void)facebookInviteWithContent:(SZG_FBSDKShareContent *)content
                          success:(void (^)(void))success
                           cancel:(void(^)(void))cancel
                          failure:(void (^)(NSError *))failure
{
    SZG_FBSDKHelper *helper = [SZG_FBSDKHelper sharedInstance];
    helper.inviteSuccess = success;
    helper.inviteCancel = cancel;
    helper.inviteFailure = failure;
    
    FBSDKAppInviteContent *inviteContent = [[FBSDKAppInviteContent alloc] init];
    inviteContent.appLinkURL = [NSURL URLWithString:content.link];
    inviteContent.appInvitePreviewImageURL = [NSURL URLWithString:content.picture];
    
    FBSDKAppInviteDialog *dialog = [[FBSDKAppInviteDialog alloc] init];
    dialog.content = inviteContent;
    dialog.fromViewController = MY_KEYWINDOW_ROOTVC;
    dialog.delegate = helper;
    
    [dialog show];
}

- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results
{
    if (results[@"didComplete"] && ![results[@"completionGesture"] isEqualToString:@"cancel"])
    {
        [SZG_FBSDKHelper sharedInstance].inviteSuccess();
        return;
    }
    [SZG_FBSDKHelper sharedInstance].inviteCancel();
}

- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error
{
    [SZG_FBSDKHelper sharedInstance].inviteFailure(error);
}

+ (void)facebookRequestWithContent:(SZG_FBSDKShareContent *)content
                           success:(void (^)(void))success
                            cancel:(void (^)(void))cancel
                           failure:(void (^)(NSError *))failure
{
    SZG_FBSDKHelper *helper = [SZG_FBSDKHelper sharedInstance];
    helper.requestSuccess = success;
    helper.requestCancel = cancel;
    helper.requestFailure = failure;
    
    FBSDKGameRequestContent *requestContent = [[FBSDKGameRequestContent alloc] init];
    requestContent.message = content.describe;
    requestContent.title = content.title;
    
    [FBSDKGameRequestDialog showWithContent:requestContent
                                   delegate:helper];
}

- (void)gameRequestDialog:(FBSDKGameRequestDialog *)gameRequestDialog didCompleteWithResults:(NSDictionary *)results
{
    [SZG_FBSDKHelper sharedInstance].requestSuccess();
}

- (void)gameRequestDialog:(FBSDKGameRequestDialog *)gameRequestDialog didFailWithError:(NSError *)error
{
    [SZG_FBSDKHelper sharedInstance].requestFailure(error);
}

- (void)gameRequestDialogDidCancel:(FBSDKGameRequestDialog *)gameRequestDialog
{
    [SZG_FBSDKHelper sharedInstance].requestCancel();
}

+ (void)facebookFriendsListSuccess:(void (^)(id))success
                           failure:(void (^)(NSError *))failure
{
    if ([[FBSDKAccessToken currentAccessToken].permissions containsObject:@"user_friends"])
    {
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me/friends?fields=id,name,picture&limit=100000"
                                                                       parameters:nil
                                                                       HTTPMethod:@"GET"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
        {
            if (error)
            {
                failure(error);
            }
            else
            {
                success(result);
            }
        }];
    }
}

@end
