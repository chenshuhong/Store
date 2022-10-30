const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Int", function () {
  async function deployFixture() {
    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await ethers.getSigners();

    const Int = await ethers.getContractFactory("Int");
    const int = await Int.deploy();
    return { int, owner, otherAccount };
  }
  describe("contraryBit", async function () {
    it('0',async function(){
        const { int, owner, otherAccount } =
        await loadFixture(deployFixture);
  
      expect(await int.contraryBit(0)).to.equal(-1);
    })
  });

});
