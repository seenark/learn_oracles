const Coingecko = require("coingecko-api");
const Oracle = artifacts.require("Oracle.sol");

const POLL_INTERVAL = 5000;
const CoingeckoClient = new Coingecko();

module.exports = async (done) => {
  const [_, reporter] = await web3.eth.getAccounts();
  const oracle = await Oracle.deployed();

  while (true) {
    const response = await CoingeckoClient.simple.price({ ids: "solana", vs_currencies: ["usd", "thb"] });

    let solanaPrice = response.data.solana.usd;
    solanaPrice = Number.parseInt(Number.parseFloat(solanaPrice) * 100);
    const key = web3.utils.soliditySha3("SOL/USD");
    await oracle.updateData(key, solanaPrice, { from: reporter });
    console.log(`Solana Price: ${solanaPrice}`);
    await new Promise((resolve) => setTimeout(resolve, POLL_INTERVAL));
  }

  done();
};
