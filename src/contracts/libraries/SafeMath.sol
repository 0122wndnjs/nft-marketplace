// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

library SafeMath {
    // build functions to perform safemath operations that would otherwise replace 
    // intuitive preventative measures

    // function add r = x + y
    function add(uint x, uint y) internal pure returns (uint256) {
        uint256 r = x + y;
        require(r >= x, 'SafeMath: Addition Overflow');
        return r;
    }

    // function subtract r = x - y
    function sub(uint x, uint y) internal pure returns (uint256) {
        require(y <= x, 'SafeMath: Subtraction Overflow');
        uint256 r = x - y;
        return r;
    }
}