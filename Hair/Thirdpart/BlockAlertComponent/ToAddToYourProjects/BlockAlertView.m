//
//  BlockAlertView.m
//
//

#import "BlockAlertView.h"
#import "BlockBackground.h"
#import "BlockUI.h"
#import "UIViewAdditions.h"

@implementation BlockAlertView

@synthesize view = _view;
@synthesize backgroundImage = _backgroundImage;
@synthesize vignetteBackground = _vignetteBackground;

static UIImage *background = nil;
static UIImage *backgroundlandscape = nil;
static UIFont *titleFont = nil;
static UIFont *messageFont = nil;
static UIFont *buttonFont = nil;


#pragma mark - init

+ (void)initialize
{
    if (self == [BlockAlertView class])
    {
        //background = [UIImage imageNamed:kAlertViewBackground];
        UIEdgeInsets insets = UIEdgeInsetsMake(4, 4, 4, 4);
        background = [YQGlobalHelper createBackgroundImageWithImageName:kAlertViewBackground edgeInsets:insets];

        //background = [[background stretchableImageWithLeftCapWidth:4 topCapHeight:4] retain];
        
        backgroundlandscape = [UIImage imageNamed:kAlertViewBackgroundLandscape];
        backgroundlandscape = [backgroundlandscape stretchableImageWithLeftCapWidth:0 topCapHeight:kAlertViewBackgroundCapHeight];
        
        titleFont = kAlertViewTitleFont;
        messageFont = kAlertViewMessageFont;
        buttonFont = kAlertViewButtonFont;
    }
}

+ (BlockAlertView *)alertWithTitle:(NSString *)title message:(NSString *)message
{
    return [[BlockAlertView alloc] initWithTitle:title message:message];
}

+ (void)showInfoAlertWithTitle:(NSString *)title message:(NSString *)message
{
    BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:title message:message];
    [alert setDestructiveButtonWithTitle:NSLocalizedString(@"知道了", nil) block:nil];
    [alert show];
}

+ (void)showErrorAlert:(NSError *)error
{
    BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:NSLocalizedString(@"Operation Failed", nil) message:[NSString stringWithFormat:NSLocalizedString(@"The operation did not complete successfully: %@", nil), error]];
    [alert setDestructiveButtonWithTitle:@"知道了" block:nil];
    [alert show];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (void)addComponents:(CGRect)frame {
    //顶部logo
    if (_logoName && ![_logoName isEqualToString:@""]) {
        UIImageView* logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_logoName]];
        logoView.left = self.view.width/2 - logoView.width/2;
        logoView.top = _height;
        [_view addSubview:logoView];
        _height += logoView.height + 5;
    }
    if (_title && ![_title isEqualToString:@""])
    {
        CGSize size = [_title sizeWithFont:titleFont
                         constrainedToSize:CGSizeMake(frame.size.width-kAlertViewBorder*2, 1000)
                             lineBreakMode:NSLineBreakByWordWrapping];
        
        UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(kAlertViewBorder, _height, frame.size.width-kAlertViewBorder*2, size.height)];
        labelView.font = titleFont;
        labelView.numberOfLines = 0;
        labelView.lineBreakMode = NSLineBreakByWordWrapping;
        labelView.textColor = [UIColor colorWithRed:0x66/255.0 green:0x66/255.0 blue:0x66/255.0 alpha:1.0];
        labelView.backgroundColor = [UIColor clearColor];
        labelView.textAlignment = NSTextAlignmentCenter;
        //labelView.shadowColor = kAlertViewTitleShadowColor;
        //labelView.shadowOffset = kAlertViewTitleShadowOffset;
        labelView.text = _title;
        [_view addSubview:labelView];
        
        _height += size.height + kAlertViewBorder;
    }
    
    if (_message && ![_message isEqualToString:@""])
    {
        CGSize size = [_message sizeWithFont:messageFont
                           constrainedToSize:CGSizeMake(frame.size.width-kAlertViewBorder*2, 1000)
                               lineBreakMode:NSLineBreakByWordWrapping];
        
        UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(kAlertViewBorder, _height, frame.size.width-kAlertViewBorder*2, size.height)];
        labelView.font = messageFont;
        labelView.numberOfLines = 0;
        labelView.lineBreakMode = NSLineBreakByWordWrapping;
        labelView.textColor = [UIColor colorWithRed:0x66/255.0 green:0x66/255.0 blue:0x66/255.0 alpha:1.0];//kAlertViewMessageTextColor;
        labelView.backgroundColor = [UIColor clearColor];
        labelView.textAlignment = msgAlignment;
        //labelView.shadowColor = kAlertViewMessageShadowColor;
        //labelView.shadowOffset = kAlertViewMessageShadowOffset;
        labelView.text = _message;
        [_view addSubview:labelView];
        
        _height += size.height + kAlertViewBorder;
    }
}

- (void)setupDisplay
{
    [[_view subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    UIWindow *parentView = [BlockBackground sharedInstance];
    CGRect frame = parentView.bounds;
    frame.origin.x = floorf((frame.size.width - 280) * 0.5);
    frame.size.width = 280;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        frame.size.width += 150;
        frame.origin.x -= 75;
    }
    
    _view.frame = frame;
    
    _height = kAlertViewBorder + 15;
    
    if (NeedsLandscapePhoneTweaks) {
        _height -= 15; // landscape phones need to trimmed a bit
    }

    [self addComponents:frame];

    if (_shown)
        [self show];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message 
{
    self = [super init];
    
    if (self)
    {
        self.hasCloseBtn = NO;
        //background = [UIImage imageNamed:kAlertViewBackground];        
        _title = title;
        _message = message;
        msgAlignment = NSTextAlignmentCenter;
        _view = [[UIView alloc] init];
        _view.tag = 999999;
        _view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        _blocks = [[NSMutableArray alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(setupDisplay) 
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification 
                                                   object:nil];   
        
        if ([self class] == [BlockAlertView class])
            [self setupDisplay];
        
        _vignetteBackground = NO;
    }
    
    return self;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message logo:(NSString*)logoName {
    if (self = [self initWithTitle:title message:message]) {
        _logoName = logoName;
        [self setupDisplay];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (void)addButtonWithTitle:(NSString *)title color:(NSString*)color block:(void (^)())block 
{
    [_blocks addObject:[NSArray arrayWithObjects:
                        block ? [block copy] : [NSNull null],
                        title,
                        color,
                        nil]];
}

- (void)addButtonWithTitle:(NSString *)title block:(void (^)())block 
{
    [self addButtonWithTitle:title color:@"gray" block:block];
}

- (void)setCancelButtonWithTitle:(NSString *)title block:(void (^)())block 
{
    [self addButtonWithTitle:title color:@"black" block:block];
}

- (void)setDestructiveButtonWithTitle:(NSString *)title block:(void (^)())block
{
    [self addButtonWithTitle:title color:@"red" block:block];
}

- (void)setMessageAlighment:(NSTextAlignment)textAlignMent {
    msgAlignment = textAlignMent;
    [self setupDisplay];
}

- (void)show
{
    _shown = YES;
    
    BOOL isSecondButton = NO;
    NSUInteger index = 0;
    for (NSUInteger i = 0; i < _blocks.count; i++)
    {
        NSArray *block = [_blocks objectAtIndex:i];
        NSString *title = [block objectAtIndex:1];
        NSString *color = [block objectAtIndex:2];
        NSString* btnBackImgName = nil;
        NSString* btnBackImgHilightName = nil;
        //取消按钮背景图片特别处理
        if ([color isEqualToString:@"black"]) {
            btnBackImgName = @"huiseanniu";
            btnBackImgHilightName = @"huiseanniu-";
        }
        else
        {
            btnBackImgName = @"lanseanniu";
            btnBackImgHilightName = @"lanseanniu-";
        }
        //UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"alert-%@-button.png", color]];
        UIEdgeInsets insets = UIEdgeInsetsMake(7, 7, 7, 7);
        UIImage *image = [YQGlobalHelper createBackgroundImageWithImageName:btnBackImgName edgeInsets:insets];
        UIImage *highImage = [YQGlobalHelper createBackgroundImageWithImageName:btnBackImgHilightName edgeInsets:insets];
        CGFloat maxHalfWidth = floorf((_view.bounds.size.width-kAlertViewBorder*3)*0.5);
        CGFloat width = _view.bounds.size.width-kAlertViewBorder*2;
        CGFloat xOffset = kAlertViewBorder;
        if (isSecondButton)
        {
            width = maxHalfWidth;
            xOffset = width + kAlertViewBorder * 2;
            isSecondButton = NO;
        }
        else if (i + 1 < _blocks.count)
        {
            // In this case there's another button.
            // Let's check if they fit on the same line.
            CGSize size = [title sizeWithFont:buttonFont 
                                  minFontSize:10 
                               actualFontSize:nil
                                     forWidth:_view.bounds.size.width-kAlertViewBorder*2 
                                lineBreakMode:NSLineBreakByClipping];
            
            if (size.width < maxHalfWidth - kAlertViewBorder)
            {
                // It might fit. Check the next Button
                NSArray *block2 = [_blocks objectAtIndex:i+1];
                NSString *title2 = [block2 objectAtIndex:1];
                size = [title2 sizeWithFont:buttonFont 
                                minFontSize:10 
                             actualFontSize:nil
                                   forWidth:_view.bounds.size.width-kAlertViewBorder*2 
                              lineBreakMode:NSLineBreakByClipping];
                
                if (size.width < maxHalfWidth - kAlertViewBorder)
                {
                    // They'll fit!
                    isSecondButton = YES;  // For the next iteration
                    width = maxHalfWidth;
                }
            }
        }
        else if (_blocks.count  == 1)
        {
            // In this case this is the ony button. We'll size according to the text
            CGSize size = [title sizeWithFont:buttonFont
                                  minFontSize:10
                               actualFontSize:nil
                                     forWidth:_view.bounds.size.width-kAlertViewBorder*2
                                lineBreakMode:NSLineBreakByClipping];
            
            size.width = MAX(size.width, 80);
            if (size.width + 2 * kAlertViewBorder < width)
            {
                //width = size.width + 2 * kAlertViewBorder;
                xOffset = floorf((_view.bounds.size.width - width) * 0.5);
            }
        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(xOffset, _height, width, kAlertButtonHeight);        
        //button.titleLabel.font = buttonFont;
        if (IOS_LESS_THAN_6) {
#pragma clan diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            //button.titleLabel.minimumFontSize = 10;
#pragma clan diagnostic pop
        }
        else {
            //button.titleLabel.adjustsFontSizeToFitWidth = YES;
            //button.titleLabel.adjustsLetterSpacingToFitWidth = YES;
            //button.titleLabel.minimumScaleFactor = 0.1;
        }
        //button.titleLabel.textAlignment = NSTextAlignmentCenter;
        //button.titleLabel.shadowOffset = kAlertViewButtonShadowOffset;
        button.backgroundColor = [UIColor clearColor];
        button.tag = i+1;
        
        //[button setBackgroundImage:image forState:UIControlStateNormal];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setBackgroundImage:highImage forState:UIControlStateHighlighted];
        //[button setTitleColor:kAlertViewButtonTextColor forState:UIControlStateNormal];
        //[button setTitleShadowColor:kAlertViewButtonShadowColor forState:UIControlStateNormal];
        //[button setTitle:title forState:UIControlStateNormal];
        //button.accessibilityLabel = title;
        
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [_view addSubview:button];
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:button.frame];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = buttonFont;
        titleLabel.shadowOffset = kAlertViewButtonShadowOffset;
        titleLabel.textColor = kAlertViewButtonTextColor;
        //取消按钮字体颜色特别处理
        if ([color isEqualToString:@"black"]) {
            titleLabel.textColor = UIColorFromRGB(0x666666);
        }
        titleLabel.text = title;
        if (IOS_LESS_THAN_6) {
#pragma clan diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            titleLabel.minimumFontSize = 10;
#pragma clan diagnostic pop
        }
        else {
            titleLabel.adjustsFontSizeToFitWidth = YES;
            titleLabel.adjustsLetterSpacingToFitWidth = YES;
            titleLabel.minimumScaleFactor = 0.1;
        }
        [_view addSubview:titleLabel];
        if (!isSecondButton)
            _height += kAlertButtonHeight + kAlertViewBorder;
        
        index++;
    }

    //_height += 10;  // Margin for the shadow // not sure where this came from, but it's making things look strange (I don't see a shadow, either)
    
    if (_height < background.size.height)
    {
        CGFloat offset = background.size.height - _height;
        _height = background.size.height;
        CGRect frame;
        for (NSUInteger i = 0; i < _blocks.count; i++)
        {
            UIButton *btn = (UIButton *)[_view viewWithTag:i+1];
            frame = btn.frame;
            frame.origin.y += offset;
            btn.frame = frame;
        }
    }
    //加close按钮
    CGSize viewSize = _view.bounds.size;
    if (self.hasCloseBtn) {
        UIImageView* closeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(viewSize.width - 20, 5, 15, 15)];
        closeIcon.tag = 222;
        closeIcon.image = [UIImage imageNamed:@"alertViewClose"];
        [_view addSubview:closeIcon];
        UIButton *closebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closebtn.tag = 333;
        closebtn.backgroundColor = [UIColor clearColor];
        closebtn.frame = CGRectMake(viewSize.width - 25, 0, 25, 25);
        [closebtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_view addSubview:closebtn];
    }    
    CGRect frame = _view.frame;
    frame.origin.y = - _height;
    frame.size.height = _height;
    _view.frame = frame;
    
    UIImageView *modalBackground = [[UIImageView alloc] initWithFrame:_view.bounds];
    
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
        modalBackground.image = backgroundlandscape;
    else
        modalBackground.image = background;

    modalBackground.contentMode = UIViewContentModeScaleToFill;
    modalBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_view insertSubview:modalBackground atIndex:0];
    
    if (_backgroundImage)
    {
        [BlockBackground sharedInstance].backgroundImage = _backgroundImage;
        _backgroundImage = nil;
    }
    
    [BlockBackground sharedInstance].vignetteBackground = _vignetteBackground;
    _BackView = [[UIView alloc] initWithFrame:[BlockBackground sharedInstance].bounds];
    _BackView.backgroundColor = [UIColor blackColor];
    _BackView.alpha = 0.5;
    [[BlockBackground sharedInstance] addSubview:_BackView];
    [[BlockBackground sharedInstance] addToMainWindow:_view];
    [[BlockBackground sharedInstance] addAlertObject:self];
    
    __block CGPoint center = _view.center;
    center.y = floorf([BlockBackground sharedInstance].bounds.size.height * 0.5) + kAlertViewBounce;
    center.y -= kAlertViewBounce;
    _view.center = center;
     _view.alpha = 1.0;
    _cancelBounce = NO;
    
    [UIView animateWithDuration:.6
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [BlockBackground sharedInstance].alpha = 1.0f;
                         _view.center = center;
                     } 
                     completion:^(BOOL finished) {
                         /*
                         if (_cancelBounce) return;
                         
                         [UIView animateWithDuration:0.1
                                               delay:0.0
                                             options:0
                                          animations:^{
                                              center.y -= kAlertViewBounce;
                                              _view.center = center;
                                          } 
                                          completion:^(BOOL finished) {
                                              [[NSNotificationCenter defaultCenter] postNotificationName:@"AlertViewFinishedAnimations" object:self];
                                          }];
                          */
                     }];
    
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated 
{
    _shown = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
//    if (buttonIndex >= 0 && buttonIndex < [_blocks count])
//    {
//        id obj = [[_blocks objectAtIndex: buttonIndex] objectAtIndex:0];
//        if (![obj isEqual:[NSNull null]])
//        {
//            ((void (^)())obj)();
//        }
//    }
    
    if (animated)
    {
        [UIView animateWithDuration:0.1
                              delay:0.0
                            options:0
                         animations:^{
                             //CGPoint center = _view.center;
                             //center.y += 20;
                            // _view.center = center;
                         } 
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:.6
                                                   delay:0.0 
                                                 options:UIViewAnimationOptionCurveEaseIn
                                              animations:^{
                                                  //CGRect frame = _view.frame;
                                                  //frame.origin.y = -frame.size.height;
                                                  //_view.frame = frame;
                                                  [[BlockBackground sharedInstance] removeView:_BackView];
                                                  [[BlockBackground sharedInstance] reduceAlphaIfEmpty];
                                              } 
                                              completion:^(BOOL finished) {
                                                  [[BlockBackground sharedInstance] removeView:_view];                                                  
                                                  _view = nil;
                                                  [self invokeBlock:buttonIndex];
                                                  [[BlockBackground sharedInstance] delAlertObject:self];
                                              }];
                         }];
    }
    else
    {
        [[BlockBackground sharedInstance] removeView:_view];
        _view = nil;
        [self invokeBlock:buttonIndex];
    }
}
-(void)invokeBlock:(int)buttonIndex{
    if (buttonIndex >= 0 && buttonIndex < [_blocks count])
    {
        id obj = [[_blocks objectAtIndex: buttonIndex] objectAtIndex:0];
        if (![obj isEqual:[NSNull null]])
        {
            ((void (^)())obj)();
        }
    }
    
}
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Action

- (void)buttonClicked:(id)sender 
{
    /* Run the button's block */
    int buttonIndex = [(UIButton *)sender tag] - 1;
    [self dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

- (void)closeBtnClicked:(id)sender
{
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:0
                     animations:^{
                         //CGPoint center = _view.center;
                         //center.y += 20;
                         //_view.center = center;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:.6
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              //CGRect frame = _view.frame;
                                              //frame.origin.y = -frame.size.height;
                                              //_view.frame = frame;
                                              [[BlockBackground sharedInstance] removeView:_BackView];
                                              [[BlockBackground sharedInstance] reduceAlphaIfEmpty];
                                          }
                                          completion:^(BOOL finished) {
                                              [[BlockBackground sharedInstance] removeView:_view];                                              
                                               _view = nil;                                              
                                          }];
                     }];

}

@end
