const { ethers } = require("hardhat");
require("dotenv").config({ path: ".env" });
const { NFT_DEV_CONTRACT_ADDRESS } = require("../constants");

async function main() {
  const NFTDevContract = NFT_DEV_CONTRACT_ADDRESS;
  const NFTDevTokenContract = await ethers.getContractFactory("NFTDevToken");
  const deployedNFTDevTokenContract = await NFTDevTokenContract.deploy(NFTDevContract);
  console.log("NFTDevToken deployed to address:", deployedNFTDevTokenContract.address);
}


main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
