//
//  ArduinoClient.h
//  RacoonnRecognizer
//
//  Created by Alexander Sivura on 9/11/16.
//  Copyright © 2016 sivura. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArduinoClient : NSObject

+ (ArduinoClient *)sharedClient;
- (void) sendNumber: (NSNumber *) number compltion: (void (^)(NSString *result))completion;


@end
