//
//  ViewController.m
//  CSPasteManager
//
//  Created by Dana Buehre on 6/25/17.
//  Copyright © 2017 CreatureCoding. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    UIButton *_completeButton;
    CSPasteManager *_pasteManager;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pasteManager = [[CSPasteManager alloc] init];
    
    UIButton *ghostBinButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [ghostBinButton setBackgroundColor:[UIColor colorWithRed:0.71 green:0.71 blue:0.71 alpha:1.0]];
    [ghostBinButton setTitle:@"post to ghostbin" forState:UIControlStateNormal];
    [ghostBinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ghostBinButton addTarget:self action:@selector(postToGhostBin) forControlEvents:UIControlEventTouchUpInside];
    ghostBinButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:ghostBinButton];
    
    UIButton *hasteBinButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [hasteBinButton setBackgroundColor:[UIColor colorWithRed:0.71 green:0.71 blue:0.71 alpha:1.0]];
    [hasteBinButton setTitle:@"post to hastebin" forState:UIControlStateNormal];
    [hasteBinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [hasteBinButton addTarget:self action:@selector(postToHasteBin) forControlEvents:UIControlEventTouchUpInside];
    hasteBinButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:hasteBinButton];
    
    _completeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_completeButton setBackgroundColor:[UIColor colorWithRed:0.71 green:0.71 blue:0.71 alpha:1.0]];
    [_completeButton setTitle:@"Nothing Yet" forState:UIControlStateNormal];
    [_completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_completeButton addTarget:self action:@selector(openPost) forControlEvents:UIControlEventTouchUpInside];
    _completeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_completeButton];
    
    // ghostBinButton Constraints
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:ghostBinButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:ghostBinButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-28.0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[ghostBinButton]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(ghostBinButton)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[ghostBinButton(==44)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(ghostBinButton)]];
    
    // hasteBinButton Constraints
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:hasteBinButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:hasteBinButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:28.0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[hasteBinButton]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(hasteBinButton)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[hasteBinButton(==44)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(hasteBinButton)]];
    
    // completionButton Constraints
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_completeButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_completeButton]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_completeButton)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_completeButton]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_completeButton)]];


}

- (void)postToGhostBin {
    [_pasteManager makeRequestWithPostService:CSPMPostServiceGhostBin body:@"hello, ghostbin!" expiration:@"5m" completion:^(NSURL *response, NSError *error) {
        
        // update your UI here for task completion
        if (!error) {
            [self updateForCompletionWithURL:response.description withSuccess:YES];
            NSLog(@"upload successful : %@", response.description);
            
        } else {
            [self updateForCompletionWithURL:error.localizedDescription withSuccess:NO];
            NSLog(@"upload failed with ERROR : %@", error.localizedDescription);
            
        }
    }];
}

- (void)postToHasteBin {
    [_pasteManager makeRequestWithPostService:CSPMPostServiceHasteBin body:@"hello, hastebin!" expiration:nil completion:^(NSURL *response, NSError *error) {
        
        // update your UI here for task completion
        if (!error) {
            [self updateForCompletionWithURL:response.description withSuccess:YES];
            NSLog(@"upload successful : %@", response.description);
            
        } else {
            [self updateForCompletionWithURL:error.localizedDescription withSuccess:NO];
            NSLog(@"upload failed with ERROR : %@", error.localizedDescription);
            
        }
    }];
}

- (void)openPost {
    [[UIPasteboard generalPasteboard] setString:_completeButton.titleLabel.text];
    [_completeButton setTitle:@"copied" forState:UIControlStateNormal];
    [self performSelector:@selector(refreshCompletionTitle) withObject:nil afterDelay:3];
}

- (void)refreshCompletionTitle {
    [_completeButton setTitle:[[UIPasteboard generalPasteboard] string] forState:UIControlStateNormal];
}

- (void)updateForCompletionWithURL:(NSString *)URL withSuccess:(BOOL)success {
    // make sure were on the main thread for updating UI since this will be called inside a block
    dispatch_async(dispatch_get_main_queue(), ^{
        [_completeButton setTitle:URL forState:UIControlStateNormal];
        [_completeButton setBackgroundColor:success ? [UIColor colorWithRed:0.35 green:0.79 blue:0.30 alpha:1.0] : [UIColor colorWithRed:0.93 green:0.26 blue:0.40 alpha:1.0]];
    });
}

@end
