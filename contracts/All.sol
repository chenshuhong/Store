// SPDX 版权许可标识
// SPDX-License-Identifier: MIT

//Pragma
pragma solidity ^0.8.17; // 版本标识
pragma abicoder v1; // ABI Coder Pragma

// 导入其他源文件
import * as moduleName from "modulePath"; // 等同于 import "modulePath" as moduleName;
import {symbol1 as alias, symbol2} from "modulePath";

// 合约结构
contract contractName {
    address seller; // 状态变量，永久地存储在合约存储中的值。
    
    struct Voter { // 结构体
        uint weight;
        bool voted;
        address delegate;
        uint vote;
    }
    
    Voter v;
    
    // 枚举类型，可用来创建由一定数量的“常量值”构成的自定义类型
    enum ActionChoices { GoLeft, GoRight, GoStraight, SitStill }
    ActionChoices choice;
    ActionChoices constant defaultChoice = ActionChoices.GoStraight;
    
    
    function Mybid() public { // 定义函数，代码的可执行单元
        // ...
    }
    
    // 定义错误，Solidity 为应对失败，允许用户定义 error 来描述错误的名称和数据。
    // 没有足够的资金用于转账， 参数 `requested` 表示需要的资金，`available` 表示仅有的资金。
    error NotEnoughFunds(uint requested, uint available);
    
    // 事件，是能方便地调用以太坊虚拟机日志功能的接口。
    event HighestBidIncreased(address bidder, uint amount); // 事件
    
    // 修改器，可以用来以声明的方式修改函数语义，这里当调用者不是合约创建者的时候，会报错
    modifier onlySeller() {
        require(
            msg.sender == seller,
            "Only seller can call this."
        );
        _; // 这个是关键，可以把这里想象成slot，使用该修改器的函数代码替换这里
    }
    
    function abort() public onlySeller { // 修改器用法
        // ...
        emit HighestBidIncreased(msg.sender, msg.value); // 触发事件
        
        uint balance = balances[msg.sender];
        if (balance < amount)
            revert NotEnoughFunds(amount, balance); // revert 能触发错误
    }
}

function Mybid() public payable { // 合约外也可以定义函数
    // ...
}