# PGP Keys Storage with Encryption and Decryption for iOS

## Dependencies

* [ObjectivePGP](https://github.com/krzyzanowskim/ObjectivePGP)


## Future Work

* Add Navigation
  * key management
    * import from file sharing using iTunes (not possible locally)
    * import from URL (only for public keys)
    * ~~import from Text input~~ Done.
  * encrypting + signing content
  * decrypting content
* password field for decryption and signing

## Building

* Install dependencies
```bash
pod install
```
* Open `encdecpgp.xcworkspace` using Xcode in this same folder


## References

* [Start Developing iOS Apps (Swift)](https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/)
