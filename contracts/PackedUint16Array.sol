// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.7;

/// @title PackedUint16Array
/// @author alsco77
library PackedUint16Array {
    using PackedUint16Array for PackedUint16Array.PackedArray;

    struct PackedArray {
        uint256[] array;
        uint256 length;
    }

    // Verifies that the higher level count is correct, and that the last uint256 is left packed with 0's
    function initStruct(uint256[] memory _arr, uint256 _len)
        internal
        pure
        returns (PackedArray memory)
    {
        uint256 actualLength = _arr.length;
        uint256 len0 = _len / 16;
        require(actualLength == len0 + 1, "Invalid arr length");

        uint256 len1 = _len % 16;
        uint256 leftPacked = uint256(_arr[len0] >> (len1 * 16));
        require(leftPacked == 0, "Invalid uint256 packing");

        return PackedArray(_arr, _len);
    }

    function getValue(PackedArray storage ref, uint256 _index) internal view returns (uint16) {
        require(_index < ref.length, "Invalid index");
        uint256 aid = _index / 16;
        uint256 iid = _index % 16;
        return uint16(ref.array[aid] >> (iid * 16));
    }

    function setValue(
        PackedArray storage ref,
        uint256 _index,
        uint16 _value
    ) internal {
        uint256 aid = _index / 16;
        uint256 iid = _index % 16;

        // 1. Do an && between old value and a mask
        uint256 mask = uint256(~(uint256(65535) << (iid * 16)));
        uint256 masked = ref.array[aid] & mask;
        // 2. Do an |= between (1) and positioned _value
        mask = uint256(_value) << (iid * 16);
        ref.array[aid] = masked | mask;
    }

    function extractIndex(PackedArray storage ref, uint256 _index) internal {
        // Get value at the end
        uint16 endValue = ref.getValue(ref.length - 1);
        ref.setValue(_index, endValue);
        ref.setValue(ref.length - 1, 0);
        ref.length--;
    }
}
