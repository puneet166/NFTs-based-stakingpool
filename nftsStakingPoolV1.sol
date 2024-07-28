//SPDX-License-Identifier: MIT

import "./Proxiable.sol";
// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.6.0/contracts/token/ERC20/IERC20.sol


// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.0/contracts/utils/introspection/IERC165.sol


// OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.0/contracts/token/ERC721/IERC721.sol


// OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)

pragma solidity ^0.8.0;


/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;
}

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.6.0/contracts/utils/math/SafeMath.sol


// OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)

pragma solidity ^0.8.0;

// CAUTION
// This version of SafeMath should only be used with Solidity 0.8 or later,
// because it relies on the compiler's built in overflow checks.

/**
 * @dev Wrappers over Solidity's arithmetic operations.
 *
 * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
 * now has built in overflow checking.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}


// File: NFTstaking.sol


// Import OpenZeppelin's ERC20 and ERC721 interfaces


// import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
// Import OpenZeppelin's SafeMath library

// Import the Proxiable contract


// Specify the Solidity version
pragma solidity 0.8.0;

// Define the nftStaking contract, inheriting from Proxiable
contract nftStaking is Proxiable {
    using SafeMath for uint256; // Use SafeMath for uint256

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
        require(nftContractAddress==address(0),"contract already initialize");
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
        // IERC721(nftContractAddress).approve(address(this), tokenId); // aprprove the token to smart contract

        require(IERC721(nftContractAddress).getApproved(tokenId) == address(this), "Not having approval to transfer"); // Ensure contract has approval

        // Transfer the NFT to this contract
        IERC721(nftContractAddress).transferFrom(msg.sender, address(this), tokenId);
       
        // Update the nftData mapping with the new staking details
        nftData[msg.sender][tokenId] = nftDetails(
            tokenId,
            0,
            false,
            0,
            block.timestamp.add(delayPeriodForallStaker),
            msg.sender,
            block.timestamp
        );

        // // Emit the staking event
        emit stakingNftEvent(tokenId, block.timestamp, msg.sender, block.timestamp.add(unboundingPeriod), msg.sender);
        return true;
    }

    // Function to withdraw rewards
    function rewardWithdrawl(uint256 tokenId) public returns (bool) {
        nftDetails storage nft = nftData[msg.sender][tokenId]; // Access NFT details from storage
        // require(block.timestamp >= nft.delayPeriod, "Waiting period for reward claim is not over"); // Check if delay period is over
        require(block.timestamp >= nft.delayPeriod, "Waiting period for reward claim is not over"); // Check if delay period is over

        // Calculate the total rewards
        uint256 totalRewards = calculateReward(tokenId);
        require(totalRewards > 0, "No reward pending"); // Ensure there are rewards to withdraw

     

        // Transfer the rewards to the owner
        IERC20(erc20RewardsTokenAddress).transfer(nft.owner, totalRewards);
        return true;
    }

    // Internal function to calculate rewards
    function calculateReward(uint256 tokenId) internal returns (uint256) {
        nftDetails storage nft = nftData[msg.sender][tokenId]; // Access NFT details from storage
        // require(nft.unboundingPeriod >= block.timestamp, "No reward for this NFT"); // Check if unbounding period is over
        require(nft.owner != address(0), "This NFT doesn't exist"); // Check if NFT is already staked
        require(!nft.isWithdraw,"No further rewards this NFT has unstaked"); // Mark the NFT as withdrawn

        uint256 totalTime = block.timestamp.sub(nft.lastRewardClaimed); // Calculate the total time since last reward claimed
        if (totalTime > 0) {
            uint256 totalBlocks = totalTime.div(10); // Assume 1 block per 10 seconds
            nft.lastRewardClaimed = block.timestamp; // Update last reward claimed timestamp
            uint256 reward = totalBlocks.mul(rewardsPerBlock); // Calculate the reward
            nft.clamedRewards = nft.clamedRewards.add(reward); // Update claimed rewards
             // Update the delay period
            nft.delayPeriod = block.timestamp.add(delayPeriodForallStaker);
            return reward;
        }
        return 0;
    }

    // Function to unstake an NFT
    function unstakingNft(uint256 tokenId) public returns (bool) {
        nftDetails storage nft = nftData[msg.sender][tokenId]; // Access NFT details from storage
        require(nftData[msg.sender][tokenId].owner != address(0), "NFT not found"); // Check Nft exist or not

        require(!nft.isWithdraw, "This NFT is already unstaked"); // Ensure NFT is not already unstaked

        nft.unboundingPeriod = block.timestamp.add(unboundingPeriod); // Update the unbounding period
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
        require(nftData[msg.sender][tokenId].owner != address(0), "NFT not found"); //  Check Nft exist or not
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
