//
//  PostCollectionViewCell.h
//  tinytorch_test
//
//  Created by Alok Desai on 22/02/18.
//  Copyright © 2018 Cuelogic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UIImageView *postTypeImage;
@property (weak, nonatomic) IBOutlet UILabel *postMessage;



@end
