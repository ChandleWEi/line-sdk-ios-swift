//
//  LoginConfiguration.swift
//
//  Copyright (c) 2016-present, LINE Corporation. All rights reserved.
//
//  You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
//  copy and distribute this software in source code or binary form for use
//  in connection with the web services and APIs provided by LINE Corporation.
//
//  As with any software that integrates with the LINE Corporation platform, your use of this software
//  is subject to the LINE Developers Agreement [http://terms2.line.me/LINE_Developers_Agreement].
//  This copyright notice shall be included in all copies or substantial portions of the software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
//  DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Foundation

struct LoginConfiguration {
    let channelID: String
    let universalLinkURL: URL?
    
    init(channelID: String, universalLinkURL: URL?) {
        self.channelID = channelID
        
        if let url = universalLinkURL, url.scheme?.lowercased() != "https" {
            Log.assertionFailure("Universal link is required to start with https scheme.")
        }
        
        self.universalLinkURL = universalLinkURL
    }
    
    let APIHost = Constant.APIHost
    
    func isValidCustomizeURL(url: URL) -> Bool {
        guard let scheme = url.scheme else {
            return false
        }
        guard scheme.lowercased() == Constant.thirdPartyAppRetrurnScheme.lowercased() else {
            return false
        }
        guard url.host?.lowercased() == "authorize" else {
            return false
        }
        return true
    }
    
    func isValidUniversalLinkURL(url: URL) -> Bool {
        
        guard let setURL = universalLinkURL else {
            return false
        }
        
        guard let setComponents = URLComponents(url: setURL, resolvingAgainstBaseURL: false),
              let receivedComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else
        {
            return false
        }
        
        guard setComponents.scheme?.lowercased() == "https",
              receivedComponents.scheme?.lowercased() == "https" else
        {
            return false
        }
        
        guard setComponents.host?.lowercased() == receivedComponents.host?.lowercased() else {
            return false
        }
        
        guard setComponents.path.lowercased() == receivedComponents.path.lowercased() else {
            return false
        }
        
        return true
    }
    
    func isValidSourceApplication(appID: String) -> Bool {
        var validPrefixes = ["jp.naver", "com.apple"]
        if let currentAppID = Bundle.main.bundleIdentifier {
            validPrefixes.append(currentAppID)
        }
        
        let valid = validPrefixes.contains { appID.hasPrefix($0) }
        return valid
    }
}