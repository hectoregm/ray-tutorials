//
//  Level.swift
//  CookieCrunch
//
//  Created by Hector Enrique Gomez Morales on 7/15/14.
//  Copyright (c) 2014 Hector Enrique Gomez Morales. All rights reserved.
//

import Foundation

let NumColumns = 9
let NumRows = 9

class Level {
    let cookies = Array2D<Cookie>(columns: NumColumns, rows: NumRows) // private
    let tiles = Array2D<Tile>(columns: NumColumns, rows: NumRows) //private
    var possibleSwaps = Set<Swap>() // private
    let targetScore: Int!
    let maximumMoves: Int!
    
    init(filename: String) {
        if let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle(filename) {
            if let tilesArray: AnyObject = dictionary["tiles"] {
                for (row, rowArray) in enumerate(tilesArray as [[Int]]) {
                    let tileRow = NumRows - row - 1
                    
                    for (column, value) in enumerate(rowArray) {
                        if value == 1 {
                            tiles[column, tileRow] = Tile()
                        }
                    }
                }
                targetScore = (dictionary["targetScore"] as NSNumber).integerValue
                maximumMoves = (dictionary["moves"] as NSNumber).integerValue
            }
        }
    }
    
    func cookieAtColumn(column: Int, row: Int) -> Cookie? {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return cookies[column, row]
    }
    
    func tileAtColumn(column: Int, row: Int) -> Tile? {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return tiles[column, row]
    }
    
    func shuffle() -> Set<Cookie> {
        var set: Set<Cookie>
        do {
            set = createInitialCookies()
            detectPossibleSwaps()
            println("possible swaps: \(possibleSwaps)")
        } while possibleSwaps.count == 0
        return set
    }
    
    func createInitialCookies() -> Set<Cookie> {
        var set = Set<Cookie>()
        
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                if tiles[column, row] {
                    var cookieType: CookieType
                    do {
                        cookieType = CookieType.random()
                    } while (column >= 2 &&
                        cookies[column - 1, row]?.cookieType == cookieType &&
                        cookies[column - 2, row]?.cookieType == cookieType)
                        || (row >= 2 &&
                            cookies[column, row - 1]?.cookieType == cookieType &&
                            cookies[column, row - 2]?.cookieType == cookieType)
                
                    let cookie = Cookie(column: column, row: row, cookieType: cookieType)
                    cookies[column, row] = cookie
                
                    set.addElement(cookie)
                }
            }
        }
        
        return set
    }
    
    func performSwap(swap: Swap) {
        let columnA = swap.cookieA.column
        let rowA = swap.cookieA.row
        let columnB = swap.cookieB.column
        let rowB = swap.cookieB.row
        
        cookies[columnA, rowA] = swap.cookieB
        swap.cookieB.column = columnA
        swap.cookieB.row = rowA
        
        cookies[columnB, rowB] = swap.cookieA
        swap.cookieA.column = columnB
        swap.cookieA.row = rowB
    }
    
    func hasChainAtColumn(column: Int, row: Int) -> Bool {
        let cookieType = cookies[column, row]!.cookieType
        
        var horzLength = 1
        for var i = column - 1; i >= 0 && cookies[i, row]?.cookieType == cookieType;
            --i, ++horzLength { }
        for var i = column + 1; i < NumColumns && cookies[i, row]?.cookieType == cookieType;
            ++i, ++horzLength { }
        if horzLength >= 3 { return true }
        
        var vertLength = 1
        for var i = row - 1; i >= 0 && cookies[column, i]?.cookieType == cookieType;
            --i, ++vertLength { }
        for var i = row + 1; i < NumRows && cookies[column, i]?.cookieType == cookieType;
            ++i, ++vertLength { }
        return vertLength >= 3
    }
    
    func detectPossibleSwaps() {
        var set = Set<Swap>()
        
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                if let cookie = cookies[column, row] {
                    if column < NumColumns - 1 {
                        if let other = cookies[column + 1, row] {
                            cookies[column, row] = other
                            cookies[column + 1, row] = cookie
                            
                            if hasChainAtColumn(column + 1, row: row) ||
                                hasChainAtColumn(column, row: row) {
                                set.addElement(Swap(cookieA: cookie, cookieB: other))
                            }
                            
                            cookies[column,row] = cookie
                            cookies[column + 1, row] = other
                        }
                    }
                    
                    if row < NumRows - 1 {
                        if let other = cookies[column, row + 1] {
                            cookies[column, row] = other
                            cookies[column, row + 1] = cookie
                            
                            // Is either cookie now part of a chain?
                            if hasChainAtColumn(column, row: row + 1) ||
                                hasChainAtColumn(column, row: row) {
                                    set.addElement(Swap(cookieA: cookie, cookieB: other))
                            }
                            
                            // Swap them back
                            cookies[column, row] = cookie
                            cookies[column, row + 1] = other
                        }
                    }
                }
            }
        }
        
        possibleSwaps = set
    }
    
    func isPossibleSwap(swap: Swap) -> Bool {
        return possibleSwaps.containsElement(swap)
    }
    
    func detectHorizontalMatches() -> Set<Chain> {
        let set = Set<Chain>()
        
        for row in 0..<NumRows {
            for var column = 0; column < NumColumns - 2; {
                if let cookie = cookies[column, row] {
                    let matchType = cookie.cookieType
                    
                    if cookies[column + 1, row]?.cookieType == matchType &&
                       cookies[column + 2, row]?.cookieType == matchType {
                        let chain = Chain(chainType: .Horizontal)
                        do {
                            chain.addCookie(cookies[column, row]!)
                            ++column
                        } while column < NumColumns && cookies[column, row]?.cookieType == matchType
                        
                        set.addElement(chain)
                        continue
                    }
                }
                ++column
            }
        }
        return set
    }
    
    func detectVerticalMatches() -> Set<Chain> {
        let set = Set<Chain>()
        
        for column in 0..<NumColumns {
            for var row = 0; row < NumRows - 2; {
                if let cookie = cookies[column, row] {
                    let matchType = cookie.cookieType
                    
                    if cookies[column, row + 1]?.cookieType == matchType &&
                        cookies[column, row + 2]?.cookieType == matchType {
                            
                            let chain = Chain(chainType: .Vertical)
                            do {
                                chain.addCookie(cookies[column, row]!)
                                ++row
                            } while row < NumRows && cookies[column, row]?.cookieType == matchType
                            
                            set.addElement(chain)
                            continue
                    }
                }
                ++row
            }
        }
        return set
    }
    
    func removeMatches() -> Set<Chain> {
        let horizontalChains = detectHorizontalMatches()
        let verticalChains = detectVerticalMatches()
        
        println("Horizontal matches: \(horizontalChains)")
        removeCookies(horizontalChains)
        println("Vertical matches: \(verticalChains)")
        removeCookies(verticalChains)
        calculateScores(horizontalChains)
        calculateScores(verticalChains)
        
        return horizontalChains.unionSet(verticalChains)
    }
    
    func removeCookies(chains: Set<Chain>) {
        for chain in chains {
            for cookie in chain.cookies {
                cookies[cookie.column, cookie.row] = nil
            }
        }
    }
    
    func fillHoles() -> [[Cookie]] {
        var columns = [[Cookie]]()
        for column in 0..<NumColumns {
            var array = [Cookie]()
            for row in 0..<NumRows {
                if tiles[column, row] && cookies[column, row] == nil {
                    for lookup in (row + 1)..<NumRows {
                        if let cookie = cookies[column, lookup] {
                            cookies[column, lookup] = nil
                            cookies[column, row] = cookie
                            cookie.row = row
                            array.append(cookie)
                            
                            break
                        }
                    }
                }
            }
            if !array.isEmpty {
                columns.append(array)
            }
        }
        return columns
    }
    
    func topUpCookies() -> [[Cookie]] {
        var columns = [[Cookie]]()
        var cookieType: CookieType = .Unknown
        
        for column in 0..<NumColumns {
            var array = [Cookie]()
            
            for var row = NumRows - 1; row >= 0 && cookies[column, row] == nil; --row {
                if tiles[column, row] {
                    var newCookieType: CookieType
                    do {
                        newCookieType = CookieType.random()
                    } while newCookieType == cookieType
                    cookieType = newCookieType

                    let cookie = Cookie(column: column, row: row, cookieType: cookieType)
                    cookies[column, row] = cookie
                    array.append(cookie)
                }
            }
            if !array.isEmpty {
                columns.append(array)
            }
        }
        println("topUpCookies: \(columns)")
        return columns
    }
    
    func calculateScores(chains: Set<Chain>) {
        for chain in chains {
            chain.score = 60 * (chain.length - 2)
        }
    }
}