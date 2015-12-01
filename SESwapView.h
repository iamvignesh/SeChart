//
//  SESwapView.h
//  MobileIntelligence
//
//  Created by Vigneshkumar on 11/6/14.
//
//

#import <UIKit/UIKit.h>
#import "LabelProperty.h"
@protocol SwapViewDelegate<NSObject>
-(int)numberOfLabels;
@end
@interface SESwapView : UIView
{
    
}
-(void)showText:(NSString *)value ForSeries:(int)series inPosition:(CGPoint)point;
@property(nonatomic,assign)int valueLabelsCount;
@property(nonatomic,assign)id <SwapViewDelegate> delegate;
@property(nonatomic,strong)LabelProperty *defaultProperty;

@end
