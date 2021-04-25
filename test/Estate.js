/* Contracts in this test */

const Estate = artifacts.require(
  "../contracts/Estate.sol"
);


contract("Estate", (accounts) => {
  const URI_BASE = 'https://github.com/BillionNFTHomepage/';
  const CONTRACT_URI = `${URI_BASE}/ERC-721`;
  let estate;

  before(async () => {
    estate = await Estate.deployed();
  });

  // This is all we test for now

  // This also tests contractURI()

  describe('#constructor()', () => {
    it('should set the contractURI to the supplied value', async () => {
      assert.equal(await estate.contractURI(), CONTRACT_URI);
    });
  });
});
