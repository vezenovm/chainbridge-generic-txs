const BridgeExecutor = artifacts.require("BridgeExecutor");
const Storage = artifacts.require("Storage");
const BridgeFungibleToken = artifacts.require("BridgeFungibleToken");

module.exports = async function(deployer) {
  // Deploy BridgeExecutor, then deploy Storage, passing in BridgeExecutor's newly deployed address
  // deployer.deploy(BridgeExecutor, "0x3e51e1e60455fD37418E7252674F20C300E5B7EF", "0x09C7d6C18ef5f13394396e2De94dBD983414aD0B").then(function() {
  //   return deployer.deploy(Storage, BridgeExecutor.address);
  // });

  // await deployer.deploy(BridgeExecutor, "0x3e51e1e60455fD37418E7252674F20C300E5B7EF", "0x09C7d6C18ef5f13394396e2De94dBD983414aD0B");
  // const bridgeExecutorContract = await BridgeExecutor.deployed();
  deployer.deploy(BridgeFungibleToken, "0x3e51e1e60455fD37418E7252674F20C300E5B7EF", "0x09C7d6C18ef5f13394396e2De94dBD983414aD0B");
  // deployer.deploy(Storage, "0x169c74c97c1BFFA672eFC40B64Acfb68f07339f7");
};
