
const { ethers, run } = require("hardhat");

const localChainId = "31337";

// const sleep = (ms) =>
//   new Promise((r) =>
//     setTimeout(() => {
//       console.log(`waited for ${(ms / 1000).toFixed(3)} seconds`);
//       r();
//     }, ms)
//   );

module.exports = async ({ getNamedAccounts, deployments, getChainId }) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = await getChainId();

  const talentDaoTokenContract = await deploy("TalentDaoToken", {
    from: deployer,
    args: ["0x3f15B8c6F9939879Cb030D6dd935348E57109637"],
    log: true,
  });

  await deploy("MembershipNftToken", {
    from: deployer,
    args: [
      "0x3f15B8c6F9939879Cb030D6dd935348E57109637",
      talentDaoTokenContract.address,
    ],
    log: true,
  });


  // Getting a previously deployed contract
  const MembershipNftToken = await ethers.getContract(
    "MembershipNftToken",
    deployer
  );

  await deploy("TalentDaoManager", {
    from: deployer,
    args: [
      "0x3f15B8c6F9939879Cb030D6dd935348E57109637", // contract manager
      "0x3f15B8c6F9939879Cb030D6dd935348E57109637", // contract owner
      TalentDAOTokenContract.address, // TDAO token address
      TalentDAONFTTokenContract.address, // TDAO NFT token address
      MembershipNftToken.address, // TDAO Member token address
    ],
    log: true,
    waitConfirmations: 5,
  });


  // Verify from the command line by running `yarn verify`

  // You can also Verify your contracts with Etherscan here...
  // You don't want to verify on localhost
  try {
    if (chainId !== localChainId) {
      await run("verify:verify", {
        address: TalentDAOTokenContract.address,
        contract: "contracts/TalentDaoToken.sol:TalentDaoToken",
        constructorArguments: ["0x3f15B8c6F9939879Cb030D6dd935348E57109637"],
      });
      
      await run("verify:verify", {
        address: MembershipNftToken.address,
        contract: "contracts/MembershipNftToken.sol:MembershipNftToken",
        constructorArguments: [
          "0x3f15B8c6F9939879Cb030D6dd935348E57109637",
          talentDaoTokenContract.address,
        ],
      });
      await run("verify:verify", {
        address: TalentDaoManagerContract.address,
        contract: "contracts/TalentDaoManager.sol:TalentDaoManager",
        constructorArguments: [
          "0x3f15B8c6F9939879Cb030D6dd935348E57109637", // contract manager
          "0x3f15B8c6F9939879Cb030D6dd935348E57109637", // contract owner
          MembershipNftToken.address, // TDAO Member token address
        ],
      });
    }
  } catch (error) {
    console.error(error);
  }
};
module.exports.tags = [
  "TalentDaoToken",
  "TalentDaoNftToken", 
  "TalentDaoManager",
];