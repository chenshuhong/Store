// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Int {

    int256 i=0;

    // 按位取反
    function contraryBit(int256 value) public returns (int256) {
        return ~value;
    } 
    
}