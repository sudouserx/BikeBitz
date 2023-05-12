require("@nomicfoundation/hardhat-toolbox");

//require("@nomiclabs/hardhat-ethers")
 require('dotenv').config()

 const GOERLI_RPC_URL = process.env.GOERLI_RPC_URL || 
"https://goerli.infura.io/v3/7a1b61cf070f4a9f80fb234c1d4c529a"
 const PRIVATE_KEY = process.env.PRIVATE_KEY

 module.exports = {
     defaultNetwork: "localhost",
     networks: {
         localhost: {
         },
         goerli: {
             url: GOERLI_RPC_URL,
             accounts: [PRIVATE_KEY],
             saveDeployments: true,
         },
     },

  solidity: "0.8.5",
};