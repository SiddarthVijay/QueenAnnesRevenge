const GenerateCommit = artifacts.require("GenerateCommit");

module.exports = function (deployer) {
    deployer.deploy(GenerateCommit);
};
