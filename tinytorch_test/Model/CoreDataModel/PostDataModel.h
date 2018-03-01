//
//  PostDataModel.h
//  tinytorch_test
//
//  Created by Alok Desai on 28/02/18.
//  Copyright © 2018 Cuelogic. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface PostDataModel : NSManagedObject

@property (nonatomic, retain) NSString *postId;
@property (nonatomic, retain) NSString *postType;
@property (nonatomic, retain) NSString *postAttachment;
@property (nonatomic, retain) NSString *postMessage;

@end
