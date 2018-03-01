//
//  LoginViewController.m
//  tinytorch_test
//
//  Created by Alok Desai on 20/02/18.
//  Copyright © 2018 Cuelogic. All rights reserved.
//

#import "LoginViewController.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "PostViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *LoginButton;
@property (weak, nonatomic) IBOutlet UITextField *UserEmail;
@property (weak, nonatomic) IBOutlet UITextField *UserPassword;
@property (weak, nonatomic) AFHTTPSessionManager *manager;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _manager = [AFHTTPSessionManager manager];
    self.UserEmail.delegate = self;
    self.UserPassword.delegate = self;
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"user_id"] != nil){
        [self launchPostScreen];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"user_id"] != nil){
        [self launchPostScreen];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.UserEmail resignFirstResponder];
    [self.UserPassword resignFirstResponder];
    return true;
}


- (IBAction)login:(id)sender {
    NSLog(@"Login Clicked");
    if([self validateData]){
        [self loginUser];
    }
}

- (BOOL) validateData {
    if(self.UserEmail.text.length == 0){
        [SVProgressHUD showErrorWithStatus:@"Please Enter User Email"];
        return false;
    }else if(self.UserPassword.text.length == 0){
        [SVProgressHUD showErrorWithStatus:@"Please Enter User Password"];
        return false;
    }else {
        return true;
    }
    
}

- (void) loginUser {
    [SVProgressHUD show];
    [self.view endEditing:YES];
    NSString *loginURL = @"https://app.tinytorch.com/api/v1/users/sign_in";
    [_manager POST:loginURL parameters:[self getLogInRequestData] progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"JSON: %@", responseObject);
        NSString *userId = [responseObject objectForKey:@"user_id"];
        NSString *userName = [responseObject objectForKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"user_id"];
        [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"user_name"];
        NSLog(@"User ID: %@",[[NSUserDefaults standardUserDefaults] stringForKey:@"user_id"]);
        [self launchPostScreen];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

- (NSMutableDictionary*)getLogInRequestData {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
    [data setObject:self.UserEmail.text forKey:@"email"];
    [data setObject:self.UserPassword.text forKey:@"password"];
    [dict setObject:data forKey:@"user"];
    return dict;
}

- (void) launchPostScreen {
    NSString *detailControllerIdentifier = @"PostViewController";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Posts" bundle: nil];
    PostViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:detailControllerIdentifier];
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UIWindow *window = appDelegate.window;
    window.rootViewController = detailViewController;
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
