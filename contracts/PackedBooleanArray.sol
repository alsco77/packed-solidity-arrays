// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.7;

/// @title PackedBooleanArray
/// @author alsco77
library PackedBooleanArray {
    using PackedBooleanArray for PackedBooleanArray.PackedArray;

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
        uint256 len0 = _len / 256;
        require(actualLength == len0 + 1, "Invalid arr length");

        uint256 len1 = _len % 256;
        uint256 leftPacked = uint256(_arr[len0] >> len1);
        require(leftPacked == 0, "Invalid uint256 packing");

        return PackedArray(_arr, _len);
    }

    function getValue(PackedArray storage ref, uint256 _index) internal view returns (bool) {
        require(_index < ref.length, "Invalid index");
        uint256 aid = _index / 256;
        uint256 iid = _index % 256;
        return (ref.array[aid] >> iid) & 1 == 1 ? true : false;
    }

    function pushValue(PackedArray storage ref, bool _value) internal {
        uint256 len = ref.length;
        uint256 iid = len % 256;
        if(iid == 0) {
            ref.array.push(_value ? 1 : 0);
        } else {
            ref.setValue(len, _value);
        }
        ref.length += 1;
    }

    function setValue(
        PackedArray storage ref,
        uint256 _index,
        bool _value
    ) internal {
        uint256 aid = _index / 256;
        uint256 iid = _index % 256;
        require(iid != 0, "Must create new entry");

        // 1. Do an & between old value and a mask
        uint256 mask = uint256(~(uint256(1) << iid));
        uint256 masked = ref.array[aid] & mask;
        // 2. Do an |= between (1) and positioned _value
        mask = uint256(_value ? 1 : 0) << (iid);
        ref.array[aid] = masked | mask;
    }

    function extractIndex(PackedArray storage ref, uint256 _index) internal {
        // Get value at the end
        bool endValue = ref.getValue(ref.length - 1);
        ref.setValue(_index, endValue);
        ref.setValue(ref.length - 1, false);
        ref.length--;
    }
}
