//
//  PostTokenExchangeRequestTests.swift
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

import XCTest
@testable import LineSDK

extension PostTokenExchangeRequest: ResponseDataStub {
    
    static let successToken = "123"
    
    static let success: String =
    """
    {
        "access_token":"\(successToken)",
        "refresh_token":"abc",
        "token_type":"Bearer",
        "scope":"profile openid",
        "id_token": "hello",
        "expires_in":2592000
    }
    """
}

class PostTokenExchangeRequestTests: XCTestCase {

    let config = LoginConfiguration(channelID: "123", universalLinkURL: nil)
    
    func testSuccess() {
        let expect = expectation(description: "\(#file)_\(#line)")
        let session = Session.stub(configuration: config, string: PostTokenExchangeRequest.success)
        
        let request = PostTokenExchangeRequest(
            channelID: config.channelID,
            code: "abcabc",
            otpValue: "123123",
            redirectURI: "urlurl")
        
        session.send(request) { result in
            let token = result.value!
            XCTAssertEqual(token.value, "123")
            XCTAssertEqual(token.refreshToken, "abc")
            XCTAssertEqual(token.tokenType, "Bearer")
            XCTAssertEqual(token.permissions, [LoginPermission.profile, LoginPermission.openID])
            XCTAssertEqual(token.expiresAt, token.createdAt.addingTimeInterval(token.expiresIn))
            XCTAssertEqual(token.IDToken, "hello")
            
            expect.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
