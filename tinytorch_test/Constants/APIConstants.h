//
//  APIConstants.h
//  TinyTorch
//
//  Created by Basawaraj on 17/02/17.
//  Copyright © 2017 TinyTorch. All rights reserved.
//

#ifndef APIConstants_h
#define APIConstants_h

#define INSTAGRAM_CALLBACK_URL_PART @"/auth/instagram/callback/mobile"
#define LINKEDIN_CALLBACK_URL_PART @"/auth/linkedin/callback/mobile"

#define PRODUCTION

#ifdef PRODUCTION

#define baseUrl @"https://app.tinytorch.com/api/v1" //Live URL
#define INSTAGRAM_CALLBACK_BASE [NSString stringWithFormat:@"https://app.tinytorch.com%@",INSTAGRAM_CALLBACK_URL_PART]
#define INSTAGRAM_CLIENT_SECRET @"c093158c3fa8429b951b3454a9e35b01"
#define INSTAGRAM_CLIENT_ID @"34d319ec08e645eb94e87bf7c9cc235d"

#define LINKEDIN_CALLBACK_BASE [NSString stringWithFormat:@"https://app.tinytorch.com%@",LINKEDIN_CALLBACK_URL_PART]
#define LINKEDIN_CLIENT_SECRET @"JAePdrnI5atAIXoZ"
#define LINKEDIN_CLIENT_ID @"86ie4gejloeqa4"

#define GOOGLE_PLUS_CLIENT_ID @"428323417150-hud9ief0005lui641824g5qpi155a04o.apps.googleusercontent.com"

#define JWT_SECRET @"ij-kRlKv-PaU-rvByLX0viKTxWAaooAn5z8a1244bAE8Dp1vr4RSn1ytXh4Z-o-I"
#define JWT_EXPIRY 60
#define JWT_EXPIRY_UPLOAD 1200

#define TWITTER_API_KEY @"BfjmJxSa52Alahgcnh3223qhk"
#define TWITTER_API_SECRET @"4qlyJk9F0zWJ8yKDak31fdO2yV7vDe0QwJs5PxIWf2Nh9aavUe"


#else

#define baseUrl @"https://staging.tinytorch.com/api/v1" //Staging URL
#define INSTAGRAM_CALLBACK_BASE [NSString stringWithFormat:@"https://staging.tinytorch.com%@",INSTAGRAM_CALLBACK_URL_PART]
#define INSTAGRAM_CLIENT_SECRET @"e3a22748f0a24dda9edb80980d9dbe49"
#define INSTAGRAM_CLIENT_ID @"0258543cb187485a9e51ed991c32feae"

#define LINKEDIN_CALLBACK_BASE [NSString stringWithFormat:@"https://staging.tinytorch.com%@",LINKEDIN_CALLBACK_URL_PART]
#define LINKEDIN_CLIENT_SECRET @"JAePdrnI5atAIXoZ"
#define LINKEDIN_CLIENT_ID @"86ie4gejloeqa4"

#define GOOGLE_PLUS_CLIENT_ID @"428323417150-hud9ief0005lui641824g5qpi155a04o.apps.googleusercontent.com"

#define JWT_SECRET @"cO-36bGwJO-uHP6HsM3jhtVILEhcYzvmeat_kVXHvM7nEh6lQeNZ4Mnb1KTrjW5_"
#define JWT_EXPIRY 60
#define JWT_EXPIRY_UPLOAD 1200

#define TWITTER_API_KEY @"rwF2fGxL5ZNq3FJnAMyNiMtWg"
#define TWITTER_API_SECRET @"8hrM6O0gaqLa6OW2V54Ku2BWX4e0JZ0VGCFDrWaEDH08Cqxj4d"
#endif


//EndPoints
#define signUp @"users"
#define logIn @"users/sign_in"
#define confirmation @"users/confirmation"
#define forgotPassword @"users/password"
#define unlockAccount @"users/unlock"
#define verifyAccount @"users/confirmation/confirmed"
#define resetPassword @"users/password/reset"
#define unlock @"users/unlock/account"
//#define posts @"posts"
#define search @"search"

//API URL's
#define SIGNUP_API_URL [NSString stringWithFormat:@"%@/%@",baseUrl,signUp]
#define LOGIN_API_URL [NSString stringWithFormat:@"%@/%@",baseUrl,logIn]
#define CONFIRMATION_API_URL [NSString stringWithFormat:@"%@/%@",baseUrl,confirmation]
#define FORGOT_PASSWORD_API_URL [NSString stringWithFormat:@"%@/%@",baseUrl,forgotPassword]
#define UNLOCK_ACCOUNT_API_URL [NSString stringWithFormat:@"%@/%@",baseUrl,unlockAccount]
#define VERIFY_ACCOUNT_API_URL [NSString stringWithFormat:@"%@/%@",baseUrl,verifyAccount]
#define RESET_PASSWORD_API_URL [NSString stringWithFormat:@"%@/%@",baseUrl,resetPassword]
#define UNLOCK_API_URL [NSString stringWithFormat:@"%@/%@",baseUrl,unlock]
#define MYPOSTS_API_URL(userId) [NSString stringWithFormat:@"%@/%@/%@/posts",baseUrl,signUp,userId]
#define MYPOSTS_SEARCH_API_URL [NSString stringWithFormat:@"%@/%@/elastic_search",baseUrl,search]
#define UPDATE_POST_API_URL(postId) [NSString stringWithFormat:@"%@/posts/%@",baseUrl,postId]
#define CREATE_POST_API_URL(userId) [NSString stringWithFormat:@"%@/%@/%@/posts",baseUrl,signUp,userId]
#define SCHEDULE_POST_API_URL(userId) [NSString stringWithFormat:@"%@/%@/%@/scheduled-posts",baseUrl,signUp,userId]
#define SEARCH_USER_API_URL [NSString stringWithFormat:@"%@/users/search_by_email",baseUrl]
#define BECOME_USER_API_URL(userId) [NSString stringWithFormat:@"%@/users/%@/become_another_user",baseUrl, userId]
#define ADD_SOCIAL_ACCOUNT_API_URL [NSString stringWithFormat:@"%@/identities/",baseUrl]
#define REMOVE_SOCIAL_ACCOUNT_API_URL(id) [NSString stringWithFormat:@"%@/identities/%@",baseUrl,id]

#define CAMPAIGNS_API_URL(userId) [NSString stringWithFormat:@"%@/users/%@/templates/campaign_list_for_mobile",baseUrl, userId]
#define CAMPAIGNS_DELETE_API_URL(campaignId) [NSString stringWithFormat:@"%@/templates/%@",baseUrl, campaignId]
#define CAMPAIGNS_FOR_POSTS_API_URL [NSString stringWithFormat:@"%@/templates",baseUrl]
#define CAMPAIGN_POSTS_API_URL(campaignName) [NSString stringWithFormat:@"%@/templates/%@",baseUrl,campaignName]
#define CLONE_CAMPAIGN_API_URL(campaignId) [NSString stringWithFormat:@"%@/templates/%@/clones",baseUrl,campaignId]
#define CREATE_CAMPAIGN_API_URL(userId) [NSString stringWithFormat:@"%@/users/%@/templates",baseUrl, userId]
#define IMPORT_FROM_COLLECTIONS_CAMPAIGN_API_URL(campaignId) [NSString stringWithFormat:@"%@/templates/%@/template-posts/import_from_collections",baseUrl,campaignId]

#define UPDATE_CAMPAIGNS_FOR_POSTS_API_URL [NSString stringWithFormat:@"%@/template-posts/bulk_template_post_creation",baseUrl]
#define UPDATE_CAMPAIGN_POST_API_URL(postId) [NSString stringWithFormat:@"%@/template-posts/%@",baseUrl, postId]
#define SCHEDULE_CAMPAING_API_URL(campaignId) [NSString stringWithFormat:@"%@/templates/%@/scheduled-templates",baseUrl,campaignId]
#define REMOVE_POST_FROM_CAMPAIGN_API_URL(postId) [NSString stringWithFormat:@"%@/template-posts/%@",baseUrl, postId]
#define COLLECTIONS_API_URL(userId) [NSString stringWithFormat:@"%@/users/%@/collections",baseUrl, userId]
#define UPDATE_COLLECTIONS_API_URL [NSString stringWithFormat:@"%@/collections/bulk_collection_post_creation",baseUrl]
#define CREATE_COLLECTIONS_API_URL [NSString stringWithFormat:@"%@/collections",baseUrl]
#define COLLECTION_POSTS_API_URL(collectionId) [NSString stringWithFormat:@"%@/collections/%@/posts",baseUrl,collectionId]
#define COLLECTION_API_URL(collectionId) [NSString stringWithFormat:@"%@/collections/%@",baseUrl,collectionId]

#define HEALTH_CHECK_API_URL [NSString stringWithFormat:@"%@/preferences",baseUrl]

#define FETCH_CAMPIGNS_SCHEDULED_POST_API_URL(scheduledId) [NSString stringWithFormat:@"%@/scheduled-templates/%@",baseUrl,scheduledId]
#define FETCH_SCHEDULED_POST_API_URL(userId) [NSString stringWithFormat:@"%@/%@/%@/scheduled-posts",baseUrl,signUp,userId]
#define FETCH_USER_IDENTITIES_API_URL(userId) [NSString stringWithFormat:@"%@/%@/%@/identities",baseUrl,signUp,userId]
#define SCHEDULED_POST_API_URL(postID) [NSString stringWithFormat:@"%@/scheduled-posts/%@",baseUrl,postID]

#define UPDATE_STATUS_SCHEDULED_POST_API_URL(postID) [NSString stringWithFormat:@"%@/scheduled-posts/%@/update_instagram_post_status",baseUrl,postID]
#define FETCH_SEARCH_CATEGORIES [NSString stringWithFormat:@"%@/categories",baseUrl]
#define SEND_NOW_SCHEDULED_POST_API_URL(postID) [NSString stringWithFormat:@"%@/scheduled-posts/%@/send-now",baseUrl,postID]
#define UPDATE_SCHEDULED_POST_API_URL(userId, postID) [NSString stringWithFormat:@"%@/users/%@/scheduled-posts/%@",baseUrl,userId, postID]
#define SIGNOUT [NSString stringWithFormat:@"%@/users/sign_out",baseUrl]
#define FETCH_USER_INFORMATION(userId) [NSString stringWithFormat:@"%@/users/%@",baseUrl,userId]

#define FETCH_GOOGLE_PAGES [NSString stringWithFormat:@"%@/identities/gplus_pages",baseUrl]

//Constants
#define kValue @"value"
#define kName @"name"
#define kfileName @"fileName"
#define kFile_Name @"file_name"

//API Request And Response Keys
#define kUser @"user"
#define kUserIdentities @"UserIdentities"
#define kEmail @"email"
#define kPassword @"password"
#define kUserName @"username"
#define kTimezone @"timezone"
#define kUserId @"user_id"
#define kErrors @"errors"
#define kMessage @"message"
#define kError @"error"
#define kConfirmationToken @"confirmation_token"
#define kPasswordConfirmation @"password_confirmation"
#define kResetPasswordToken @"reset_password_token"
#define kUnlockToken @"unlock_token"
#define kInclude @"include"
#define kCount @"count"
#define kPage @"page"
#define kPerPage @"per_page"
#define kCurrentPage @"current_page"
#define kNextPage @"next_page"
#define kPreviousPage @"prev_page"
#define kData @"data"
#define kMeta @"meta"
#define kId @"id"
#define kType @"type"
#define kPostType @"post_type"
#define kTags @"tags"
#define kLink @"link"
#define kCreatedAt @"created_at"
#define kUpdatedAt @"updated_at"
#define kUserId @"user_id"
#define kCategory @"category"
#define kCategoryId @"category_id"
#define kUrl @"url"
#define kKey @"key"
#define kPhoto @"photo"
#define kTitle @"title"
#define kDescription @"description"
#define kSlug @"slug"
#define kAvatar @"avatar"
#define kPostsCount @"posts_count"
#define kAttachments @"attachments"
#define kQuery @"query"
#define kResults @"results"
#define kHits @"hits"
#define kNbHits @"nbHits"
#define kNbPages @"nbPages"
#define kHitsPerPage @"hitsPerPage"
#define kProcessTimeMS @"processingTimeMS"
#define kExhaustNbHits @"exhaustiveNbHits"
#define kParams @"params"
#define kSchedulePostsCount @"scheduled_posts_count"
#define kObjectId @"objectID"
#define kS3PathExits @"s3_path_exist"
#define kS3PathUrl @"s3_path_url"
#define kLocalImageUrl @"local_image_url"
#define kLocalImageExits @"local_img_exist"
#define kLocalImage @"local_image"
#define kkeyDup @"key_dup"
#define kRowOrderPosition @"row_order_position"
#define kFileName @"filename"
#define kDestroy @"_destroy"
#define kMobileRequest @"mobile_request"
#define kPostTypeMessage @"message"
#define kPostTypePhoto @"photo"
#define kPostTypeMultiPhoto @"multi_photo"
#define kPostTypeLink @"link"
#define kPostTypeVideo @"video"
#endif /* APIConstants_h */
