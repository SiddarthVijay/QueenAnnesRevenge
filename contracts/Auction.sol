pragma solidity >=0.4.22 <0.8.0;

contract Auction {
    bool public biddingClosed;
    bool public isAuctionClosed;
    uint256 public bidPeriodEndTime;
    uint256 public auctionEndTime;
    address public beneficiary;

    constructor(
        uint256 _bidPeriod,
        uint256 _auctionPeriod,
        address _beneficiary
    ) public {
        bidPeriodEndTime = block.timestamp + _bidPeriod;
    }
}
