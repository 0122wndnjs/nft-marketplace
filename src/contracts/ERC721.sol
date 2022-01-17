// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

    /*
    building out the minting function:
        a. nft to point to an address
        b. keep track of the token ids
        c. keep track of token owner addresses to token ids
        d. keep track of how many tokens an owner address has
        e. create an event that emits a transfer log 
            - contract address, where it is being minted to, the id
    */

contract ERC721 {

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    // mapping in solidity creates a hash table of key pair values 

    // Mapping from token id to the owner
    mapping(uint256 => address) private _tokenOwner;

    // Mapping from owner to number of owned tokens
    mapping(address => uint256) private _OwnedTokensCount;

    function _exists(uint256 tokenId) internal view returns (bool) {
        // setting the address of nft owner to check the mapping of the address from tokenOwer at the tokenId
        address owner = _tokenOwner[tokenId];
        // return truthiness that address is not zero
        return owner != address(0);
    }

    function _mint(address to, uint256 tokenId) internal {
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
}