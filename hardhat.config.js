require("@nomiclabs/hardhat-waffle");
require ('dotenv').config();
require("@nomiclabs/hardhat-etherscan");

const {PrivateKey, RinkebyURL, KovanURL, MumbaiURL, EtherscanApiKey} = process.env;


module.exports = {
  solidity: "0.8.7",
  defaultNetwork: "hardhat",
  networks: {
    rinkeby: {
      url: RinkebyURL,
      accounts: [PrivateKey]
    },
    mumbai: {
      url: MumbaiURL,
      accounts: [PrivateKey]
    },
    kovan: {
      url: KovanURL,
      accounts: [PrivateKey]
    }
  },
    etherscan: {
      apiKey: EtherscanApiKey
    },

};