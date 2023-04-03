//
//  ClientAuthorizationService.swift
//  Runner
//

import Foundation
import PomeloNetworking

class ClientAuthorizationService: PomeloAuthorizationServiceProtocol {
    
    var clientToken: String?
    
    func getValidToken(completionHandler: @escaping (String?) -> Void) {
        let session = URLSession.shared
        guard let urlRequest = buildRequest(email: Constants.email) else {
            print("\(String.userTokenError) cannot build request")
            completionHandler(nil)
            return
        }
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("\(String.userTokenError) \(error)")
                completionHandler(nil)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let dto = try decoder.decode(PomeloAccessTokenDTO.self, from: data!)
                completionHandler(dto.accessToken)
            } catch {
                print("\(String.userTokenError) \(error.localizedDescription)")
                completionHandler(nil)
            }
        }
        task.resume()
    }
    
    private func buildRequest(email: String) -> URLRequest? {
        let url = URL(string: Constants.endPoint)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"

        let body = [
            String.BodyParams.email: "\(email)"
        ]
        
        do {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = .withoutEscapingSlashes
            urlRequest.httpBody = try jsonEncoder.encode(body)
        } catch {
            print(error.localizedDescription)
            return nil
        }
        
        urlRequest.setValue("application/json", forHTTPHeaderField: String.AuthHeaders.contentType)
        return urlRequest
    }
}

fileprivate extension String {
    static let userTokenError = "Cards Sample App error!🔥 - EndUserTokenService: "

    struct AuthHeaders {
        static let contentType = "Content-Type"
    }
    
    struct BodyParams {
        static let userId = "user_id"
        static let email = "email"
    }
}
