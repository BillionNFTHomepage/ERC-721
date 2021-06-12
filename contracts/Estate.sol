pragma solidity ^0.5.0;

import "./ERC721Tradable.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/cryptography/ECDSA.sol";

/**
 * @title Estate
 * Estate - a contract for my non-fungible creatures.
 */
contract Estate is Ownable, ERC721Tradable {
    constructor(address proxyRegistryAddress)
        public
        ERC721Tradable("Estate", "BNFT", proxyRegistryAddress)
    {}

    function canMint(bytes memory signature, uint blockNo, uint32 topLeftX, uint32 topLeftY, uint32 bottomRightX, uint32 bottomRightY) public view returns (bool) {
        require (block.number <= blockNo + 20);
        
        bytes memory data;
        bytes32 convertedData;
        
        data = abi.encodePacked(msg.sender, blockNo, topLeftX, topLeftY, bottomRightX, bottomRightY);
        convertedData = keccak256(data);
        convertedData = ECDSA.toEthSignedMessageHash(convertedData);
        address recoveredOwner = ECDSA.recover(convertedData, signature);
        
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