//
//  DragView.m
//  iOS1-1
//
//  Created by 胡知平 on 16/5/6.
//  Copyright © 2016年 胡知平. All rights reserved.
//

#import "DragView.h"

@interface DragView() {
    
    UIPanGestureRecognizer *_pan;
    UITapGestureRecognizer *_tap;
}



@end

@implementation DragView {
    
    CGPoint startCenter;
}


- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        self.userInteractionEnabled = YES;
        
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handletap:)];
        _tap.numberOfTapsRequired = 2;

        
        self.gestureRecognizers = @[_tap];
    }
    
    return self;
}

- (void) handletap:(UITapGestureRecognizer *) tap {
    
    static int temp = 0;
    
    if (temp == 0) {
        CGFloat scale = 2.0f;

        [UIView animateWithDuration:0.5 animations:^{
            
            self.transform = CGAffineTransformMakeScale(scale, scale);
            self.center = self.superview.center;
            
        }];
        
        temp = 1;
        [self addGestureRecognizer:_pan];
    } else {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.transform = CGAffineTransformIdentity;
            self.center = self.superview.center;
            
        }];
        
        temp = 0;
        [self removeGestureRecognizer:_pan];
    }
    
}

- (void) handlePan:(UIPanGestureRecognizer *) pan {

    CGPoint location = [pan translationInView:self.superview];
    CGPoint newCenter = CGPointMake(location.x + startCenter.x, location.y + startCenter.y);
  
    self.center = newCenter;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    startCenter = self.center;
    
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    return YES;
}


@end
