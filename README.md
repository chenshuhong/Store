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

该例子实现了任何人可以往其中存入自己的字符串和查询自己或他人存入的字符串功能，同时别人无法修改他人的字符串

我们先来一行行说明其功能：

#### SPDX 版权许可标识：

智能合约的代码是开源的，任何人都可以在区块链上查看。由于提供源代码总是涉及到版权方面的法律问题，Solidity 编译器鼓励使用机器可读的 [SPDX 许可标识](https://spdx.org/) 。 每个源文件都应该以这样的注释开始以说明其版权许可证。比如：`// SPDX-License-Identifier: MIT`

如果你不想指定一个许可证，或者如果源代码不开源，请使用特殊值 `UNLICENSED` ,这里的例子便是如此：`// SPDX-License-Identifier: UNLICENSED`

#### 版本标识

为了避免未来被可能引入不兼容更新的编译器所编译，源文件应该使用版本 标识 pragma 所注解。版本号的形式通常是 `0.x.0` 或者 `x.0.0`。

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

状态变量是永久地存储在合约存储中的值。`mapping (address => string) public stores;`定义了一个名为 stores 的映射，key 为地址，value 为字符串

关键字`public`让这些变量可以从外部读取,它会给变量自动生成一个同名函数，允许你在这个合约之外访问这个状态变量的当前值

这里就自动生成了

```
function stores(address account) external view returns (string) {
      return stores[account];
}
```

注意这里的函数需要一个参数，因为我们的变量是 mapping，所以生成的函数的第一个参数是该 mapping 的 key

如果我们定义的 public 变量为 uint，例如：`uint public storedData;`,那么其生成的同名函数，是不需要参数的

##### 函数

函数是代码的可执行单元。函数通常在合约内部定义，但也可以在合约外定义。函数 可以接受 参数和返回值。

```
function set(string memory value) public {
    stores[msg.sender]=value;
}
```

这里定义了一个 set 公开函数，接收一个 string 类型的字符串，注意其要是 memory 类型

函数作用是把 stores 里对应当前调用者，替换他的字符串

## hardhat

我们知道以太坊上运行的的智能合约需要是 EVM 字节码，所以我们用 solidity 编写的代码还需要进一步编译，编译可以使用`solc`,但这里我们更推荐的是使用[hardhat](https://hardhat.org/)来开发我们智能合约。我们可以用它来编译、调试、测试和部署智能合约，是目前开发以太坊智能合约最主流，也是最受欢迎的方式。

### 安装

新建一个文件夹，在文件夹的根目录，通过`npm init -y`快速创建一个 npm 项目，当然你也可以使用其他包管理工具，npm 的化建议使用 7 以上

```
npm install --save-dev hardhat
```

通过`npx hardhat`然后选择 JavaScript，初始化模板，根据提示，需要再安装 `@nomicfoundation/hardhat-toolbox`

![image-20221028020122101](https://gcore.jsdelivr.net/gh/chenshuhong/pic-bed/img/image-20221028020122101.png)

项目安装完成后，我们看下目录

![image-20221028020153940](https://gcore.jsdelivr.net/gh/chenshuhong/pic-bed/img/image-20221028020153940.png)

其中：

contracts:存放所有的合约，js 模板会帮我们创建一个 Lock.sol,用来锁定合约里的账户余额，到期才可以提取

scripts:存放脚本，目前是部署脚本

test:存放合约测试文件

hardhat.config:hardhat 的配置文件

我们使用 vscode 进行开发，推荐用 hardhat 的插件，https://hardhat.org/hardhat-vscode

### 编译

现在我们来把我们的 Store.sol 放进来，编写测试并部署

在 contracts 新建 Store.sol,把我们一开始写好的代码放进去，运行`npx hardhat compile`,建议先删掉 Lock.sol，因为 contracts 下的所有文件都会被编译

注意其在 artifacts 和 cache 生成了编译结果，生成内容我们先不管。如果我们不修改代码，再次编译，会提示 `Nothing to compile`

![image-20221028024017748](https://gcore.jsdelivr.net/gh/chenshuhong/pic-bed/img/image-20221028024017748.png)

### 测试

hardhat 包含了 Mocha、Chai 和 Ethers.js ，以支持测试，在 tests 目录下，新建 Store.js

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

我们用到了 `@nomicfoundation/hardhat-network-helpers` 的 loadFixture 来生成区块链快照，这在我们有多个测例的情况下很有用，使得我们每个测试都能从该快照对应的区块链状态开始，运行`npx hardhat test`已启动测试

![image-20221028030004563](https://gcore.jsdelivr.net/gh/chenshuhong/pic-bed/img/image-20221028030004563.png)

### 部署

测试成功后，我们可以尝试部署了

hardhat 内置了一个名为 hardhat 的特殊网络，模拟了区块链的特性，并提供了了很多工具方法方便操作该区块链，我们可以先部署到该环境验证下我们的部署脚本

部署脚本放到了`scripts`目录下，我们命名为`deploy.js`

```js
const hre = require("hardhat");

async function main() {
  const Store = await hre.ethers.getContractFactory("Store");
  const store = await Store.deploy();

  await store.deployed();

  console.log(`deployed to ${lock.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
```

运行`npx hardhat test`,我们可以看到已经部署到成功，并能看到合约地址，

![image-20221028103217758](https://gcore.jsdelivr.net/gh/chenshuhong/pic-bed/img/image-20221028103217758.png)

默认情况下，Hardhat 将在每次启动时启动一个新的 Hardhat Network 内存实例。为了方便我们保存合约调用记录，也便外部客户端可以连接到它，比如 MetaMask、或者我们的 Dapp 前端，我们可以单独启动它。

通过 `npx hardhat node`启动

![image-20221028104817014](https://gcore.jsdelivr.net/gh/chenshuhong/pic-bed/img/image-20221028104817014.png)

在运行期间，我们的一些交易也会在这打印出来

![image-20221028105005368](https://gcore.jsdelivr.net/gh/chenshuhong/pic-bed/img/image-20221028105005368.png)

在运行部署脚本的时候，我们可以指定 network 来表明我们要部署到哪个环境上

`npx hardhat run scripts/deploy.js --network localhost`

此时，该网络实例也打印出来了我们此次交易的具体信息

![image-20221028105145565](https://gcore.jsdelivr.net/gh/chenshuhong/pic-bed/img/image-20221028105145565.png)![image-20221028105201972](https://gcore.jsdelivr.net/gh/chenshuhong/pic-bed/img/image-20221028105201972.png)

### 配置文件 hardhat.config.js

当 Hardhat 运行时，它会从当前工作目录开始搜索最近的 hardhat.config.js 文件。该文件通常位于项目的根目录中。一个空的 hardhat.config.js 足以让 Hardhat 工作。

目前我们的 config 配置如下

```
require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
};
```

其有`defaultNetwork`, `networks`,`solidity`, `paths`, `mocha`这些配置

这里讲一下 networks 配置

如果我们想能部署到以太坊测试环境 Goerli，我们可以在 networks 里配置 Goerli 环境

首先要有节点的 url，我们使用 Alchemy 来获取一个节点的 url，Alchemy 是一个区块链节点服务商，通过他我们可以与以太坊链进行通信而无需运行我们自己的节点的 API，比如本地客户端。该平台还具有用于监视和分析的开发人员工具，查看 https://docs.alchemy.com/docs/alchemy-quickstart-guide , 加入 Alchemy 节点，拿到 Goerli 的 RPC url，我的是：https://eth-goerli.g.alchemy.com/v2/w7uVk4a8jPEe9TyfNC58qpZQ895vYOOs ，他就是我们 network 里 goerli 中 url 配置

为了使用该环境，我们还需要一些 eth，前往 https://goerlifaucet.com/ 获取一些实际没价值的 eth，现在我们已经有 eth 了，图里是`MetaMask`钱包，可以在谷歌浏览器插件市场下载，https://chrome.google.com/webstore/detail/metamask/nkbihfbeogaeaoehlefnkodbefgpgknn ，钱包能管理我们的区块链账户

![image-20221028114558951](https://gcore.jsdelivr.net/gh/chenshuhong/pic-bed/img/image-20221028114558951.png)

此外我们还要配置 account，所以我们需要创建一个以太坊 Goerli 环境下的外部账户，通过 metamask 创建，从中导出我们的私钥

![image-20221028114651963](https://gcore.jsdelivr.net/gh/chenshuhong/pic-bed/img/image-20221028114651963.png)

为了不公开私钥，我们引入 dotenv

```
npm install dotenv --save
```

在项目根目录创建 `.env`文件

```
GOERLI_URL = "https://eth-goerli.g.alchemy.com/v2/w7uVk4a8jPEe9TyfNC58qpZQ895vYOOs"
PRIVATE_KEY = "我是私钥，不给看"
```

hardhat.config.js 配置改为

```
require("dotenv").config();
require("@nomicfoundation/hardhat-toolbox");
const { GOERLI_URL, PRIVATE_KEY } = process.env;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
  networks: {
    goerli: {
      url: GOERLI_URL,
      accounts: [PRIVATE_KEY],
    },
  },
};

```

部署到 Goerli

```
npx hardhat run scripts/deploy.js --network goerli
```

![image-20221028142030909](https://gcore.jsdelivr.net/gh/chenshuhong/pic-bed/img/image-20221028142030909.png)

这就成功部署到以太坊测试网上了，我们可以在 [Etherscan](https://goerli.etherscan.io/)上查看此次交易和合约情况

![image-20221028142414782](https://gcore.jsdelivr.net/gh/chenshuhong/pic-bed/img/image-20221028142414782.png)

点进去可以看到该账号的余额，最近几次的交易情况，我们点进去 Transactions 第一个，那时我们刚刚部署合约产生的交易

![image-20221028142908915](https://gcore.jsdelivr.net/gh/chenshuhong/pic-bed/img/image-20221028142908915.png)

![image-20221028143124975](https://gcore.jsdelivr.net/gh/chenshuhong/pic-bed/img/image-20221028143124975.png)

我们也可以在首页的顶部搜索栏上输入刚刚部署生成的合约地址，可以看到合约情况，包括合约代码（字节码），合约产生的事件等

![image-20221028142708223](https://gcore.jsdelivr.net/gh/chenshuhong/pic-bed/img/image-20221028142708223.png)

我们还可以到 Alchemy dashboard 里看刚刚交易更详细的信息

![image-20221028143853930](https://gcore.jsdelivr.net/gh/chenshuhong/pic-bed/img/image-20221028143853930.png)

我们看到当我们调用 .deploy() 函数时，Hardhat/Ethers 在后台为我们进行的一些 JSON-RPC 调用。

### 调用

接下来用 ethers 来调用我们的合约，

我们把合约地址和 Alchemy 的 api key 都写进环境变量里

```
GOERLI_URL = "https://eth-goerli.g.alchemy.com/v2/w7uVk4a8jPEe9TyfNC58qpZQ895vYOOs"
API_KEY = "w7uVk4a8jPEe9TyfNC58qpZQ895vYOOs"
PRIVATE_KEY="我是私钥，不给看"
CONTRACT_ADDRESS = "0xc4c6dc45bec88266e9749607839D3f4DDA47Dfa9"
```

在 scripts 里新建 interact.js 文件，用来与合约交互

要调用合约里的方法，我们需要 hardhat 编译后产生的合约 ABI，其生成在`artifacts/contracts/Store.sol/Store.json`,我们先获取它

```
const contract = require("../artifacts/contracts/Store.sol/Store.json");
```

ethers.js 里实现合约交互，有三个概念需要知道

Provider：节点提供者，可对区块链进行读写访问。

Signer：一个能够签署交易的以太坊账户

Contract：部署在链上的特定合约。

我们使用了 Alchemy，所以需要用到 ether 提供的 AlchemyProvider

```js
// provider - Alchemy
const alchemyProvider = new ethers.providers.AlchemyProvider(
  (network = "goerli"),
  API_KEY
);

// signer - you
const signer = new ethers.Wallet(PRIVATE_KEY, alchemyProvider);

// contract instance
const storeContract = new ethers.Contract(
  CONTRACT_ADDRESS,
  contract.abi,
  signer
);
```

生成合约对象后，我们就可以调用合约上的公开函数了

```js
async function main() {
  const message = await storeContract.stores(signer.address);
  console.log("当前用户字符串：" + message);

  console.log("修改当前用户字符串...");
  const tx = await storeContract.set(new Date().toLocaleString());
  await tx.wait();

  const newMessage = await storeContract.stores(signer.address);
  console.log("当前用户最新字符串: " + newMessage);
}
```

我们每次都会把当前用户字符串存储在智能合约的值改为当前日期时间字符串，注意这里的`await tx.wait();`，表示等待交易确认

整体的代码如下：

```js
const API_KEY = process.env.API_KEY;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const CONTRACT_ADDRESS = process.env.CONTRACT_ADDRESS;

const contract = require("../artifacts/contracts/Store.sol/Store.json");

// provider - Alchemy
const alchemyProvider = new ethers.providers.AlchemyProvider(
  (network = "goerli"),
  API_KEY
);

// signer - you
const signer = new ethers.Wallet(PRIVATE_KEY, alchemyProvider);

// contract instance
const storeContract = new ethers.Contract(
  CONTRACT_ADDRESS,
  contract.abi,
  signer
);

async function main() {
  const message = await storeContract.stores(signer.address);
  console.log("当前用户字符串：" + message);

  console.log("修改当前用户字符串...");
  const tx = await storeContract.set(new Date().toLocaleString());
  await tx.wait();

  const newMessage = await storeContract.stores(signer.address);
  console.log("当前用户最新字符串: " + newMessage);
}

main();
```

运行脚本：

```
npx hardhat run scripts/interact.js --network goerli
```

![image-20221028154605480](https://gcore.jsdelivr.net/gh/chenshuhong/pic-bed/img/image-20221028154605480.png)

再运行一遍

![image-20221028155604476](https://gcore.jsdelivr.net/gh/chenshuhong/pic-bed/img/image-20221028155604476.png)

可以看到每次都会修改当前用户的字符串为当前日期时间

## 总结

至此我们就编写了一个带有简单读写功能的智能合约，并搭建了一个智能合约开发环境，能够编译，测试，部署，调用。最后，列一下用到的一些框架地址：

[hardhat](https://hardhat.org/)，[Solidity](https://learnblockchain.cn/docs/solidity/)，[Ethers](https://learnblockchain.cn/docs/ethers.js/)，[Alchemy](https://dashboard.alchemy.com/)，[Goerli 水龙头](https://goerlifaucet.com/)，[Goerli etherscan](https://goerli.etherscan.io/)
