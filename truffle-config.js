var HDWalletProvider = require("@truffle/hdwallet-provider");

module.exports = {
  // Uncommenting the defaults below
  // provides for an easier quick-start with Ganache.
  // You can also follow this format for other networks.
  // See details at: https://trufflesuite.com/docs/truffle/reference/configuration
  // on how to specify configuration options!
  compilers: {
    solc: {
        version: "0.8.13"  
    }
  },
  networks: {
   development: {
     host: "127.0.0.1",
     port: 7545,
     network_id: "*"
   },
   test: {
     host: "127.0.0.1",
     port: 7545,
     network_id: "*"
   },
    // Useful for deploying to a public network.
    // NB: It's important to wrap the provider as a function.
   rinkeby: {
      provider: () => new HDWalletProvider("c9ec096ae21fba882478e666cf78440d9dc27fd50512cad63365e97f18d6d13b", `https://eth-rinkeby.alchemyapi.io/v2/Pgb6UvWBwyYNRyn1_19HqhSpbRtK-74W`),
      network_id: 4,       // Rinkeby's id
      gas: 4500000,        // Rinkeby has a lower block limit than mainnet
      confirmations: 2,    // # of confs to wait between deployments. (default: 0)
      timeoutBlocks: 200,  // # of blocks before a deployment times out  (minimum/default: 50)
      skipDryRun: true     // Skip dry run before migrations? (default: false for public nets )
    },
  },
  
  // Truffle DB is currently disabled by default; to enable it, change enabled:
  // false to enabled: true. The default storage location can also be
  // overridden by specifying the adapter settings, as shown in the commented code below.
  
  // NOTE: It is not possible to migrate your contracts to truffle DB and you should
  // make a backup of your artifacts to a safe location before enabling this feature.
  
  // After you backed up your artifacts you can utilize db by running migrate as follows:
  // $ truffle migrate --reset --compile-all
  
  db: {
    enabled: false,
    host: "127.0.0.1",
    adapter: {
      name: "sqlite",
      settings: {
        directory: ".db"
      }
    }
  }
};
