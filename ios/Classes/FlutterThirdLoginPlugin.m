#import "FlutterThirdLoginPlugin.h"
#import <AuthenticationServices/AuthenticationServices.h>

@interface FlutterThirdLoginPlugin() <ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>
@property(nonatomic,strong)NSString * token;//调用获取token方法拿到的token值
@end

@implementation FlutterThirdLoginPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_third_login"
            binaryMessenger:[registrar messenger]];
  FlutterThirdLoginPlugin* instance = [[FlutterThirdLoginPlugin alloc] init];
    [instance initd];
    instance.channel = channel;
  [registrar addApplicationDelegate:instance];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void) initd
{
   
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
   if ([@"getPlatformVersion" isEqualToString:call.method]) {
     result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
   }else if ([@"iosLogin" isEqualToString:call.method]) {
       [self iosLogin:result];
       result(@"start login");
   }else if([@"allowIosLogin" isEqualToString:call.method]){
       [self allowIosLogin:result];
   }else if ([@"initAuthMobile" isEqualToString:call.method]) {
       NSString* appid = call.arguments[@"appid"];
       result(@"start initAuthMobile");
   }else if ([@"AuthMobileType" isEqualToString:call.method]) {
       
   }
   else if ([@"preLoginAuthMobile" isEqualToString:call.method]) {
   }
   else if ([@"LoginAuthMobile" isEqualToString:call.method]) {
   }
    else {
     result(FlutterMethodNotImplemented);
   }
}


    
- (void)iosLogin:(FlutterResult)result {
    if(@available(iOS 13.0, *))
    {
        ASAuthorizationAppleIDProvider *appleProvider = [[ASAuthorizationAppleIDProvider alloc] init];
        ASAuthorizationAppleIDRequest *request = appleProvider.createRequest;
        request.requestedScopes = @[ASAuthorizationScopeFullName];
        ASAuthorizationController *controller = [[ASAuthorizationController alloc]initWithAuthorizationRequests:@[request]];
        controller.delegate = self;
        controller.presentationContextProvider = self;
        [controller performRequests];
    }
    else
    {
        NSLog(@"less ios 13.0, can not to login");
    }
}

- (void)allowIosLogin:(FlutterResult)result {
    
    if(@available(iOS 13.0, *))
    {
        result(@"true");
    }
    else
    {
        result(@"false");
    }
}
    
- (void)event:(NSString*)type par2: (NSString*)content par3: (int)code{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:content forKey:@"content"];
    [dic setObject: [NSNumber numberWithInt:code] forKey:@"code"];
    [self.channel invokeMethod:type arguments:dic];
}
    
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization*)authorization API_AVAILABLE(ios(13.0)){
    if([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]])
    {
        ASAuthorizationAppleIDCredential * credential = (ASAuthorizationAppleIDCredential*)authorization.credential;
        NSString *state = credential.state;
        NSString *userID = credential.user;
        NSPersonNameComponents *fullName = credential.fullName;
        NSString *email = credential.email;
        NSString *authorizationCode = [[NSString alloc] initWithData:credential.authorizationCode encoding:NSUTF8StringEncoding];
        NSString *identityToken = [[NSString alloc] initWithData:credential.identityToken encoding:NSUTF8StringEncoding];
        ASUserDetectionStatus realUserStatus = credential.realUserStatus;
        NSArray *authorizedScopes = credential.authorizedScopes;
        
        NSLog(@"state: %@", state);
        NSLog(@"userID: %@", userID);
        NSLog(@"fullName: %@", fullName);
        NSLog(@"email: %@", email);
        NSLog(@"authorizationCode: %@", authorizationCode);
        NSLog(@"identityToken: %@", identityToken);
        NSLog(@"realUserStatus: %@", @(realUserStatus));
        NSLog(@"authorizedScopes: %@", authorizedScopes);
        [self event:@"iosLogin" par2:userID par3:0];
        
    }else if([authorization.credential isKindOfClass:[ASPasswordCredential class]]){
        ASPasswordCredential *pasCredential = authorization.credential;
        NSString *user = pasCredential.user;
        NSString *psd = pasCredential.password;
        NSLog(@"psduser %@ %@", psd, user);
        [self event:@"iosLogin" par2:user par3:-1];
    }
}

#pragma mark - ASAuthorizationControllerDelegate

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)) {
    NSString *errorMsg = nil;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"用户取消了授权请求";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            break;
    }
    //[self event:@"iosLogin" par2:errorMsg];
    NSLog(@"%@", errorMsg);
}

#pragma mark - ASAuthorizationControllerPresentationContextProviding
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller API_AVAILABLE(ios(13.0)) {
    return [UIApplication sharedApplication].keyWindow;
}

@end
