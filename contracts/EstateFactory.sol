pragma solidity ^0.8.3;

import "openzeppelin-solidity/contracts/utils/cryptography/ECDSA.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "./IFactoryERC721.sol";
import "./Estate.sol";
// import "./EstateLootBox.sol";
import "./Strings.sol";

contract EstateFactory is FactoryERC721, Ownable {
    using Strings for string;
    using ECDSA for bytes32;

    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );

    address public proxyRegistryAddress;
    address public nftAddress;
    address public lootBoxNftAddress;
    address public operatingAccount;
    string public baseURI = "https://creatures-api.opensea.io/api/factory/";

    /**
     * Enforce the existence of only 100 estates.
     */
    uint256 ESTATE_SUPPLY = 100;

    /**
     * Three different options for minting Estates (basic, premium, and gold).
     */
    uint256 NUM_OPTIONS = 1;

    constructor(address _proxyRegistryAddress, address _nftAddress, address _operatingAccount, uint _fee) public {
        proxyRegistryAddress = _proxyRegistryAddress;
        nftAddress = _nftAddress;
        operatingAccount = _operatingAccount;
        fee = _fee;
        lootBoxNftAddress = address(
            new EstateLootBox(_proxyRegistryAddress, address(this))
        );

    }

    function name() external view returns (string memory) {
        return "Estate Item Sale";
    }

    function symbol() external view returns (string memory) {
        return "BNFT";
    }

    function supportsFactoryInterface() public view returns (bool) {
        return true;
    }

    function numOptions() public view returns (uint256) {
        return NUM_OPTIONS;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        address _prevOwner = owner();
        super.transferOwnership(newOwner);
        emit Transfer(_prevOwner, newOwner);
    }

    function changeOperatingAccount(uint operatingAccount) public onlyOwner {
        operatingAccount = _operatingAccount;
    }

    function changeFee(uint fee) public onlyOwner {
        fee = _fee;
    }


    // XXX: TODO - check fee calculation
    function payFee(uint _topLeftLatitude, uint _topLeftLongitude, uint _bottomRightLatitude, _bottomRightLongitude) public returns (bool) {
        // free for airdrops etc..
        if (owner() == msg.sender)
            return true;

        uint pixels = (_topLeftLatitude - _bottomRightLatitude) * (_bottomRightLongitude - _topLeftLongitude);
        require(msg.value >= fee * 10**18 * pixels);

        operatingAccount.transfer(msg.value);
        return true;
    }

    function mint(uint256 _optionId, address _toAddress, bytes23 _signature, bytes32 _hashedMsg, 
        uint _blockNo, uint _topLeftLatitude, uint _topLeftLongitude, uint _bottomRightLatitude, 
        uint _bottomRightLongitude) public payable {
        // make sure there a fee for minting
        require(payFee(_topLeftLatitude, _topLeftLongitude, _bottomRightLatitude, _bottomRightLongitude));

        // Must be sent from the owner proxy or owner.
        ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
        assert(
            address(proxyRegistry.proxies(owner())) == msg.sender ||
                owner() == msg.sender 
        );
        require(canMint(_optionId, _signature, _hashedMsg, _topLeftLatitude, _topLeftLongitude,
            _bottomRightLatitude, _bottomRightLongitude, _blockNo));

        Estate openSeaEstate = Estate(nftAddress);
        if (_optionId == SINGLE_ESTATE_OPTION) {
            openSeaEstate.mintTo(_toAddress);
        } 
    }

    function canMint(uint256 _optionId, bytes23 _signature, bytes32 _hashedMsg, uint _blockNo,
        uint _topLeftLatitude, _topLeftLongitude, _bottomRightLatitude, _botomRightLongitude
        ) public view returns (bool) {
        // XXX: TODO - make sure that the signed block number isn't too far away from
        // the curent block. Also check the signature. We want to make sure the current block is < 20 blocks
        // ftrom when it was signed
        require (block.number <= _blockNo + 20);
        require (_hashedMsg = keccak256(abi.encodePacked(blockNo, _topLeftLatitude, _topLeftLongitude, 
            _bottomRightLatitude, _bottomRightLongitude)));
        require (operatingAccount == _signedHash.recover(_signature));

        if (_optionId >= NUM_OPTIONS) {
            return false;
        }

        Estate openSeaEstate = Estate(nftAddress);
        uint256 creatureSupply = openSeaEstate.totalSupply();

        uint256 numItemsAllocated = 0;
        if (_optionId == SINGLE_ESTATE_OPTION) {
            numItemsAllocated = 1;
        } 
        return creatureSupply < (ESTATE_SUPPLY - numItemsAllocated);
    }

    function tokenURI(uint256 _optionId) external view returns (string memory) {
        return Strings.strConcat(baseURI, Strings.uint2str(_optionId));
    }

    /**
     * Hack to get things to work automatically on OpenSea.
     * Use transferFrom so the frontend doesn't have to worry about different method names.
     */
    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) public {
        mint(_tokenId, _to);
    }

    /**
     * Hack to get things to work automatically on OpenSea.
     * Use isApprovedForAll so the frontend doesn't have to worry about different method names.
     */
    function isApprovedForAll(address _owner, address _operator)
        public
        view
        returns (bool)
    {
        if (owner() == _owner && _owner == _operator) {
            return true;
        }

        ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
        if (
            owner() == _owner &&
            address(proxyRegistry.proxies(_owner)) == _operator
        ) {
            return true;
        }

        return false;
    }

    /**
     * Hack to get things to work automatically on OpenSea.
     * Use isApprovedForAll so the frontend doesn't have to worry about different method names.
     */
    function ownerOf(uint256 _tokenId) public view returns (address _owner) {
        return owner();
    }
}
