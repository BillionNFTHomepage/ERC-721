var Estate = artifacts.require("./Estate.sol");

module.exports = function(deployer) {
  deployer.deploy(Estate);
};
