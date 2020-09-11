// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;

import "./Auction.sol";

contract BiddingRing {
    Auction auction;
    uint256 nonce;
    // events
    event bidMade(address bidder);
    event bidRevealed(address bidder, uint256 value, bool isValid);
    event BiddingClosed();
    event AuctionClosed(address barbossa, address winner);
    event CommitRevealed(address winner, uint256 winnings);
    event ReceivedWinnings(address winner, uint256 winnings);

    bool public biddingClosed;
    bool public auctionClosed;
    bool public commitMade;
    // Need to name this to be the Auction contract
    address payable public barbossa;
    address public winningBidder;
    uint256 winningBid;

    address[] public validBidders;
    mapping(address => bytes32) public hashedEscrow;
    mapping(address => uint256) public escrow;

    constructor(address payable _AuctionContract) public {
        biddingClosed = false;
        auctionClosed = false;
        commitMade = false;
        barbossa = msg.sender;
        auction = Auction(_AuctionContract);
    }

    function commitBid(bytes32 commit) external {
        require(!biddingClosed);

        hashedEscrow[msg.sender] = commit;

        emit bidMade(msg.sender);
    }

    function getCommitHash(uint256 value, uint256 _nonce)
        internal
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(value, _nonce));
    }

    function revealBid(uint256 _nonce) external payable {
        require(biddingClosed);
        require(getCommitHash(msg.value, _nonce) == hashedEscrow[msg.sender]);

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

    function closeAuctionAndMakeCommit() external {
        require(!commitMade);
        require(biddingClosed);
        require(msg.sender == barbossa);

        commitMade = true;

        (winningBidder, winningBid) = highestBid();

        nonce = block.timestamp;

        bytes32 commit = keccak256(abi.encodePacked(winningBid, nonce));

        auction.commitBid(commit);

        emit AuctionClosed(barbossa, winningBidder);
    }

    function revealCommitToAuction() external payable {
        require(commitMade);
        require(msg.sender == barbossa);

        auction.revealBid{value: winningBid}(nonce);

        auctionClosed = true;

        emit CommitRevealed(winningBidder, winningBid);
    }

    function withdrawBid() external {
        require(auctionClosed);

        if (escrow[msg.sender] > 0) {
            msg.sender.transfer(escrow[msg.sender]);
            escrow[msg.sender] = 0;
        }
    }

    function withdrawWinningsFromAuctionAndReceive() external payable {
        require(auctionClosed);
        require(msg.sender == winningBidder);

        uint256 amount = auction.withdrawBid();

        msg.sender.transfer(amount);

        emit ReceivedWinnings(msg.sender, amount);
    }

    // Write a withdrawBidFromAuction function that withdraws the bid that,
    // was given in the name of the BiddingRing and sends it to the winning pirate bidder
}
