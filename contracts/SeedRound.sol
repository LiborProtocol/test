// SPDX-License-Identifier: UNLICENSED

pragma solidity =0.8.9;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract SeedRound is ReentrancyGuard {
    using SafeERC20 for IERC20;
    using Address for address payable;
    using Address for address;
    using SafeMath for uint256;

    uint256 public constant seedTokens = 4000000000 * 1e18;
    uint256 public remaingSeedTokens = 4000000000 * 1e18;
    uint256 public claimedSeedTokens = 0;

    uint256 public minInvest; // minimum investment 10$
    uint256 public launchTime; // timestamp launch time
    uint256 public endTime; //duration of IDO
    uint256 public price;
    bool claimTime;

    address payable teamAddress;
    address payable reserve;

    uint256 public totalUsers;
    uint256 public totalBuys;
    uint256 public totalDollarContributed;

    IERC20 public USDC = IERC20(0x07865c6E87B9F70255377e024ace6630C1Eaa37F); // usdc
    IERC20 public BUSD = IERC20(0x07865c6E87B9F70255377e024ace6630C1Eaa37F);
    IERC20 public USDT = IERC20(0x07865c6E87B9F70255377e024ace6630C1Eaa37F);
    IERC20 public LBR = IERC20(0xD87Ba7A50B2E7E660f678A895E4B72E7CB4CCd9C);

    mapping(address => uint256) public investorBalances; //dictionnary of all deposits per users

    /*  mapping(address => uint256[3]) public investorHistory; */

    constructor(
        uint256 _minInvest,
        uint256 _launchTime,
        uint256 _endTime,
        address payable _teamAddress,
        address payable _reserve,
        uint256 _price
    ) {
        require(_launchTime > block.timestamp, "!_launchTime");
        minInvest = _minInvest;
        launchTime = _launchTime;
        endTime = _endTime;
        teamAddress = _teamAddress;
        reserve = _reserve;
        price = _price;
    }

    receive() external payable {
        require(msg.sender == teamAddress, "Direct deposits disabled");
    }

    function Participate(
        address _tokenAddress,
        uint256 _tokenAmount
    ) public {
        require(block.timestamp >= launchTime, "Not started");
        require(block.timestamp <= endTime, "Seed Round has ended");
        require(_tokenAmount >= minInvest, "Investment below minimum");
        require(_tokenAddress == 0x07865c6E87B9F70255377e024ace6630C1Eaa37F);
        require(remaingSeedTokens > _tokenAmount);

        IERC20 token = IERC20(_tokenAddress);

        token.safeTransferFrom(msg.sender, reserve, _tokenAmount);
        uint256 rewards = _tokenAmount.div(price).mul(1000);
        remaingSeedTokens = remaingSeedTokens - rewards;

        if (investorBalances[msg.sender] == 0) {
            totalUsers++;
        }

        investorBalances[msg.sender] = investorBalances[msg.sender].add(
            rewards
        );

        totalDollarContributed = totalDollarContributed.add(rewards);
        totalBuys++;
    } //_reserve update IDO global contribution and user contribution

    /* 
    function forwardFunding() external nonReentrant {
        require(msg.sender == tx.origin, "!EOA");
        require(msg.sender == teamAddress, "not team address");

        USDC.safeTransfer(msg.sender, _tokenAmount);
        USDT.safeTransfer(msg.sender, _tokenAmount);
        BUSD.safeTransfer(msg.sender, _tokenAmount);
    } */

    function allowClaim() public nonReentrant {
        require(msg.sender == teamAddress, "NotOwner");
        claimTime = true;
    }

    function getMyTokens() external nonReentrant {
        require(claimTime, "!notClaimable");
        require(investorBalances[msg.sender] > 0, "!balance");

        uint256 myTokens = getMySeedTokens(msg.sender);

        LBR.safeTransfer(msg.sender, myTokens);
    }

    /* view functions */

    function getMySeedTokens(address _sender) public view returns (uint256) {
        return (investorBalances[_sender]);
    }

    function getTotalDollarContributed() public view returns (uint256) {
        return (totalDollarContributed);
    }

    function getTotalUsers() public view returns (uint256) {
        return (totalUsers);
    }

    function getTotalBuys() public view returns (uint256) {
        return (totalBuys);
    }
}
