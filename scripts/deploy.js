const hre = require("hardhat");

async function main() {

  const FundDeposit = await hre.ethers.getContractFactory("FundDeposit");
  const fundDeposit = await FundDeposit.deploy();

  await fundDeposit.deployed();
  console.log("contract deployed to:", fundDeposit.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
