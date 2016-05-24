//
//  STPAPIConnection.h
//  Stripe
//
//  Created by Phil Cohen on 4/9/14.
//
import Foundation
typealias APIConnectionCompletionBlock = (response: NSURLResponse, body: NSData, requestError: NSError) -> Void
// Like NSURLConnection but verifies that the server isn't using a revoked certificate.
class STPAPIConnection: NSObject {
    convenience override init(request: NSURLRequest) {
        super.init()
        self.request = request
            self.connection = NSURLConnection(request: request, delegate: self, startImmediately: false)
            self.receivedData = NSMutableData()
            ///[NSMutableData data];
    }

    func runOnOperationQueue(queue: NSOperationQueue, completion handler: APIConnectionCompletionBlock) {
        if self.started {
            NSException.raise("OperationNotPermitted", format: "This API connection has already started.")
        }
        if !queue {
            NSException.raise("RequiredParameter", format: "'queue' is required")
        }
        if !handler {
            NSException.raise("RequiredParameter", format: "'handler' is required")
        }
        self.started = true
        self.completionBlock = handler.copy()
        self.connection.delegateQueue = queue
        self.connection.start()
    }

    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        self.receivedResponse = response
    }

    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        self.receivedData.appendData(data)
    }

    func connectionDidFinishLoading(connection: NSURLConnection) {
        self.connection = nil
        self.completionBlock(self.receivedResponse, self.receivedData, nil)
        self.receivedData = nil
        self.receivedResponse = nil
    }

    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        if self.overrideError {
            error = self.overrideError
        }
        self.connection = nil
        self.receivedData = nil
        self.receivedResponse = nil
        self.completionBlock(self.receivedResponse, self.receivedData, error!)
    }

    func connection(connection: NSURLConnection, willSendRequestForAuthenticationChallenge challenge: NSURLAuthenticationChallenge) {
        if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
            var serverTrust: SecTrustRef = challenge.protectionSpace().serverTrust()
                var resultType: SecTrustResultType
            SecTrustEvaluate(serverTrust, resultType)
            // Check for revocation manually since CFNetworking doesn't. (see https://revoked.stripe.com for more)
            for var i = 0, count = SecTrustGetCertificateCount(serverTrust); i < count; i++ {
                if self.self.isCertificateBlacklisted(SecTrustGetCertificateAtIndex(serverTrust, i)) {
                    self.overrideError = self.self.blacklistedCertificateError()
                    challenge.sender.cancelAuthenticationChallenge(challenge)
                    return
                }
            }
            challenge.sender.performDefaultHandlingForAuthenticationChallenge(challenge)
        }
        else if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodDefault) {
            // If this is an HTTP Authorization request, just continue. We want to bubble this back through the
            // request's error handler.
            challenge.sender.continueWithoutCredentialForAuthenticationChallenge(challenge)
        }
        else {
            challenge.sender.performDefaultHandlingForAuthenticationChallenge(challenge)
        }

    }

    class func certificateBlacklist() -> [AnyObject] {
        return ["05c0b3643694470a888c6e7feb5c9e24e823dc53",         // api.stripe.com
"5b7dc7fbc98d78bf76d4d4fa6f597a0c901fad5c"]
    }

    class func isCertificateBlacklisted(certificate: SecCertificateRef) -> Bool {
        return self.certificateBlacklist().containsObject(self.SHA1FingerprintOfCertificateData(certificate))
    }

    class func SHA1FingerprintOfCertificateData(certificate: SecCertificateRef) -> String {
        var data: CFDataRef = SecCertificateCopyData(certificate)
        var fingerprint: String = self.SHA1FingerprintOfData((data as! NSData))
        CFRelease(data)
        return fingerprint
    }

    class func SHA1FingerprintOfData(data: NSData) -> String {
        var digest: UInt8
            // Convert the NSData into a C buffer.
        var cData = malloc(data.characters.count)
        data.getBytes(cData, length: data.characters.count)
        CC_SHA1(cData, (data.length as! CC_LONG), digest)
            // Convert to NSString.
        var output: NSMutableString = NSMutableString(capacity: CC_SHA1_DIGEST_LENGTH * 2)
        for var i = 0; i < CC_SHA1_DIGEST_LENGTH; i++ {
            output.appendFormat("%02x", digest[i])
        }
        free(cData)
        return output.lowercaseString
    }

    class func blacklistedCertificateError() -> NSError {
        return NSError(domain: StripeDomain, code: STPConnectionError, userInfo: [NSLocalizedDescriptionKey: STPUnexpectedError, STPErrorMessageKey: "Invalid server certificate. You tried to connect to a server " + 
            "that has a revoked SSL certificate, which means we cannot securely send data to that server. " + 
            "Please email support@stripe.com if you need help connecting to the correct API server."])
    }

    var started: Bool
    var request: NSURLRequest
    var connection: NSURLConnection {
        get {
            self.receivedResponse = response
        }
    }

    var receivedData: NSMutableData
    var receivedResponse: NSURLResponse
    var overrideError: NSError
    // Replaces the request's error
    var completionBlock: APIConnectionCompletionBlock
}
//
//  STPAPIConnection.m
//  Stripe
//
//  Created by Phil Cohen on 4/9/14.
//
import CommonCrypto