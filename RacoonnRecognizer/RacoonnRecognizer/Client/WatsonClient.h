//
//  WatsonClient.h
//  RacoonnRecognizer
//
//  Created by Alexander Sivura on 9/11/16.
//  Copyright © 2016 sivura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WatsonClient : NSObject

+ (WatsonClient *)sharedClient;
- (void) recognizePhoto: (UIImage *) image compltion: (void (^)(NSString *category))completion;



@end
