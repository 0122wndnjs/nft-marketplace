// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

library SafeMath {
    // build functions to perform safemath operations that would otherwise replace 
    // intuitive preventative measures

    // function add r = x + y
    function add(uint256 x, uint256 y) internal pure returns (uint256) {
        uint256 r = x + y;
        require(r >= x, 'SafeMath: Addition Overflow');
        return r;
    }

    // function subtract r = x - y
    function sub(uint256 x, uint256 y) internal pure returns (uint256) {
        require(y <= x, 'SafeMath: Subtraction Overflow');
        uint256 r = x - y;
        return r;
    }

    // 1. Write an internally visible multiply function which ensures no remaining multiplication
    // overflow and using the r = x * y equation
    // 2. Solidity only automatically asserts when dividing by 0.
    // Write an internally visible divide function which requires that y is always greater than 0
    // within the r = x / y equation
    // 3. Write a modulo function which requires that y does not equal zero under any circumstance.
    // Return the modulo of the equation from r = x % y

    // function multiply r = x * y
    function mul(uint256 x, uint256 y) internal pure returns (uint256) {
        // gas optimization
        if (x == 0) {
            return 0;
        } 

        uint256 r = x * y;
        require(r / x == y, 'SafeMath: Multiplication Overflow');
        return r;
    }

    // function divide r = x / y
    function divide(uint256 x, uint256 y) internal pure returns (uint256) {
        require(y > 0, 'SafeMath: Divisiion by Zero');
        uint256 r = x / y;
        return r;
    }

    // gas spending remains untouched
    function mod(uint256 x, uint256 y) internal pure returns (uint256) {
        require(y != 0, 'SafeMath: Modulo by Zero');
        return x % y;
    }
}