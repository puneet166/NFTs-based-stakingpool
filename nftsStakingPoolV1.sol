// SPDX-License-Identifier: MIT
// Import OpenZeppelin's ERC20 and ERC721 interfaces
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.6.0/contracts/token/ERC20/IERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.6.0/contracts/token/ERC721/IERC721.sol";
// Import the Proxiable contract
import "./Proxiable.sol";

// Specify the Solidity version
pragma solidity 0.8.0;

// Define the nftStaking contract, inheriting from Proxiable
contract nftStaking is Proxiable {
    // State variables
    address public nftContractAddress; // Address of the NFT contract
    uint256 public rewardsPerBlock; // Rewards per block for staking
    uint256 public unboundingPeriod; // Period before unstaking is allowed
    uint256 public delayPeriodForallStaker; // Delay period for all stakers
    address public erc20RewardsTokenAddress; // Address of the ERC20 rewards token
    bool public isStakingPaused; // Flag to pause staking
    address public owner; // Contract owner

    // Structure to store NFT details
    struct nftDetails {
        uint256 nftNo; // NFT number
        uint256 clamedRewards; // Claimed rewards
        bool isWithdraw; // Withdrawal status
        uint256 unboundingPeriod; // Unbounding period for the NFT
        uint256 delayPeriod; // Delay period for the NFT
        address owner; // Owner of the NFT
        uint256 lastRewardClaimed; // Last reward claimed timestamp
    }

    // Event to be emitted when an NFT is staked
    event stakingNftEvent(uint256 tokenId, uint256 timestamp, address owner, uint256 delayPeriod, address staker);

    // Mapping to store NFT data for each address and token ID
    mapping(address => mapping(uint256 => nftDetails)) public nftData;

    // Function to initialize the contract
    function initialize(
        address _nftContractAddress,
        address _erc20RewardToken,
        uint256 _rewardsPerBlock,
        uint256 _unboundingPeriod,
        uint256 _delayPeriodForallStaker
    ) public {
        require(_nftContractAddress != address(0), "Invalid NFT contract address"); // Ensure valid NFT contract address
        require(_erc20RewardToken != address(0), "Invalid ERC20 token address"); // Ensure valid ERC20 token address

        // Initialize state variables
        nftContractAddress = _nftContractAddress;
        erc20RewardsTokenAddress = _erc20RewardToken;
        rewardsPerBlock = _rewardsPerBlock;
        unboundingPeriod = _unboundingPeriod;
        delayPeriodForallStaker = _delayPeriodForallStaker;
        owner = msg.sender; // Set the contract deployer as the owner
    }

    // Modifier to restrict access to the owner
    modifier onlyOwner {
        require(msg.sender == owner, "This is not the owner");
        _;
    }

    // Modifier to check if staking is paused
    modifier isPaused {
        require(!isStakingPaused, "Staking paused till the next update");
        _;
    }

    // Function to stake an NFT
    function stakingNft(uint256 tokenId) public isPaused returns (bool) {
        require(tokenId >= 0, "Invalid token ID"); // Ensure valid token ID
        require(nftData[msg.sender][tokenId].owner == address(0), "This NFT is already staked"); // Check if NFT is already staked
        require(IERC721(nftContractAddress).ownerOf(tokenId) == msg.sender, "Invalid owner"); // Ensure the sender is the owner
        require(IERC721(nftContractAddress).getApproved(tokenId) == address(this), "Not having approval to transfer"); // Ensure contract has approval

        // Transfer the NFT to this contract
        IERC721(nftContractAddress).safeTransferFrom(msg.sender, address(this), tokenId);

        // Update the nftData mapping with the new staking details
        nftData[msg.sender][tokenId] = nftDetails(
            tokenId,
            0,
            false,
            0,
            block.timestamp + delayPeriodForallStaker,
            msg.sender,
            block.timestamp
        );

        // Emit the staking event
        emit stakingNftEvent(tokenId, block.timestamp, msg.sender, block.timestamp + unboundingPeriod, msg.sender);
        return true;
    }

    // Function to withdraw rewards
    function rewardWithdrawl(uint256 tokenId) public returns (bool) {
        nftDetails storage nft = nftData[msg.sender][tokenId]; // Access NFT details from storage
        require(block.timestamp >= nft.delayPeriod, "Waiting period is not over"); // Check if delay period is over

        // Calculate the total rewards
        uint256 totalRewards = calculateReward(tokenId);
        require(totalRewards > 0, "No reward pending"); // Ensure there are rewards to withdraw

        // Update the delay period
        nft.delayPeriod = block.timestamp + delayPeriodForallStaker;

        // Transfer the rewards to the owner
        IERC20(erc20RewardsTokenAddress).transfer(nft.owner, totalRewards);
        return true;
    }

    // Internal function to calculate rewards
    function calculateReward(uint256 tokenId) internal returns (uint256) {
        nftDetails storage nft = nftData[msg.sender][tokenId]; // Access NFT details from storage
        require(nft.unboundingPeriod >= block.timestamp, "No reward for this NFT"); // Check if unbounding period is over

        uint256 totalTime = block.timestamp - nft.lastRewardClaimed; // Calculate the total time since last reward claimed
        if (totalTime > 0) {
            uint256 totalBlocks = totalTime / 10; // Assume 1 block per 10 seconds
            nft.lastRewardClaimed = block.timestamp; // Update last reward claimed timestamp
            uint256 reward = totalBlocks * rewardsPerBlock; // Calculate the reward
            nft.clamedRewards += reward; // Update claimed rewards

            return reward;
        }
        return 0;
    }

    // Function to unstake an NFT
    function unstakingNft(uint256 tokenId) public returns (bool) {
        nftDetails storage nft = nftData[msg.sender][tokenId]; // Access NFT details from storage
        require(!nft.isWithdraw, "This NFT is already unstaked"); // Ensure NFT is not already unstaked

        nft.unboundingPeriod = block.timestamp + unboundingPeriod; // Update the unbounding period
        uint256 totalRewards = calculateReward(tokenId); // Calculate rewards

        nft.isWithdraw = true; // Mark the NFT as withdrawn

        if (totalRewards > 0) {
            IERC20(erc20RewardsTokenAddress).transfer(nft.owner, totalRewards); // Transfer rewards if any
        }
        return true;
    }

    // Function to withdraw an NFT after unstaking
    function withdrawlNft(uint256 tokenId) public returns (bool) {
        nftDetails storage nft = nftData[msg.sender][tokenId]; // Access NFT details from storage
        require(nft.unboundingPeriod < block.timestamp, "Unbounding period is not over"); // Check if unbounding period is over
        require(nft.isWithdraw, "First unstake the NFT"); // Ensure the NFT is unstaked

        // Transfer the NFT back to the owner and delete the NFT data
        IERC721(nftContractAddress).transferFrom(address(this), nft.owner, tokenId);
        delete nftData[msg.sender][tokenId];
        return true;
    }

    // Function to update the staking pool data
    function updateStakingPoolData(
        uint256 newRewardsPerBlock,
        uint256 newUnboundingPeriod,
        uint256 newdelayPeriodForallStaker,
        bool wantPauseStaking
    ) public onlyOwner returns (bool) {
        // Update the staking pool parameters
        rewardsPerBlock = newRewardsPerBlock;
        unboundingPeriod = newUnboundingPeriod;
        delayPeriodForallStaker = newdelayPeriodForallStaker;
        isStakingPaused = wantPauseStaking;
        return true;
    }

    // Function to update the contract code address (for upgradeability)
    function updateCode(address newCode) public onlyOwner {
        updateCodeAddress(newCode); // Call the inherited function to update the code address
    }
}
