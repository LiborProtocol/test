import { HardhatUserConfig } from "hardhat/config";
import "@nomiclabs/hardhat-ethers";
import * as dotenv from "dotenv";

dotenv.config();
const zaddr =
  "0000000000000000000000000000000000000000000000000000000000000000";
  
const config: HardhatUserConfig = {
  defaultNetwork: "hardhat",
  networks: {
    ropsten: {
      url: process.env.ROPSTEN_URL ? process.env.ROPSTEN_URL : zaddr,
      accounts: [
        process.env.ROPSTEN_PRIVATE_KEY
          ? process.env.ROPSTEN_PRIVATE_KEY
          : zaddr,
      ],
      chainId: 5, // Ropsten's id
      gas: 8000000, // Ropsten has a lower block limit than mainnet
      gasPrice: 53000000000,
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
