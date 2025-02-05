import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("ERC20", (m) => {
  // Deploy the ESGI token with an initial supply
  const initialSupply = BigInt(1000000); // 1 million tokens
  const esgiToken = m.contract("ESGIToken", [initialSupply]);
  return { esgiToken };
})
