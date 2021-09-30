import { StandardAccounts } from "@utils/standardAccounts"
import { ethers } from "hardhat"
import { MockPackedArray, MockPackedArray__factory } from "types"
import { expect } from "chai"
import allPrimes from "./allPrimes.json"

describe("PackedUint16Array", () => {
    let sa: StandardAccounts
    let mockPackedArray: MockPackedArray

    const deploy = async () => {
        mockPackedArray = await new MockPackedArray__factory(sa.default.signer).deploy()
        await mockPackedArray.init(allPrimes, 6542)
    }

    before(async () => {
        const accounts = await ethers.getSigners()
        sa = await new StandardAccounts().initAccounts(accounts)
        await deploy()
    })

    it("should set values", async () => {
        await mockPackedArray.setValue(0, 62000)
        expect(await mockPackedArray.fetchValue(0)).eq(62000)
        expect(await mockPackedArray.fetchValue(1)).eq(3)
    })
    it("should pop the value", async () => {
        await mockPackedArray.popValue(0)
        expect(await mockPackedArray.fetchValue(0)).eq(65521)
    })
})
