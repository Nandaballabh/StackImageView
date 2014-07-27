//
//  NBStackScrollImageView.m
//  NBStackScrollImageView
//
//  Created by Nanda Ballabh on 11/07/14.
//  Copyright (c) 2014 Nanda. All rights reserved.
//

#import "NBStackScrollImageView.h"

@interface NBStackScrollView : UIScrollView <StackScrollViewDelegate>
@property(nonatomic) NSArray* imageViewArr; //images array
@property(nonatomic) float imageWidth; //image width
@property(nonatomic, assign) NSObject<StackScrollViewDelegate>* SlideImagedelegate;
@end

@implementation NBStackScrollView
@synthesize imageViewArr, imageWidth, SlideImagedelegate;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(imageViewArr.count > 0)
    {
        int index = roundf(self.contentOffset.x/imageWidth);
        if(index < 0)
            index = 0;
        if(index > imageViewArr.count -1)
            index = imageViewArr.count - 1;
        UIImageView* imageView = [imageViewArr objectAtIndex:index];
        imageView.layer.zPosition = -10;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if(imageViewArr.count > 0)
    {
        int index = roundf(self.contentOffset.x/imageWidth);
        if(index < 0)
            index = 0;
        if(index > imageViewArr.count -1)
            index = imageViewArr.count - 1;
        UIImageView* imageView = [imageViewArr objectAtIndex:index];
        imageView.layer.zPosition = 0;
        if([SlideImagedelegate respondsToSelector:@selector(StackScrollViewDidEndClick:)])
            [self StackScrollViewDidEndClick:index];
    }
}

@end


@implementation NBStackScrollImageView
@synthesize _zMarginValue, _xMarginValue, _angleValue, _alphaValue;
@synthesize _imageArray;

- (id)init
{
    CGRect frame = {{0,0},{320,460}};
    self = [super initWithFrame:frame];
    if(self)
    {
        _index = -1;
        _imageViewArray = [[NSMutableArray alloc]init ];
        _scrollImageArray = [[NSMutableArray alloc]init ];
        _scrollView = [[NBStackScrollView alloc]initWithFrame:frame];

        [self addSubview:_moveView];
        [self addSubview:_scrollView];
        
        _zMarginValue = 10.f;
        _xMarginValue = 10.f;
        _angleValue = 0.f;
        _alphaValue = 1000;
        _shadowAlpha = 0;
        _shadowValueX = 0;
        _shadowValueY = 0;
        _imageArray = [[NSMutableArray alloc]init ];
        _delegate = nil;
        
        CATransform3D sublayerTransform = CATransform3DIdentity; 
        sublayerTransform.m34 = -0.02;
        [_moveView.layer setSublayerTransform:sublayerTransform];
        [_scrollView.layer setSublayerTransform:sublayerTransform];
    }
    return self;
}

#pragma mark -
#pragma mark interface function

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _index = -1;
        _imageViewArray = [[NSMutableArray alloc]init ];
        _scrollImageArray = [[NSMutableArray alloc]init ];
        frame.origin = CGPointMake(0, 0);
        _moveView = [[UIView alloc]initWithFrame:frame];
        _scrollView = [[NBStackScrollView alloc]initWithFrame:frame];
        //_scrollview
        [self addSubview:_moveView];
        [self addSubview:_scrollView];
        
        _zMarginValue = 0.f;
        _xMarginValue = 0.f;
        _angleValue = 0.f;
        _alphaValue = 1000;
        _shadowAlpha = 0;
        _shadowValueX = 0;
        _shadowValueY = 0;
        _imageArray = [[NSMutableArray alloc]init ];
        _delegate = nil;
        
        CATransform3D sublayerTransform = CATransform3DIdentity;
        sublayerTransform.m34 = -0.02;
        [_moveView.layer setSublayerTransform:sublayerTransform];
        [_scrollView.layer setSublayerTransform:sublayerTransform];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame ZMarginValue:(float)zMarginValue
       XMarginValue:(float)xMarginValue AngleValue:(float)angleValue Alpha:(float)alphaValue
{
    self = [super initWithFrame:frame];
    if (self) {
        _index = -1;
        _imageViewArray = [[NSMutableArray alloc]init ];
        _scrollImageArray = [[NSMutableArray alloc]init ];
        frame.origin = CGPointMake(0, 0);
        _moveView = [[UIView alloc]initWithFrame:frame];
        _scrollView = [[NBStackScrollView alloc]initWithFrame:frame];
        
        [self addSubview:_moveView];
        [self addSubview:_scrollView];
        
        _zMarginValue = zMarginValue;
        _xMarginValue = xMarginValue;
        _angleValue = angleValue;
        _alphaValue = alphaValue;
        _shadowAlpha = 0;
        _shadowValueX = 0;
        _shadowValueY = 0;
        _imageArray = [[NSMutableArray alloc]init];
        _delegate = nil;
        
        CATransform3D sublayerTransform = CATransform3DIdentity;
        sublayerTransform.m34 = -0.002;
        [_moveView.layer setSublayerTransform:sublayerTransform];
        [_scrollView.layer setSublayerTransform:sublayerTransform];
    }
    return self;
}

- (void)setImageShadowsWtihDirectionX:(float)value_X Y:(float)value_Y Alpha:(float)alphaValue
{
    _shadowAlpha = alphaValue;
    _shadowValueX = value_X;
    _shadowValueY = value_Y;
}

- (void) addImage:(UIImage *)image
{
    UIImage* resizeImage = [self ImageWithSize:image toSize:self.frame.size];
    [_imageArray addObject:resizeImage];
}

- (void)reLoadUIview
{
    
    if(_scrollImageArray.count > 0)
    {
        for(UIImageView* imageView in _scrollImageArray)
            [imageView removeFromSuperview];
        [_scrollImageArray removeAllObjects];
    }
   
    if(_imageViewArray.count > 0)
    {
        for(UIImageView* imageView in _imageViewArray)
            [imageView removeFromSuperview];
        [_imageViewArray removeAllObjects];
    }
    if(_imageArray.count > 0)
    {
        _index = 0;
        
        [self loadScrollView];
        
        [self loadImageView];
    }
}

#pragma mark -
#pragma mark private function

- (void)loadScrollView
{
    CGSize viewSize = self.frame.size;
    float width = viewSize.width;
    for(int i=0; i<_imageArray.count; i++)
    {
        UIImage* image = [_imageArray objectAtIndex:i];
        CGPoint point = CGPointMake(i*width, 0);
    
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(point.x, point.y, viewSize.width, viewSize.height)];
        imageView.image = image;
        imageView.layer.transform = CATransform3DMakeRotation(_angleValue, 0, -1, 0);
        if(i != 0 )
            imageView.hidden = YES;
        
        UIBezierPath* shadowPath = [UIBezierPath bezierPathWithRect:imageView.bounds];
        imageView.layer.shadowPath = shadowPath.CGPath;
        imageView.layer.shadowOffset = CGSizeMake(_shadowValueX, _shadowValueY);
        imageView.layer.shadowOpacity = _shadowAlpha;
        
        if(self.borderColor)
        {
            imageView.layer.borderColor = self.borderColor.CGColor;
            imageView.layer.borderWidth = 2.f;
        }
        else
            imageView.layer.borderWidth = 0.f;
        
        
        [_scrollImageArray addObject:imageView];
        [_scrollView addSubview:imageView];
    }
   
    if(_scrollImageArray.count > 1)
        _scrollView.contentSize = CGSizeMake(width*_scrollImageArray.count, viewSize.height);
    else
        _scrollView.contentSize = CGSizeMake(width*_scrollImageArray.count, viewSize.height+20);
    _scrollView.contentOffset = CGPointMake(0, 0);
    _scrollView.pagingEnabled = YES;
    _scrollView.autoresizingMask = YES;
    _scrollView.clipsToBounds = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.SlideImagedelegate = self;
    _scrollView.imageViewArr = _scrollImageArray;
    _scrollView.imageWidth = width;
}

- (void)loadImageView
{
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    
    for(int i=0; i<_imageArray.count; i++)
    {
        UIImage* image = [_imageArray objectAtIndex:i];
      
        float zPosition = -i*width/_zMarginValue;
        float alpha = 1 - i*width/_alphaValue;
        CGPoint point;
        switch (self.stackPostion) {
            case StackPositionTop:
                point = CGPointMake(0,-i*width/_xMarginValue);
                break;
            case StackPositionBottom:
                point = CGPointMake(0,i*width/_xMarginValue);
                break;
            case StackPositionLeft:
                point = CGPointMake(-i*width/_xMarginValue,0);
                break;
            case StackPositionRight:
                point = CGPointMake(i*width/_xMarginValue,0);
                break;
                
            default:
                point = CGPointMake(0,i*width/_xMarginValue);
                break;
        }

        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(point.x, point.y, width,height)];
        imageView.image = image;
        imageView.layer.transform = CATransform3DMakeRotation(_angleValue, 0, -1, 0);
        imageView.layer.zPosition = zPosition;
        imageView.alpha = alpha;
        
        
        UIBezierPath* shadowPath = [UIBezierPath bezierPathWithRect:imageView.bounds];
        imageView.layer.shadowPath = shadowPath.CGPath;
        imageView.layer.shadowOffset = CGSizeMake(_shadowValueX, _shadowValueY);
        imageView.layer.shadowOpacity = _shadowAlpha;
        
        if(self.borderColor)
        {
            imageView.layer.borderColor = self.borderColor.CGColor;
            imageView.layer.borderWidth = 2.f;
        }
        else
            imageView.layer.borderWidth = 0.f;
        
        
        if(i == 0)
            imageView.hidden = YES;
        [_imageViewArray addObject:imageView];
        [_moveView addSubview:imageView];
    }
}

- (UIImage *)ImageWithSize:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(reSize);
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}

#pragma mark - delegate function
#pragma mark UIScrollView delegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    float offset_x = scrollView.contentOffset.x;
    float width = scrollView.frame.size.width;
    float height = scrollView.frame.size.height;
    
    for(int i=0; i<_imageViewArray.count; i++)
    {
        
        UIImageView* scrollImageView = [_scrollImageArray objectAtIndex:i];
        float currOrigin_x = i * width;
        float angleValue = (offset_x-currOrigin_x)/width - _angleValue;
        if(angleValue < -_angleValue)
            angleValue = -_angleValue;
        if(angleValue > _alphaValue)
            angleValue = _alphaValue;
        scrollImageView.layer.transform = CATransform3DMakeRotation(angleValue, 0, 1, 0);
        if(currOrigin_x - offset_x>0)
        {
            if(i != 0)
                scrollImageView.hidden = YES;
        }
        else
            scrollImageView.hidden = NO;
        
        
        float range = (currOrigin_x-offset_x)/_xMarginValue;
        UIImageView* moveImageView = [_imageViewArray objectAtIndex:i];
        // Add stack view
        CGRect frame;
        switch (self.stackPostion) {
            case StackPositionTop:
               frame = CGRectMake(0, -range, width, height);
                break;
            case StackPositionBottom:
                frame = CGRectMake(0, range, width, height);
                break;
            case StackPositionLeft:
                frame = CGRectMake(-range, 0, width, height);
                break;
            case StackPositionRight:
                frame = CGRectMake(range, 0, width, height);
                break;
                
            default:
                frame = CGRectMake(0, range, width, height);
                break;
        }
        
        moveImageView.frame = frame;
        if(range <= 0)
            moveImageView.hidden = YES;
        else
        {
            if(i != 0)
                moveImageView.hidden = NO;
        }
        
        float range_z = (offset_x-currOrigin_x)/_zMarginValue;
        moveImageView.layer.zPosition = range_z;
        
        float alpha = 1.f - (currOrigin_x-offset_x)/_alphaValue;
        moveImageView.alpha = alpha;
    }
    _index = roundf(offset_x/width);
    
    
    if([_delegate respondsToSelector:@selector(StackViewDidScrollAtStackIndex:)])
        [_delegate StackViewDidScrollAtStackIndex:_index];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    for(UIImageView* imageView in _scrollImageArray)
        imageView.layer.zPosition = 0;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if([_delegate respondsToSelector:@selector(StackViewDidEndScorllWithIndex:)])
    {
        [_delegate StackViewDidEndScorllWithIndex:_index];
    }
}

#pragma mark Sli SlideScrollViewDelegate
- (void)SlideScrollViewDidEndClick:(int)index
{
    if([_delegate respondsToSelector:@selector(StackViewClickedWithIndex:)])
    {
        [_delegate StackViewClickedWithIndex:_index];
    }
}

@end