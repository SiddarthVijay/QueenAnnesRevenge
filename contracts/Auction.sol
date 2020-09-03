pragma solidity >=0.4.22 <0.8.0;

contract Auction {
    bool public biddingClosed;
    bool public AuctionClosed;
    // uint256 public bidPeriodEndTime;
    // uint256 public auctionEndTime;
    address public beneficiary;

    constructor(address _beneficiary) public {
        biddingClosed = false;
        auctionClosed = false;
    }

    function commitBid(uint256 bid) external {
        require(!biddingClosed);
    }
}
