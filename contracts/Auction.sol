pragma solidity >=0.4.22 <0.8.0;

contract Auction {
    bool public biddingClosed;
    bool public auctionClosed;
    // uint256 public bidPeriodEndTime;
    // uint256 public auctionEndTime;
    address public barbossa;

    mapping(address => uint256) public hashedEscrow;
    mapping(address => uint256) public escrow;

    constructor(address _barbossa) public {
        biddingClosed = false;
        auctionClosed = false;
        barbossa = _barbossa;
    }

    function commitBid(uint256 commit) external {
        require(!biddingClosed);

        hashedEscrow[msg.sender] = commit;
    }

    function revealBid(uint256 nonce) external payable {
        require(biddingClosed);
        // require(msg.value == dehash(nonce, hashedEscrow[msg.sender]));

        escrow[msg.sender] = msg.value;
    }
}
