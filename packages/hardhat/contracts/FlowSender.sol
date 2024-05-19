//SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.14;

import { ISuperfluid, ISuperToken } from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol";
import { SuperTokenV1Library } from "@superfluid-finance/ethereum-contracts/contracts/apps/SuperTokenV1Library.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IFakeDAI is IERC20 {
    function mint(address account, uint256 amount) external;
}

contract FlowSender {
    using SuperTokenV1Library for ISuperToken;
    mapping (address => bool) public accountList;
    ISuperToken public daix;

    // fDAIx address on Polygon Mumbai = 0x5D8B4C2554aeB7e86F387B4d6c00Ac33499Ed01f
    constructor(ISuperToken _daix) {
        daix = _daix;
    }

    function gainDaiX() external {
        IFakeDAI fdai = IFakeDAI(daix.getUnderlyingToken());
        fdai.mint(address(this), 10000e18);
        fdai.approve(address(daix), 20000e18);
        daix.upgrade(10000e18);
    }

    function createStream(int96 flowRate, address receiver) external {
        daix.createFlow(receiver, flowRate);
    }

    function updateStream(int96 flowRate, address receiver) external {
        daix.updateFlow(receiver, flowRate);
    }

    function deleteStream(address receiver) external {
        daix.deleteFlow(address(this), receiver);
    }

    function readFlowRate(address receiver) external view returns (int96 flowRate) {
        return daix.getFlowRate(address(this), receiver);
    }
}
