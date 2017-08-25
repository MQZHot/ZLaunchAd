//
//  ZLaunchAdVC.m
//  ZLaunchAdObjc
//
//  Created by mengqingzheng on 2017/8/18.
//  Copyright © 2017年 mengqingzheng. All rights reserved.
//

#import "ZLaunchAdVC.h"
#import "UIImageView+ZLaunchAd.h"

#define DEFAULT_TIME 3

@interface ZLaunchAdVC ()

@property (nonatomic, assign) NSInteger         defaultTime;
@property (nonatomic, strong) UIImageView       *launchImageView;       /// 启动页
@property (nonatomic, strong) UIImageView       *launchAdImgView;       /// 启动广告
@property (nonatomic, strong) UIButton          *skipBtn;               /// 跳过按钮
@property (nonatomic, strong) dispatch_source_t originalTimer;          /// 默认定时器
@property (nonatomic, strong) dispatch_source_t dataTimer;              /// 广告定时器
@property (nonatomic, assign) NSInteger         adDuration;             /// 广告停留时间
@property (nonatomic, strong) CAShapeLayer      *animationLayer;
@property (nonatomic, assign) CGFloat           adViewBottomDistance;
@property (nonatomic, assign) TransitionStyle   transitionStyle;
@property (nonatomic,   copy) ZLaunchAdCompletion    adImgViewClick;
@property (nonatomic, strong) ZLaunchAdConfig   *skipBtnConfig;         /// 配置跳过按钮
@property (nonatomic, strong) UIViewController  *rootViewController;

@end

@implementation ZLaunchAdVC

- (instancetype)initWithDuration: (NSInteger)duration transitionStyle: (TransitionStyle)transitionStyle adBottom: (CGFloat)adBottom rootViewController: (UIViewController *)rootViewController {
    self = [super init];
    if (self) {
        self.defaultTime = duration;
        self.transitionStyle = transitionStyle;
        self.adViewBottomDistance = adBottom;
        self.rootViewController = rootViewController;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.skipBtnConfig = [[ZLaunchAdConfig alloc]init];
    self.defaultTime = self.defaultTime <= 0 ? DEFAULT_TIME : self.defaultTime;
    self.adViewBottomDistance = self.adViewBottomDistance <= 0 ? 100 : self.adViewBottomDistance;
    [self.view addSubview:self.launchImageView];
    [self startTimer];
}

#pragma mark - 配置广告图
- (void)configNetImageWithURL: (NSString *)url duration: (NSInteger)duration adImgViewClick: (ZLaunchAdCompletion)adImgViewClick {
    
    if ([url isEqualToString:@""]) { return; }
    self.adDuration = duration < 1 ? 1 : duration;
    [self.view addSubview:self.launchAdImgView];
    __weak typeof(self)weakSelf = self;
    [self.launchAdImgView configImageWithUrl:url completion:^{
        
        [weakSelf addSkipBtn];
        
        if (!weakSelf.originalTimer) { return; }
        [weakSelf adStartTimer];
        [UIView animateWithDuration:0.8 animations:^{
            weakSelf.launchAdImgView.alpha = 1;
        }];
        
    }];
    self.adImgViewClick = adImgViewClick;
}
/// 本地图片
- (void)configLocalImageWithImage: (UIImage *)image duration: (NSInteger)duration adImgViewClick: (ZLaunchAdCompletion)adImgViewClick {
    if (image == nil) { return; }
    self.adDuration = duration < 1 ? 1 : duration;
    [self.view addSubview:self.launchAdImgView];
    self.launchAdImgView.image = image;
    
    [self addSkipBtn];
    if (!self.originalTimer) { return; }
    
    [self adStartTimer];
    [UIView animateWithDuration:0.8 animations:^{
        self.launchAdImgView.alpha = 1;
    }];
    self.adImgViewClick = adImgViewClick;
}
/// 本地GIF
- (void)configLocalGifWithName: (NSString *)name duration: (NSInteger)duration adImgViewClick: (ZLaunchAdCompletion)adImgViewClick {
    self.adDuration = duration < 1 ? 1 : duration;
    [self.view addSubview:self.launchAdImgView];
    [self.launchAdImgView gifWithName:name completion:^{
        [self addSkipBtn];
        if (!self.originalTimer) { return; }
        
        [self adStartTimer];
        
        [UIView animateWithDuration:0.8 animations:^{
            self.launchAdImgView.alpha = 1;
        }];
    }];
    self.adImgViewClick = adImgViewClick;
}

- (void)addSkipBtn {
    [self.skipBtn removeFromSuperview];
    if (self.animationLayer) {
        [self.animationLayer removeFromSuperlayer];
        self.animationLayer = nil;
    }
    if (self.skipBtnConfig.skipBtnType != SkipBtnTypeNone) {
        
        if (self.configSkipBtn) {
            self.configSkipBtn(self.skipBtnConfig);
        }
        self.skipBtn.backgroundColor = self.skipBtnConfig.backgroundColor;
        self.skipBtn.titleLabel.font = self.skipBtnConfig.titleFont;
        [self.skipBtn setTitleColor:self.skipBtnConfig.titleColor forState:UIControlStateNormal];
        if (self.skipBtnConfig.skipBtnType == SkipBtnTypeCircle) {
            self.skipBtn.frame = CGRectMake(0, 0, self.skipBtnConfig.height, self.skipBtnConfig.height);
            self.skipBtn.layer.cornerRadius = self.skipBtnConfig.height*0.5;
            [self circleBtnAddLayerWithStrokeColor:self.skipBtnConfig.strokeColor lineWidth:self.skipBtnConfig.lineWidth];
        } else {
            self.skipBtn.frame = CGRectMake(0, 0, self.skipBtnConfig.width, self.skipBtnConfig.height);
            self.skipBtn.layer.cornerRadius = self.skipBtnConfig.cornerRadius;
        }
        self.skipBtn.center = CGPointMake(self.skipBtnConfig.centerX, self.skipBtnConfig.centerY);
        [self.view addSubview: self.skipBtn];
        [self.skipBtn setTitle: self.skipBtnConfig.skipBtnType == SkipBtnTypeTimer ? [NSString stringWithFormat:@"\%ld 跳过",self.adDuration] : @"跳过" forState: UIControlStateNormal];
    }
}
/// 添加动画
- (void)circleBtnAddLayerWithStrokeColor: (UIColor *)strokeColor lineWidth: (CGFloat)lineWidth {
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithOvalInRect:self.skipBtn.bounds];
    self.animationLayer = [[CAShapeLayer alloc]init];
    self.animationLayer.path = bezierPath.CGPath;
    self.animationLayer.lineWidth = lineWidth;
    self.animationLayer.strokeColor = strokeColor.CGColor;
    self.animationLayer.fillColor = [UIColor clearColor].CGColor;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    animation.duration = self.adDuration;
    animation.fromValue = @0;
    animation.toValue = @1;
    [self.animationLayer addAnimation:animation forKey:nil];
    [self.skipBtn.layer addSublayer: self.animationLayer];
}
#pragma mark - 点击事件

- (void)imgViewTapAction:(UITapGestureRecognizer *)sender {
    dispatch_source_cancel(self.dataTimer);
    __strong typeof(self)weakSelf = self;
    [self launchAdVCRemoveCompletion:^{
        __strong typeof(weakSelf) strongWeakSelf = weakSelf;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (strongWeakSelf.adImgViewClick) {
                strongWeakSelf.adImgViewClick();
            }
        });
    }];
}

- (void)skipBtnAction {
    if (self.dataTimer) {
        dispatch_source_cancel(self.dataTimer);
    }
    [self launchAdVCRemoveCompletion:nil];
}
#pragma mark -  懒加载
- (UIButton *)skipBtn {
    if (!_skipBtn) {
        _skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_skipBtn addTarget:self action:@selector(skipBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _skipBtn;
}
- (UIImageView *)launchImageView {
    if (!_launchImageView) {
        _launchImageView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _launchImageView.image = [self getLaunchImage];
    }
    return _launchImageView;
}
- (UIImageView *)launchAdImgView {
    if (!_launchAdImgView) {
        _launchAdImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Z_SCREEN_WIDTH, Z_SCREEN_HEIGHT-self.adViewBottomDistance)];
        _launchAdImgView.userInteractionEnabled = true;
        _launchAdImgView.alpha = 0.2;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgViewTapAction:)];
        [_launchAdImgView addGestureRecognizer:tap];
    }
    return _launchAdImgView;
}

#pragma mark - 广告结束
- (void)launchAdVCRemoveCompletion: (ZLaunchAdCompletion)completion {
    if (self.originalTimer) {
        dispatch_source_cancel(self.originalTimer);
    }
    if (self.dataTimer) {
        dispatch_source_cancel(self.dataTimer);
    }
    if (self.rootViewController) {
        [self transitionAnimation];
        [UIApplication sharedApplication].keyWindow.rootViewController = self.rootViewController;
        if (completion) {
            completion();
        }
    }
}
- (void)transitionAnimation {
    CATransition *trans = [[CATransition alloc]init];
    trans.duration = 0.5;
    switch (self.transitionStyle) {
        case TransitionStyleRippleEffect:
            trans.type = @"rippleEffect";
            break;
        case TransitionStyleFlipFromLeft:
            trans.type = @"oglFlip";
            trans.subtype = kCATransitionFromLeft;
            break;
        case TransitionStyleFlipFromRight:
            trans.type = @"oglFlip";
            trans.subtype = kCATransitionFromRight;
            break;
        case TransitionStyleFlipFromTop:
            trans.type = @"oglFlip";
            trans.subtype = kCATransitionFromTop;
            break;
        case TransitionStyleFlipFromBottom:
            trans.type = @"oglFlip";
            trans.subtype = kCATransitionFromTop;
            break;
        default:
            trans.type = @"fade";
            break;
    }
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:trans forKey:nil];
}

#pragma mark - GCD定时器
- (void)startTimer {
    self.originalTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(self.originalTimer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.originalTimer, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"默认定时器%ld",(long)self.defaultTime);
            
            if (self.defaultTime == 0) {
                [self launchAdVCRemoveCompletion:nil];
            }
            self.defaultTime -= 1;
        });
    });
    dispatch_resume(self.originalTimer);
}

- (void)adStartTimer {
    dispatch_source_cancel(self.originalTimer);
    self.dataTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(self.dataTimer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.dataTimer, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"广告倒计时%ld",(long)self.adDuration);
            
            [self.skipBtn setTitle: self.skipBtnConfig.skipBtnType == SkipBtnTypeTimer ? [NSString stringWithFormat:@"\%ld 跳过",self.adDuration] : @"跳过" forState: UIControlStateNormal];
            
            if (self.adDuration == 0) {
                [self launchAdVCRemoveCompletion:nil];
            }
            self.adDuration -= 1;
        });
    });
    dispatch_resume(self.dataTimer);
}

#pragma mark - 获取启动页
- (UIImage *)getLaunchImage{
    UIImage *launchImage = [self assetsLaunchImage];
    if(launchImage) return launchImage;
    return [self storyboardLaunchImage];
}

- (UIImage *)assetsLaunchImage{
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString *viewOrientation = @"Portrait";//横屏"Landscape"
    NSString *launchImageName = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict){
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]){
            launchImageName = dict[@"UILaunchImageName"];
            UIImage *image = [UIImage imageNamed:launchImageName];
            return image;
        }
    }
    return nil;
}

- (UIImage *)storyboardLaunchImage{
    NSString *storyboardLaunchName = [[NSBundle mainBundle].infoDictionary valueForKey:@"UILaunchStoryboardName"];
    UIViewController *launchVC = [[UIStoryboard storyboardWithName:storyboardLaunchName bundle:nil] instantiateInitialViewController];
    if(launchVC){
        UIView *view = launchVC.view;
        view.frame = [UIScreen mainScreen].bounds;
        return [self viewConvertImage:view];
    }
    return nil;
}

- (UIImage*)viewConvertImage:(UIView*)launchView{
    CGSize imageSize = launchView.bounds.size;
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    [launchView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *launchImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return launchImage;
}

- (void)dealloc {
    NSLog(@"bye----bye");
}
@end
