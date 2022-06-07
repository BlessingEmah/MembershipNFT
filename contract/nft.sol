//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

///@title The NEW membership NFT contract
///@author BlessingEmah

contract NewNft is Ownable, ERC721URIStorage {
    using Counters for Counters.Counter;
    //using safeERC20 for IERC20;

    Counters.Counter private _tokenIds;

    address public treasury;
    address public newTokenAddress;
    IERC20 private newToken;

    constructor(address _owner, address _newToken) ERC721("New NFT", "NN") {
        newToken = IERC20(_newToken);
        newTokenAddress = _newToken;
        _transferOwnership(_owner);
    }

    ///@dev for Opensea
function contractURI() public pure returns (string memory){
    return "";
}

///@dev this is an internal mint function
 /// @param ownerAddress the user that is minting the token address
/// @param tokenURI the metadata uri for the nft
/// @param amount the amount of tdao tokens submitting
function mintNewnft(address ownerAddress, string memory tokenURI, uint256 amount) public returns(uint256) {
    require(newToken.balanceOf(msg.sender) > amount, "you dont have enough New Token");
    newToken.transferFrom(ownerAddress, treasury, amount);
    _tokenIds.increment();

    //mint the nft to the owner
    uint256 newItemId = _tokenIds.current();
    _mint(ownerAddress, newItemId);
    _setTokenURI(newItemId, tokenURI);

    return (newItemId);
}

////////////////////  Only Owner Functions ////////////////////

///@dev public function to set the token URI
///@param _tokenId the id of the token to update
///@param _tokenURI the new token URI

function setTokenURI (uint256 _tokenId, string memory _tokenURI) public onlyOwner{
    _setTokenURI(_tokenId, _tokenURI);
}

function getContractBalance(address token) public view onlyOwner returns(uint256) {
    return IERC20(token).balanceOf(address(this));
}

function withdrawNewToken() public onlyOwner {
    newToken.transferFrom(address(this), _msgSender(), newToken.balanceOf(address(this)));
}

 
}

