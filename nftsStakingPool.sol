// SPDX-License-Identifier: MIT
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.6.0/contracts/token/ERC20/IERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.6.0/contracts/token/ERC721/IERC721.sol";
pragma solidity 0.8.0;
contract nftStaking{
address nftContractAddress;
uint256 rewardsPerBlock;
uint256 unboundingPeriod;
uint256 delayPeriodForallStaker;
address erc20RewardsTokenAddress;
bool isStakingPaused;
address owner ;
    struct nftDetails{ 
        uint256 nftNo;
        uint256 clamedRewards;
        bool isWithdraw;
        uint256 unboundingPeriod;
        uint256 delayPeriod;
        address owner;
        uint256 lastRewardClaimed;

    }
    event stakingNftEvent(uint256,uint256,address,uint256,address);
    mapping(address=>mapping(uint256=>nftDetails)) public nftData;
    constructor(address _nftContractAddress , address _erc20RewardToken,uint256 _rewardsPerBlock, uint256 _unboundingPeriod, uint256 _delayPeriodForallStaker){
        nftContractAddress=_nftContractAddress;
        erc20RewardsTokenAddress=_erc20RewardToken;
        rewardsPerBlock=_rewardsPerBlock;
        unboundingPeriod=_unboundingPeriod;
        owner=msg.sender;
        delayPeriodForallStaker=_delayPeriodForallStaker;
    }
    modifier onlyOwner{
        require(msg.sender==owner,"This is not the owner");
        
        _;
    }
    modifier ispaused{
        require(isStakingPaused==false,"staking paused till the next update");
        _;
    }
    function stakingNft(uint256 tokenId) external ispaused returns(bool){
        require(tokenId>=0,"invalid token id");
        require(nftData[msg.sender][tokenId].owner==address(0),"This NFT is already staked");
        require(IERC721(nftContractAddress).ownerOf(tokenId)==msg.sender,"invalid owner");
        require(IERC721(nftContractAddress).getApproved(tokenId)==address(this),"not having approval to transfer ");
        IERC721(nftContractAddress).safeTransferFrom(msg.sender,address(this),tokenId);
        nftData[msg.sender][tokenId]=nftDetails(tokenId,0,false,0,block.timestamp+delayPeriodForallStaker,msg.sender,block.timestamp);
        emit stakingNftEvent(tokenId,block.timestamp,msg.sender,block.timestamp+unboundingPeriod,msg.sender);
        return true;
    }
    function rewardWithdrawl(uint256 tokenId) external returns(bool){
        require(block.timestamp>=nftData[msg.sender][tokenId].delayPeriod,"waiting period is not over");
        uint256 totalrewards=calculateReward(tokenId);
        require(totalrewards>0,"no reward pending");
        // nftData[msg.sender][tokenId].clamedRewards=nftData[msg.sender][tokenId].clamedRewards+totalrewards;
        nftData[msg.sender][tokenId].delayPeriod=block.timestamp+delayPeriodForallStaker;
        
        IERC20(erc20RewardsTokenAddress).transfer(nftData[msg.sender][tokenId].owner,totalrewards);
        return true;
    }
    function calculateReward(uint256 tokenId) internal  returns(uint256){
        // require(nftData[msg.sender][tokenId].isWithdraw==false,"no reward for this NFT");
        // require(nftData[msg.sender][tokenId].delayPeriod<block.timestamp);
        require(nftData[msg.sender][tokenId].unboundingPeriod>=block.timestamp,"no reward for this NFT");

        uint256 totalTime=block.timestamp-nftData[msg.sender][tokenId].lastRewardClaimed;
        if(totalTime>0)
        {

        uint256 totalBlocks=totalTime/10; 

        nftData[msg.sender][tokenId].lastRewardClaimed=block.timestamp;
        nftData[msg.sender][tokenId].clamedRewards=nftData[msg.sender][tokenId].clamedRewards+totalBlocks*rewardsPerBlock;

        // return totalBlocks*rewardsPerBlock;
        }
        return 0;


    }
    function unstakingNft(uint256 tokenId) external returns(bool){
        require(nftData[msg.sender][tokenId].isWithdraw==false,"this nft is already unstaked");
        nftData[msg.sender][tokenId].unboundingPeriod= block.timestamp+unboundingPeriod;
        uint256 totalrewards=calculateReward(tokenId);
        nftData[msg.sender][tokenId].isWithdraw=true;
        // nftData[msg.sender][tokenId].delayPeriod=block.timestamp+delayPeriodForallStaker;


        if(totalrewards>0){
        IERC20(erc20RewardsTokenAddress).transfer(nftData[msg.sender][tokenId].owner,totalrewards);
        }
        return true;

    }

    function withdrawlNft(uint256 tokenId) external returns(bool){
        require(nftData[msg.sender][tokenId].unboundingPeriod<block.timestamp,"unbounding period is not over");
        require(nftData[msg.sender][tokenId].isWithdraw==true,"First unstake the NFT");
        delete nftData[msg.sender][tokenId];
        IERC721(nftContractAddress).transferFrom(address(this),nftData[msg.sender][tokenId].owner,tokenId);
        return true;
    }

    function updateStakingPoolData(uint256 newRewardsPerBlock , uint256 newUnboundingPeriod, uint256 newdelayPeriodForallStaker, bool wantPauseStaking ) onlyOwner external returns(bool){
        rewardsPerBlock=newRewardsPerBlock;
        unboundingPeriod=newUnboundingPeriod;
        delayPeriodForallStaker=newdelayPeriodForallStaker;
        isStakingPaused=wantPauseStaking;
        return true;
    }
}
