import { ethers } from "hardhat";

async function main() {
  

  //!!!igner!!!!
  const accounts = await ethers.getSigners();
  const deployer = accounts[0];

  console.log("Deployer: ", deployer.address);
  const Lock = await ethers.getContractFactory("LiquidityTransformer");
  const lock = await Lock.deploy(deployer.address,deployer.address,'1659100000');

  await lock.deployed();
  //console.log(lock.WETH());

  console.log("Contract deployed to:", lock.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
