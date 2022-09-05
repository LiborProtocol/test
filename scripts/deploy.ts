import { ethers } from "hardhat";

async function main() {
    const accounts = await ethers.getSigners();
  const deployer = accounts[0];
  console.log("Deployer: ", deployer.address);
  const SeedRound= await ethers.getContractFactory("SeedRound");
  const seedRound = await SeedRound.deploy(0,'1662398560', '1692310800', deployer.address,deployer.address,12);
  await seedRound.deployed();
  console.log("Contract deployed to:", seedRound.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});