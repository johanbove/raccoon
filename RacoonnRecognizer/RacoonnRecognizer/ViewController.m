//
//  ViewController.m
//  RacoonnRecognizer
//
//  Created by Alexander Sivura on 9/10/16.
//  Copyright © 2016 sivura. All rights reserved.
//
#import "ViewController.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import "WatsonClient.h"

@interface ViewController()

@property (strong, nonatomic) GPUImageMotionDetector *motionDetector;

@property (strong, nonatomic) IBOutlet GPUImageView *imageView;
@property (strong, nonatomic) IBOutlet UISlider *strengthSlider;
@property (strong, nonatomic) IBOutlet UILabel *strengthLabel;
@property (strong, nonatomic) IBOutlet UIView *borderView;
@property (strong, nonatomic) IBOutlet UIImageView *photoView;
@property (strong, nonatomic) IBOutlet UIView *scannerView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scannerViewConstraint;

@property (strong, nonatomic) IBOutlet UIView *greyImageView;
@property(strong, nonatomic) GPUImageFilter *filter;




@property (nonatomic) BOOL isImageProcessing;
@property (nonatomic) BOOL isStarted;

@end

@implementation ViewController

- (GPUImageFilter *)filter {
    if (!_filter) {
        _filter = [[GPUImageFilter alloc] init];
    }
    return _filter;
}


- (GPUImageMotionDetector *)motionDetector {
    if (!_motionDetector) {
        _motionDetector = [[GPUImageMotionDetector alloc] init];
        _motionDetector.motionDetectionBlock = ^void (CGPoint motionCentroid, CGFloat motionIntensity, CMTime frameTime) {
            if (!self.isStarted) {
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
  
                if (motionIntensity > 0.01) {
                    //NSLog(@"motionCentroid: %@, motionIntensity %f, %lld", NSStringFromCGPoint(motionCentroid), motionIntensity, frameTime.value);
                    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(processImage:) object:nil];
                    if (motionCentroid.x > 0.3 && motionCentroid.x < 0.7 && motionCentroid.y > 0.3 && motionCentroid.y < 0.7) {
                        [self performSelector:@selector(processImage:) withObject:nil afterDelay:0.3f];
                    }
                    
                }
            });
            


            
        };
    }
    return _motionDetector;
}

- (void)setStarted: (id) sender {
    self.isStarted = YES;
}

- (void) startScannerAnimation {
    self.scannerViewConstraint.constant = 0;
    [self.view layoutIfNeeded];
    self.scannerView.hidden = NO;
    [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseInOut animations:^{
        self.scannerViewConstraint.constant = self.scannerView.superview.frame.size.width - self.scannerView.frame.size.width;
        [self.view layoutIfNeeded];
    } completion:nil];
    
}

- (void) stopScannerAnimation {
    [self.scannerView.layer removeAllAnimations];
    self.scannerViewConstraint.constant = 0;
    self.scannerView.hidden = YES;
}

- (UIImage *)imageByCroppingImage:(UIImage *)image scale: (CGFloat) scale
{
    // not equivalent to image.size (which depends on the imageOrientation)!
    double refWidth = CGImageGetWidth(image.CGImage);
    double refHeight = CGImageGetHeight(image.CGImage);
    
    double x = (refWidth - refWidth * scale) / 2.0;
    double y = (refHeight - refHeight * scale) / 2.0;
    
    CGRect cropRect = CGRectMake(x, y, refWidth * scale, refHeight * scale);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    
    UIImage *cropped = [UIImage imageWithCGImage:imageRef scale:0.0 orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);
    
    return cropped;
}


- (void)processImage: (id) sender {
    if (self.isImageProcessing) {
        return;
    }
    NSLog(@"Process image");
    self.isImageProcessing = YES;
    
    [videoCamera capturePhotoAsImageProcessedUpToFilter:self.filter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
       
        UIImage *image = [self imageByCroppingImage:processedImage scale: 0.7f];
        self.photoView.image = image;
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        self.photoView.hidden = NO;
        self.greyImageView.hidden = NO;
        [self startScannerAnimation];
        
        [[WatsonClient sharedClient] recognizePhoto:image compltion:^(NSString *category) {
            NSLog(@"Cactegory %@", category);
        }];
        
        [self performSelector:@selector(finishProcessImage:) withObject:nil afterDelay:4];
        
        
    }];
    
}

- (void)finishProcessImage: (id) sender {
    NSLog(@"Finish Process image");
    self.isImageProcessing = NO;
    self.photoView.hidden = YES;
    [self startScannerAnimation];
    self.greyImageView.hidden = YES;
    [self stopScannerAnimation];
}

- (void)setBorderView:(UIView *)borderView {
    _borderView = borderView;
    _borderView.layer.borderColor = [UIColor greenColor].CGColor;
    _borderView.layer.borderWidth = 3.0f;
}

- (IBAction)strangthChanged:(UISlider *)sender {
    [self updateStrangth];
}

- (void) updateStrangth {
    self.strengthLabel.text = [NSString stringWithFormat:@"%f", self.strengthSlider.value];
    self.motionDetector.lowPassFilterStrength = 0.5;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
     [self performSelector:@selector(setStarted:) withObject:nil afterDelay:1.f];
    
    videoCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];
 
    videoCamera.outputImageOrientation = UIInterfaceOrientationLandscapeRight;
   videoCamera.horizontallyMirrorFrontFacingCamera = YES;
    
    
    [self updateStrangth];

    
    [videoCamera addTarget:self.motionDetector];
    [videoCamera addTarget:self.filter];
    GPUImageView *filterView = self.imageView;

    [videoCamera addTarget:filterView];
    
    [videoCamera startCameraCapture];
    
 }



@end
