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

    IERC20 public USDC = IERC20(0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984); // usdc
    IERC20 public BUSD = IERC20(0xD87Ba7A50B2E7E660f678A895E4B72E7CB4CCd9C);
    IERC20 public USDT = IERC20(0x326C977E6efc84E512bB9C30f76E30c160eD06FB);
    IERC20 public LBR = IERC20(0xD87Ba7A50B2E7E660f678A895E4B72E7CB4CCd9C);

    mapping(address => uint256) public userBalances; //dictionnary of reward amounts per user
    mapping(address => uint256) public userParticipations1;
    mapping(address => uint256) public userParticipations2;
    mapping(address => uint256) public userParticipations3; //
 //
 //

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

    function Participate(address _tokenAddress, uint256 _tokenAmount) public {
        require(block.timestamp >= launchTime, "Not started");
        require(block.timestamp <= endTime, "Seed Round has ended");
        require(_tokenAmount >= minInvest, "Investment below minimum");
        require(
            _tokenAddress == 0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984 ||
                _tokenAddress == 0xD87Ba7A50B2E7E660f678A895E4B72E7CB4CCd9C ||
                _tokenAddress == 0x326C977E6efc84E512bB9C30f76E30c160eD06FB
        );
        require(remaingSeedTokens > _tokenAmount);

        IERC20 token = IERC20(_tokenAddress);
        token.safeTransferFrom(msg.sender, reserve, _tokenAmount);
        uint256 rewards = _tokenAmount.div(price).mul(1000);
        remaingSeedTokens = remaingSeedTokens - rewards;

        if (userBalances[msg.sender] == 0) {
            totalUsers++;
        }

        userBalances[msg.sender] = userBalances[msg.sender].add(rewards);

        totalDollarContributed = totalDollarContributed.add(_tokenAmount);
        totalBuys++;

        if (_tokenAddress == 0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984) {
            userParticipations1[msg.sender] = userParticipations1[msg.sender].add(_tokenAmount);
        }
        if (_tokenAddress == 0xD87Ba7A50B2E7E660f678A895E4B72E7CB4CCd9C) {
            userParticipations1[msg.sender] = userParticipations2[msg.sender].add(_tokenAmount);
        }
        if (_tokenAddress == 0x326C977E6efc84E512bB9C30f76E30c160eD06FB) {
            userParticipations1[msg.sender] = userParticipations3[msg.sender].add(_tokenAmount);
        }
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
        require(userBalances[msg.sender] > 0, "!balance");
        require(claimedSeedTokens <= seedTokens);
        uint256 myTokens = getMySeedTokens(msg.sender);
        LBR.safeTransfer(msg.sender, myTokens);
        claimedSeedTokens.add(myTokens);
    }

    /* IDO parameters functions */

    /* view functions */

    function getMySeedTokens(address _sender) public view returns (uint256) {
        return (userBalances[_sender]);
    }

    function getUserParticipations1(address _sender)
        public
        view
        returns (uint256)
    {
        return (userParticipations1[_sender]);
    }

    function getUserParticipations2(address _sender)
        public
        view
        returns (uint256)
    {
        return (userParticipations2[_sender]);
    }

    function getUserParticipations3(address _sender)
        public
        view
        returns (uint256)
    {
        return (userParticipations3[_sender]);
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
