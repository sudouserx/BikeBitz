const hre = require("hardhat");
const fs = require("fs");

async function main() {
  try {
    const Contract = await hre.ethers.getContractFactory("BikeFactory");
    const contract = await Contract.attach(
      `${address}` // The deployed contract address
    );

    const user = await contract.userOf(1);
    console.log("User of : ", user);
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
