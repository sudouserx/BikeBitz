const hre = require("hardhat");
const fs = require("fs");

async function main() {
  try {
    const Contract = await hre.ethers.getContractFactory("BikeFactory");
    const contract = await Contract.attach(
      `${address}` // The deployed contract address
    );

    let overrides = {
      value: ethers.utils.parseEther((0.5).toString()),
    };
    const tx = await contract.nftMint(
      "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266",
      ethers.utils.parseEther((0.000005).toString()),
      overrides
    );

    console.log("Minted: ", tx);
  } catch (error) {
    console.log(error);
  }
}

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
