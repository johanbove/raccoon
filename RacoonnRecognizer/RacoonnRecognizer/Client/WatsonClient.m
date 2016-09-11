//
//  WatsonClient.m
//  RacoonnRecognizer
//
//  Created by Alexander Sivura on 9/11/16.
//  Copyright © 2016 sivura. All rights reserved.
//

#import "WatsonClient.h"

@implementation WatsonClient

+ (WatsonClient *) sharedClient {
    static WatsonClient *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WatsonClient alloc] init];
    });
    return sharedInstance;
}




@end
