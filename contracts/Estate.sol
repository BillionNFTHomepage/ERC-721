pragma solidity ^0.5.0;

import "./ERC721Tradable.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

/**
 * @title Estate
 * Estate - a contract for my non-fungible creatures.
 */
contract Estate is ERC721Tradable {
    constructor(address _proxyRegistryAddress)
        public
        ERC721Tradable("Estate", "BNFT", _proxyRegistryAddress)
    {}

    // function canMint(bytes23 _signature, bytes32 _signedHash, uint _blockNo, uint _topLeftY, uint _topLeftX, uint _bottomRightY, uint _bottomRightX) public view returns (bool) {
        // require (block.number <= _blockNo + 20);
        // require (_hashedMsg = keccak256(abi.encodePacked(_blockNo, _topLeftY, _topLeftX, 
        //     _bottomRightY, _bottomRightX)));
        // require (operatingAccount == _signedHash.recover(_signature));

        // Estate estate = Estate(nftAddress);
        // uint256 creatureSupply = estate.totalSupply();

        // uint256 numItemsAllocated = 0;
        // return creatureSupply < (ESTATE_SUPPLY - 1);
        // return true;
    // }

    function baseTokenURI() public pure returns (string memory) {
        return "https://github.com/BillionNFTHomepage/www/";
    }

    function contractURI() public pure returns (string memory) {
        return "https://github.com/BillionNFTHomepage/www";
    }
}