pragma solidity ^0.4.21;

// ----------------------------------------------------------------------------
// Want to say something?
//
// Use this to send some random text from the Gnosis multisig wallet
//
// Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
// ----------------------------------------------------------------------------

contract ERC20Partial {
    function balanceOf(address owner) public constant returns (uint256 balance);
    function transfer(address to, uint256 value) public returns (bool success);
}


// ----------------------------------------------------------------------------
// Owned contract
// ----------------------------------------------------------------------------
contract Owned {
    address public owner;
    address public newOwner;
    event OwnershipTransferred(address indexed from, address indexed to);

    function Owned() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }

    function acceptOwnership() public {
        if (msg.sender == newOwner) {
            emit OwnershipTransferred(owner, newOwner);
            owner = newOwner;
        }
    }
}


contract SayIt is Owned {
    event Said(address indexed who, string text);

    function say(string text) public {
        emit Said(msg.sender, text);
    }

    function transferOut(address tokenAddress) public onlyOwner {
        if (tokenAddress == address(0)) {
            owner.transfer(address(this).balance);
        } else {
            ERC20Partial token = ERC20Partial(tokenAddress);
            uint balance = token.balanceOf(this);
            token.transfer(owner, balance);
        }
    }
}