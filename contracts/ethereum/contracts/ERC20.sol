// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.28;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract GLDToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("Gold", "GLD") {
        // Mint the initial supply
        _mint(msg.sender, initialSupply);
    }

    function mint(uint256 amount) public {
        // Mint new tokens and assign them to the sender
        _mint(msg.sender, amount);
    }

    function burn(uint256 amount) public {
        // Burn tokens from the sender's balance
        _burn(msg.sender, amount);
    }

    function transfer(
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        // Transfer tokens from the sender to the recipient
        _transfer(msg.sender, recipient, amount);
        return true;
    }
}
