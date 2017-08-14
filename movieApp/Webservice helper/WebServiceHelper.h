//
//  WebServiceHelper.h
//  APiDemo
//
//  Created by SourceKode on 06/10/15.
//  Copyright © 2015 Ecsion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>

@interface WebServiceHelper : NSObject<NSURLSessionDataDelegate>

+ (WebServiceHelper *)sharedInstance;

- (void)callGetDataWithMethod:(NSString *)strMethodName  withParameters:(NSDictionary *)requestDict  withHud:(BOOL)isHud success:(void(^)(id response))successBlock errorBlock:(void(^)(id error))errorBlock withHeader:(NSDictionary *)Value;
- (void)callPostDataWithMethod:(NSString *)strMethodName withParameters:(NSDictionary *)requestDict  withHud:(BOOL)isHud success:(void(^)(id response))successBlock errorBlock:(void(^)(id error))errorBlock  withHeaderValues:(NSDictionary *)headerValue;



@end
