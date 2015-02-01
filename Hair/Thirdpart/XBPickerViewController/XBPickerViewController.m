//
//  XBPickerViewController.m
//  TuNiuApp
//
//  Created by Ben on 14-8-27.
//  Copyright (c) 2014年 Tuniu. All rights reserved.
//

#import "XBPickerViewController.h"

@interface XBPickerViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIToolbar *pickerToolBar;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (assign, nonatomic) NSInteger selectedIndex;


@end

@implementation XBPickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.backgroundView.alpha = 0.0f;
    self.pickerToolBar.alpha = 0.0f;
    self.selectedIndex = [self.titles indexOfObject:self.selectedTitle];
    if (self.selectedIndex == NSNotFound)
    {
        self.selectedIndex = 0;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.selectedIndex != NSNotFound)
    {
        [self.pickerView selectRow:self.selectedIndex
                       inComponent:0
                          animated:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Picker view datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [self.titles count] > 0 ? 2 : 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.titles.count;
    }else{
        NSInteger index = [self.pickerView selectedRowInComponent:0];
        return [[[self.titles objectAtIndex:index] objectForKey:@"data"] count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return [[self.titles objectAtIndex:row] objectForKey:@"title"];
    }else{
        NSInteger index = [self.pickerView selectedRowInComponent:0];
        return [[[[self.titles objectAtIndex:index] objectForKey:@"data"] objectAtIndex:row] objectForKey:@"title"];
    }
}

#pragma mark - Picker view delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        self.selectedIndex = row;
        [pickerView reloadComponent:1];
    }
}

#pragma mark - UI events

- (IBAction)okButtonClicked:(id)sender
{
    [self dismiss:YES];
}

- (IBAction)cancelButtonClicked:(id)sender
{
    [self dismiss:NO];
}

- (void)dismiss:(BOOL)ok
{
    [UIView animateWithDuration:0.3f
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.backgroundView.alpha = 0.0f;
                         self.pickerToolBar.alpha = 0.0f;
                         CGRect frame = self.pickerView.frame;
                         frame.origin.y = self.view.frame.size.height;
                         self.pickerView.frame = frame;;
                     } completion:^(BOOL finished) {
                         
                         if (ok && self.selectionBlock)
                         {
                             self.selectionBlock(self.selectedIndex);
                         }
                         [self willMoveToParentViewController:nil];
                         [self.view removeFromSuperview];
                         [self removeFromParentViewController];
                     }];
}

+ (XBPickerViewController *)pickerViewController
{
    XBPickerViewController *controller = [[self alloc] initWithNibName:NSStringFromClass([self class])
                                                                bundle:nil];
    return controller;
}

- (void)showInViewController:(UIViewController *)parentViewController
{
    self.backgroundView.alpha = 0.0f;
    self.pickerToolBar.alpha = 0.0f;
    [parentViewController addChildViewController:self];
    self.view.frame = parentViewController.view.bounds;
    CGRect frame = self.pickerView.frame;
    frame.origin.y = self.view.frame.size.height;
    self.pickerView.frame = frame;
    [parentViewController.view addSubview:self.view];
    [self didMoveToParentViewController:parentViewController];
    [UIView animateWithDuration:0.3f
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.backgroundView.alpha = 0.5f;
                         self.pickerToolBar.alpha = 1.0f;
                         CGRect frame = self.pickerView.frame;
                         frame.origin.y = self.view.frame.size.height - frame.size.height;
                         self.pickerView.frame = frame;
                     } completion:^(BOOL finished) {
                         
                     }];
}

@end
