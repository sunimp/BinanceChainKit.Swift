//
//  BinanceAddressValidator.swift
//  BinanceChainKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

public class BinanceAddressValidator {
    private let segWitBech32: SegWitBech32

    public init(prefix: String) {
        segWitBech32 = SegWitBech32(hrp: prefix)
    }

    public func validate(address: String) throws {
        try _ = segWitBech32.decode(addr: address)
    }

}
