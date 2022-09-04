import { HardhatUserConfig } from "hardhat/config";
import "@nomiclabs/hardhat-ethers";
import * as dotenv from "dotenv";

dotenv.config();
const zaddr =
  "0000000000000000000000000000000000000000000000000000000000000000";
  
const config: HardhatUserConfig = {
  defaultNetwork: "hardhat",
  networks: {
    goerli: {
      url: process.env.GOERLI_URL ? process.env.GOERLI_URL : zaddr,
      accounts: [
        process.env.GOERLI_PRIVATE_KEY1
          ? process.env.GOERLI_PRIVATE_KEY1
          : zaddr,
        process.env.GOERLI_PRIVATE_KEY2
          ? process.env.GOERLI_PRIVATE_KEY2
          : zaddr  
      ],
      chainId: 5, // Goerli's id
      //gas: 8000000, // Goerli has a lower block limit than mainnet
      //gasPrice: 53000000000,
      //gasPrice: 2000000000
    }
  }
  ,
  solidity: {
    compilers: [
      {
        version: "0.8.9",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    ],
  }
};
export default config;
