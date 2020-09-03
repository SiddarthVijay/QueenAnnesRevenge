pragma solidity >=0.4.22 <0.8.0;

contract Auction {
    bool public biddingClosed;
    bool public auctionClosed;
    // uint256 public bidPeriodEndTime;
    // uint256 public auctionEndTime;
    address public barbossa;

    address[] public validBidders;
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
        validBidder.append(msg.sender);
    }

    function highestBid() internal view returns (address, uint256) {
        address memory tempWinner;
        uint256 memory highestBidAmt = 0;
        uint256 memory secondHighestBidAmt = 0;
        for (uint256 index = 0; index < escrow.length; index++) {
            if (escrow[validBidders[index]] > highestBidAmt) {
                tempWinner = validBidders[index];

                secondHighestBidAmt = highestBidAmt;
                highestBidAmt = escrow[tempWinner];
            }
        }

        return (tempWinner, secondHighestBidAmt);
    }

    function closeBidding() external {
        require(msg.sender == barbossa);

        biddingClosed = true;
    }

    function closeAuctionAndCollectWinningBid() external {
        require(!auctionClosed);
        require(biddingClosed);
        require(msg.sender == barbossa);
    }
}
