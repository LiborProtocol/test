import { messagePrefix } from "@ethersproject/hash";
import { ethers } from "hardhat";
const { BigNumber } = require("@ethersproject/bignumber");

async function main() {
  

  //!!!igner!!!!
  const accounts = await ethers.getSigners();
  const user = accounts[1]; /*
  const user1 = accounts[1]; */



  console.log("User: ", user.address);
  const Seed = await ethers.getContractFactory("SeedRound");
  const seed = await Seed.attach("0x54a47cB3DA3EF65fdb9883C5be454fFe47c8a8f9");
  //console.log(await seed.connect(user).reserve( {value: ethers.utils.parseUnits("0.02","ether")}));
 // console.log(await seed.connect(user).reserveWithToken("0xD87Ba7A50B2E7E660f678A895E4B72E7CB4CCd9C",57000)); 
 
  /*console.log(await seed.connect(user1).reserve( {value: ethers.utils.parseUnits("0.001","ether")}));
  console.log(await seed.connect(user1).reserve( {value: ethers.utils.parseUnits("0.001","ether")}));
  console.log(await seed.connect(user1).checkMyTokens(accounts[1].address));
  */
 
  console.log(await seed.connect(user).getInvestorHistory(user.address)); /*
  console.log(await seed.connect(user1).getInvestorHistory(accounts[0].address)); */
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});


//Contract address :0xc148E2704927301067657561fCEC2507eb54461C
//Contract address :0x8C9f2DbC3539e50F561303A51f8a869047542E2e
//Contract address :0xAc50F3894354179223f1f26bbBf52c68c8ac1649
// 0x54a47cB3DA3EF65fdb9883C5be454fFe47c8a8f9