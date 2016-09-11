//
//  ViewController.h
//  RacoonnRecognizer
//
//  Created by Alexander Sivura on 9/10/16.
//  Copyright © 2016 sivura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GPUImage/GPUImage.h>

@interface ViewController : UIViewController
{
    GPUImageStillCamera *videoCamera;

    GPUImageMovieWriter *movieWriter;
}


@end
