const assetContract = artifacts.require("asset");

module.exports = function(deployer) {
  deployer.deploy(assetContract);
};
