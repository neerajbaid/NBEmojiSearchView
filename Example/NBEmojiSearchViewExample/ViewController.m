//
//  ViewController.m
//  NBEmojiSearchViewExample
//
//  Created by Neeraj Baid on 6/13/15.
//  Copyright (c) 2015 Neeraj Baid. All rights reserved.
//

#import "NBEmojiSearchView.h"
#import "ViewController.h"

@interface ViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) NBEmojiSearchView *searchView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchView = [[NBEmojiSearchView alloc] init];
    self.searchView.frame = CGRectMake(0, 60, self.view.frame.size.width, 300);
    [self.view addSubview:self.searchView];
    self.textField.delegate = self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self.searchView searchWithText:newString];
    return YES;
}

@end
