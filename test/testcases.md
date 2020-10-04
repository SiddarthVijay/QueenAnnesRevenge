### Run the following commands after compiling, developing and deploying the program on Ethereum:

`let auc = await Auction.deployed({from: accounts[0]});`

`let ring = await BiddingRing.deployed({from: accounts[0]});`

`let com = await GenerateCommit.deployed({from: accounts[0]});`

`com.hash(2000000000, 100);`

`com.hash(1000000000, 100);`

`com.hash(1000000000, 1000);`

`web3.eth.getBalance(accounts[0]);`

`web3.eth.getBalance(accounts[1]);`

`web3.eth.getBalance(accounts[2]);`

`web3.eth.getBalance(accounts[3]);`

`auc.commitBid('0x4048c495c45cd9848666c81b7ec59844bb1a1ee002946d1b16ac04e277410c6f', {from: accounts[1]});`

`auc.commitBid('0x31ccd9c6526b4e3752c325ca832ff0249ac4607e155d0d5d9a1289f950ba24c6', {from: accounts[2]});`

`auc.commitBid('0x6abce7847871ea6ca090827adbc92ebcacd8a8b15ca3b82a60d8a7ff8854c08c', {from: accounts[3]});`

`auc.closeBidding({from: accounts[0]});`

`auc.revealBid(100, {value: 2000000000, from: accounts[1]});`

`auc.revealBid(100, {value: 1000000000, from: accounts[2]});`

`auc.revealBid(1000, {value: 1000000000, from: accounts[3]});`

`auc.closeAuctionAndCollectWinningBid({from: accounts[0]});`
