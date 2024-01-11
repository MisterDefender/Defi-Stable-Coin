// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC20Burnable, ERC20} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
/**
 * @title DecentralizedStableCoin
 * @author Nikhil Mukati a.k.a MisterDefender
 * Collateral: Exogenous (wETH & wBTC)
 * Minting: Algorithmic
 * Relative stability: Pegged to USD$
 * This contract is governed by DSCEngine. This contract is just hold the ERC20 implementation of our stablecoin system
 */

contract DecentralizedStableCoin is ERC20Burnable, Ownable {
    error DecentralizedStableCoin_MusteBeMoreThanZero();
    error DecentralizedStableCoin_BurnAmountExceedsBalance();
    error DecentralizedStableCoin_NotZeroAddress();

    constructor() ERC20("DecentralizedStableCoin", "DSC") Ownable(msg.sender) {}

    function burn(uint256 _amount) public override onlyOwner {
        uint256 balance = balanceOf(msg.sender);
        if (_amount <= 0) {
            revert DecentralizedStableCoin_MusteBeMoreThanZero();
        }
        if (balance < _amount) {
            revert DecentralizedStableCoin_BurnAmountExceedsBalance();
        }
        super.burn(_amount);
    }

    function mint(address _to, uint256 _amount) external onlyOwner returns (bool) {
        if (_to == address(0)) {
            revert DecentralizedStableCoin_NotZeroAddress();
        }
        if (_amount <= 0) {
            revert DecentralizedStableCoin_MusteBeMoreThanZero();
        }
        _mint(_to, _amount);
        return true;
    }
}
