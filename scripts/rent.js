const hre = require("hardhat");
const fs = require("fs");

const wallet2 = "0x70997970C51812dc3A010C7d01b50e0d17dc79C8";

async function main() {
  try {
    const Contract = await hre.ethers.getContractFactory("BikeFactory");
    const contract = await Contract.attach(
      `${address}` // The deployed contract address
    );

    let overrides = {
      value: ethers.utils.parseEther((3).toString()),
    };
    const tx = await contract.rentNFT(
      "0x70997970C51812dc3A010C7d01b50e0d17dc79C8",
      1,
      1683889158,
      overrides,
    );

    console.log("Rented: ", tx);
  } catch (error) {
    console.log(error);
  }
}

var address;
fs.readFile("./deploymentAddress.txt", "utf8", (err, data) => {
  if (err) {
    console.error(err);
    return;
  }
  address = data;
});

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
