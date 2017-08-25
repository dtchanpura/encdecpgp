//
//  CryptoUtils.swift
//  encdecpgp
//
//  Created by Darshil Chanpura on 19/08/17.
//  Copyright © 2017 Darshil Chanpura. All rights reserved.
//

import Foundation
import os.log
import ObjectivePGP


class CryptoUtils {
    
    static let pgp:ObjectivePGP = ObjectivePGP()
    static func encryptTextTo(_ text: String, keyId: String) -> String {
        //        let url:URL? = URL(string: "https://stackoverflow.com")
        //        let task = URLSession.shared.dataTask(with: url!) {
        //            (data, response, error) in
        
        //            print("\(data?.base64EncodedString() ?? "error occured")")
        //        }
        //        task.resume()
        //        guard let secretKeyURL = Bundle.main.url(forResource: "testing.sec", withExtension: "asc"),
        //            let secretKeyData = try? Data(contentsOf: secretKeyURL),
        //            let publicKeyURL = Bundle.main.url(forResource: "testing.pub", withExtension: "asc"),
        //            let publicKeyData = try? Data(contentsOf: publicKeyURL) else { fatalError("Can't find key file") }
        //        print(secretKeyData, publicKeyData)
        return text + keyId
    }
    
    static func initializeKeyringFromFile() {
        pgp.importKeys(fromFile: "\(NSHomeDirectory())/pubring.pgp")
        pgp.importKeys(fromFile: "\(NSHomeDirectory())/secring.pgp")
    }
    static func getPublicKeys () -> [KeyDetail] {
        var keyDetails:[KeyDetail] = []
        for key in pgp.keys {
            var keyType:KeyType = KeyType.publicKey
            if key.isSecret {
             keyType = KeyType.secretKey
            } else if key.isSecret && key.isPublic {
                keyType = KeyType.secretAndPublicKey
            }
//            let pgpPacket0:PGPUserIDPacket? = key.publicKey?.allKeyPackets()[0].tag.rawValue as? PGPUserIDPacket
//            let pgpPacket1:PGPUserIDPacket? = key.publicKey?.allKeyPackets()[1] as? PGPUserIDPacket
            
//            print(pgpPacket0 ?? "error 0")
//            print(pgpPacket1 ?? "error 1")
            
//            print(key)
            
            keyDetails.append(KeyDetail(pgpKey: key, keyId: key.keyID.longKeyString, keyType: keyType )!)
        }
        return keyDetails
    }

    // Not used
    static func addKey(_ keyName:String, keyText: String) -> Bool {
        pgp.importKeys(from: Data(base64Encoded: keyText)!)
        try? pgp.exportKeys(of: PGPPartialKeyType.secret, toFile: "\(NSHomeDirectory())/secring.pgp")
        try? pgp.exportKeys(of: PGPPartialKeyType.public, toFile: "\(NSHomeDirectory())/pubring.pgp")
        return true;
    }
    
    static func getKeyDetails(_ keyString: String) -> [KeyDetail] {
        
        var keyDetails:[KeyDetail] = []
        for pgpKey in pgp.importKeys(from: Data(base64Encoded: keyString)!) {
            os_log("added key" , log: OSLog.default, type: .debug)
            keyDetails.append(KeyDetail(pgpKey: pgpKey)!)
        }
        return keyDetails
    }
    static func flushKeys() {
        try? pgp.exportKeys(of: PGPPartialKeyType.secret, toFile: "\(NSHomeDirectory())/secring.pgp")
        try? pgp.exportKeys(of: PGPPartialKeyType.public, toFile: "\(NSHomeDirectory())/pubring.pgp")
    }
}
