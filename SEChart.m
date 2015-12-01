//
//  SEChart.m
//  MobileIntelligence
//
//  Created by Vigneshkumar on 7/8/14.
//
//

#import "SEChart.h"
@interface SEChart()
{
    UITapGestureRecognizer *touchRecognizer;
    UIPanGestureRecognizer *panGesture;
    CGPoint lastPoint;
    BOOL correctingLabel;
    UILongPressGestureRecognizer *_swapLineGesture;
    
}
@property(nonatomic,strong)UILabel *titleLabel;
@end
@implementation SEChart
-(id)init
{
    self=[super init];
    if (self) {
        _needToUpdate=NO;
        _sliderEnabled=NO;
        correctingLabel=NO;
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    _sliderEnabled=NO;
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        panGesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(labelPanned:)];
        _needToUpdate=NO;
        
        _panImageView=[[UIImageView alloc]init];
        _panImageView.image=[UIImage imageNamed:@"slider.png"];
        [_panImageView setUserInteractionEnabled:YES];
        [panGesture addTarget:self action:@selector(labelPanned:)];
        //    [self addSubview:panLabel];
        [_panImageView setFrame:CGRectMake(frame.size.width/2,frame.size.height-40,38,28)];
        _panImageView.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:_panImageView];
        [_panImageView addGestureRecognizer:panGesture];
        _panImageView.userInteractionEnabled=YES;
    }
    [self addSubview:[self titleLabel]];
    return self;
}
-(UILongPressGestureRecognizer *)swapLineGesture
{
    if (!_swapLineGesture) {
        _swapLineGesture=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(gesTureLongPressed:)];
        [_swapLineGesture setAllowableMovement:3.0];
        [_swapLineGesture setMinimumPressDuration:0.38];
        [self addGestureRecognizer:_swapLineGesture];
        
    }
    return _swapLineGesture;
}

-(void)gesTureLongPressed:(UILongPressGestureRecognizer *)sender
{
    CGPoint point=[sender locationInView:self];
//    UIImageView *_panlabel=[self panImageView];
//    CGPoint canter=_panlabel.center;
//    CGPoint center2=_panImageView.center;
//    CGPoint newCenter=CGPointMake(canter.x+point.x-lastPoint.x, canter.y);
    if ([sender state]==UIGestureRecognizerStateBegan) {
//        _panlabel.center=newCenter;
//        lastPoint=newCenter;
        if (CGRectContainsPoint(self.bounds, point)) {
            [[self positionNotifier] sliderframeMovedto:_panImageView.frame toCenter:point];
        }
        else
        {
            //_panImageView.center=center2;
        }
    }
    else if ([sender state]==UIGestureRecognizerStateChanged)
    {
        
        if (CGRectContainsPoint(self.bounds, point)) {
            [[self positionNotifier] sliderframeMovedto:_panImageView.frame toCenter:point];
        }
        else
        {
            //_panImageView.center=center2;
        }
    }
    else if (([sender state]==UIGestureRecognizerStateEnded)||([sender state]==UIGestureRecognizerStateFailed))
    {
        
        CGPoint point=[_chartContainer convertPoint:point fromView:self];
        float newPosiX=roundf(point.x/_scalingX)*_scalingX;
        CGPoint point2=[self convertPoint:CGPointMake(newPosiX, 0) fromView:_chartContainer];
        
        correctingLabel=YES;
        
        [UIView animateWithDuration:0.1 animations:^(void){
            
        }completion:^(BOOL finished){
            correctingLabel=NO;
            [[self positionNotifier] gestureEndedinPosition:point2];
            [[self popController] dismissPopoverAnimated:NO];
        }];
    }
    [self.positionNotifier viewLongPressed:sender];
}
-(void)setSliderEnabled:(BOOL)sliderEnabled
{
    _sliderEnabled=sliderEnabled;
    if (sliderEnabled) {
        UIImageView *_panlabel=[self panImageView];
        [_panlabel addGestureRecognizer:panGesture];
        _panlabel.userInteractionEnabled=YES;
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)labelPanned:(UIPanGestureRecognizer *)sender
{
    if (correctingLabel) {
        
    }
    else
    {
        CGPoint point=[sender locationInView:self];
        UIImageView *_panlabel=[self panImageView];
        CGPoint canter=_panlabel.center;
        CGPoint center2=_panImageView.center;
        CGPoint newCenter=CGPointMake(canter.x+point.x-lastPoint.x, canter.y);
        if ([sender state]==UIGestureRecognizerStateBegan) {
            
        }
        else if ([sender state]==UIGestureRecognizerStateChanged)
        {
            _panlabel.center=newCenter;
            lastPoint=newCenter;
            if (CGRectContainsRect(self.bounds,_panImageView.frame)) {
                [[self positionNotifier] sliderframeMovedto:_panImageView.frame toCenter:_panImageView.center];
            }
            else
            {
                _panImageView.center=center2;
            }
        }
        else if (([sender state]==UIGestureRecognizerStateEnded)||([sender state]==UIGestureRecognizerStateFailed))
        {
            
            CGPoint point=[_chartContainer convertPoint:newCenter fromView:self];
            float newPosiX=roundf(point.x/_scalingX)*_scalingX;
            CGPoint point2=[self convertPoint:CGPointMake(newPosiX, 0) fromView:_chartContainer];
            newCenter.x=point2.x;
            correctingLabel=YES;
            [UIView animateWithDuration:0.1 animations:^(void){
                _panImageView.center=newCenter;
            }completion:^(BOOL finished){
                correctingLabel=NO;
                [[self positionNotifier] sliderframeMovedto:_panImageView.frame toCenter:_panImageView.center];
                [[self popController] dismissPopoverAnimated:NO];
                
                
                float width=(_chartContainer.frame.size.width-_chartContainer.frame.origin.x);
                
                if(point.x<0){
                    [UIView animateWithDuration:0.4 animations:^{
                        _panImageView.center=CGPointMake(_chartContainer.frame.origin.x, center2.y);
                    } completion:^(BOOL finished) {
                        [[self positionNotifier] sliderframeMovedto:_panImageView.frame toCenter:_panImageView.center];
                    }];
                    
                }
                else if (point.x>width){
                    [UIView animateWithDuration:0.4 animations:^{
                        _panImageView.center=center2;
                    } completion:^(BOOL finished) {
                        [[self positionNotifier] sliderframeMovedto:_panImageView.frame toCenter:_panImageView.center];
                    }];
                    
                }
            }];
        }
    }
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (_sliderEnabled) {
        UIImageView *_panlabel=[self panImageView];
        [self addSubview:_panlabel];
        
        _panlabel.userInteractionEnabled=YES;
    }
}
-(void)setTitle:(NSString *)title
{
    _title=title;
    if (_titleLabel) {
        [_titleLabel setText:_title];
    }
}
-(UIImageView *)panImageView
{
    if (!_panImageView) {
        CGRect frame=self.bounds;
        panGesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(labelPanned:)];
        [panGesture addTarget:self action:@selector(labelPanned:)];
        _panImageView=[[UIImageView alloc]init];
        _panImageView.image=[UIImage imageNamed:@"slider.png"];
        [_panImageView setUserInteractionEnabled:YES];
        //    [self addSubview:panLabel];
        [_panImageView setFrame:CGRectMake(frame.size.width/2,frame.size.height-40,38,28)];
        
        //panLabel.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:_panImageView];
        [_panImageView addGestureRecognizer:panGesture];
        _panImageView.userInteractionEnabled=YES;
    }
    if (_sliderEnabled) {
        [_panImageView setHidden:NO];
    }
    else
    {
        [_panImageView setHidden:YES];
    }
    return _panImageView;
}

-(void)reloadData
{
    if (_title) {
        UILabel *label=[self Label];
        [label setText:_title];
        [self addSubview:label];
        [label setNumberOfLines:0];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height*TITLESPACE)];
    }
}
-(UILabel *)Label
{
    if (!_titleLabel) {
        _titleLabel=[[UILabel alloc]init];
    }
    if (_titleFont) {
        _titleLabel.font=_titleFont;
    }
    return _titleLabel;
}

-(UILabel *)titlelabel
{
    return [self Label];
}

-(void)setEnableTouchNotification:(BOOL)enableTouchNotification
{
    _enableTouchNotification=enableTouchNotification;
    if (enableTouchNotification) {
        if (!touchRecognizer) {
            touchRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chartDoubleTapped:)];
            touchRecognizer.numberOfTapsRequired=2;
            touchRecognizer.numberOfTouchesRequired=1;
        }
        [self addGestureRecognizer:touchRecognizer];
    }
    else
    {
        [self removeGestureRecognizer:touchRecognizer];
    }
}
-(void)chartDoubleTapped:(UITapGestureRecognizer *)sender
{
    [[self genralDelegate] chartDoubleTapped:self];
}
-(void)drawRect:(CGRect)rect
{
    if (_sliderEnabled) {
        
    }
}
-(PopValueController *)popValueController
{
    if (!_popValueController) {
        _popValueController=[PopValueController sharedInstance];
    }
    return _popValueController;
}
-(void)reloadWithAnimationDuration:(CGFloat)animationDuration
{
    self.animationSpeed=animationDuration;
    [self reloadData];
}
-(UIPopoverController *)popController
{
    if (!_popController) {
        PopValueController *contr=[self popValueController];
        _popController=[[UIPopoverController alloc]initWithContentViewController:contr];
    }
    _popValueController.preferredContentSize=_popController.contentViewController.view.frame.size;
    return _popController;
}
-(void)layoutSubviews
{
    CGRect rect=[self bounds];
    [super layoutSubviews];
    UIImageView *_panLabel=[self panImageView];
    _panLabel.center=CGPointMake(_panLabel.center.x, rect.size.height/2);
    CGRect rect2=_panLabel.frame;
    if (rect2.origin.x<=0) {
        if (self.chartContainer) {
            rect2.origin.x=[self convertPoint:self.chartContainer.frame.origin fromView:self.chartContainer].x+self.tileWidth;
        }
        else
        {
            rect2.origin.x=0;
        }
    }
    rect2.origin.y=rect.size.height-rect2.size.height;
    _panLabel.frame=rect2;
    [self bringSubviewToFront:_panImageView];
    lastPoint=_panImageView.center;
//    [[self positionNotifier] sliderframeMovedto:_panImageView.frame toCenter:_panImageView.center];
}
#pragma mark dealloc
-(void)dealloc
{
    [self.chartContainer removeFromSuperview];
    self.chartContainer=nil;
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    self.positionNotifier=nil;
    self.genralDelegate=nil;
    [_panImageView removeFromSuperview];
    _panImageView=nil;
}
@end
