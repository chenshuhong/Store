前提：你已经知道区块链，以太坊，以及智能合约的概念

这里将讲述一个最基本的（读/写）智能合约的代码编写，编译，部署，测试，及调用。

## Solidity

Solidity 是一门面向合约的、为实现智能合约而创建的高级编程语言。我们将使用这门语言来编写我们的智能合约代码。

官网地址：https://solidity.readthedocs.io/

中文翻译网站：https://learnblockchain.cn/docs/solidity/index.html

先来看一个基本的读写例子

```solidity
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

```

该例子实现了任何人可以往其中存入自己的字符串和查询自己存入的字符串功能，同时别人无法修改他人的字符串，也无法查询他人的字符串功能。

我们先来一行行说明其功能：

#### SPDX版权许可标识：

智能合约的代码是开源的，任何人都可以在区块链上查看。由于提供源代码总是涉及到版权方面的法律问题，Solidity编译器鼓励使用机器可读的 [SPDX 许可标识](https://spdx.org/) 。 每个源文件都应该以这样的注释开始以说明其版权许可证。比如：`// SPDX-License-Identifier: MIT`

如果你不想指定一个许可证，或者如果源代码不开源，请使用特殊值 `UNLICENSED` ,这里的例子便是如此：`// SPDX-License-Identifier: UNLICENSED`

#### 版本标识

为了避免未来被可能引入不兼容更新的编译器所编译，源文件应该使用版本 标识pragma 所注解。版本号的形式通常是 `0.x.0` 或者 `x.0.0`。

这里是：`pragma solidity ^0.8.9;`表示源文件将既不允许低于` 0.8.9` 版本的编译器编译， 也不允许高于（包含） `0.9.0` 版本的编译器编译

表达式遵循 [npm](https://docs.npmjs.com/cli/v6/using-npm/semver) 版本语义。

#### 注释

可以使用单行注释（`//`）和多行注释（`/*...*/`）

```
// 这是一个单行注释。

/*
这是一个
多行注释。
*/
```

#### contract

在 Solidity 语言中，合约类似于其他面向对象编程语言中的**类**。通过`contract 合约名称 {合约代码}`来描述一个合约

这里我们定义了一个叫做 `Store` 的智能合约

每个合约中可以包含 状态变量、 函数、事件 Event, 结构体 和 枚举类型 的声明，且合约可以从其他合约继承。

##### 状态变量

状态变量是永久地存储在合约存储中的值。`mapping (address => string) public stores;`定义了一个名为stores的映射，key为地址，value为字符串

关键字`public`让这些变量可以从外部读取,它会给变量自动生成一个同名函数，允许你在这个合约之外访问这个状态变量的当前值

这里就自动生成了

```
function stores(address account) external view returns (string) {
      return stores[account];
}
```

注意这里的函数需要一个参数，因为我们的变量是mapping，所以生成的函数的第一个参数是该mapping的key

如果我们定义的public变量为uint，例如：`uint public storedData;`,那么其生成的同名函数，是不需要参数的

##### 函数

函数是代码的可执行单元。函数通常在合约内部定义，但也可以在合约外定义。函数 可以接受 参数和返回值。

```
function set(string memory value) public {
    stores[msg.sender]=value;
}
```

这里定义了一个set公开函数，接收一个string类型的字符串，注意其要是memory类型

函数作用是把stores里对应当前调用者，替换他的字符串

## hardhat

我们知道以太坊上运行的的智能合约需要是EVM字节码，所以我们用solidity编写的代码还需要进一步编译，编译可以使用`solc`,但这里我们更推荐的是使用[hardhat](https://hardhat.org/)来开发我们智能合约。我们可以用它来编译、调试、测试和部署智能合约，是目前开发以太坊智能合约最主流，也是最受欢迎的方式。

### 安装

新建一个文件夹，在文件夹的根目录，通过`npm init -y`快速创建一个npm项目，当然你也可以使用其他包管理工具，npm的化建议使用7以上

```
npm install --save-dev hardhat
```

通过`npx hardhat`然后选择JavaScript，初始化模板，根据提示，需要再安装 `@nomicfoundation/hardhat-toolbox`

![image-20221028020122101](https://gcore.jsdelivr.net/gh/chenshuhong/pic-bed/img/image-20221028020122101.png)

项目安装完成后，我们看下目录

![image-20221028020153940](https://gcore.jsdelivr.net/gh/chenshuhong/pic-bed/img/image-20221028020153940.png)



其中：

contracts:存放所有的合约，js模板会帮我们创建一个Lock.sol,用来锁定合约里的账户余额，到期才可以提取

scripts:存放脚本，目前是部署脚本

test:存放合约测试文件

hardhat.config:hardhat的配置文件

我们使用vscode进行开发，推荐用hardhat的插件，https://hardhat.org/hardhat-vscode

### 编译

现在我们来把我们的Store.sol放进来，编写测试并部署

在contracts新建Store.sol,把我们一开始写好的代码放进去，运行`npx hardhat compile`,建议先删掉Lock.sol，因为contracts下的所有文件都会被编译

注意其在artifacts和cache生成了编译结果，生成内容我们先不管。如果我们不修改代码，再次编译，会提示 `Nothing to compile`

![image-20221028024017748](https://gcore.jsdelivr.net/gh/chenshuhong/pic-bed/img/image-20221028024017748.png)

### 测试

hardhat包含了Mocha、Chai 和 Ethers.js ，以支持测试，在tests目录下，新建Store.js

```js
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Store", function () {
  async function deployFixture() {
    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await ethers.getSigners();

    const Store = await ethers.getContractFactory("Store");
    const store = await Store.deploy();
    const ownerString = "China";
    const otherString = "American";
    return { store, owner, otherAccount, ownerString, otherString };
  }
  it("Set And Get", async function () {
    const { store, owner, otherAccount, ownerString, otherString } =
      await loadFixture(deployFixture);

    await store.set(ownerString);
    await store.connect(otherAccount).set(otherString);

    expect(await store.stores(owner.address)).to.equal(ownerString);
    expect(await store.stores(otherAccount.address)).to.equal(otherString);
  });

});

```

我们用到了 `@nomicfoundation/hardhat-network-helpers` 的 loadFixture来生成区块链快照，这在我们有多个测例的情况下很有用，使得我们每个测试都能从该快照对应的区块链状态开始，运行`npx hardhat test`已启动测试

![image-20221028030004563](https://gcore.jsdelivr.net/gh/chenshuhong/pic-bed/img/image-20221028030004563.png)

### 部署

测试成功后，我们可以尝试部署了
