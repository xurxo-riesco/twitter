//
//  ComposeViewController.m
//  twitter
//
//  Created by Xurxo Riesco on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"
#import "Tweet.h"

@interface ComposeViewController () <UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *charactersRemaining;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.delegate = self;
    if(self.isResponse)
    {
        self.textView.text = [NSString stringWithFormat:@"@%@ ", [[self.tweet user] screenName] ];
    }
    // Do any additional setup after loading the view.
}
- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)didTapPost:(id)sender {
    [self composeTweet];
}
- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"Changing");
    NSUInteger length;
    length = [textView.text length];

    self.charactersRemaining.title = [NSString stringWithFormat:@"%lu", (280 -(unsigned long)length)];
}

- (void)composeTweet
{
    if(self.isResponse)
    {
        [[APIManager shared]replyStatusWithText:self.textView.text toID:self.tweet.idStr completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error composing Tweet: %@", error.localizedDescription);
            }
            else{
                [self.delegate didTweet:tweet];
                NSLog(@"Composed tweet sucessfully!");
            }
        }];
        self.isResponse = false;
    }else{
        [[APIManager shared]postStatusWithText:self.textView.text completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error composing Tweet: %@", error.localizedDescription);
            }
            else{
                [self.delegate didTweet:tweet];
                NSLog(@"Composed tweet sucessfully!");
            }
        }];
    }
    [self dismissViewControllerAnimated:true completion:nil];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
