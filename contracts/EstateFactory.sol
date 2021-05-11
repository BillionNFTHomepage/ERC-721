pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/cryptography/ECDSA.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "./IFactoryERC721.sol";
import "./Estate.sol";
import "./Strings.sol";

contract EstateFactory is FactoryERC721, Ownable {
    // using Strings for string;
    // using ECDSA for bytes32;

    // event Transfer(
    //     address indexed from,
    //     address indexed to,
    //     uint256 indexed tokenId
    // );

    // address public proxyRegistryAddress;
    // address public nftAddress;
    // address public operatingAccount;
    // string public baseURI = "https://github.com/BillionNFTHomepage/www/";
    // uint256 fee;

    // /**
    //  * Enforce the existence of only 100 estates.
    //  */
    // uint256 ESTATE_SUPPLY = 1000000;

    // constructor(address _proxyRegistryAddress, address _nftAddress, address _operatingAccount, uint _fee) public {
    //     proxyRegistryAddress = _proxyRegistryAddress;
    //     nftAddress = _nftAddress;
    //     operatingAccount = _operatingAccount;
    //     fee = _fee;
    // }

    // function name() external view returns (string memory) {
    //     return "Estate Factory";
    // }

    // function symbol() external view returns (string memory) {
    //     return "BNFT";
    // }

    // function supportsFactoryInterface() public view returns (bool) {
    //     return true;
    // }

    // function changeFee(uint _fee) public onlyOwner {
    //     fee = _fee;
    // }


    // // XXX: TODO - check fee calculation
    // // function payFee(uint _topLeftY, uint _topLeftX, uint _bottomRightY, uint _bottomRightX) public returns (bool) {
    // //     // free for airdrops etc..
    // //     if (owner() == msg.sender)
    // //         return true;

    // //     uint pixels = (_topLeftY - _bottomRightY) * (_bottomRightX - _topLeftX);
    // //     require(msg.value >= fee * 10**18 * pixels);

    // //     operatingAccount.transfer(msg.value);
    // //     return true;
    // // }

    // function mint(address _toAddress, bytes23 _signature, bytes32 _hashedMsg, 
    //     uint _blockNo, uint _topLeftY, uint _topLeftX, uint _bottomRightY, 
    //     uint _bottomRightX) public payable {
    //     // make sure there a fee for minting
    //     // require(payFee(_topLeftY, _topLeftX, _bottomRightY, _bottomRightX));

    //     // Must be sent from the owner proxy or owner.
    //     ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
    //     assert(
    //         address(proxyRegistry.proxies(owner())) == msg.sender ||
    //             owner() == msg.sender 
    //     );

    //     Estate estate = Estate(nftAddress);
    //     estate.mintTo(_toAddress);
    // }

    // function tokenURI() external view returns (string memory) {
    //     return baseURI;
    // }

    // /**
    //  * Hack to get things to work automatically on estate.
    //  * Use transferFrom so the frontend doesn't have to worry about different method names.
    //  */
    // function transferFrom(
    //     address _from,
    //     address _to,
    //     uint256 _tokenId
    // ) public {
    //     // mint(_tokenId, _to);
    // }

    // /**
    //  * Hack to get things to work automatically on estate.
    //  * Use isApprovedForAll so the frontend doesn't have to worry about different method names.
    //  */
    // function isApprovedForAll(address _owner, address _operator)
    //     public
    //     view
    //     returns (bool)
    // {
    //     if (owner() == _owner && _owner == _operator) {
    //         return true;
    //     }

    //     ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
    //     if (
    //         owner() == _owner &&
    //         address(proxyRegistry.proxies(_owner)) == _operator
    //     ) {
    //         return true;
    //     }

    //     return false;
    // }

    // /**
    //  * Hack to get things to work automatically on estate.
    //  * Use isApprovedForAll so the frontend doesn't have to worry about different method names.
    //  */
    // function ownerOf(uint256 _tokenId) public view returns (address _owner) {
    //     return owner();
    // }
}
