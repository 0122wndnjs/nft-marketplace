// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import './ERC721Connector.sol';

contract KryptoBird is ERC721Connector {

    // array to store our nfts
    string [] public kryptoBirdz;

    mapping(string => bool) _kryptoBirdzExists;
    
    function mint(string memory _kryptoBird) public {
        require(!_kryptoBirdzExists[_kryptoBird], 'Error - kryptoBird already exists');
        // this is deprecated - uint _id = KryptoBirdz.push(_kryptoBird);
        kryptoBirdz.push(_kryptoBird);
        uint _id = kryptoBirdz.length - 1;
        // .push no longer returns the length but a ref to the added element
        _mint(msg.sender, _id);
    }
    
    // initialize this contract to inherit name and symbol from erc732metadata
    // so that the name is KryptoBird and the symbol is KBIRDZ
    
    constructor() ERC721Connector('KryptoBird', 'KBIRDZ') {

    }
}