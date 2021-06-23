// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./ERC721Tradable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

/**
 * @title Estate
 * Estate - a contract for my non-fungible creatures.
 */
contract Estate is Ownable, ERC721Tradable {
    event EstateMinted(address to, uint blockNo, uint32 topLeftX, uint32 topLeftY, uint32 bottomRightX, uint32 bottomRightY);
    
    constructor(address proxyRegistryAddress)
        ERC721Tradable("Estate", "BNFT", proxyRegistryAddress)
    {}
    
    function mintTo(address to, bytes memory signature, uint blockNo, uint32 topLeftX, uint32 topLeftY, uint32 bottomRightX, uint32 bottomRightY) public onlyOwner returns (bool) {
        if (!canMint(to, signature, blockNo, topLeftX, topLeftY, bottomRightX, bottomRightY)) {
            return false;
        }

        super.mintTo(to);
        emit EstateMinted(to, blockNo, topLeftX, topLeftY, bottomRightX, bottomRightY);

        return true;
    }

    using ECDSA for bytes32;

    function canMint(address to, bytes memory signature, uint blockNo, uint32 topLeftX, uint32 topLeftY, uint32 bottomRightX, uint32 bottomRightY) public view returns (bool) {
        //require (block.number <= blockNo + 20);
        
        bytes memory data;
        bytes32 convertedData;
        
        data = abi.encodePacked(to, blockNo, topLeftX, topLeftY, bottomRightX, bottomRightY);
        convertedData = keccak256(data);
	address recoveredOwner = convertedData.toEthSignedMessageHash().recover(signature);

        return recoveredOwner == owner();
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://github.com/BillionNFTHomepage/www/";
    }

    function contractURI() public pure returns (string memory) {
        return "https://github.com/BillionNFTHomepage/www";
    }
}
