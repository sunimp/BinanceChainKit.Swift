//
//  Balance.swift
//  BinanceChainKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import GRDB

// MARK: - Balance

class Balance: Record {
    let symbol: String
    var amount: Decimal

    init(symbol: String, amount: Decimal) {
        self.symbol = symbol
        self.amount = amount

        super.init()
    }

    override class var databaseTableName: String {
        "balances"
    }

    enum Columns: String, ColumnExpression {
        case amount
        case symbol
    }

    required init(row: Row) throws {
        symbol = row[Columns.symbol]
        amount = row[Columns.amount]

        try super.init(row: row)
    }

    override func encode(to container: inout PersistenceContainer) throws {
        container[Columns.symbol] = symbol
        container[Columns.amount] = amount
    }

}

// MARK: CustomStringConvertible

extension Balance: CustomStringConvertible {

    public var description: String {
        "BALANCE: [symbol: \(symbol); amount: \(amount)]"
    }

}
