// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.7;

import { PackedUint16Array } from "../PackedUint16Array.sol";

contract MockPackedArray {
    using PackedUint16Array for PackedUint16Array.PackedArray;

    PackedUint16Array.PackedArray internal packedUint16s;

    function init(uint256[] calldata _data, uint256 _length) external {
        packedUint16s = PackedUint16Array.initStruct(_data, _length);
    }

    function fetchValue(uint256 tokenId) public view returns (uint16 value) {
        return packedUint16s.getValue(tokenId);
    }

    function setValue(uint256 pos, uint16 val) public {
        packedUint16s.setValue(pos, val);
    }

    function popValue(uint256 pos) public {
        packedUint16s.extractIndex(pos);
    }
}
