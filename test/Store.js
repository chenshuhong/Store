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
