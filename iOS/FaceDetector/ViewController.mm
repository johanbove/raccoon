//
//  ViewController.m
//  FaceDetector
//
//  Created by Mujtaba Hassanpur on 10/3/15.
//  Copyright © 2015 Mujtaba Hassanpur. All rights reserved.
//

#import <OpenCV-iOS/opencv2/highgui/highgui.hpp>
#import <OpenCV-iOS/opencv2/videoio/cap_ios.h>

#include <OpenCV-iOS/opencv2/objdetect/objdetect.hpp>

#include <OpenCV-iOS/opencv2/imgproc.hpp>
#include <OpenCV-iOS/opencv2/videoio.hpp>
#include <OpenCV-iOS/opencv2/highgui.hpp>
#include <OpenCV-iOS/opencv2/video.hpp>

#include <OpenCV-iOS/opencv2/imgcodecs.hpp>





//#include <opencv2/highgui/highgui.hpp>
//#import <opencv2/videoio/cap_ios.h>
using namespace cv;

#import "ViewController.h"

@interface ViewController () {
    BOOL _cameraInitialized;
    CvVideoCamera *_videoCamera;
    CascadeClassifier _faceDetector;
    
    cv::Mat img, fgmask;
    cv::Ptr<cv::BackgroundSubtractor> bg_model;
    bool update_bg_model;
    //    Where, img <- smaller image fgmask <- the mask denotes that where motion is happening update_bg_model <- if you want to fixed your background;
    

}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupVideoCamera];
    [self setupFaceDetector];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_videoCamera start];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_videoCamera stop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupVideoCamera {
    if (_cameraInitialized) {
        return;
    }
    
    _videoCamera = [[CvVideoCamera alloc] initWithParentView:self.view];
    _videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    _videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPresetMedium;
    _videoCamera.grayscaleMode = NO;
    _videoCamera.rotateVideo = YES;
    _videoCamera.delegate = self;
}

- (void)setupFaceDetector {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"haarcascade_frontalface_default" ofType:@"xml"];
    const char *filePath = [path cStringUsingEncoding:NSUTF8StringEncoding];
    _faceDetector = CascadeClassifier(filePath);
}

#pragma mark - CvVideoCameraDelegate

- (void)processImage:(cv::Mat &)image {
    //process here
    cv::cvtColor(image, img, cv::COLOR_BGRA2RGB);
    int fixedWidth = 270;
    cv::resize(img, img, cv::Size(fixedWidth,(int)((fixedWidth*1.0f)*   (image.rows/(image.cols*1.0f)))),cv::INTER_NEAREST);
    
    //update the model
    bg_model->apply(img, fgmask, update_bg_model ? -1 : 0);
    
    GaussianBlur(fgmask, fgmask, cv::Size(7, 7), 2.5, 2.5);
    threshold(fgmask, fgmask, 10, 255, cv::THRESH_BINARY);
    
    image = cv::Scalar::all(0);
    img.copyTo(image, fgmask);
    
//    Mat gray;
//    vector<cv::Rect> faces;
//    Scalar color = Scalar(0, 255, 0);
//    cvtColor(image, gray, COLOR_BGR2GRAY);
//    _faceDetector.detectMultiScale(gray, faces, 1.15, 2, 0, cv::Size(30, 30));
//    for (int i = 0; i < faces.size(); i++) {
//        rectangle(image, faces[i], color, 1);
//    }
}

@end
