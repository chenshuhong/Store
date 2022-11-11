// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.17;

import "hardhat/console.sol";

contract IntType {
    int public i;
    int public i8;
    int256 public i256;
    uint public ui;
    uint8 public ui8;
    uint256 public ui256;

    function minAndMax() public view {
        console.log("int min value");
        console.logInt(type(int).min);
        console.log("int max value");
        console.logInt(type(int).max);
        console.log("int8 min value");
        console.logInt(type(int8).min);
        console.log("int8 max value");
        console.logInt(type(int8).max);
        console.log("int256 min value");
        console.logInt(type(int256).min);
        console.log("int256 max value");
        console.logInt(type(int256).max);

        console.log("uint min value");
        console.log(type(uint).min);
        console.log("uint max value");
        console.log(type(uint8).max);
        console.log("uint8 min value");
        console.log(type(uint8).min);
        console.log("uint8 max value");
        console.log(type(uint8).max);
        console.log("uint256 min value");
        console.log(type(uint256).min);
        console.log("uint256 max value");
        console.log(type(uint256).max);
    }

    function moveBit() public view{
        uint8 ui8 = 127;
        int8 i8 = -127;
        console.log("left move 127,move 1",ui8<<1);
        console.log("left move 127,move 2",ui8<<2);
        console.log("left move 127,move 3",ui8<<3);
        console.log("right move 127,move 1",ui8>>1);
        console.log("right move 127,move 2",ui8>>2);
        console.log("right move 127,move 6",ui8>>6);
        console.log("right move 127,move 7",ui8>>7);
        console.log("right move 127,move 8",ui8>>8);

        console.log("left move -1,move 1");
        console.logInt(i8<<1);
        console.log("left move -1,move 2");
        console.logInt(i8<<2);
        console.log("left move -1,move 7");
        console.logInt(i8<<7);
        console.log("left move -1,move 8");
        console.logInt(i8<<8);
    }

    function calcOver() public view{
        uint a = 2;
        uint b=3;
        unchecked { uint c = a-b;console.log(c); }
        uint d = a-b;
        console.log(d);
    }

}