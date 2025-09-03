import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("LPVault", (m) => {
    // Use the ERC20 contract deployed in the previous module to get the token address
    if (process.env.ESGI_TOKEN_ADDRESS === undefined) {
        // If the ESGI token address is not set, throw an error
        throw new Error("ESGI_TOKEN_ADDRESS is not set in the environment");
    } else if (process.env.ETH_PUBLIC_KEY === undefined) {
        // If the admin address is not set, throw an error
        throw new Error("ETH_PUBLIC_KEY is not set in the environment");
    } else {
        // Get the ESGI token address and the admin address from the environment
        const adminAddress = process.env.ETH_PUBLIC_KEY;
        const esgiToken = m.contractAt("ESGIToken", process.env.ESGI_TOKEN_ADDRESS);

        // Deploy LPVault with the token address
        const lpVault = m.contract("LPVault", [adminAddress, esgiToken]);

        return { lpVault };
    }
})