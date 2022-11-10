const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");
const { ethers } = require("hardhat");
const { PANIC_CODES } = require("@nomicfoundation/hardhat-chai-matchers/panic");

describe("IntType", function () {
  async function deployFixture() {
    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await ethers.getSigners();

    const IntType = await ethers.getContractFactory("IntType");
    const intType = await IntType.deploy();
    return { intType, owner, otherAccount };
  }
  it("minAndMax", async function () {
    const { intType } = await loadFixture(deployFixture);
    expect(await intType.minAndMax()).not.to.be.reverted;
  });

  it.only("moveBit", async function () {
    const { intType } = await loadFixture(deployFixture);
    expect(await intType.moveBit()).not.to.be.reverted;
  });

  it("calcOver", async function () {
    const { intType } = await loadFixture(deployFixture);
    expect(await intType.calcOver()).to.be.revertedWithPanic(
      PANIC_CODES.ARITHMETIC_UNDER_OR_OVERFLOW
    );
  });
});
