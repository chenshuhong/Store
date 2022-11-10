// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.17;

contract BoolType {

    // 默认值false
    bool public bf;
    // 可在定义时赋值
    bool public bt = true;

    // 逻辑非
    function not() public view returns (bool) {
        return !bf;
    }

    // 逻辑与
    function and() public view returns (bool) {
        return bf&&bt;
    }

    // 逻辑或
    function or() public view returns (bool) {
        return bf||bt;
    }

    // 等于
    function equal() public view returns (bool) {
        return bf==bt;
    }

    // 不等于
    function notEqual() public view returns (bool) {
        return bf!=bt;
    }
}