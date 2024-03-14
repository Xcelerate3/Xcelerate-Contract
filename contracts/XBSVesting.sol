// SPDX-License-Identifier: MIT
//  __  __        _                _       
//  \ \/ /___ ___| | ___ _ __ __ _| |_ ___ 
//   \  // __/ _ \ |/ _ \ '__/ _` | __/ _ \
//   /  \ (_|  __/ |  __/ | | (_| | ||  __/
//  /_/\_\___\___|_|\___|_|  \__,_|\__\___|

pragma solidity >=0.8.2 <0.9.0;

interface ERC20 {
    function transfer(address to, uint256 value) external returns (bool);
    function balanceOf(address who) external view returns (uint256);
}

contract XBSVesting {
    address public beneficiary;
    uint256 public cliff;
    uint256 public start;
    uint256 public duration;
    uint256 public cliffDuration;
    uint256 public released;

    ERC20 public token;

    event Released(uint256 amount);

    constructor(
        address _beneficiary,
        uint256 _cliffDuration,
        uint256 _duration,
        address _token
    ) {
        require(_beneficiary != address(0), "Invalid beneficiary address");
        require(_token != address(0), "Invalid token address");
        require(_cliffDuration <= _duration, "Cliff duration is longer than duration");

        beneficiary = _beneficiary;
        cliffDuration = _cliffDuration;
        duration = _duration;
        token = ERC20(_token);
        start = block.timestamp;
        cliff = start + cliffDuration;
    }

    function release() public {
        require(block.timestamp >= start, "Vesting hasn't started yet");
        uint256 vested = vestedAmount();
        require(vested > released, "No vested tokens available for release");

        uint256 toRelease = vested - released;
        released = vested;

        token.transfer(beneficiary, toRelease);
        emit Released(toRelease);
    }

    function vestedAmount() public view returns (uint256) {
        if (block.timestamp < cliff) {
            return 0;
        } else if (block.timestamp >= start + duration) {
            return released + token.balanceOf(address(this));
        } else {
            uint256 elapsedTime = block.timestamp - cliff;
            uint256 totalVestableTokens = released + token.balanceOf(address(this));
            uint256 vestableAmountPerSecond = totalVestableTokens / duration;
            return elapsedTime * vestableAmountPerSecond;
        }
    }
}