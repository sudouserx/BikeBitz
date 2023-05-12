// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
const fs = require("fs")

async function main() {
  const BASE_URI = "ipfs://QmSHHEwGszGkfJqDEKVQ7RNiCGrsR7kUn9MReusuBsfiWY";
  const TOKEN_NAME = "Bike Tyson";
  const TOKEN_SYMBOL = "BIKE";
  const PRICE = "5"

  const BikeFactory = await hre.ethers.getContractFactory("BikeFactory");
  const bike_factory = await BikeFactory.deploy(BASE_URI, PRICE, TOKEN_NAME, TOKEN_SYMBOL);

  await bike_factory.deployed();
  console.log("deployed address: ",bike_factory.address)


const content = bike_factory.address;

fs.writeFile('./deploymentAddress.txt', content, err => {
  if (err) {
    console.error(err);
  }
});

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
