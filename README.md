# Tezos/Ethereum Bridge & Liquidity Pool
A liquidity pool based bridge system for token transfers between Ethereum and Tezos blockchains, with staking rewards.

## Learning Objectives:

1. Understand cross-chain bridging and liquidity mechanisms.
2. Implement and deploy smart contracts on Ethereum and Tezos.
3. Develop an off-chain relayer system for blockchain synchronization.
4. Ensure security and reliability of asset transfers.
5. Implement staking rewards mechanism.

The project must include:

1. **Ethereum Smart Contracts:** An ERC-20 LP Vault contract managing token liquidity, transfer operations, and staking rewards.
2. **Tezos Smart Contracts:** An FA2 LP contract managing equivalent token liquidity and staking rewards on Tezos.
3. **Off-chain Relayer:** A Node.js/Python/Go program coordinating cross-chain liquidity operations.

## Bridge Process:

User     | Ethereum                | Off-chain Relayer        | Tezos
-------- | ----------------------- | ------------------------ | --------
         | -- ERC-20 Deposit -->   |                          |
         |                         | -- LP Event -->          |
         |                         |                          | -- FA2 Transfer -->
         |                         | <-- Transfer Event --    |
         |     <-- Confirmation -- |                          |
         | -- FA2 Request -->      |                          |
         |                         | -- Request Event -->     |
         |  <-- ERC-20 Transfer -- |                          |

The Bridge Liquidity Pool process between Ethereum and Tezos will be as follows:
- Deposit on Ethereum:
    - User deposits ERC-20 tokens to the LP Vault.
    - Optional: Lock tokens for staking rewards.
- Event emission:
    - LP Vault emits a liquidity/staking event.
- Off-chain Relayer detects the event:
    - Relayer coordinates with Tezos LP.
- Transfer/Stake on Tezos:
    - FA2 LP transfers equivalent tokens or stakes them.
- Withdrawal request on Tezos:
    - User requests withdrawal from FA2 LP.
- Event emission on Tezos:
    - LP emits a withdrawal event.
- Off-chain Relayer detects the event:
    - Relayer initiates Ethereum LP transfer.
- Transfer on Ethereum:
    - LP Vault transfers tokens to user.

## API Endpoints and Functions:

1. **Ethereum LP Vault API:**
   - `/eth/provideLiquidity/{address}/{amount}` (POST): Add liquidity
   - `/eth/removeLiquidity/{address}/{amount}` (POST): Remove liquidity
   - `/eth/bridgeTransfer/{address}/{amount}` (POST): Bridge transfer
   - Optional:
        - `/eth/stake/{address}/{amount}/{duration}` (POST): Stake tokens
        - `/eth/unstake/{address}/{amount}` (POST): Unstake tokens
        - `/eth/claimRewards/{address}` (POST): Claim staking rewards
   
2. **Tezos LP API:**
   - `/tezos/provideLiquidity/{address}/{amount}` (POST): Add liquidity
   - `/tezos/removeLiquidity/{address}/{amount}` (POST): Remove liquidity
   - `/tezos/bridgeTransfer/{address}/{amount}` (POST): Bridge transfer
   - Optional:
        - `/tezos/stake/{address}/{amount}/{duration}` (POST): Stake tokens
        - `/tezos/unstake/{address}/{amount}` (POST): Unstake tokens
        - `/tezos/claimRewards/{address}` (POST): Claim staking rewards

## Technical Specifications:

Ethereum LP Vault (Solidity):
- Global Variables:
    - `mapping(address => uint256) public lpShares` : LP token shares
    - `mapping(address => Stake) public stakes` : Staking information
    - `uint256 public totalLiquidity` : Total pool liquidity
    - `uint256 public totalStaked` : Total staked tokens
    - `event LiquidityProvided(address indexed provider, uint256 amount)`
    - `event Transfer(address indexed user, uint256 amount)`
    - `event Staked(address indexed user, uint256 amount, uint256 duration)`
- Functions:
    - `provideLiquidity(uint256 amount)`: Add to LP
    - `removeLiquidity(uint256 shares)`: Remove from LP
    - `bridgeTransfer(address user, uint256 amount)`: Process bridge transfer
    - `stake(uint256 amount, uint256 duration)`: Stake tokens
    - `unstake(uint256 amount)`: Unstake tokens
    - `claimRewards()`: Claim staking rewards

Tezos LP Contract (Archetype or LIGO):
- Global Variables:
    - `lp_shares : big_map(address, nat)` : LP token shares
    - `stakes : big_map(address, stake_info)` : Staking information
    - `total_liquidity : nat` : Total pool liquidity
    - `total_staked : nat` : Total staked tokens
    - `event LiquidityProvided(address indexed provider, nat amount)`
    - `event Transfer(address indexed user, nat amount)`
    - `event Staked(address indexed user, nat amount, nat duration)`
- Functions:
    - `provide_liquidity(nat amount)`: Add to LP
    - `remove_liquidity(nat shares)`: Remove from LP
    - `bridge_transfer(address user, nat amount)`: Process bridge transfer
    - `stake(nat amount, nat duration)`: Stake tokens
    - `unstake(nat amount)`: Unstake tokens
    - `claim_rewards()`: Claim staking rewards

Off-chain Relayer (Node.js/Python/Go):
- Functions:
    - `monitorEthereumLP()`:
        - Track Ethereum LP events
        - Subscribe to LP Vault contract events using Web3.js
        - Monitor `LiquidityProvided`, `Transfer`, and `Staked` events
        - Queue detected events for processing
        - Log event details including block number and timestamp
        
    - `monitorTezosLP()`:
        - Track Tezos LP events
        - Connect to Tezos node using Taquito
        - Watch for FA2 LP contract operations
        - Filter relevant operations (`provide_liquidity`, `transfer`, `stake`)
        - Queue operations for cross-chain processing
        - Verify operation status and confirmations
        - Store operation history
        
    - `processTransfer(chain, user, amount)`:
        - Handle cross-chain transfers
        - Verify source chain balance and liquidity
        - Check destination chain capacity
        - Calculate transfer fees and rewards
        - Generate transfer signature
        - Submit transfer transaction
        - Monitor transaction confirmation
        - Update balances on both chains
        - Emit transfer completion event
        
    - `validateLiquidity(chain)`:
        - Verify LP status
        - Check total liquidity available
        - Verify staking pool balance
        - Calculate utilized vs available liquidity
        - Monitor liquidity thresholds
        
    - `calculateRewards(chain, user)`:
        - Calculate staking rewards
        - Get user stake duration and amount
        - Apply base APY rate

## Technical Stack:

- Solidity for Ethereum
- Web3.js / Ethers.js for Ethereum integration
- Archetype or LIGO for Tezos
- Taquito for Tezos integration
- Node.js/Python/Rust/Go for the Off-chain Relayer