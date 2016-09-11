//
//  WatsonClient.m
//  RacoonnRecognizer
//
//  Created by Alexander Sivura on 9/11/16.
//  Copyright © 2016 sivura. All rights reserved.
//

#import "WatsonClient.h"
#import <AFNetworking/AFNetworking.h>

@interface WatsonClient()

@property(nonatomic, strong) AFURLSessionManager *sessionManager;


@end

@implementation WatsonClient

+ (WatsonClient *) sharedClient {
    static WatsonClient *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WatsonClient alloc] init];
    });
    return sharedInstance;
}

- (AFURLSessionManager *) sessionManager {
    if (!_sessionManager) {
       _sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
 
    }
    return _sessionManager;
}

- (void) recognizePhoto: (UIImage *) image compltion: (void (^)(NSString *category))completion {
   
    
    
    
    
    NSString *urlString = [NSString stringWithFormat:@"https://gateway-a.watsonplatform.net/visual-recognition/api/v3/classify?api_key=%@&version=2016-05-20&classifier_ids=soiled_271983402", @"eb77159345d46fd8d77426efc7256d2f76b8640b"];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *data = UIImageJPEGRepresentation(image, 1.f);
        [formData appendPartWithFileData:data name:@"images_file" fileName:@"img.jpeg" mimeType:@"image/jpg"];
    } error:nil];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [self.sessionManager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {

                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          NSLog(@"Error: %@", error);
                      } else {
                          NSLog(@"%@ %@", response, responseObject);
                      }
                      completion(@"");
                  }];
    
    [uploadTask resume];
}


@end
