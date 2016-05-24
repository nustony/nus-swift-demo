//
//  PTKCardType.h
//  PTKPayment Example
//
//  Created by Alex MacCaw on 1/22/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//
//#define PTKCardType_h
//typedef enum {
//    PTKCardTypeVisa,
//    PTKCardTypeMasterCard,
//    PTKCardTypeAmex,
//    PTKCardTypeDiscover,
//    PTKCardTypeJCB,
//    PTKCardTypeDinersClub,
//    PTKCardTypeUnknown
//} PTKCardType;
enum PTKCardType : Int {
    case Visa
    case MasterCard
    case Amex
    case Discover
    case JCB
    case DinersClub
    case Unknown
}