// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;

contract BiddingRing {
    // events
    event bidMade(address bidder);
    event bidRevealed(address bidder, uint256 value, bool isValid);
    event BiddingClosed();
    event AuctionClosed(address barbossa, uint256 winnings);

    bool public biddingClosed;
    bool public auctionClosed;
    // Need to name this to be the Auction contract
    address payable public barbossa;

    address[] public validBidders;
    mapping(address => bytes32) public hashedEscrow;
    mapping(address => uint256) public escrow;

    constructor() public {
        biddingClosed = false;
        auctionClosed = false;
        barbossa = msg.sender;
    }

    function commitBid(bytes32 commit) external {
        require(!biddingClosed);

        hashedEscrow[msg.sender] = commit;

        emit bidMade(msg.sender);
    }

    function getCommitHash(uint256 value, uint256 nonce)
        internal
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(value, nonce));
    }

    function revealBid(uint256 nonce) external payable {
        require(biddingClosed);
        require(getCommitHash(msg.value, nonce) == hashedEscrow[msg.sender]);

        escrow[msg.sender] = msg.value;
        validBidders.push(msg.sender);

        emit bidRevealed(msg.sender, msg.value, true);
    }

    function highestBid() internal returns (address, uint256) {
        address tempWinner;
        uint256 highestBidAmt = 0;
        for (uint256 index = 0; index < validBidders.length; index++) {
            if (escrow[validBidders[index]] > highestBidAmt) {
                tempWinner = validBidders[index];
                highestBidAmt = escrow[tempWinner];
            }
        }

        escrow[tempWinner] = 0;
        return (tempWinner, highestBidAmt);
    }

    function closeBidding() external {
        require(msg.sender == barbossa);

        biddingClosed = true;

        emit BiddingClosed();
    }

    function closeAuctionAndCollectWinningBid() external {
        require(!auctionClosed);
        require(biddingClosed);
        require(msg.sender == barbossa);

        auctionClosed = true;

        address winningBidder;
        uint256 winningBid;
        (winningBidder, winningBid) = highestBid();

        // Need to send it to the contract instead
        barbossa.transfer(winningBid);

        emit AuctionClosed(barbossa, winningBid);
    }

    function withdrawBid() external {
        require(auctionClosed);

        if (escrow[msg.sender] > 0) {
            msg.sender.transfer(escrow[msg.sender]);
            escrow[msg.sender] = 0;
        }
    }

    // Write a withdrawBidFromAuction function that withdraws the bid that,
    // was given in the name of the BiddingRing and sends it to the winning pirate bidder
}
