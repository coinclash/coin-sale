const { expect, assert } = require("chai");
const { ethers } = require("hardhat");

describe("FundDeposit", async function () {
  let fundDeposit
  let add1
  beforeEach(async function () {
    add1 = await ethers.getSigners()
    const FundDeposit = await ethers.getContractFactory("FundDeposit");
    fundDeposit = await FundDeposit.deploy();
    await fundDeposit.deployed();
    const txn = await fundDeposit.whiteListUser(add1[0].address);
  })
  // it("Should return error", async function () {
  //   // expect(()=> await fundDeposit.myBalance()).to.throw("call revert exception");
  // });

  it("User Whitelist check", async function () {
    const balance = await fundDeposit.myBalance();
    expect(balance.toString()).to.equal("0") ;
  })

  it("User Deposit Check", async function () {
    const txn = await fundDeposit.sendEth({from:add1[0].address, value:ethers.utils.parseEther("0.011")});
    txn.wait(1)
    const balance = await fundDeposit.myBalance();
    assert.equal(ethers.utils.formatUnits(balance.toString(), 'ether'), '0.011');
  })

});
