pragma solidity ^0.5.0;

import "./ERC721Tradable.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/cryptography/ECDSA.sol";

/**
 * @title Estate
 * Estate - a contract for my non-fungible creatures.
 */
contract Estate is Ownable, ERC721Tradable {
    event EstateMinted(address to, uint blockNo, uint32 topLeftX, uint32 topLeftY, uint32 bottomRightX, uint32 bottomRightY);
    
    constructor(address proxyRegistryAddress)
        public
        ERC721Tradable("Estate", "BNFT", proxyRegistryAddress)
    {}
    
    function mintTo(address to, bytes memory signature, uint blockNo, uint32 topLeftX, uint32 topLeftY, uint32 bottomRightX, uint32 bottomRightY) public onlyOwner (bool) {
        if (!canMint(to, signature, blockNo, topLeftX, topLeftY, bottomRightX, bottomRightY)) {
            return false;
        }

        super.mintTo(to);
        emit EstateMinted(to, blockNo, topLeftX, topLeftY, bottomRightX, bottomRightY);

        return true;
    }

    using ECDSA for bytes32;

    function canMint(address to, bytes memory signature, uint blockNo, uint32 topLeftX, uint32 topLeftY, uint32 bottomRightX, uint32 bottomRightY) public returns (bool) {
        //require (block.number <= blockNo + 20);
        
        bytes memory data;
        bytes32 convertedData;
        
        data = abi.encodePacked(to, blockNo, topLeftX, topLeftY, bottomRightX, bottomRightY);
        convertedData = keccak256(data);

        return recoveredOwner == owner();

        //XXX: todo - fees!
    }

    function baseTokenURI() public pure returns (string memory) {
        return "https://github.com/BillionNFTHomepage/www/";
    }

    function contractURI() public pure returns (string memory) {
        return "https://github.com/BillionNFTHomepage/www";
    }
}