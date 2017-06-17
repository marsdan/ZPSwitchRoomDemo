//
//  ZPScrollView.m
//  ZPSwitchRoomDemo
//
//  Created by mars on 2017/6/17.
//  Copyright © 2017年 ZhaoPeng. All rights reserved.
//

#import "ZPScrollView.h"

#define kSCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#define kSCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define kRANDOMCOLOR   [UIColor colorWithRed:(arc4random() % 255) / 255.0f green:(arc4random() % 255) / 255.0f blue:(arc4random() % 255) / 255.0f alpha:1.0];


@interface ZPScrollView ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

{
    NSArray *_dataArray;
}
/**
 显示主播头像的视图
 */
@property (nonatomic, strong)UIScrollView *scrollView;
/**当前显示的
 */
@property (nonatomic, strong) UIImageView *middleImageView;
/**
 上面的
 */
@property (nonatomic, strong) UIImageView *topImageView;
/**
 下面的
 */
@property (nonatomic, strong) UIImageView *bottomImageView;

/**
 分页控制器
 */
@property (nonatomic, strong) UIPageControl *pageControl;

/**
 当前选择的页码
 */
@property (nonatomic, assign, readonly) NSInteger currentPage;

/**
 此View就是我们看到的控件容器视图层
 */
@property (nonatomic, strong) UIView *controlsView;

/**
 拖拽手势
 */
@property (nonatomic, strong) UIPanGestureRecognizer * _Nonnull panGestureRecognizer;
@property (nonatomic, assign) CGPoint panStartPoint;//记录触摸起始点
@property (nonatomic, assign) CGPoint myViewPoint;//视图停止时的起点
@end

@implementation ZPScrollView

- (instancetype)initWithScrollDataArray:(NSArray *)dataArray
{
    self = [super initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, kSCREENHEIGHT)];
    if (self) {
        _dataArray = dataArray;
        [self setUI];
        [self setData];
        [self addGesture];
    }
    return self;
}
#pragma mark- 添加UI
-(void)setUI{
    [self addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.middleImageView];
    [self.scrollView addSubview:self.topImageView];
    [self.scrollView addSubview:self.bottomImageView];
    
    //设置三张图片的frame
    //     _leftImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds));
    
    CGFloat imageView_W = CGRectGetWidth(self.scrollView.bounds);
    CGFloat imageView_H = CGRectGetHeight(self.scrollView.bounds);
    
    
    //第一张
    self.topImageView.frame = CGRectMake(0, 0, imageView_W, imageView_H);
    //第二张 也就是我们中间显示控件的一张
    self.middleImageView.frame = CGRectOffset(self.topImageView.frame, 0,CGRectGetHeight(self.topImageView.frame));
    //第三张
    self.bottomImageView.frame =CGRectOffset(self.middleImageView.frame, 0,  CGRectGetHeight(self.middleImageView.frame));
    
    //添加毛玻璃效果
    [self.topImageView addSubview:[self addBlurEffectToView:self.topImageView effectWithStyle:UIBlurEffectStyleDark]];
    [self.middleImageView addSubview:[self addBlurEffectToView:self.middleImageView effectWithStyle:UIBlurEffectStyleDark]];
    [self.bottomImageView addSubview:[self addBlurEffectToView:self.bottomImageView effectWithStyle:UIBlurEffectStyleDark]];
    
    //添加控件容器到中间背景图层
    [self.middleImageView addSubview:self.controlsView];
    
    
}


#pragma mark- 添加清屏手势
- (void)addGesture{
    
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(myPanGestureRecognizer:)];
    self.panGestureRecognizer.delegate = self;
    [self addGestureRecognizer:self.panGestureRecognizer];
    
}
- (void)myPanGestureRecognizer:(UIPanGestureRecognizer *)sender{
    CGPoint currentPoint;
    CGPoint endPoint;
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            self.panStartPoint = [sender translationInView:self];
            break;
        case UIGestureRecognizerStateChanged:
        {
            currentPoint = [sender translationInView:self];
     

            //判断滑动方向
            if(self.panStartPoint.x > currentPoint.x){
                //向左滑
                //判断开始起点 只有当
                if(self.myViewPoint.x != 0){
                    
                    self.controlsView.frame = CGRectMake(self.myViewPoint.x + currentPoint.x, self.controlsView.frame.origin.y, self.controlsView.frame.size.width, self.controlsView.frame.size.height);
                }
            }
            if(self.panStartPoint.x < currentPoint.x){
                //取消输入框焦点
                
                //向右滑
                if(self.myViewPoint.x == 0){
                    
                    self.controlsView.frame = CGRectMake(currentPoint.x, self.controlsView.frame.origin.y, self.controlsView.frame.size.width, self.controlsView.frame.size.height);
                }
            }
            
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        {
            endPoint = [sender translationInView:self];
            
            //得到手势滑动的速度
            CGPoint mysudu =   [sender velocityInView:self];
            CGFloat  offset_x = 0;
            CGFloat offset_w = self.frame.size.width/3;
            
            //当滑动速度大于500时 进行左右动画
            if (fabs(mysudu.x) >500) {
                if(mysudu.x >500){
                    //向右
                    if(self.myViewPoint.x == 0){
                        offset_x = self.controlsView.frame.size.width;;
                    }else{
                        offset_x = self.controlsView.frame.size.width;;
                    }
                    
                }
                if (mysudu.x <-500 ) {
                    //向左
                    if(self.myViewPoint.x >0){
                        offset_x = 0;
                        
                    }
                }
            }else{
                if((endPoint.x - self.panStartPoint.x) > offset_w){
                    offset_x = self.controlsView.frame.size.width;
                }else if ((fabs(endPoint.x) - fabs(self.panStartPoint.x)) > offset_w) {
                    offset_x = 0;
                }else{
                    if (self.myViewPoint.x == 0) {
                        offset_x = 0 ;
                    }else{
                        offset_x = self.controlsView.frame.size.width;
                    }
                    
                }
            }
            [self controlsViewMobile_X:offset_x animate:YES];
            
        }
            break;
            
        default:
            break;
    }
}


/**
 清屏视图动画
 
 @param isLeftOrRigth YES: 左 NO: 右
 */
-(void)controlsViewMobile_X:(CGFloat )offset_x animate:(BOOL)animate{
    if (animate) {
        [UIView animateWithDuration:0.25 animations:^{
            self.controlsView.frame = CGRectMake(offset_x, self.controlsView.frame.origin.y, self.controlsView.frame.size.width, self.controlsView.frame.size.height);
            self.myViewPoint = self.controlsView.frame.origin;
        }];
    }else{
        self.controlsView.frame = CGRectMake(offset_x, self.controlsView.frame.origin.y, self.controlsView.frame.size.width, self.controlsView.frame.size.height);
        self.myViewPoint = self.controlsView.frame.origin;
    }
    
    
}


#pragma mark- 设置数据
-(void)setData{
    //这个值用来判断我们当前进入这个的这个房间在这个数组里面的下标值，场景就是 我一共有20个主播，而我当前进入的是第5个主播房间，那么下边就是4，
    NSInteger index_MY = 2;//我们模拟当前进入的房间是房间列表下标为2
    
    //设置最大页数
    self.pageControl.numberOfPages = _dataArray.count;
    //当前进入的页数
    self.pageControl.currentPage = index_MY;
    _currentPage = index_MY;
    
    if (_dataArray.count <= 1) {
        //如果只有1个的时候 就不支持滑动
        self.scrollView.contentSize = CGSizeMake(0, CGRectGetHeight(self.bounds));
    }else{
        //1个以上可以可滑动
        self.scrollView.contentSize = CGSizeMake(0, CGRectGetHeight(self.bounds)*3);
    }
    [self refreshView];
    
}

#pragma mark- 刷新视图
-(void)refreshView{
    NSInteger index = _currentPage;
    [self setImageView:self.middleImageView imageURL:_dataArray[index]];
    
    index = _currentPage-1<0?_dataArray.count-1:_currentPage-1;
    
    [self setImageView:self.topImageView imageURL:_dataArray[index]];
    
    index = _currentPage+1>=_dataArray.count?0:_currentPage+1;
    [self setImageView:self.bottomImageView imageURL:_dataArray[index]];
    
    self.scrollView.contentOffset = CGPointMake(0, CGRectGetHeight(self.bounds));
    //设置数据
//    [self updateData];
}

//根据数组中类型判断如何展示图片
-(void)setImageView:(UIImageView*)imageView imageURL:(NSString *)URL
{
    //设置图片
    imageView.backgroundColor = kRANDOMCOLOR;
    
}

-(void)refreshCurrentPage
{
    if (self.scrollView.contentOffset.y >= CGRectGetHeight(self.bounds)*1.5) {
        
        _currentPage ++;
        
        if (_currentPage > _dataArray.count-1) {
            _currentPage = 0;
        }
    }else if (self.scrollView.contentOffset.y <= CGRectGetHeight(self.bounds)/2) {
        _currentPage--;
        
        if (_currentPage < 0) {
            _currentPage = _dataArray.count-1;
        }
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //开始滚动时暂停定时器
    NSLog(@"scrollView____WillBeginDragging");

    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self refreshCurrentPage];
    
    if (self.pageControl.currentPage != _currentPage) {
        self.pageControl.currentPage = _currentPage;
        [self refreshView];
        //滚动结束
        NSLog(@"scrollView____DidEndDecelerating%@",_dataArray[_currentPage]);
    }
    
}

//滚动动画停止时执行,代码改变时出发,也就是setContentOffset改变时
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;
{
    NSLog(@"scrollView___DidEndScrollingAnimation");
}
#pragma mark- 点击事件冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
    
    NSLog(@"%@",NSStringFromClass([touch.view class]));
    if ([touch.view isKindOfClass:NSClassFromString(@"BaseRoomBottomToolbar")] ||[touch.view isKindOfClass:NSClassFromString(@"UICollectionView")] ||[touch.view isKindOfClass:NSClassFromString(@"UITableViewCellContentView")] ||[touch.view isKindOfClass:NSClassFromString(@"UITableView")] ||[touch.view isKindOfClass:NSClassFromString(@"UILabel")] || touch.view.tag == 123 ||[touch.view isKindOfClass:NSClassFromString(@"UIButton")]) {
//        _scrollView.scrollEnabled = NO;
        return NO;
    }
//    _scrollView.scrollEnabled = YES;
    return YES;
}



#pragma mark- get

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollsToTop = NO;
        _scrollView.contentSize = CGSizeMake(0, CGRectGetHeight(self.bounds)*3);
        
    }
    return _scrollView;
}
-(UIPageControl*)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.hidesForSinglePage = YES;
        
    }
    return _pageControl;
}

-(UIImageView *)middleImageView{
    if (!_middleImageView) {
        _middleImageView = [[UIImageView alloc]init];
         _middleImageView.backgroundColor = kRANDOMCOLOR;
        _middleImageView.userInteractionEnabled = YES;
    }
    return _middleImageView;
}

- (UIImageView *)topImageView{
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc]init];
        _topImageView.backgroundColor = kRANDOMCOLOR;
    }
    return _topImageView;
}

- (UIImageView *)bottomImageView{
    if (!_bottomImageView) {
        _bottomImageView = [[UIImageView alloc]init];
        _bottomImageView.backgroundColor = kRANDOMCOLOR;
    }
    return _bottomImageView;
}

-(UIView *)controlsView{
    if (!_controlsView) {
        _controlsView = [[UIView alloc]initWithFrame:self.bounds];
        _controlsView.backgroundColor = kRANDOMCOLOR;
    }
    return _controlsView;
}



#pragma mark- 添加毛玻璃
-(UIVisualEffectView *)addBlurEffectToView:(UIView *)toView effectWithStyle:(UIBlurEffectStyle)style{
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:style];
    UIVisualEffectView  *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    visualEffectView.frame = toView.bounds;
    visualEffectView.alpha = 1;
    return visualEffectView;
}



@end
