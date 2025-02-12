// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract Airdrop {
    address public owner;
    IERC20 public token;

    event Airdropped(address indexed recipient, uint256 amount);

    constructor(address _token) {
        owner = msg.sender;
        token = IERC20(_token);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this");
        _;
    }

    // ایردراپ به یک آدرس
    function airdropSingle(address recipient, uint256 amount) public onlyOwner {
        require(amount > 0, "Amount must be greater than zero");
        require(token.balanceOf(owner) >= amount, "Insufficient balance for airdrop");

        token.transfer(recipient, amount);

        emit Airdropped(recipient, amount);
    }

    // ایردراپ به چندین آدرس
    function airdropBatch(address[] memory recipients, uint256[] memory amounts) public onlyOwner {
        require(recipients.length == amounts.length, "Recipients and amounts length mismatch");

        for (uint i = 0; i < recipients.length; i++) {
            require(amounts[i] > 0, "Amount must be greater than zero");
            require(token.balanceOf(owner) >= amounts[i], "Insufficient balance for airdrop");

            token.transfer(recipients[i], amounts[i]);

            emit Airdropped(recipients[i], amounts[i]);
        }
    }

    // مشاهده موجودی توکن‌های قرارداد
    function getContractBalance() public view returns (uint256) {
        return token.balanceOf(address(this));
    }
}