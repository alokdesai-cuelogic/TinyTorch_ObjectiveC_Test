//
//  MyPostResponse.h
//  tinytorch_test
//
//  Created by Alok Desai on 22/02/18.
//  Copyright © 2018 Cuelogic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enums.h"
#import <UIKit/UIKit.h>

@interface PostsMetaData : NSObject

@property (nonatomic,assign)  NSUInteger totalPosts;

@property (nonatomic,assign)  int count;
@property (nonatomic,assign)  int perPage;
@property (nonatomic,assign)  int currentPage;
@property (nonatomic,assign)  int nextPage;
@property (nonatomic,assign)  int prevPage;
@property (nonatomic,assign)  int numberOfHits;
@property (nonatomic,assign)  long processingTimeMS;
@property (nonatomic,strong)  NSString *query;
@property (nonatomic,assign)  BOOL isExhaustNumberHits;
@property (nonatomic,assign)  NSString *params;

@end

@interface LinkInfo : NSObject

@property (nonatomic,strong)  NSString *linkUrl;
@property (nonatomic,strong)  NSString *linkPhoto;
@property (nonatomic,strong)  NSString *linkTitle;
@property (nonatomic,strong)  NSString *linkDescription;

@end

@interface AttachmentInfo : NSObject

@property (nonatomic,strong)  NSString *attachmentId;
@property (nonatomic,strong)  NSString *attachmentType;
@property (nonatomic,strong)  NSString *attachmentUrl;
@property (nonatomic,strong)  NSString *attachmentKey;
@property (nonatomic, strong) NSString *thumbUrl;
@property (nonatomic,assign)  BOOL isS3PathExits;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic,strong)  NSString *s3PathUrl;
@property (nonatomic,strong)  NSString *localImageUrl;
@property (nonatomic,assign)  BOOL isLocalImageExits;
@property (nonatomic,strong)  NSData *attachmentData;
@property (nonatomic,strong)  NSString *attachmentImageName;
@property (nonatomic,strong)  NSString *rowPosition;
@property (nonatomic,strong)  NSString * isDestroy;
- (UIImage *) getAttachmentImage;
@end

@interface UserInfo : NSObject

@property (nonatomic,strong)  NSString *userId;
@property (nonatomic,strong)  NSString *userType;
@property (nonatomic,strong)  NSString *userName;
@property (nonatomic,strong)  NSString *userSlug;
@property (nonatomic,strong)  NSString *userAvatar;
@property (nonatomic,assign)  int userPostsCount;

@end

@interface CategoryInfo : NSObject

@property (nonatomic,assign)  int categoryId;
@property (nonatomic,strong)  NSString *categoryTitle;
@property (nonatomic,strong)  NSString *categorySlug;
@property (nonatomic,strong)  NSString *categoryType;

@end

@interface PostsData : NSObject

@property (nonatomic,strong)  NSString *postId;
@property (nonatomic,strong)  NSString *type;
@property (nonatomic,assign)  PostType postType;
@property (nonatomic,strong)  NSString *postMessage;
@property (nonatomic,strong)  NSArray  *postTags;
@property (nonatomic,strong)  LinkInfo *postLink;
@property (nonatomic,strong)  NSString *createdAt;
@property (nonatomic,strong)  NSString *updatedAt;
@property (nonatomic,strong)  NSString *postUserId;
@property (nonatomic,assign)  int postCategoryId;
@property (nonatomic,strong)  UserInfo  *postUserInfo;
@property (nonatomic,strong)  CategoryInfo  *postCategoryInfo;
@property (nonatomic,strong)  NSMutableArray *postAttachments;
@property (nonatomic,assign)  int schedulePostsCount;
@property (nonatomic,strong)  NSString *objectId;
@property (nonatomic,assign)  BOOL isExpanded;
@property (nonatomic,assign)  CGFloat totalHeight;

- (NSString *) getDisplayImage;

@end


@interface MyPostResponse : NSObject
@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic,strong) PostsMetaData *metaData;
@end
