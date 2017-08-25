//
//  KeyDetail.swift
//  Pods
//
//  Created by Darshil Chanpura on 24/08/17.
//
//

import Foundation
import UIKit
import ObjectivePGP
import os.log


enum KeyType {
    case secretKey
    case publicKey
    case secretAndPublicKey
}

struct PropertyKey {
    static let pgpKey = "pgpKey"
    static let keyUsers = "keyUsers"
    static let keyId = "keyId"
    static let keyType = "keyType"
}

class KeyDetail: NSObject, NSCoding {
    //MARK: External Objects
    static let pgp:ObjectivePGP = ObjectivePGP()

    
    //MARK: Properties
    var pgpKey: PGPKey
    var keyUsers: [PGPUser]
    var keyId: String
    var keyType: KeyType?
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("keyring")
    
    //MARK: Static Methods
    
    
    
    //MARK: Initialization

    
    required convenience init?(coder aDecoder: NSCoder) {

        guard let pgpKeyData = aDecoder.decodeObject(forKey: PropertyKey.pgpKey) as? Data else {
            os_log("Error while decoding pgpKey.", log: OSLog.default, type: .error)
            return nil
        }
        let keys = KeyDetail.pgp.importKeys(from: pgpKeyData)
        
        self.init(pgpKey: keys.first!)
    }
    
    required convenience init?(pgpKeyData: Data) {
        guard let pgpKey:PGPKey = KeyDetail.pgp.importKeys(from: pgpKeyData).first else {
            return nil
        }
        self.init(pgpKey: pgpKey)
    }

    init?(pgpKey: PGPKey, keyId: String, keyType: KeyType?) {

        self.pgpKey = pgpKey
        self.keyId = keyId
        self.keyUsers = []

        if pgpKey.isPublic {
            self.keyType = KeyType.publicKey
            self.keyUsers += (pgpKey.publicKey?.users)!
        } else if pgpKey.isSecret {
            self.keyType = KeyType.secretKey
            self.keyUsers += (pgpKey.secretKey?.users)!
        }

        if(keyType == nil) {
            self.keyType = KeyType.publicKey
        } else {
            self.keyType = keyType
        }

    }
    init?(pgpKey: PGPKey) {
        self.pgpKey = pgpKey
        self.keyUsers = []
        if pgpKey.isPublic {
            self.keyType = KeyType.publicKey
            self.keyUsers += (pgpKey.publicKey?.users)!
        } else if pgpKey.isSecret {
            self.keyType = KeyType.secretKey
            self.keyUsers += (pgpKey.secretKey?.users)!
        }
        self.keyId = pgpKey.keyID.longKeyString
        
    }

    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        try! aCoder.encode(pgpKey.export(), forKey: PropertyKey.pgpKey)
//        aCoder.encode(keyUsers, forKey: PropertyKey.keyUsers)
//        aCoder.encode(keyId, forKey: PropertyKey.keyId)
//        aCoder.encode(keyType, forKey: PropertyKey.keyType)
    }
    
    
    
}
