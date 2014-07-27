//
//  NBStackScrollImageView.h
//  NBStackScrollImageView
//
//  Created by Nanda Ballabh on 11/07/14.
//  Copyright (c) 2014 Nanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef NS_OPTIONS(NSInteger, StackPosition){
    
    StackPositionTop ,
    StackPositionBottom,
    StackPositionRight,
    StackPositionLeft
};


@protocol NBStackScrollImageViewDelegate<NSObject>
@optional

 //View Clicked With Index
- (void)StackViewClickedWithIndex:(int)index;

 //View didScroll With Index
- (void)StackViewDidScrollAtStackIndex:(int)index;

//View didEndScroll With Index
- (void)StackViewDidEndScorllWithIndex:(int)index;
@end

@protocol StackScrollViewDelegate <NSObject>
@optional
- (void) StackScrollViewDidEndClick:(int)index;
@end

@class NBStackScrollView;

@interface NBStackScrollImageView : UIView <UIScrollViewDelegate, StackScrollViewDelegate>
{
    int _index;
    NSMutableArray* _scrollImageArray;
    NSMutableArray* _imageViewArray;
    NBStackScrollView* _scrollView;
    UIView* _moveView;
    float _shadowValueX,_shadowValueY;
    float _shadowAlpha;
}

@property (nonatomic, assign) NSObject<NBStackScrollImageViewDelegate>* delegate;
@property(nonatomic) float _zMarginValue;
@property(nonatomic) float _xMarginValue;
@property(nonatomic) float _alphaValue;
@property(nonatomic) float _angleValue;
@property(nonatomic, strong) UIColor* borderColor;
@property(nonatomic,readonly) NSMutableArray* _imageArray;
@property(nonatomic) StackPosition stackPostion;

- (id)initWithFrame:(CGRect)frame;

- (id)initWithFrame:(CGRect)frame ZMarginValue:(float)zMarginValue
       XMarginValue:(float)xMarginValue AngleValue:(float)angleValue Alpha:(float)alphaValue;
- (void)addImage:(UIImage*)image; //add images to view
- (void)setImageShadowsWtihDirectionX:(float)value_X Y:(float)value_Y Alpha:(float)alphaValue;
- (void)reLoadUIview;
@end
