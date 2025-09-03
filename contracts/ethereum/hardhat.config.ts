import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-ignition-ethers";
import "@nomicfoundation/hardhat-ignition";
import "@nomicfoundation/hardhat-toolbox";
import "ethers";

const config: HardhatUserConfig = {
  solidity: "0.8.28",
};

export default config;
