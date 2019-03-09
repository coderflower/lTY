//
//  NSString-SFExtension.swift
//  CB-Swift
//
//  Created by 花菜 on 2018/4/17.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//

import UIKit



// MARK: - 路径相关
extension String {
    /// 获取caches全路径
    var caches: String {
        return (NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(self)
    }
    /// 获取temp全路径
    var temp: String {
        return (NSTemporaryDirectory() as NSString).appendingPathComponent(self)
    }
    /// 获取doc全路径
    var document: String {
        return (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(self)
    }
    
}

// MARK: - 计算文本矩形框尺寸
extension  String {
    
    /// 根据文本计算其尺寸
    ///
    /// - Parameter font: 文本使用的字体
    /// - Returns: 文本尺寸
    func size(font: UIFont) -> CGSize {
        var size = CGSize.zero
        
        let attributes = [NSAttributedString.Key.font: font]
        size = (self as NSString).size(withAttributes: attributes)
        size.width = CGFloat(ceilf(Float(size.width)))
        size.height = CGFloat(ceilf(Float(size.height)))
        return size
    }
    
    /// 计算文本宽高
    ///
    /// - Parameters:
    ///   - font: 文本所用的字体
    ///   - maxWidth: 最大宽度
    ///   - lineSpace: 行间距
    /// - Returns: 文本的宽高
    func calculateSize(font: UIFont,maxWidth: CGFloat = UIScreen.main.bounds.size.width) -> CGSize {
        let size = CGSize(width: maxWidth, height: CGFloat(MAXFLOAT))
        var textSize = self.asNSString.boundingRect(with: size, options: [.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: font], context: nil
            ).size
        // 将高度取整,否则可能导致多行文字显示不全
        textSize.height = CGFloat(ceilf(Float(textSize.height)))
        return textSize
    }
    /// 调整文字行间距
    func adjustText(_ lineSpacing: CGFloat) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttributes([.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: count))
        return attributedString
    }
    var isContainChinese: Bool {
        for (_, value) in self.enumerated() {
            if ("\u{4E00}" <= value  && value <= "\u{9FA5}") {
                return true
            }
        }
        return false
    }
}

extension String {
    var asNSString: NSString {
        return self as NSString
    }
    func toDictionary() -> NSDictionary? {
        let data = self.data(using: .utf8, allowLossyConversion: true)
        let dic = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
        return dic
    }
    /// 中文转码
    var transformURL: String {
        var charSet = CharacterSet.urlQueryAllowed
        charSet.insert(charactersIn: "#")
        charSet.insert(charactersIn: "%")
        return addingPercentEncoding(withAllowedCharacters: charSet) ?? self
    }
}



// MARK: - 正则
extension String {
    enum ValidatedType {
        case Email
        case PhoneNumber
        case IDCard
    }
    private func validateText(validatedType type: ValidatedType) -> Bool {
        do {
            let pattern: String
            if type == ValidatedType.Email {
                pattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
            }
            else if type == ValidatedType.PhoneNumber {
                pattern = "^1[0-9]{10}$"
            } else {
                pattern = "(^[0-9]{15}$)|([0-9]{17}([0-9]|[0-9a-zA-Z])$)"
            }
            let regex: NSRegularExpression = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let matches = regex.matches(in: self, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, self.count))
            return matches.count > 0
        }
        catch {
            return false
        }
    }
    func emailIsValidated() -> Bool {
        return validateText(validatedType: ValidatedType.Email)
    }
    func phoneNumberIsValidated() -> Bool {
        return validateText(validatedType: ValidatedType.PhoneNumber)
    }
    
    // 隐藏手机敏感信息
    func phoneNumberhideMid() -> String {
        let startIndex = self.index("".startIndex, offsetBy: 4)
        let endIndex = self.index("".startIndex, offsetBy: 7)
        var tmpStr = self
        tmpStr.replaceSubrange(startIndex...endIndex, with: "****")
        return tmpStr
    }
    
    // 隐藏敏感信息
    mutating func numberHideMidWithOtherChar(form: Int, to: Int,char: String) {
        // 判断，防止越界
        var form = form;   var to = to
        if form < 0 {
            form = 0
        }
        if to > self.count {
            to = self.count
        }
        var star = ""
        for _ in form...to {
            star.append(char)
        }
        
        let startIndex = self.index("".startIndex, offsetBy: form)
        let endIndex = self.index("".startIndex, offsetBy: to)
        self.replaceSubrange(startIndex...endIndex, with: star)
    }
}

/// 获取ip地址
extension String {
    
    var ipAddress: String {
        // get list of all interfaces on the local machine
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        guard getifaddrs(&ifaddr) == 0 else {
            return "0.0.0.0"
        }
        guard let firstAddr = ifaddr else {
            return "0.0.0.0"
        }
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            
            let interface = ifptr.pointee
            
            // Check for IPV4 or IPV6 interface
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                // Check interface name
                let name = String(cString: interface.ifa_name)
                if name == "en0" {
                    // Convert interface address to a human readable string
                    var addr = interface.ifa_addr.pointee
                    var hostName = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(&addr,
                                socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostName, socklen_t(hostName.count), nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostName)
                }
            }
        }
        freeifaddrs(ifaddr)
        return address ?? "0.0.0.0"
        
    }
}

extension String {
    /// UUID
    var uuidString: String {
        
        let uuidString = NSUUID().uuidString
        
        return uuidString
    }
    
    func substring(from: Int, to: Int) -> String {
        let fromIndex = index(startIndex, offsetBy: from)
        let toIndex = index(startIndex, offsetBy: to)
        return String(self[fromIndex..<toIndex])
    }
}



// MARK: - 加密  HMAC_SHA1/MD5/SHA1/SHA224......

/**  需在桥接文件导入头文件 ，因为C语言的库
 
 *   #import <CommonCrypto/CommonDigest.h>
 
 *   #import <CommonCrypto/CommonHMAC.h>
 
 */
/*
enum CryptoAlgorithm {
    
    /// 加密的枚举选项
    
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    
    
    var HMACAlgorithm: CCHmacAlgorithm {
        
        var result: Int = 0
        
        switch self {
            
        case .MD5:      result = kCCHmacAlgMD5
            
        case .SHA1:     result = kCCHmacAlgSHA1
            
        case .SHA224:   result = kCCHmacAlgSHA224
            
        case .SHA256:   result = kCCHmacAlgSHA256
            
        case .SHA384:   result = kCCHmacAlgSHA384
            
        case .SHA512:   result = kCCHmacAlgSHA512
            
        }
        
        return CCHmacAlgorithm(result)
        
    }
    
    
    
    var digestLength: Int {
        
        var result: Int32 = 0
        
        switch self {
            
        case .MD5:      result = CC_MD5_DIGEST_LENGTH
            
        case .SHA1:     result = CC_SHA1_DIGEST_LENGTH
            
        case .SHA224:   result = CC_SHA224_DIGEST_LENGTH
            
        case .SHA256:   result = CC_SHA256_DIGEST_LENGTH
            
        case .SHA384:   result = CC_SHA384_DIGEST_LENGTH
            
        case .SHA512:   result = CC_SHA512_DIGEST_LENGTH
            
        }
        
        return Int(result)
        
    }
    
}

*/

extension String {
    
    /*
     
     *   func：加密方法
     
     *   参数1：加密方式； 参数2：加密的key
     
     */
    /*
    func hmac(algorithm: CryptoAlgorithm, key: String) -> String {
        
        let str = self.cString(using: String.Encoding.utf8)
        
        let strLen = Int(self.lengthOfBytes(using: String.Encoding.utf8))
        
        let digestLen = algorithm.digestLength
        
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        let keyStr = key.cString(using: String.Encoding.utf8)
        
        let keyLen = Int(key.lengthOfBytes(using: String.Encoding.utf8))
        
        CCHmac(algorithm.HMACAlgorithm,  str!, strLen, keyStr!, keyLen, result)
        
        
        
        let digest = stringFromResult(result:  result, length: digestLen)
        
//        result.deallocate(capacity: digestLen)
        free(result)
        
        return digest
        
    }
    
    
    
    private func stringFromResult(result: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String {
        
        let hash = NSMutableString()
        
        for i in 0..<length {
            
            hash.appendFormat("%02x", result[i])
            
        }
        
        return String(hash)
        
    }
    */
}






