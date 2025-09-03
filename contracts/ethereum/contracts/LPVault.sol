// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract LPVault {
    // Struct to store the stake details
    struct Stake {
        uint256 amount;
        uint256 timestamp;
        uint256 duration;
    }

    // Initial storage variables (state variables)
    address public admin;
    IERC20 public token;
    mapping(address => uint256) public lpShares;
    mapping(address => Stake) public stakes;
    uint256 public totalLiquidity;
    uint256 public totalStaked;

    // Constructor to initialize the contract
    constructor(address _admin, address _token) {
        admin = _admin;
        token = IERC20(_token);
    }

    // Events for better logging and tracking
    event LiquidityProvided(address indexed provider, uint256 amount);
    event Transfer(address indexed user, uint256 amount);
    event Staked(address indexed user, uint256 amount, uint256 duration);

    function provideLiquidity(uint256 amount) public {
        // Check if the amount is greater than 0
        require(amount > 0, "Amount must be greater than 0");
        // Transfer the tokens from the user to the contract
        require(
            IERC20(token).transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );
        // Update the user's liquidity shares
        lpShares[msg.sender] += amount;
        // Update the total liquidity
        totalLiquidity += amount;
        // Emit the LiquidityProvided event
        emit LiquidityProvided(msg.sender, amount);
    }

    function removeLiquidity(uint256 shares) public {
        // Check if the shares are greater than 0
        require(shares > 0, "Shares must be greater than 0");
        // Check if the user has enough shares to remove
        require(
            lpShares[msg.sender] >= shares,
            "Insufficient shares to remove"
        );
        // Calculate the amount to be removed based on the shares
        uint256 amount = (shares * totalLiquidity) / lpShares[msg.sender];
        // Update the user's liquidity shares
        lpShares[msg.sender] -= shares;
        // Update the total liquidity
        totalLiquidity -= amount;
        // Transfer the tokens to the user
        require(IERC20(token).transfer(msg.sender, amount), "Transfer failed");
    }

    function bridgeTransfer(address user, uint256 amount) public {
        // Check if the amount is greater than 0
        require(
            IERC20(token).transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );
        // Update the user's liquidity shares
        lpShares[user] += amount;
        // Update the total liquidity
        totalLiquidity += amount;
        // Emit the Transfer event
        emit Transfer(user, amount);
    }

    function stake(uint256 amount, uint256 duration) public {
        // Check if the amount is greater than 0
        require(amount > 0, "Amount must be greater than 0");
        // Check if the user has enough shares to stake
        require(lpShares[msg.sender] >= amount, "Insufficient shares to stake");
        // Check if the user already has an active stake
        require(
            stakes[msg.sender].amount == 0,
            "User already has an active stake"
        );
        // Transfer the tokens from the user to the contract
        stakes[msg.sender] = Stake(amount, block.timestamp, duration);
        // Update the total staked amount
        totalStaked += amount;
        // Emit the Staked event
        emit Staked(msg.sender, amount, duration);
    }

    function unstake(uint256 amount) public {
        // Check if the amount is greater than 0
        require(amount > 0, "Amount must be greater than 0");
        // Check if the user has enough shares to unstake
        require(
            stakes[msg.sender].amount >= amount,
            "Insufficient amount to unstake"
        );
        // Check if the stake is still active
        require(
            block.timestamp >=
                stakes[msg.sender].timestamp + stakes[msg.sender].duration,
            "Stake is still active"
        );
        // Transfer the tokens to the user
        stakes[msg.sender].amount -= amount;
        // Update the total staked amount
        totalStaked -= amount;
        // Emit the Transfer event
        require(IERC20(token).transfer(msg.sender, amount), "Transfer failed");
    }

    function claimRewards() public {
        // Check if the user has an active stake
        require(
            block.timestamp >=
                stakes[msg.sender].timestamp + stakes[msg.sender].duration,
            "Stake is still active"
        );
        // Calculate the rewards based on the staked amount
        uint256 amount = stakes[msg.sender].amount;
        // Transfer the rewards to the user
        stakes[msg.sender].amount = 0;
        // Update the total staked amount
        totalStaked -= amount;
        // Emit the Transfer event
        require(IERC20(token).transfer(msg.sender, amount), "Transfer failed");
    }
}
