Solidity 是一种静态类型语言，这意味着每个变量（状态变量和局部变量）都需要在编译时指定变量的类型。

文档已经写的很清楚了：https://learnblockchain.cn/docs/solidity/types.html#value-types

但是

## 值类型

类型的变量将始终按值来传递。 也就是说，当这些变量被用作函数参数或者用在赋值语句中时，总会进行值拷贝。

- bool
- int/uint: 整型，8 位到 256 位,以 `8` 位为步长递增。 `uint` 和 `int` 分别是 `uint256` 和 `int256` 的别名。
- fixed / ufixed:定长浮点型，在关键字 `ufixedMxN` 和 `fixedMxN` 中，`M` 表示该类型占用的位数，`N` 表示可用的小数位数。 `M` 必须能整除 8，即 8 到 256 位。 `N` 则可以是从 0 到 80 之间的任意数。 `ufixed` 和 `fixed` 分别是 `ufixed128x19` 和 `fixed128x19` 的别名。
- address:地址类型
- 合约类型：每一个 [contract](https://learnblockchain.cn/docs/solidity/contracts.html#contracts) 定义都有他自己的类型。
- 定长字节数组：`bytes1`， `bytes2`， `bytes3`， …， `bytes32`
- 地址字面常量
- 有理数和整数字面常量
- 字符串字面常量
- Unicode 字面常量
- 十六进制字面常量
- 枚举类型
- 用户定义的值类型
- 函数类型

## 引用类型

引用类型可以通过多个不同的名称修改它的值，而值类型的变量，每次都有独立的副本。因此，必须比值类型更谨慎地处理引用类型。

如果使用引用类型，则必须明确指明数据存储哪种类型的位置（空间）里：

- 内存memory，即数据在内存中，因此数据仅在其生命周期内（函数调用期间）有效。不能用于外部调用。
- 存储storage，状态变量保存的位置，只要合约存在就一直存储．
- 调用数据calldata，用来保存函数参数的特殊数据位置，是一个只读位置。