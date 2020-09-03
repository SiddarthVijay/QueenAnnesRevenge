// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;

contract Auction {
    bool public biddingClosed;
    bool public auctionClosed;
    // uint256 public bidPeriodEndTime;
    // uint256 public auctionEndTime;
    address payable public barbossa;

    address[] public validBidders;
    mapping(address => uint256) public hashedEscrow;
    mapping(address => uint256) public escrow;

    // constructor(address payable _barbossa) public {
    constructor() {
        biddingClosed = false;
        auctionClosed = false;
        barbossa = 0x89205A3A3b2A69De6Dbf7f01ED13B2108B2c43e7;
    }

    function commitBid(uint256 commit) external {
        require(!biddingClosed);

        hashedEscrow[msg.sender] = commit;
    }

    // function revealBid(uint256 nonce) external payable {
    function revealBid() external payable {
        require(biddingClosed);
        // require(msg.value == dehash(nonce, hashedEscrow[msg.sender]));

        escrow[msg.sender] = msg.value;
        validBidders.push(msg.sender);
    }

    function highestBid() internal returns (uint256) {
        address tempWinner;
        uint256 highestBidAmt = 0;
        uint256 secondHighestBidAmt = 0;
        for (uint256 index = 0; index < validBidders.length; index++) {
            if (escrow[validBidders[index]] > highestBidAmt) {
                tempWinner = validBidders[index];

                secondHighestBidAmt = highestBidAmt;
                highestBidAmt = escrow[tempWinner];
            }
        }

        escrow[tempWinner] -= secondHighestBidAmt;
        return secondHighestBidAmt;
    }

    function closeBidding() external {
        require(msg.sender == barbossa);

        biddingClosed = true;
    }

    function closeAuctionAndCollectWinningBid() external {
        require(!auctionClosed);
        require(biddingClosed);
        require(msg.sender == barbossa);

        auctionClosed = true;

        uint256 winningBid = highestBid();

        barbossa.transfer(winningBid);

        // Need to emit events
    }

    function withdrawBid() external {
        require(auctionClosed);

        if (escrow[msg.sender] > 0) {
            msg.sender.transfer(escrow[msg.sender]);
            escrow[msg.sender] = 0;

            // Need to emit event here too
        }
    }
}
