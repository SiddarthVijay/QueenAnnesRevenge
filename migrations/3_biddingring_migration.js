const BiddingRing = artifacts.require("BiddingRing");

module.exports = function (deployer, auctionContract) {
    deployer.deploy(BiddingRing, auctionContract);
};
