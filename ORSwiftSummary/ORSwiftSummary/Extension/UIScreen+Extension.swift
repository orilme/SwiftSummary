//
//  UIScreen+Extension.swift
//  UAgent
//
//  Created by TY on 2019/3/17.
//  Copyright © 2019 com.yjyz.www. All rights reserved.
//

import UIKit

extension UIScreen{
    // iOS11安全区域顶部
    static let SafeAreaInsetsTop:CGFloat = UIDevice.ISIPHONE_X() ? 44 : 20
    
    static let WIDTH : CGFloat = UIScreen.main.bounds.size.width
    static let HEIGHT : CGFloat = UIScreen.main.bounds.size.height
    static let NAVHEIGHT:CGFloat = (UIDevice.ISIPHONE_X() ? 64.0 + 24.0 : 64.0)
    static let IPHONXSafeTop:CGFloat = (UIDevice.ISIPHONE_X() ? 24 : 0)
    static let IPHONXSafeBottom:CGFloat = (UIDevice.ISIPHONE_X() ? 34 : 0)

    /// 宽度比
    static let kScalWidth = (WIDTH / 375)
    /// 高度比
    static let kScalHeight = (HEIGHT / 667)


    /// 键盘顺位正则
    static let keyboardSequence1 = "(qwe|ewq|wer|rew|ert|tre|rty|ytr|tyu|uyt|yui|iuy|uio|oiu|iop|poi)|(asd|dsa|sdf|fds|dfg|gfd|fgh|hgf|ghj|jhg|hjk|kjh|jkl|lkj)|(zxc|cxz|xcv|vcx|cvb|bvc|vbn|nbv|bnm|mnb)"

    /// 字母、数字、符号正则
    static let letterNumberSymbolic = "(([a-z]|[A-Z])[0-9][`~!@#$%^&*()_\\-+=<>?:\"{}|,.\\/;'\\[\\]·~！@#￥%……&*（）——\\-+={}|《》？：“”【】、；‘’，。、])"

    /// 大小写字母、数字、符号正则
    static let bigSmallLetterNumberSymbolic = "([A-Z][a-z][0-9][`~!@#$%^&*()_\\-+=<>?:\"{}|,.\\/;'\\[\\]·~！@#￥%……&*（）——\\-+={}|《》？：“”【】、；‘’，。、])"

    /// 炸开字母|数字|符号
    static let boom = "[0-9]+|[a-z]+|[A-Z]+|[^0-9a-zA-Z]+"
    static let letterSequence = "(abc|cba|bcd|dcb|cde|edc|def|fed|efg|gfe|fgh|hgf|ghi|ihg|hij|jih|ijk|kji|jkl|lkj|klm|mlk|lmn|nml|mno|onm|nop|pon|opq|qpo|pqr|rqp|qrs|srq|rst|tsr|stu|uts|tuv|vut|uvw|wvu|vwx|xwv|wxy|yxw|xyz|zyx)|(ABC|CBA|BCD|DCB|CDE|EDC|DEF|FED|EFG|GEF|FGH|HGF|GHI|IHG|HIJ|JIH|IJK|KJI|JKL|LKJ|KLM|MLK|LMN|NML|MNO|ONM|NOP|PON|OPQ|QPO|PQR|RQP|QRS|SRQ|RST|TSR|STU|UTS|TUV|VUT|UVW|WVU|VWX|XWV|WXY|YXW|XYZ|ZYX)"

    
    static let numberRegular = "[0-9]"

    static let letter = "[a-zA-Z]"

    static let smallLetter = ".*[a-z]+.*"

    static let bigLetter = ".*[A-Z]+.*"

    static let bigSmallLetter = "[A-Z][a-z]|[a-z][A-Z]"

    static let repeatStr = "([0-9a-zA-Z])\\1{2}"

    static let symbol = "[^0-9a-zA-Z]"

    /// 数字正则
    static let number = "(012|210|123|321|234|432|345|543|456|654|567|765|678|876|789|987|098)"
}
