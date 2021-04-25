pragma solidity ^0.5.11;

import "multi-token-standard/contracts/interfaces/IERC721TokenReceiver.sol";

import "../EstateFactory.sol";


contract TestForReentrancyAttack is IERC721TokenReceiver {
    // bytes4(keccak256("onERC721Received(address,address,uint256,uint256,bytes)"))
    bytes4 constant internal ERC721_RECEIVED_SIG = 0xf23a6e61;
    // bytes4(keccak256("onERC721BatchReceived(address,address,uint256[],uint256[],bytes)"))
    bytes4 constant internal ERC721_BATCH_RECEIVED_SIG = 0xbc197c81;
    // bytes4(keccak256("onERC721Received(address,address,uint256,uint256,bytes)")) ^ bytes4(keccak256("onERC721BatchReceived(address,address,uint256[],uint256[],bytes)"))
    bytes4 constant internal INTERFACE_ERC721_RECEIVER_FULL = 0x4e2312e0;
    //bytes4(keccak256('supportsInterface(bytes4)'))
    bytes4 constant internal INTERFACE_ERC165 = 0x01ffc9a7;

    address public factoryAddress;
    uint256 private totalToMint;

    constructor() public {}

    function setFactoryAddress(address _factoryAddress) external {
        factoryAddress = _factoryAddress;
        totalToMint = 3;
    }

    /*function attack(uint256 _totalToMint) external {
        require(_totalToMint >= 2, "_totalToMint must be >= 2");
        totalToMint = _totalToMint;
        EstateFactory(factoryAddress).mint(1, address(this), 1, "");
        }*/

    // We attempt a reentrancy attack here by recursively calling the
    // EstateFactory that created the Estate ERC721 token
    // that we are receiving here.
    // We expect this to fail if the EstateFactory.mint() function
    // defends against reentrancy.

    function onERC721Received(
        address /*_operator*/,
        address /*_from*/,
        uint256 _id,
        uint256 /*_amount*/,
        bytes calldata /*_data*/
    )
        external
        returns(bytes4)
    {
        uint256 balance = IERC721(msg.sender).balanceOf(address(this), _id);
        if(balance < totalToMint)
        {
            // 1 is the factory lootbox option, not the token id
            EstateFactory(factoryAddress)
                .mint(1, address(this), 1, "");
        }
        return ERC721_RECEIVED_SIG;
    }

    function supportsInterface(bytes4 interfaceID)
        external
        view
        returns (bool)
    {
        return interfaceID == INTERFACE_ERC165 ||
            interfaceID == INTERFACE_ERC721_RECEIVER_FULL;
    }

    // We don't use this but we need it for the interface

    function onERC721BatchReceived(address /*_operator*/, address /*_from*/, uint256[] memory /*_ids*/, uint256[] memory /*_values*/, bytes memory /*_data*/)
        public returns(bytes4)
    {
        return ERC721_BATCH_RECEIVED_SIG;
    }
}
