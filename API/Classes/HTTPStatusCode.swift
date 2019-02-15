//
//  HTTPStatusCode.swift
//  RxToolkit
//
//  Created by Martin Daum on 10.07.18.
//

import Foundation

public enum HTTPStatusCode: Int {
    case unknown = 0
    case `continue` = 100
    case switchingProtocols = 101
    case processing = 102
    case checkpoint = 103
    case ok = 200
    case created = 201
    case accepted = 202
    case nonAuthoritativeInformation = 203
    case noContent = 204
    case resetContent = 205
    case partialContent = 206
    case multiStatus = 207
    case alreadyReported = 208
    case imUsed = 226
    case multipleChoices = 300
    case movedPermanently = 301
    case found = 302
    case seeOther = 303
    case notModified = 304
    case useProxy = 305
    case temporaryRedirect = 307
    case permanentRedirect = 308
    case badRequest = 400
    case unauthorized = 401
    case paymentRequired = 402
    case forbidden = 403
    case notFound = 404
    case methodNotAllowed = 405
    case notAcceptable = 406
    case proxyAuthenticationRequired = 407
    case requestTimeout = 408
    case conflict = 409
    case gone = 410
    case lengthRequired = 411
    case preconditionFailed = 412
    case payloadTooLarge = 413
    case uriTooLong = 414
    case unsupportedMediaType = 415
    case rangeNotSatisfiable = 416
    case expectationFailed = 417
    case imATeapot = 418
    case misdirectedRequest = 421
    case unprocessableEntity = 422
    case locked = 423
    case failedDependency = 424
    case upgradeRequired = 426
    case preconditionRequired = 428
    case tooManyRequests = 429
    case requestHeaderFieldsTooLarge = 431
    case iisLoginTimeout = 440
    case nginxNoResponse = 444
    case iisRetryWith = 449
    case blockedByWindowsParentalControls = 450
    case unavailableForLegalReasons = 451
    case nginxSSLCertificateError = 495
    case nginxSSLCertificateRequired = 496
    case nginxHTTPToHTTPS = 497
    case tokenExpired = 498
    case nginxClientClosedRequest = 499
    case internalServerError = 500
    case notImplemented = 501
    case badGateway = 502
    case serviceUnavailable = 503
    case gatewayTimeout = 504
    case httpVersionNotSupported = 505
    case variantAlsoNegotiates = 506
    case insufficientStorage = 507
    case loopDetected = 508
    case bandwidthLimitExceeded = 509
    case notExtended = 510
    case networkAuthenticationRequired = 511
    case siteIsFrozen = 530
}

public extension HTTPStatusCode {
    public var isInformational: Bool {
        return isIn(range: 100...199)
    }
    
    public var isSuccess: Bool {
        return isIn(range: 200...299)
    }
    
    public var isRedirection: Bool {
        return isIn(range: 300...399)
    }
    
    public var isClientError: Bool {
        return isIn(range: 400...499)
    }
    
    public var isServerError: Bool {
        return isIn(range: 500...599)
    }
    
    private func isIn(range: ClosedRange<HTTPStatusCode.RawValue>) -> Bool {
        return range.contains(rawValue)
    }
}

public extension HTTPStatusCode {
    public var localizedReasonPhrase: String {
        return HTTPURLResponse.localizedString(forStatusCode: rawValue)
    }
}

// MARK: - Printing

extension HTTPStatusCode: CustomDebugStringConvertible, CustomStringConvertible {
    public var description: String {
        if isSuccess {
            return "\(rawValue)"
        }
        return "\(rawValue) - \(localizedReasonPhrase)"
    }
    public var debugDescription: String {
        return "HTTPStatusCode:\(description)"
    }
}

// MARK: - HTTP URL Response

public extension HTTPStatusCode {
    public init(response: HTTPURLResponse?) {
        guard let response = response else {
            self = .unknown
            return
        }
        self = HTTPStatusCode(rawValue: response.statusCode) ?? .unknown
    }
    
    private init(_ rawValue: Int) {
        self = HTTPStatusCode(rawValue: rawValue) ?? .unknown
    }
}

public extension HTTPURLResponse {
    public var httpStatusCode: HTTPStatusCode {
        return HTTPStatusCode(response: self)
    }
}
