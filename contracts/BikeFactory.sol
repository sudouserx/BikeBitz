// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "../interfaces/IERC4907.sol";

contract BikeFactory is ERC721, IERC4907 {
    event UpdateRentalFee(uint256 indexed tokenId, uint256 updatedRentalFee);

    struct UserInfo {
        address user; // address of user role
        uint64 expires; // unix timestamp, user expires
    }

    // using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    using Strings for uint256;

    mapping(uint256 => UserInfo) private _users;

    /// @notice While creating an nft ,( address => balance ) is initilized to 0
    mapping(address => uint256) private rentFeeBalance;

    /// @notice The fee is stored in unit of WEI ( tokenId => fee)
    mapping(uint256 => uint256) private feesPerMinute;

    string public BASE_URI;
    uint256 public MAX_SUPPLY = 10000;
    uint256 public PRICE = 0;

    constructor(
        string memory baseURI,
        uint256 price,
        string memory name,
        string memory symbol
    ) ERC721(name, symbol) {
        PRICE = price;
        BASE_URI = baseURI;
    }

    function _baseURI() internal view override returns (string memory) {
        return string(abi.encodePacked(BASE_URI, "/"));
    }

    /// @notice set the user and expires of a NFT
    /// @dev The zero address indicates there is no user
    /// Throws if `tokenId` is not valid NFT
    /// @param user  The new user of the NFT
    /// @param expires  UNIX timestamp, The new user could use the NFT before expires
    function setUser(
        uint256 tokenId,
        address user,
        uint64 expires
    ) public virtual override {
        require(
            _isApprovedOrOwner(msg.sender, tokenId),
            "ERC721: transfer caller is not owner nor approved"
        );
        require(userOf(tokenId) == address(0), "User already assigned");
        require(expires > block.timestamp, "expires should be in future");
        UserInfo storage info = _users[tokenId];
        info.user = user;
        info.expires = expires;
        emit UpdateUser(tokenId, user, expires);
    }

    function rentNFT(
        address addr,
        uint256 tokenId,
        uint64 expires
    ) public payable returns(uint256) {
        require(userOf(tokenId) == address(0), "User already assigned");

        require(expires > block.timestamp, "expires should be in future");

        // -- totalMinute = minuteOf(expires) - minuteOf(block.timestamp)
        uint256 minuteDiff = (1683889158 - block.timestamp)/ 60;
        uint256 calculatedFee = feesPerMinute[tokenId] * minuteDiff;

        require(msg.value >= calculatedFee, "insufficient fund");

        UserInfo storage info = _users[tokenId];
        info.user = addr;
        info.expires = expires;


        /// @notice while minting nft, set the rentFeeBalance[minterAddress] = 0
        rentFeeBalance[ownerOf(tokenId)] += msg.value;
        emit UpdateUser(tokenId, addr, expires);

        return tokenId;
    }

    /// @notice Get the user address of an NFT
    /// @dev The zero address indicates that there is no user or the user is expired
    /// @param tokenId The NFT to get the user address for
    /// @return The user address for this NFT
    function userOf(
        uint256 tokenId
    ) public view virtual override returns (address) {
        if (uint256(_users[tokenId].expires) >= block.timestamp) {
            return _users[tokenId].user;
        }
        return address(0);
    }

    /// @notice Get the user expires of an NFT
    /// @dev The zero value indicates that there is no user
    /// @param tokenId The NFT to get the user expires for
    /// @return The user expires for this NFT
    function userExpires(
        uint256 tokenId
    ) public view virtual override returns (uint256) {
        return _users[tokenId].expires;
    }

    /// @dev See {IERC165-supportsInterface}.
    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC721) returns (bool) {
        return
            interfaceId == type(IERC4907).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    function nftMint(
        address addr,
        uint256 feePerMinute
    ) public payable returns (uint256) {
        uint256 supply = totalSupply();
        require(supply <= MAX_SUPPLY, "maximum mint reached");
        require(msg.value >= PRICE, "insufficient funds from the factory");
        _tokenIdCounter.increment();
        uint256 tokenId = _tokenIdCounter.current();
        _safeMint(addr, tokenId);
        feesPerMinute[tokenId] = feePerMinute;
        rentFeeBalance[addr] = 0;

        console.log(tokenId);

        return tokenId;
    }

    // update feePerMinute
    function updateFeePerMinute(uint256 updatedFee, uint256 tokenId) public {
        // check the existance of the token ??

        require(
            msg.sender == ownerOf(tokenId),
            "Unauthorized to update the fee"
        );
        feesPerMinute[tokenId] = updatedFee;

        emit UpdateRentalFee(tokenId, updatedFee);
    }

    /// @notice Query this to get the list of token ids available
    // @ can be used to query the metadata of each nft
    // getMetadata( uint256 tokenId) public view returns( memory metadata)
    // token ids ( 0 -- tokenIdCounter.current())
    function lastTokenId() public view returns (uint256) {
        return _tokenIdCounter.current();
    }

    /// @notice Not the total supply ! it counts burned tokens as well
    function totalSupply() internal view returns (uint256) {
        return _tokenIdCounter.current();
    }

    function withdraw(uint256 amount, uint256 tokenId) public {
        require(
            msg.sender == ownerOf(tokenId),
            "Unauthorized as the owner of the token"
        );
        require(amount <= rentFeeBalance[msg.sender], "Not enough balance");
        payable(msg.sender).transfer(amount);
        rentFeeBalance[msg.sender] -= amount;
    }

    // string [] tokenURIs;
    // function listOfTokenUriAvailable() public returns(string memory []) {

    // }
}
