// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.7;

import { PackedBooleanArray } from "../PackedBooleanArray.sol";

contract MockPackedBooleanArray {
    using PackedBooleanArray for PackedBooleanArray.PackedArray;

    PackedBooleanArray.PackedArray internal packedBooleans;

    function init(uint256[] calldata _data, uint256 _length) external {
        packedBooleans = PackedBooleanArray.initStruct(_data, _length);
    }

    function getValue(uint256 index) public view returns (bool value) {
        return packedBooleans.getValue(index);
    }

    function setValue(uint256 pos, bool val) public {
        packedBooleans.setValue(pos, val);
    }
}
