//
//  Enums.h
//  TinyTorch
//
//  Created by Basawaraj on 29/03/17.
//  Copyright © 2017 TinyTorch. All rights reserved.
//

#ifndef Enums_h
#define Enums_h
#import <UIKit/UIKit.h>

//Enums
typedef enum {
    ForgotPassword,
    ConfirmAccount,
    UnlockAccount
} HelpOptions;

typedef enum {
    Message,
    Photo,
    MultiPhoto,
    Link,
    Video
} PostType;


typedef enum {
    Profile,
    Page,
    Event,
    Group
} ProviderType;

#endif /* Enums_h */
