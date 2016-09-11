//
//  ViewController.m
//  RacoonnRecognizer
//
//  Created by Alexander Sivura on 9/10/16.
//  Copyright © 2016 sivura. All rights reserved.
//
#import "ViewController.h"
#import <AssetsLibrary/ALAssetsLibrary.h>

@interface ViewController()

@property (strong, nonatomic) GPUImageMotionDetector *filter;

@property (strong, nonatomic) IBOutlet GPUImageView *imageView;
@property (strong, nonatomic) IBOutlet UISlider *strengthSlider;
@property (strong, nonatomic) IBOutlet UILabel *strengthLabel;
@property (strong, nonatomic) IBOutlet UIView *borderView;

@end

@implementation ViewController


- (GPUImageMotionDetector *)filter {
    if (!_filter) {
        _filter = [[GPUImageMotionDetector alloc] init];
        _filter.motionDetectionBlock = ^void (CGPoint motionCentroid, CGFloat motionIntensity, CMTime frameTime) {
            if (motionIntensity > 0.01) {
                NSLog(@"motionCentroid: %@, motionIntensity %f, %lld", NSStringFromCGPoint(motionCentroid), motionIntensity, frameTime.value);
            }

            
        };
    }
    return _filter;
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
    self.filter.lowPassFilterStrength = self.strengthSlider.value;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];
    //    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];
    //    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionBack];
    //    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1920x1080 cameraPosition:AVCaptureDevicePositionBack];
    
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    videoCamera.horizontallyMirrorFrontFacingCamera = YES;
    [self updateStrangth];

    
    
    //    filter = [[GPUImageTiltShiftFilter alloc] init];
    //    [(GPUImageTiltShiftFilter *)filter setTopFocusLevel:0.65];
    //    [(GPUImageTiltShiftFilter *)filter setBottomFocusLevel:0.85];
    //    [(GPUImageTiltShiftFilter *)filter setBlurSize:1.5];
    //    [(GPUImageTiltShiftFilter *)filter setFocusFallOffRate:0.2];
    
    //    filter = [[GPUImageSketchFilter alloc] init];
    //    filter = [[GPUImageColorInvertFilter alloc] init];
    //    filter = [[GPUImageSmoothToonFilter alloc] init];
    //    GPUImageRotationFilter *rotationFilter = [[GPUImageRotationFilter alloc] initWithRotation:kGPUImageRotateRightFlipVertical];
    
    [videoCamera addTarget:self.filter];
    GPUImageView *filterView = self.imageView;
    //    filterView.fillMode = kGPUImageFillModeStretch;
    //    filterView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    
    // Record a movie for 10 s and store it in /Documents, visible via iTunes file sharing
    

    [self.filter addTarget:filterView];
    
    [videoCamera startCameraCapture];
    
 }



@end
