# BikeFactory Smart Contract

This repository contains the smart contract for the BikeFactory project. The BikeFactory contract is an ERC721-compliant contract that allows users to mint and manage non-fungible tokens (NFTs) representing bicycles. It includes functionalities for setting users, renting NFTs, updating rental fees, and more.

## Features

- Mint new NFTs representing bicycles
- Set users and expiration dates for NFTs
- Rent NFTs and calculate rental fees
- Update rental fees per minute
- Withdraw rental fees

## Installation

To use the BikeFactory contract, follow these steps:

1. Clone this repository:

   ```shell
   git clone https://github.com/sudouserx/BikeBitz.git
   ```

2. Install the required dependencies:

   ```shell
   npm install
   ```

3. Deploy the contract to your desired blockchain network using a development tool like Hardhat.

## Usage

To interact with the BikeFactory contract, you can use various functions exposed by the contract:

- `nftMint`: Mint a new NFT representing a bicycle.
- `setUser`: Set the user and expiration date for an NFT.
- `rentNFT`: Rent an NFT and calculate the rental fee.
- `updateFeePerMinute`: Update the rental fee per minute for an NFT.
- `userOf`: Get the user address of an NFT.
- `userExpires`: Get the expiration date of an NFT user.
- `withdraw`: Withdraw rental fees from the contract.

Please refer to the contract code for more details on each function's parameters and usage.
