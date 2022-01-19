// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import './ERC165.sol';
import './interfaces/IERC721.sol'; 

    /*
    building out the minting function:
        a. nft to point to an address
        b. keep track of the token ids
        c. keep track of token owner addresses to token ids
        d. keep track of how many tokens an owner address has
        e. create an event that emits a transfer log 
            - contract address, where it is being minted to, the id
    */

contract ERC721 is ERC165, IERC721 {

    // mapping in solidity creates a hash table of key pair values 

    // Mapping from token id to the owner
    mapping(uint256 => address) private _tokenOwner;

    // Mapping from owner to number of owned tokens
    mapping(address => uint256) private _OwnedTokensCount;

    // Mapping from token id to approved addresses
    mapping(uint256 => address) private _tokenApprovals;

    // 1. REGISTER the Interface for the ERC721 contracts so that it includes the following functions:
    // balanceOf, ownerOf, transferFrom
    // *note by register the interface: write the constructors with the according byte conversions
    
    // 2. REGISTER the Interface for the ERC721Enumerable contract so that includes
    // totalSupply, tokenByIndex, tokenOfOwnerByIndex
    
    // 3. REGISTER the Interface for the ERC721Metadata contract so that includes
    // name, symbol

    constructor() {
        _registerInterface(bytes4(keccak256('balanceOf(bytes4)')^
        keccak256('ownerOf(bytes4)')^keccak256('transferFrom(bytes4)')));
    }

    /// @notice Count all NFTs assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this
    ///  function throws for queries about the zero address.
    /// @param _owner An address for whom to query the balance
    /// @return The number of NFTs owned by `_owner`, possibly zero
    function balanceOf(address _owner) public view override returns (uint256) {
        require(_owner != address(0), 'owner query for non-existent token');
        return _OwnedTokensCount[_owner];
    }

    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT
    function ownerOf(uint256 _tokenId) public view override returns (address) {
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), 'owner query for non-existent token');
        return owner;
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        // setting the address of nft owner to check the mapping of the address from tokenOwer at the tokenId
        address owner = _tokenOwner[tokenId];
        // return truthiness that address is not zero
        return owner != address(0);
    }

    function _mint(address to, uint256 tokenId) internal virtual {
        // requires that the address isn't zero
        require(to != address(0), 'ERC721: minting to the zero address');
        // requires that the token does not already exist
        require(!_exists(tokenId), 'ERC721: token already minted');
        // we are adding a new adderss with a token id for minting
        _tokenOwner[tokenId] = to;
        // keeping track of each address that is minting and adding one 
        _OwnedTokensCount[to] += 1;

        emit Transfer(address(0), to, tokenId);
    }

    /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
    ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
    ///  THEY MAY BE PERMANENTLY LOST
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
        // 1. add the token id to the address receiving the token
        // 2. update the balance of the address _from token
        // 3. update the balance of the address _to
        // 4. add the safe functionality:
        // a. require that the address receiving a token is not a zero address
        // b. require the address transfering the token actually owne the token

        require(_to != address(0), 'Error - ERC721 Transfer to the zero address');
        require(ownerOf(_tokenId) == _from, 'Trying to transfer a token the address does not own!');
        _OwnedTokensCount[_from] -= 1;
        _OwnedTokensCount[_to] += 1;
        _tokenOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) override public {
        require(isApprovedOrOwner(msg.sender, _tokenId));
        _transferFrom(_from, _to, _tokenId);
    }

    // 1. require that the person approving is the owner
    // 2. approve an address to a token (tokenId)
    // 3. require that we can't approve sending tokens of the owner to the owner (current caller)
    // 4. update the map of the approval addresses
    function approve(address _to, uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(_to != owner, 'Error - approval to current owner');
        require(msg.sender == owner, 'Current caller is not the owner of the token');
        _tokenApprovals[tokenId] = _to;

        emit Approval(owner, _to, tokenId);
    }

    function isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
        require(_exists(tokenId), 'token does not exist');
        address owner = ownerOf(tokenId);
        return(spender == owner);
    }
}