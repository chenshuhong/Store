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
