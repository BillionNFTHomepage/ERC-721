pragma solidity ^0.5.0;

import "./ERC721Tradable.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/cryptography/ECDSA.sol";

/**
 * @title Estate
 * Estate - a contract for my non-fungible creatures.
 */
contract Estate is Ownable, ERC721Tradable {
    event DebugSignature(bytes data);
    event DebugBytes(bytes data);
    event DebugBytes32(bytes32 data);
    event RecoveredOwner(address owner);
    event EmitAddress(address addy);
    event Length(uint length);
    event Msg(string msg);
    
    constructor(address proxyRegistryAddress)
        public
        ERC721Tradable("Estate", "BNFT", proxyRegistryAddress)
    {}
    
    //function mintTo(address to, bytes memory signature, uint blockNo, uint32 topLeftX, uint32 topLeftY, uint32 bottomRightX, uint32 bottomRightY) public onlyOwner {
    //    if (canMint(to, signature, blockNo, topLeftX, topLeftY, bottomRightX, bottomRightY)) {
    //        super.mintTo(to);
    //    }
    //}

    using ECDSA for bytes32;

    function canMint(address to, bytes memory signature, uint blockNo, uint32 topLeftX, uint32 topLeftY, uint32 bottomRightX, uint32 bottomRightY) public returns (bool) {
        //require (block.number <= blockNo + 20);
        
        bytes memory data;
        bytes32 convertedData;
        
        data = abi.encodePacked(to, blockNo, topLeftX, topLeftY, bottomRightX, bottomRightY);
        emit DebugBytes(data);
        convertedData = keccak256(data);
        emit DebugBytes32(convertedData);
        convertedData = convertedData.toEthSignedMessageHash();
        emit DebugBytes32(convertedData);
        address recoveredOwner = convertedData.recover(signature);
        emit RecoveredOwner(recoveredOwner);

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