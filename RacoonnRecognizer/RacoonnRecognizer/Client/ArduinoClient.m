//
//  ArduinoClient.m
//  RacoonnRecognizer
//
//  Created by Alexander Sivura on 9/11/16.
//  Copyright © 2016 sivura. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "ArduinoClient.h"

@interface ArduinoClient()

@property(nonatomic, strong) AFURLSessionManager *sessionManager;


@end

@implementation ArduinoClient

+ (ArduinoClient *) sharedClient {
    static ArduinoClient *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ArduinoClient alloc] init];
    });
    return sharedInstance;
}

- (AFURLSessionManager *) sessionManager {
    if (!_sessionManager) {
        _sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        
    }
    return _sessionManager;
}

- (void) sendNumber:(NSNumber *)number compltion:(void (^)(NSString *))completion {
    NSString *urlString = [NSString stringWithFormat:@"http://192.241.204.102:8001?set=%@", number];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [self.sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
        }
        completion(@"");
    }];
    [dataTask resume];
    
}


@end