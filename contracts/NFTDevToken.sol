//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./INFTDev.sol";

contract NFTDevToken is ERC20, Ownable {
    uint256 public constant tokenPrice = 0.001 ether;
    uint256 public constant tokensPerNFT = 10 * 10**18;
    uint256 public constant maxTotalSupply = 1000000 * 10**18;
    INFTDev NFTDev;

    mapping(uint256 => bool) public tokenIdsClaimed;

    constructor(address _NFTDevContract) ERC20("MyToken", "DEVT") {
        NFTDev = INFTDev(_NFTDevContract);
    }

    function mint(uint256 _amount) public payable {
        uint256 _amountTotal = tokenPrice * _amount;
        require(msg.value >= _amountTotal, "Please send more Ether");
        uint256 amountWithDecimals = _amount * 10**18;
        require(
            totalSupply() + amountWithDecimals <= maxTotalSupply,
            "Exceeds max supply"
        );
        _mint(msg.sender, amountWithDecimals);
    }

    function claim() public {
        address sender = msg.sender;
        uint256 balance = NFTDev.balanceOf(sender);
        require(balance > 0, "You do not own any NFTs to claim tokens");
        uint256 amount = 0;

        for (uint256 i = 0; i < balance; i++) {
            uint256 tokenId = NFTDev.tokenOfOwnerByIndex(sender, i);
            if (!tokenIdsClaimed[tokenId]) {
                amount += 1;
                tokenIdsClaimed[tokenId] = true;
            }
        }
        require(amount > 0, "You have claim all of your tokens");
        _mint(sender, amount * tokensPerNFT);
    }

    receive() external payable {}

    fallback() external payable {}
}
