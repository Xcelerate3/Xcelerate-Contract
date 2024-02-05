// SPDX-License-Identifier: MIT
//  __  __        _                _       
//  \ \/ /___ ___| | ___ _ __ __ _| |_ ___ 
//   \  // __/ _ \ |/ _ \ '__/ _` | __/ _ \
//   /  \ (_|  __/ |  __/ | | (_| | ||  __/
//  /_/\_\___\___|_|\___|_|  \__,_|\__\___|

pragma solidity >=0.8.2 <0.9.0;

import {ERC20, ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import {ERC20Capped} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import {ERC20Pausable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @title XBS Token Contract
/// @notice Implements an ERC20 token with a cap, burnability, pausability, and ownership features
contract XBS is
    ERC20Burnable,
    ERC20Permit,
    ERC20Capped,
    ERC20Pausable,
    Ownable
{
    /// @notice Initializes the contract with a name, symbol, cap, and initial owner
    constructor()
        ERC20("Xcelerate", "XBS")
        ERC20Permit("Xcelerate")
        ERC20Capped(423 * 1e6)
        Ownable()
    {}

    /// @notice Allows the owner to pause all token transfers
    function pause() external onlyOwner {
        _pause();
    }

    /// @notice Allows the owner to unpause the token transfers
    function unpause() external onlyOwner {
        _unpause();
    }

    /// @notice Allows the owner to mint new tokens, up to the cap
    /// @param to The address that will receive the minted tokens
    /// @param amount The amount of tokens to mint
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    /// @dev Internal function to update state during transfers, respecting the cap and pausability
    /// @param from The address sending the tokens
    /// @param to The address receiving the tokens
    /// @param value The amount of tokens being transferred
    function _update(
        address from,
        address to,
        uint256 value
    ) internal override(ERC20, ERC20Capped, ERC20Pausable) {
        super._update(from, to, value);
    }
}