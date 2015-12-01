//
//  SEChart.h
//  MobileIntelligence
//
//  Created by Vigneshkumar on 7/8/14.
//
//

#import <UIKit/UIKit.h>
#import "PopValueController.h"
#define TITLESPACE 0.167
@protocol ChartDelegate<NSObject>
-(void)chartDoubleTapped:(id)sender;
-(BOOL)chartShouldSelectElement:(int)element inSeries:(int)series;
-(void)chartDidSelectElement:(int)element inSeries:(int)series;
@end
@protocol ChartDataSource <NSObject>
-(int)numberOfXaxisTitlesinChart:(id)sender;
-(NSString *)XaxisTitleAtIndex:(int)index inChart:(id)sender;
-(int)numberOfSeriesInChart:(id)sender;
-(int)numberOfValuesInSeries:(int)series inChart:(id)sender;
-(NSNumber *)valueOfItemAtIndex:(int)index inSeries:(int)series inChart:(id)sender;

@end
@protocol SliderDelegate <NSObject>
-(void)sliderframeMovedto:(CGRect)frame toCenter:(CGPoint)center;
-(void)gestureEndedinPosition:(CGPoint)endPoint;
-(void)viewLongPressed:(UILongPressGestureRecognizer *)sender;

@end

@interface SEChart : UIView
{
    
}
@property(nonatomic,weak)id<ChartDelegate>genralDelegate;
@property(nonatomic,weak)id<SliderDelegate> positionNotifier;
@property(nonatomic,weak)id<ChartDataSource> dataSource1;
@property(nonatomic,strong)NSMutableArray *arrayY;
@property(nonatomic,assign)int valueLabelsCount;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)UIFont *titleFont;
@property(nonatomic,assign)BOOL isMinimized;
@property(nonatomic,assign)BOOL enableTouchNotification;
@property(nonatomic,assign)BOOL sliderEnabled;
@property(nonatomic,strong)UIImageView *panImageView;
@property(nonatomic,assign)float scalingX;
@property(nonatomic,assign)float scalingY;
@property(nonatomic,assign)float gridWidth;
@property(nonatomic,assign)float gridHeight;
@property(nonatomic,assign)CGFloat animationSpeed;
@property(nonatomic,assign)int style;
@property(nonatomic,assign)float tileWidth;
@property(nonatomic,strong)UIView *chartContainer;
@property(nonatomic,assign)BOOL needToUpdate;
@property(nonatomic,strong)UIPopoverController *popController;
@property(nonatomic,strong)PopValueController *popValueController;
-(UILabel *)titlelabel;
-(void)reloadData;
@end
