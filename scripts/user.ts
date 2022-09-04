import { messagePrefix } from "@ethersproject/hash";
import { ethers } from "hardhat";

async function main() {
  

  //!!!igner!!!!
  const accounts = await ethers.getSigners();
  const user = accounts[0]; /*
  const user1 = accounts[1]; */



  console.log("User: ", user.address);
  const Seed = await ethers.getContractFactory("SeedRound");
  const seed = await Seed.attach("0xEBb11DD1Db93766b0a805b102e62DaC14FF3d728");
  console.log(await seed.connect(user).reserve( {value: ethers.utils.parseUnits("0.05","ether")})); 

  console.log(await seed.connect(user).getMySeedTokens(user.address));
  console.log(await seed.connect(user).getTotalWeiContributed());
  console.log(await seed.connect(user).getTotalUsers());
  console.log(await seed.connect(user).getTotalBuys());
  //console.log(await seed.connect(accounts[1]).forwardFunding());

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});


//Contract address :0xEBb11DD1Db93766b0a805b102e62DaC14FF3d728