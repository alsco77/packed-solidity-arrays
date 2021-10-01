import { StandardAccounts } from "@utils/standardAccounts"
import { ethers } from "hardhat"
import { MockPackedBooleanArray, MockPackedBooleanArray__factory } from "types"
import { expect } from "chai"
import { BN } from "@utils/math"

describe("PackedBooleanArray", () => {
    let sa: StandardAccounts
    let mockPackedArray: MockPackedBooleanArray

    // interface Data {
    //     arr: BN[]
    //     len: BN
    //     value: boolean
    // }

    const deploy = async () => {
        mockPackedArray = await new MockPackedBooleanArray__factory(sa.default.signer).deploy()
    }

    // const snap = async (index: number) => ({
    //     arr: await mockPackedArray.packedBooleans(),
    // })

    before(async () => {
        const accounts = await ethers.getSigners()
        sa = await new StandardAccounts().initAccounts(accounts)
        await deploy()
    })

    // Test getValue
    it("should pass even if array isn't initialised", async () => {
        expect(await mockPackedArray.getValue(12)).eq(false)
    })

    context("setting values on an empty array", async () => {
        beforeEach(async () => {
            await deploy()
        })
        it("should set value at index 0", async () => {
            await mockPackedArray.setValue(0, true)
            expect(await mockPackedArray.getValue(0)).eq(true)
            expect(await mockPackedArray.getValue(1)).eq(false)
            expect(await mockPackedArray.getValue(2)).eq(false)
        })
        it("should set value at index 6", async () => {
            await mockPackedArray.setValue(6, true)
            expect(await mockPackedArray.getValue(0)).eq(false)
            expect(await mockPackedArray.getValue(1)).eq(false)
            expect(await mockPackedArray.getValue(6)).eq(true)
            expect(await mockPackedArray.getValue(9)).eq(false)
        })
        it("should set value at index 257", async () => {
            await mockPackedArray.setValue(257, true)
            expect(await mockPackedArray.getValue(252)).eq(false)
            expect(await mockPackedArray.getValue(256)).eq(false)
            expect(await mockPackedArray.getValue(257)).eq(true)
            expect(await mockPackedArray.getValue(258)).eq(false)
        })
    })

    context("setting values on an array of len 270", async () => {
        beforeEach(async () => {
            await deploy()
            await mockPackedArray.init([242342, 1], 270)
        })
        const runChecks = async () => {
            expect(await mockPackedArray.getValue(2)).eq(true)
            expect(await mockPackedArray.getValue(7)).eq(true)
            expect(await mockPackedArray.getValue(19)).eq(false)
            expect(await mockPackedArray.getValue(256)).eq(true)
            expect(await mockPackedArray.getValue(257)).eq(false)
            expect(await mockPackedArray.getValue(513)).eq(false)
            expect(await mockPackedArray.getValue(515)).eq(false)
        }
        it("should get basic values", async () => {
            await runChecks()
        })
        it("should set value at index 260", async () => {
            await mockPackedArray.setValue(260, true)
            await runChecks()
            expect(await mockPackedArray.getValue(260)).eq(true)
        })
        it("should set value at index 514", async () => {
            await mockPackedArray.setValue(514, true)
            await runChecks()
            expect(await mockPackedArray.getValue(514)).eq(true)
        })
    })
    context("setting values on an array of len 100", async () => {
        before(async () => {
            await deploy()
            await mockPackedArray.init([242342], 100)
        })
        const runChecks = async () => {
            expect(await mockPackedArray.getValue(2)).eq(true)
            expect(await mockPackedArray.getValue(7)).eq(true)
            expect(await mockPackedArray.getValue(19)).eq(false)
            expect(await mockPackedArray.getValue(257)).eq(false)
            expect(await mockPackedArray.getValue(513)).eq(false)
            expect(await mockPackedArray.getValue(515)).eq(false)
        }
        it("should set value at index 255 (last one on first slot)", async () => {
            await mockPackedArray.setValue(255, true)
            await runChecks()
            expect(await mockPackedArray.getValue(255)).eq(true)
        })
        it("should set value at index 256 (first one on next slot)", async () => {
            await mockPackedArray.setValue(256, true)
            await runChecks()
            expect(await mockPackedArray.getValue(256)).eq(true)
            await mockPackedArray.setValue(256, false)
            expect(await mockPackedArray.getValue(256)).eq(false)
        })
    })
})
