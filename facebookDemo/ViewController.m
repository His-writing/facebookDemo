//
//  ViewController.m
//  facebookDemo
//
//  Created by shuzhenguo on 2016/11/18.
//  Copyright © 2016年 shuzhenguo. All rights reserved.
//

#import "ViewController.h"
#import "SZG_FBSDKShareContent.h"
#import "SZG_FBSDKHelper.h"

static NSString * const CELLID = @"cellID";

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>


@end

@implementation ViewController

{
    UITableView *demoTV;
    NSArray *list;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initList];
    
    demoTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 20.f, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 20.f)
                                          style:UITableViewStylePlain];
    demoTV.delegate = self;
    demoTV.dataSource = self;
    [self.view addSubview:demoTV];
}

- (void)initList
{
    list = @[@"Login",
             @"Share",
             @"Invite",
             @"Request",
             @"Friends"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return list.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CELLID];
    }
    cell.textLabel.text = list[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            [self facebookLogin];
            break;
        case 1:
            [self facebookShare];
            break;
        case 2:
            [self facebookInvite];
            break;
        case 3:
            [self facebookRequest];
            break;
        case 4:
            [self facebookFriends];
            break;
        default:
            break;
    }
}

- (void)facebookLogin
{
    [SZG_FBSDKHelper facebookLoginSuccess:^
     {
         NSLog(@"facebook login success");
     }
                              cancel:^
     {
         NSLog(@"facebook login cancelled");
     }
                             failure:^(NSError *error)
     {
         
         
         NSLog(@"facebook login failed : %@", error);
     }];
}

- (void)facebookShare
{
    
    
//    return @[
//             [SIPhoto photoWithObjectURL:[NSURL URLWithString:@"http://shareitexampleapp.parseapp.com/goofy/"]
//                                   title:@"Make a Goofy Face"
//                                  rating:5
//                                   image:[UIImage imageNamed:@"Goofy"]],
//             [SIPhoto photoWithObjectURL:[NSURL URLWithString:@"http://shareitexampleapp.parseapp.com/viking/"]
//                                   title:@"Happy Viking, Happy Liking"
//                                  rating:3
//                                   image:[UIImage imageNamed:@"Viking"]],
//             [SIPhoto photoWithObjectURL:[NSURL URLWithString:@"http://shareitexampleapp.parseapp.com/liking/"]
//                                   title:@"Happy Liking, Happy Viking"
//                                  rating:4
//                                   image:[UIImage imageNamed:@"Liking"]],
//             ];
//}

    SZG_FBSDKShareContent *content = [[SZG_FBSDKShareContent alloc] init];
    content.link = @"http://www.chinabooks99.top";
    content.title = @"ios 开发网站，有空就更新";
    content.picture = @"http://img3.redocn.com/20100401/Redocn_2010022517534367.jpg";
    content.describe = @"SHARE!";
    
    [SZG_FBSDKHelper facebookShareWithContent:content
                                 success:^
     {
         NSLog(@"facebook share success");
     }
                                  cancel:^
     {
         NSLog(@"facebook share cancelled");
     }
                                 failure:^(NSError *error)
     {
         NSLog(@"facebook share failed : %@", error);
     }];
}

- (void)facebookInvite
{
    SZG_FBSDKShareContent *content = [[SZG_FBSDKShareContent alloc] init];
    content.link = @"https://fb.me/100007451956356";
    content.picture = @"http://img3.redocn.com/20100401/Redocn_2010022517534367.jpg";
    
    [SZG_FBSDKHelper facebookInviteWithContent:content
                                  success:^
     {
         NSLog(@"facebook invite success");
     }
                                   cancel:^
     {
         NSLog(@"facebook invite cancelled");
     }
                                  failure:^(NSError *error)
     {
         NSLog(@"facebook invite failed : %@", error);
     }];
}

- (void)facebookRequest
{
    SZG_FBSDKShareContent *content = [[SZG_FBSDKShareContent alloc] init];
    content.title = @"title";
    content.describe = @"message";
    
    [SZG_FBSDKHelper facebookRequestWithContent:content
                                   success:^
     {
         NSLog(@"facebook request success");
     }
                                    cancel:^
     {
         NSLog(@"facebook request cancelled");
     }
                                   failure:^(NSError *error)
     {
         NSLog(@"facebook request failed : %@", error);
     }];
}

- (void)facebookFriends
{
    [SZG_FBSDKHelper facebookFriendsListSuccess:^(id result)
     {
         NSLog(@"facebook friends list : %@", result);
     }
                                   failure:^(NSError *error)
     {
         NSLog(@"facebook request friends list failed : %@", error);
     }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
