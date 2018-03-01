//
//  PostViewController.m
//  tinytorch_test
//
//  Created by Alok Desai on 21/02/18.
//  Copyright © 2018 Cuelogic. All rights reserved.
//

#import "PostViewController.h"
#import <JWT/JWT.h>
#import "AFNetworking.h"
#import "PostCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MyPostResponse.h"
#import "APIConstants.h"
#import "SVProgressHUD.h"
#import "Reachability.h"
#import "CCBottomRefreshControl/UIScrollView+BottomRefreshControl.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "PostDataModel.h"
#import "LoginViewController.h"

@interface PostViewController ()
@property (weak, nonatomic) AFHTTPSessionManager *manager;
@property (weak, nonatomic) IBOutlet UICollectionView *postCollectionView;
@property (weak, nonatomic) NSArray *image_array, *label_array;
@property (strong, nonatomic) MyPostResponse *postData;
@end

@implementation PostViewController {
    UIRefreshControl *refreshController;
    UIRefreshControl *bottomRefreshController;
    NSInteger postPage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _manager = [AFHTTPSessionManager manager];
    postPage = 1;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
    NSString *documentPath = [paths objectAtIndex:0];
    NSLog(@"documentPath @%@",documentPath);
    
    
    refreshController = [[UIRefreshControl alloc] init];
    bottomRefreshController = [[UIRefreshControl alloc] init];
    [_postCollectionView addSubview:refreshController];
    [refreshController addTarget:self action:@selector(loadDat) forControlEvents:UIControlEventValueChanged];
    bottomRefreshController.triggerVerticalOffset = 120.;
    [bottomRefreshController addTarget:self action:@selector(bottomRefreshControl) forControlEvents:UIControlEventValueChanged];
    _postCollectionView.bottomRefreshControl = bottomRefreshController;
    
    _image_array = [NSArray arrayWithObjects: @"launch_logo.png", @"launch_logo.png", @"launch_logo.png", @"launch_logo.png",@"launch_logo.png", @"launch_logo.png",@"launch_logo.png", @"launch_logo.png", nil ];
    _label_array = [NSArray arrayWithObjects: @"APPLE", @"ANDROID",@"APPLE", @"ANDROID", @"APPLE", @"ANDROID",
                   @"APPLE", @"ANDROID", nil ];
    
    _postCollectionView.delegate = self;
    _postCollectionView.dataSource = self;
    
    _postData = [[MyPostResponse alloc] init];
    
    CGRect rect = _postCollectionView.frame;
    rect.origin.x = 5;
    rect.origin.y = 0;
    rect.size.width = [[UIScreen mainScreen] bounds].size.width - 5;
    rect.size.height = [[UIScreen mainScreen] bounds].size.height;
    
    _postCollectionView.frame = rect;
    _postCollectionView.backgroundColor = [UIColor clearColor];
    
    [_postCollectionView registerNib:[UINib nibWithNibName:@"PostCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionCell"];
    
    if([Reachability isNetworkAvailable]){
        [self loadMyPosts];
    }else{
        [SVProgressHUD showErrorWithStatus:@"No Network Available, Showing Offline Posts"];
        [self fetchOfflinePosts];
    }
    
}
- (IBAction)logoutUser:(UIBarButtonItem *)sender {
    [SVProgressHUD showSuccessWithStatus:@"Logout"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"user_id"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"user_name"];
    [self launchLoginScreen];
}

- (void) launchLoginScreen {
    NSString *loginControllerIdentifier = @"LoginViewController";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle: nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:loginControllerIdentifier];
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UIWindow *window = appDelegate.window;
    window.rootViewController = loginViewController;
}

- (void) loadDat {
    if([Reachability isNetworkAvailable]){
        postPage = 1;
        [self refreshMyPosts];
    }else {
        [refreshController endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"No Network Available"];
    }
}

- (void) bottomRefreshControl {
    if ((_postData.metaData.nextPage == 0) && ( _postData.metaData.nextPage ==  _postData.metaData.currentPage)) {
        [bottomRefreshController endRefreshing];
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.item == _postData.data.count - 1){
        if ((_postData.metaData.nextPage != 0) && ( _postData.metaData.nextPage !=  _postData.metaData.currentPage)) {
            [self loadMoreMyPosts];
        }else {
            [bottomRefreshController endRefreshing];
        }
    } else {
         [bottomRefreshController endRefreshing];
    }
}


- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [_postData.data count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"CollectionCell";
    
    PostCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:simpleTableIdentifier forIndexPath:indexPath];
   
    
    PostsData *postData = (PostsData *)[_postData.data objectAtIndex:indexPath.row];
//    AttachmentInfo *attachment = (AttachmentInfo *)[postData.postAttachments objectAtIndex:0];
    NSURL *displayImage = [NSURL URLWithString:[postData getDisplayImage]];
    if(displayImage && ![displayImage.absoluteString isEqualToString:@""]){
        [cell.postImage setHidden:false];
        [cell.postImage sd_setImageWithURL:[NSURL URLWithString:[postData getDisplayImage]]];
    }else {
        [cell.postImage setHidden:true];
    }
    
    if(postData.postType == Message){
        [cell.postTypeImage setHidden:true];
        [cell.postMessage setText:postData.postMessage];
    }else if (postData.postType == Photo){
        [cell.postTypeImage setHidden:true];
        [cell.postMessage setText:@""];
    }else if(postData.postType == MultiPhoto){
        [cell.postTypeImage setHidden:false];
        [cell.postTypeImage setImage:[UIImage imageNamed:@"multiphoto_type"]];
        [cell.postMessage setText:@""];
    }else if(postData.postType == Link){
        [cell.postTypeImage setHidden:false];
        [cell.postTypeImage setImage:[UIImage imageNamed:@"link_type"]];
        [cell.postMessage setText:@""];
    }else if(postData.postType == Video){
        [cell.postTypeImage setHidden:false];
        [cell.postTypeImage setImage:[UIImage imageNamed:@"video_type"]];
        [cell.postMessage setText:@""];
    }
    
    return cell;
}

#pragma mark – UICollectionViewDelegateFlowLayout

// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize s = CGSizeMake([[UIScreen mainScreen] bounds].size.width/2 - 1, [[UIScreen mainScreen] bounds].size.width/2 - 1);
    return s;
}

// 3
//- (UIEdgeInsets)collectionView:
//(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(1, 0, 1, 0);
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadMyPosts {
    [SVProgressHUD show];
    NSString *myPostURL = @"https://app.tinytorch.com/api/v1/users/";
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"user_id"];
    NSString *finalURL = [NSString stringWithFormat:@"%@%@%@", myPostURL, userId,@"/posts"];
    NSLog(@"URL: %@", finalURL);
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:finalURL parameters:[self getRequestData] error:nil];
    [req setValue:[self getAJWTToken] forHTTPHeaderField:@"Authorization"];
        
    [[_manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        if(!error){
            //NSLog(@"JSON: %@", responseObject);
            [self clearTable];
            [self parseResponse:responseObject];
        }else{
            [SVProgressHUD showErrorWithStatus:@"Error from server, showing offline posts."];
            [self fetchOfflinePosts];
        }
    }]resume];
}

- (void) refreshMyPosts {
    NSString *myPostURL = @"https://app.tinytorch.com/api/v1/users/";
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"user_id"];
    NSString *finalURL = [NSString stringWithFormat:@"%@%@%@", myPostURL, userId,@"/posts"];
    NSLog(@"URL: %@", finalURL);
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:finalURL parameters:[self getRequestData] error:nil];
    [req setValue:[self getAJWTToken] forHTTPHeaderField:@"Authorization"];
    
    [[_manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [refreshController endRefreshing];
        if(!error){
            NSLog(@"JSON: %@", responseObject);
            [self parseResponse:responseObject];
        }
    }]resume];
}

- (void) fetchOfflinePosts {
    NSManagedObjectContext *context =[self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"PostData"];
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (NSManagedObject *obj in results) {
        NSArray *keys = [[[obj entity] attributesByName] allKeys];
        [array addObject:[obj dictionaryWithValuesForKeys:keys]];
    }
    if (error != nil) {
        
        //Deal with failure
    }
    else {
        _postData = [[MyPostResponse alloc] init];
        NSMutableArray *postsArr;
        NSMutableArray *attachmentsArr;
        postsArr = [[NSMutableArray alloc] init];
         for (NSDictionary *data in array) {
             PostsData *postData = [[PostsData alloc] init];
             AttachmentInfo *attachmentInfo = [[AttachmentInfo alloc] init];
             postData.postId = [data objectForKey:@"postId"];
             postData.postType = [self getPostType:[data objectForKey:@"postType"]];
             postData.postMessage = [data objectForKey:@"postMessage"];
             attachmentsArr = [[NSMutableArray alloc] init];
             if([NSNull null] != [data objectForKey:@"postAttachment"]){
                 attachmentInfo.attachmentUrl = [data objectForKey:@"postAttachment"];
                 attachmentInfo.thumbUrl = [data objectForKey:@"postAttachment"];
             }else {
                 attachmentInfo.attachmentUrl = @"";
                 attachmentInfo.thumbUrl = @"";
             }
             [attachmentsArr addObject:attachmentInfo];
             postData.postAttachments = attachmentsArr;
             [postsArr addObject:postData];
         }
        
        _postData.data = postsArr;
        [_postCollectionView reloadData];
        //Deal with success
    }
}

- (void) loadMoreMyPosts {
    postPage = postPage + 1;
    NSString *myPostURL = @"https://app.tinytorch.com/api/v1/users/";
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"user_id"];
    NSString *finalURL = [NSString stringWithFormat:@"%@%@%@", myPostURL, userId,@"/posts"];
    NSLog(@"URL: %@", finalURL);
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:finalURL parameters:[self getRequestData] error:nil];
    [req setValue:[self getAJWTToken] forHTTPHeaderField:@"Authorization"];
    
    [[_manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [bottomRefreshController endRefreshing];
        if(!error){
            NSLog(@"JSON: %@", responseObject);
            [self parseLoadMoreResponse:responseObject];
        }
    }]resume];
}

-(NSString *)getAJWTToken
{
    NSDictionary *payload = @{@"user_id" : [[NSUserDefaults standardUserDefaults] stringForKey:@"user_id"], @"exp" : @([[[NSDate date]dateByAddingTimeInterval:60] timeIntervalSince1970])};
    id<JWTAlgorithm> algorithm = [JWTAlgorithmFactory algorithmByName:@"HS256"];
    NSString *token = [JWTBuilder encodePayload:payload].secret(@"ij-kRlKv-PaU-rvByLX0viKTxWAaooAn5z8a1244bAE8Dp1vr4RSn1ytXh4Z-o-I").algorithm(algorithm).encode;
    return token;
}

-(NSMutableDictionary*)getRequestData{
    NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
    [data setObject:@"user,category" forKey:@"include"];
    [data setObject:[NSString stringWithFormat:@"%ld",(long)postPage] forKey:@"page"];
    [data setObject:[NSString stringWithFormat:@"%d",20] forKey:@"per_page"];
    return data;
}

- (void) parseResponse:(id) postsInfo {
    _postData.data = [self getPostsData:postsInfo];
    _postData.metaData = [self getPostsMetaData:postsInfo];
    [_postCollectionView reloadData];
}

-(void) parseLoadMoreResponse:(id) postsInfo {
    [_postData.data addObjectsFromArray:[self getPostsData:postsInfo]];
    _postData.metaData = [self getPostsMetaData:postsInfo];
    [_postCollectionView reloadData];
}

-(PostsMetaData *) getPostsMetaData:(id) postsInfo {
    PostsMetaData *postsMetaData;
    if (![[postsInfo objectForKey:kMeta] isKindOfClass:[NSString class]]) {
        
        if (![[postsInfo objectForKey:kMeta] isKindOfClass:[NSNull class]]) {
            NSDictionary *dict = [postsInfo objectForKey:kMeta];
            postsMetaData = [[PostsMetaData alloc] init];
            postsMetaData.count = [[dict objectForKey:kCount] intValue];
            postsMetaData.perPage = [[dict objectForKey:kPerPage] intValue];
            postsMetaData.currentPage = [[dict objectForKey:kCurrentPage] intValue];
            if([NSNull null] != [dict objectForKey:kNextPage]){
                postsMetaData.nextPage = [[dict objectForKey:kNextPage] intValue];
            }
            if([NSNull null] != [dict objectForKey:kPreviousPage]){
                postsMetaData.prevPage = [[dict objectForKey:kPreviousPage] intValue];
            }
            
        }
        
    }
    return postsMetaData;
}

- (NSMutableArray *) getPostsData:(id) postsInfo {
    NSMutableArray *postsArr;
    if (![[postsInfo objectForKey:kData] isKindOfClass:[NSNull class]] && [postsInfo objectForKey:kData] != nil) {
        
        postsArr = [[NSMutableArray alloc] init];
        NSMutableArray *postsDataArr = [postsInfo objectForKey:kData];
        for (NSDictionary *data in postsDataArr) {
            
            PostsData *postData = [[PostsData alloc] init];
            postData.postId = [data objectForKey:kId];
            postData.type = [data objectForKey:kType];
            postData.postType = [self getPostType:[data objectForKey:kPostType]];
            postData.postMessage = [data objectForKey:kMessage];
            if ([[data objectForKey:kTags] isKindOfClass:[NSString class]]) {
                postData.postTags = [NSArray new];
            }
            else {
                postData.postTags = [data objectForKey:kTags];
            }
            
            postData.postLink = [self getLinkInfo:[data objectForKey:kLink]];
            postData.createdAt = [data objectForKey:kCreatedAt];
            postData.updatedAt = [data objectForKey:kUpdatedAt];
            postData.postUserId = [data objectForKey:kUserId];
            postData.postCategoryId = (int)[data objectForKey:kCategoryId];
            postData.postUserInfo = [self getUserInfo:[data objectForKey:kUser]];
            postData.postCategoryInfo = [self getCategoryInfo:[data objectForKey:kCategory]];
            postData.postAttachments = [self getAttachmentsData:[data objectForKey:kAttachments]];
            //postData.totalHeight = POST_CELL_HEIGHT;
            postData.isExpanded = NO;
            [self saveOfflineData:postData];
            [postsArr addObject:postData];
        }
        
    }
    return postsArr;
}

-(PostType)getPostType:(NSString *) postType {
    if ([postType  isEqual: kPostTypeMessage]) {
        return Message;
    }
    else if ([postType  isEqual: kPostTypePhoto]) {
        return Photo;
    }
    else if ([postType  isEqual: kPostTypeMultiPhoto]) {
        return MultiPhoto;
    }
    else if ([postType  isEqual: kPostTypeLink]) {
        return Link;
    }
    else if ([postType  isEqual: kPostTypeVideo]) {
        return Video;
    }
    return Message;
}

-(LinkInfo*) getLinkInfo:(id) linkInfo {
    LinkInfo *info;
    
    if (![linkInfo isKindOfClass:[NSString class]]) {
        
        if (![linkInfo isKindOfClass:[NSNull class]]) {
            info = [[LinkInfo alloc] init];
            info.linkUrl = [linkInfo objectForKey:kUrl];
            info.linkTitle = [linkInfo objectForKey:kTitle];
            info.linkPhoto = [linkInfo objectForKey:kPhoto];
            info.linkDescription = [linkInfo objectForKey:kDescription];
        }
    }
    
    return info;
}

-(UserInfo*) getUserInfo:(id) userInfo {
    UserInfo *info;
    
    if (![userInfo isKindOfClass:[NSString class]]) {
        
        if (![userInfo isKindOfClass:[NSNull class]]) {
            info = [[UserInfo alloc] init];
            info.userId = [userInfo objectForKey:kUserId];
            info.userType = [userInfo objectForKey:kType];
            info.userName = [userInfo objectForKey:kUserName];
            info.userSlug = [userInfo objectForKey:kSlug];
            info.userAvatar = [userInfo objectForKey:kAvatar];
            info.userPostsCount = (int)[userInfo objectForKey:kPostsCount];
        }
        
    }
    return info;
}

-(CategoryInfo*) getCategoryInfo:(id) categoryInfo {
    CategoryInfo *info;
    if (![categoryInfo isKindOfClass:[NSString class]]) {
        if (![categoryInfo isKindOfClass:[NSNull class]]) {
            info = [[CategoryInfo alloc] init];
            info.categoryId = (int)[categoryInfo objectForKey:kId];
            info.categoryType = [categoryInfo objectForKey:kType];
            info.categoryTitle = [categoryInfo objectForKey:kTitle];
            info.categorySlug = [categoryInfo objectForKey:kSlug];
        }
        
    }
    return info;
}

-(NSMutableArray *) getAttachmentsData:(id) attachmentsInfo {
    
    NSMutableArray *attachmentsArr;
    
    if (![attachmentsInfo isKindOfClass:[NSNull class]]) {
        
        attachmentsArr = [[NSMutableArray alloc] init];
        for (NSDictionary *data in attachmentsInfo) {
            
            AttachmentInfo *attachmentInfo = [[AttachmentInfo alloc] init];
            attachmentInfo.attachmentId = [data objectForKey:kId];
            attachmentInfo.attachmentType = [data objectForKey:kType];
            attachmentInfo.attachmentUrl = [data objectForKey:kUrl];
            attachmentInfo.attachmentKey = [data objectForKey:kKey];
            attachmentInfo.rowPosition = [NSString stringWithFormat:@"%lu",(unsigned long)[attachmentsInfo indexOfObject:data]];
            attachmentInfo.thumbUrl = [data objectForKey:@"thumb"];
            [attachmentsArr addObject:attachmentInfo];
        }
        
    }
    
    return attachmentsArr;
    
}

- (NSManagedObjectContext *)managedObjectContext {
    //NSManagedObjectContext *context = nil;
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    if ([delegate respondsToSelector:@selector(managedObjectContext)]) {
//        context = [delegate managedObjectContext];
//    }

    return delegate.persistentContainer.viewContext;
}

- (void) saveOfflineData: (PostsData *) postData {
     NSManagedObjectContext *context = [self managedObjectContext];
    // Create a new managed object
    NSManagedObject *newPost = [NSEntityDescription insertNewObjectForEntityForName:@"PostData" inManagedObjectContext:context];
    
//    PostDataModel *postModel = [NSEntityDescription insertNewObjectForEntityForName:@"PostData" inManagedObjectContext:context];
    
    NSString *postType = [self getPostTypeString:postData.postType];
    NSString *postAttachment = postData.getDisplayImage;
    
    [newPost setValue:postData.postId forKey:@"postId"];
    [newPost setValue:postType forKey:@"postType"];
    [newPost setValue:postAttachment forKey:@"postAttachment"];
    if([NSNull null] != postData.postMessage){
        [newPost setValue:postData.postMessage forKey:@"postMessage"];
    }else{
        [newPost setValue:@"" forKey:@"postMessage"];
    }
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}

- (NSString*)getPostTypeString:(PostType) postType {
    switch (postType) {
        case Message:
            return  kPostTypeMessage;
        case Photo:
            return  kPostTypePhoto;
        case MultiPhoto:
            return  kPostTypeMultiPhoto;
        case Link:
            return  kPostTypeLink;
        case Video:
            return  kPostTypeVideo;
            
        default:
            return  kPostTypeMessage;
    }
    
}

- (void) clearTable {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest * allRecords = [[NSFetchRequest alloc] init];
    [allRecords setEntity:[NSEntityDescription entityForName:@"PostData" inManagedObjectContext:context]];
    [allRecords setIncludesPropertyValues:NO];
    NSError * error = nil;
    NSArray * result = [context executeFetchRequest:allRecords error:&error];
    for (NSManagedObject * profile in result) {
        [context deleteObject:profile];
    }
    NSError *saveError = nil;
    [context save:&saveError];
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
