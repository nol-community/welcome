//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NOLM is ERC20, Ownable {
    IERC20 public constant usdcInstance =
        IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    address public feeReceiver;

    // 3000 USDC
    uint256 public constant applicationFee = 3000 * (10**6);

    constructor(
        string memory _name,
        string memory _symbol,
        address _feeReceiver
    ) ERC20(_name, _symbol) {
        feeReceiver = _feeReceiver;
    }

    function decimals() public view virtual override(ERC20) returns (uint8) {
        return 0;
    }

    function setFeeReceiver(address _newFeeReceiver) external onlyOwner {
        feeReceiver = _newFeeReceiver;
    }

    function purchaseMembership() external {
        bool success = usdcInstance.transferFrom(
            msg.sender,
            feeReceiver,
            applicationFee
        );
        require(success, "failed");
        _mint(msg.sender, 1);
    }
}
