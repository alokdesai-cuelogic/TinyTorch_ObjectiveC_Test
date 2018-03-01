//
//  MyPostResponse.m
//  tinytorch_test
//
//  Created by Alok Desai on 22/02/18.
//  Copyright © 2018 Cuelogic. All rights reserved.
//

#import "MyPostResponse.h"

@implementation LinkInfo

@end

@implementation UserInfo

@end

@implementation CategoryInfo

@end

@implementation AttachmentInfo
- (UIImage *) getAttachmentImage {
    return [UIImage imageWithData:_attachmentData];
}
@end

@implementation PostsMetaData

@end

@implementation PostsData
- (NSString *) getDisplayImage {
    NSString *postAttachmentURL = self.postType == Link ? self.postLink.linkPhoto: (self.postAttachments && self.postAttachments.count > 0 ? ((AttachmentInfo*)self.postAttachments[0]).attachmentUrl : @"");
    if (self.postType == Video) {
        postAttachmentURL = ((AttachmentInfo*)self.postAttachments[0]).thumbUrl;
    }
    return [postAttachmentURL isEqualToString:@""] ? nil : postAttachmentURL;
}

@end

@implementation MyPostResponse

@end
