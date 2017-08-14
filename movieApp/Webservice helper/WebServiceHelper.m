//
//  WebServiceHelper.m
//  APiDemo
//
//  Created by SourceKode on 06/10/15.
//  Copyright © 2015 Ecsion. All rights reserved.
//

#import "WebServiceHelper.h"
#import "SVProgressHUD.h"
#define baseUrl @"https://api.themoviedb.org/3"




@implementation WebServiceHelper

#pragma mark - SharedInstance

+ (WebServiceHelper *)sharedInstance {
    static dispatch_once_t pred;
    
    static WebServiceHelper *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [WebServiceHelper new];
        
    });
    return shared;
}

#pragma mark - Get API Calling

- (void)callGetDataWithMethod:(NSString *)strMethodName  withParameters:(NSDictionary *)requestDict  withHud:(BOOL)isHud success:(void(^)(id response))successBlock errorBlock:(void(^)(id error))errorBlock withHeader:(NSDictionary *)Value{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (isHud) {
            [SVProgressHUD showWithStatus:@"Loading"];
        }
    });
    
    NSMutableString *urlString = [NSMutableString new];
    [urlString appendString:baseUrl];
    [urlString appendString:@"/"];
    [urlString appendString:strMethodName];
    
    if (requestDict) {
        
        NSArray *keysArray = [requestDict allKeys];
        
        for (int i= 0 ; i< keysArray.count; i++) {
            
            NSString *key = [keysArray objectAtIndex:i];
            
            if (i == 0) {
                
                [urlString appendString:[NSString stringWithFormat:@"?%@=%@",key,[requestDict valueForKey:key]]];
                
            } else {
                
                [urlString appendString:[NSString stringWithFormat:@"&%@=%@",key,[requestDict valueForKey:key]]];
            }
        }
    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSDictionary * datavalue = Value;
    NSLog(@"%@",datavalue);
    if(Value!=nil){
    NSArray * keys = [Value allKeys];
    [request setValue:[Value valueForKey:keys[0]] forHTTPHeaderField:keys[0]];
    }
    // Asynchronously Api is hit here
    NSURLSessionDataTask * dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                       {
                                           
                                           if (data != nil && !error) {
                                               
                                               NSError *parseJsonError = nil;
                                               id response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseJsonError];
                                               

                                               
                                               if (!parseJsonError) {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       successBlock(response);
                                                   });                                               } else {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       errorBlock(response);
                                                   });
                                               }
                                               
                                           } else {
                                               
                                               errorBlock(@"Server is not responding. Please try after some time.");
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   errorBlock(response);
                                               });
                                           }

                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               if (isHud) {
                                                   
                                                   [SVProgressHUD dismiss];
                                               }
                                           });
                                       }];
    [dataTask resume] ;
}

#pragma mark - Post API Calling

- (void)callPostDataWithMethod:(NSString *)strMethodName withParameters:(NSDictionary *)requestDict  withHud:(BOOL)isHud  success:(void(^)(id response))successBlock errorBlock:(void(^)(id error))errorBlock withHeaderValues:(NSDictionary *)headerValue{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (isHud) {
            [SVProgressHUD showWithStatus:@"Loading"];
                   }
    });
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSString *encodedUrl = [[NSString stringWithFormat:@"%@%@", baseUrl, strMethodName]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *serverUrl = [self getURL:encodedUrl];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:serverUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];

    
    NSMutableString *paramStr = [NSMutableString new];
    for(NSString *key in requestDict){
        if(paramStr.length){
            [paramStr appendString:[NSString stringWithFormat:@"&%@=%@",key,requestDict[key]]];
        }else{
            [paramStr appendString:[NSString stringWithFormat:@"%@=%@",key,requestDict[key]]];
        }
    }
    

    NSData *postData = [paramStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *reqJSONStr = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];

    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[[reqJSONStr dataUsingEncoding:NSUTF8StringEncoding] mutableCopy]];
    if(headerValue!=nil){
        NSArray * allkeys = [headerValue allKeys];
         for(NSString *key in allkeys){
    [request setValue:[headerValue valueForKey:key] forHTTPHeaderField:key];
             
         }
        
        
    }
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data != nil && !error)
        {
            NSString *reqJSONStr1 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                  NSLog(@"%@",reqJSONStr1);

            NSError *parseJsonError = nil;
            id response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseJsonError];
            
            if (!parseJsonError) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    successBlock(response);
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    errorBlock(response);
                });
            }
            
        } else {
            
            errorBlock(@"Server is not responding. Please try after some time.");
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isHud) {
                [SVProgressHUD dismiss];
            }
        });
    }];
    [postDataTask resume];
}


- (NSURL *)getURL:(NSString *)urlStr {
    return [NSURL URLWithString:[urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
}

@end
