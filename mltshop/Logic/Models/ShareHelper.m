//
//  ShareHelper.m
//  bitmedia
//
//  Created by meng qian on 14-3-7.
//  Copyright (c) 2014年 thinktube. All rights reserved.
//

#import "ShareHelper.h"
#import "AppRequestManager.h"
#import "AppDelegate.h"
#import "ModelHelper.h"
#import "SGActionView.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <MessageUI/MessageUI.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import <NYXImagesKit/NYXImagesKit.h>
#import "NSDate+Utilities.h"


@interface ShareHelper()<WXApiDelegate,WeiboSDKDelegate, QQApiInterfaceDelegate, MFMailComposeViewControllerDelegate>

@property(nonatomic, strong)GoodsModel *theGoods;
@property(nonatomic, strong)NSArray* permissions;
@property(nonatomic, strong)NSMutableDictionary* tencentUserInfo;
@property(nonatomic, strong)MFMailComposeViewController *mailComposeViewController;

@end


@implementation ShareHelper
@synthesize shareDelegateForAppDelegate;
@synthesize permissions;
@synthesize tencentUserInfo;

+ (ShareHelper *)sharedHelper {
    static ShareHelper *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[ShareHelper alloc] init];

    });
    
    return _sharedClient;
}

////////////////////////////////////////////////
#pragma mark - wechat delegate
////////////////////////////////////////////////

- (void)shareByWechatWithContent:(NSString *)content scene:(enum WXScene)scene
{
   SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
   req.text = content;
   req.bText = YES;
   req.scene = scene;
   
   [WXApi sendReq:req];
}

- (void)shareByWechatWithTitle:(NSString *)title
                     description:(NSString *)description
                       thumbnail:(UIImage *)thumbnail
                       urlString:(NSString *)urlString
                           scene:(enum WXScene)scene
{
   
   WXMediaMessage *message = [WXMediaMessage message];
   if (scene == WXSceneTimeline) {
       message.title = title;
       message.description = description;
   }else{
       message.title = title;
       message.description = description;
   }
   
   [message setThumbImage:thumbnail];
   
   WXWebpageObject *ext = [WXWebpageObject object];
   ext.webpageUrl = urlString;
   
   message.mediaObject = ext;
   
   SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
   req.bText = NO;
   req.message = message;
   req.scene = scene;
   
   [WXApi sendReq:req];
}

// 发送一个sendReq后，收到微信或qq的回应
// 微信和QQ回应方法名一样, so..先判断一下

-(void)onResp:(id)resp
{
    // wechat
    if([resp isKindOfClass:[BaseResp class]])
    {
        if([resp errCode] == 0){
            [DataTrans showWariningTitle:T(@"分享成功") andCheatsheet:ICON_CHECK];
        }else{
            [DataTrans showWariningTitle:T(@"分享失败") andCheatsheet:ICON_TIMES];
        }
    }
    
    // QQ contect
    if([resp isKindOfClass:[QQBaseResp class]])
    {
        NSLog(@"%@", [resp errorDescription]);
        [DataTrans showWariningTitle:T(@"分享成功") andCheatsheet:ICON_CHECK];
    }
}

- (void)onReq:(BaseReq *)req
{
   
}

/////////////////////////////////////////////////////
#pragma mark -  weibo delegate
/////////////////////////////////////////////////////

- (void)shareByWeiboWithContent:(NSString *)content
                     thumbnail:(UIImage *)thumbnail

{
   
   WBMessageObject *message = [WBMessageObject message];
   
   message.text = content;
   message.imageObject = [WBImageObject object];
   message.imageObject.imageData = UIImageJPEGRepresentation(thumbnail, JPEG_QUALITY);
   
   WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
   
   [WeiboSDK sendRequest:request];
   
}


// email
- (void)shareByEmailWithTitle:(NSString *)title
                      content:(NSString *)Content
{

}
// link
- (void)shareByLinkWithContent:(NSString *)content
{
    
}

// make content
- (NSString *)makeShareContentWithTitle:(NSString *)title
                            description:(NSString *)description
                              urlString:(NSString *)urlString
{
    return @"";
}


////////////////////////////////////////////////////////////////////////
#pragma mark - weibo delegate
////////////////////////////////////////////////////////////////////////


- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    //    if ([request isKindOfClass:WBProvideMessageForWeiboRequest.class])
    //    {
    //        ProvideMessageForWeiboViewController *controller = [[[ProvideMessageForWeiboViewController alloc] init] autorelease];
    //        [self.viewController presentModalViewController:controller animated:YES];
    //    }
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            [DataTrans showWariningTitle:@"微博发送成功" andCheatsheet:ICON_CHECK];
        }else{
            [DataTrans showWariningTitle:@"微博未发送成功" andCheatsheet:ICON_TIMES];
        }
        
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        
        NSString *userID = [(WBAuthorizeResponse *)response userID];
        
        if (StringHasValue(userID)) {
            NSDictionary *userInfo = (NSDictionary *)response.userInfo;
            NSLog(@"From Sina %@",userInfo);
            // save success and seetingme
//            [[ModelHelper sharedHelper]updateMeWithWeiboAuthorizeData:userInfo];
            
        }else{
//            DDLogError(@"user weibo cancel");
        }
    }
}

/////////////////////////////////////////////////////
#pragma mark - tencent delegate
/////////////////////////////////////////////////////

- (void)shareByQQWithTitle:(NSString *)title description:(NSString *)description thumbnail:(UIImage *)thumbnail urlString:(NSString *)urlString scene:(QQShareType)scene
{
    QQApiNewsObject *message = [QQApiNewsObject objectWithURL:[NSURL URLWithString:urlString] title:title description:description previewImageData:UIImagePNGRepresentation(thumbnail)];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:message];
    if (scene == kShareMsgToQQ) {
        [QQApiInterface sendReq:req];
    }else if (scene == kShareMsgToQQQZone){
        [QQApiInterface SendReqToQZone:req];
    }
}

/////////////////////////////////////////////////////
#pragma mark - view show delegate
/////////////////////////////////////////////////////

- (void)showShareView:(GoodsModel *)_goods
{
    self.theGoods = _goods;
    [[SGActionView sharedActionView]setStyle:SGActionViewStyleLight];
    [SGActionView showGridMenuWithTitle:T(@"")
                             itemTitles:@[T(@"微信好友"),T(@"微信朋友圈"),T(@"微博"),T(@"QQ好友"),T(@"QQ空间"),T(@"邮件"),T(@"复制链接")]
                                 images:@[[UIImage imageNamed:@"weixin_share_ico"],
                                          [UIImage imageNamed:@"weixinpengyou_share_ico"],
                                          [UIImage imageNamed:@"weibo"],
                                          [UIImage imageNamed:@"qq_share_ico"],
                                          [UIImage imageNamed:@"qqkongjian_share_ico"],
                                          [UIImage imageNamed:@"email_share_ico"],
                                          [UIImage imageNamed:@"link"]
                                          ]
                         selectedHandle:^(NSInteger index) {
                             [self shareActionClickWithIndex:index];
                         }];
}

- (void)shareActionClickWithIndex:(NSUInteger)index
{
    // get image and share
    NSString *photoPath = self.theGoods.cover.thumb;
//    photoPath = [photoPath stringByAppendingString:@"@640w_480h_90q"];
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:photoPath] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        //
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (error == nil) {
            [self shareActionClickWithIndex:index andImage:image];
        }
    }];
    
}


- (void)shareActionClickWithIndex:(NSUInteger)index andImage:(UIImage *)messageImage
{
    UIImage *cropImage = [messageImage scaleToCoverSize:CGSizeMake(messageImage.size.width/8, messageImage.size.height/8)];
    NSLog(@"cropImage %f %f",cropImage.size.width, cropImage.size.height);
    
    NSString *wechatMessageTitle = [NSString stringWithFormat:@"%@-%.2f-%@-漫骆驼-中国最大的正品电影动漫周边商城",
                                    self.theGoods.goodsName,
                                    self.theGoods.shopPrice.floatValue,
                                    self.theGoods.brandName];
    
    NSString *shareUrl = [NSString stringWithFormat:@"%@/goods-%@.html",BASE_API,self.theGoods.goodsId];

    NSString *messageBody = self.theGoods.goodsBrief;
    
    [self showShareViewWithTitle:wechatMessageTitle description:messageBody thumbnail:cropImage urlString:shareUrl andIndex:index];
    
}

- (void)showShareViewWithTitle:(NSString *)title description:(NSString *)description thumbnail:(UIImage *)thumbnail urlString:(NSString *)urlString andIndex:(NSInteger)index
{

    if (index == ShareTypeWechat) {
        //        [[ShareHelper sharedHelper]sendTextContent:[DataTrans getArticleTitle:self.baseInfo] scene:WXSceneSession];
        [[ShareHelper sharedHelper]shareByWechatWithTitle:title
                                              description:description
                                                thumbnail:thumbnail
                                                urlString:urlString
                                                    scene:WXSceneSession];
    }else if (index == ShareTypeWechatFriend){
        [[ShareHelper sharedHelper]shareByWechatWithTitle:title
                                              description:description
                                                thumbnail:thumbnail
                                                urlString:urlString
                                                    scene:WXSceneTimeline];
    }else if (index == ShareTypeQQFriend) {
        [[ShareHelper sharedHelper]shareByQQWithTitle:title
                                          description:description
                                            thumbnail:thumbnail
                                            urlString:urlString
                                                scene:kShareMsgToQQ];
    }else if (index == ShareTypeQQZone){
        [[ShareHelper sharedHelper]shareByQQWithTitle:title
                                          description:description
                                            thumbnail:thumbnail
                                            urlString:urlString
                                                scene:kShareMsgToQQQZone];
    }else if (index == ShareTypeWeibo){
        [[ShareHelper sharedHelper] shareByWeiboWithContent:[NSString stringWithFormat:@"%@ \n%@",description,urlString]
                                                  thumbnail:thumbnail];
        
    }else if (index == ShareTypeEmail){
        //判断设备是否能够发送邮件
        if ([MFMailComposeViewController canSendMail]) {
            self.mailComposeViewController = [[MFMailComposeViewController alloc] init];
            self.mailComposeViewController.mailComposeDelegate = self;
            [self.mailComposeViewController setTitle:T(@"发送邮件")];
            [self.mailComposeViewController setSubject:title];
            NSString *bodyString = [NSString stringWithFormat:@"%@\n\n%@\n\n%@",title,urlString,description];
            [self.mailComposeViewController setMessageBody:bodyString isHTML:NO];
            NSData *imageData = UIImageJPEGRepresentation(thumbnail, 1.0);
            [self.mailComposeViewController addAttachmentData:imageData mimeType:@"image/jpeg" fileName:[title stringByAppendingString:@".jpg"]];
            self.mailComposeViewController.navigationBar.tintColor = [UIColor blackColor];//Cancel button text color
            [self.baseViewController presentViewController:self.mailComposeViewController animated:YES completion:^{
                //
            }];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误提示" message:@"无法发送邮件，请先绑定邮件账户" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
        
        
    }else if (index == ShareTypeLink){
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = urlString;
        [DataTrans showWariningTitle:T(@"拷贝到粘贴板") andCheatsheet:ICON_CHECK];
        NSLog(@"ShareTypeLink: %@",pasteboard.string);
    }
    
}

/////////////////////////////////////////////////////
#pragma mark -  mailCompose delegate
/////////////////////////////////////////////////////

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail send canceled...");
            [DataTrans showWariningTitle:@"取消发送" andCheatsheet:nil];
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved...");
            [DataTrans showWariningTitle:@"邮件已保存" andCheatsheet:ICON_CHECK];
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent...");
            [DataTrans showWariningTitle:@"发送成功" andCheatsheet:ICON_CHECK];
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            [DataTrans showWariningTitle:@"发送失败" andCheatsheet:nil];
            break;
        default:
            break;
    }
    
    [self.mailComposeViewController dismissViewControllerAnimated:YES completion:nil];
}



@end
