//
//  ViewController.m
//  NBEmojiSearchViewExample
//
//  Created by Neeraj Baid on 6/13/15.
//  Copyright (c) 2015 Neeraj Baid. All rights reserved.
//

#import "NBEmojiSearchView.h"
#import "ViewController.h"

@interface ViewController () <UITextFieldDelegate, NBEmojiSearchViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) NBEmojiSearchView *searchView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchView = [[NBEmojiSearchView alloc] init];
    self.searchView.frame = CGRectMake(0, 60, self.view.frame.size.width, 300);
    [self.view addSubview:self.searchView];
    [self.searchView installOnTextField:self.textField delegate:self];
}

- (void)emojiSearchView:(NBEmojiSearchView *)emojiSearchView didSelectEmoji:(NBEmoji *)emoji
{
    NSString *stringToAppend = [NSString stringWithFormat:@"%@ ", emoji.emoji];
    self.textField.text = [self.textField.text stringByAppendingString:stringToAppend];
}

@end
