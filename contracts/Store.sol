// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Store {

    /**
     * 声明了public，会自动创建getter函数
     * function stores(address account) external view returns (string) {
     *     return stores[account];
     * }
     */
    mapping (address => string) public stores;

    function set(string memory value) public {
        stores[msg.sender]=value;
    }
}