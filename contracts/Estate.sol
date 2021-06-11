pragma solidity ^0.5.0;

import "./ERC721Tradable.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

/**
 * @title Estate
 * Estate - a contract for my non-fungible creatures.
 */
contract Estate is ERC721Tradable {
    constructor(address proxyRegistryAddress)
        public
        ERC721Tradable("Estate", "BNFT", proxyRegistryAddress)
    {}

    function verify(bytes32 data, bytes32 signature) pure returns (bool) {
        return keccack256(data)
            .toEthSignedMessageHash()
            .recover(signature) == owner;
    }

    function canMint(bytes32 signature, uint blockNo, uint32 topLeftY, uint32 topLeftX32, uint32 bottomRightY, uint32 bottomRightX) public view returns (bool) {
        require (block.number <= blockNo + 20);

        data = keccak256(abi.encodePacked(msg.sender, blockNo, topLeftX, topLeftY, bottomRightX, bottomRightY));
        return _verify(data, signature);

        //XXX: todo - fees!
    }

    function baseTokenURI() public pure returns (string memory) {
        return "https://github.com/BillionNFTHomepage/www/";
    }

    function contractURI() public pure returns (string memory) {
        return "https://github.com/BillionNFTHomepage/www";
    }
}