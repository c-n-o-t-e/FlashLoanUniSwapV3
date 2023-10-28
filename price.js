import fetch from "node-fetch";
const args = process.argv.slice(2);
const apiKey = "U772ATWP1Z8J3MNMFUXXFPYD213PEVEXAZ";

const etherscanURL = `https://api.etherscan.io/api?module=gastracker&action=gasoracle&apikey=${apiKey}`;

const ethURL =
  "https://api.coingecko.com/api/v3/simple/price?ids=ethereum&vs_currencies=usd";

async function calculateTxCost() {
  const response = await fetch(ethURL);
  const data = await response.json();

  const ethPrice = data.ethereum.usd;
  const response0 = await fetch(etherscanURL);

  const data0 = await response0.json();
  const gasPrice = data0.result.ProposeGasPrice;

  const txCostForOneFlashLoan = args[0];
  const txCostForThreeFlashLoan = args[1];

  const costOfThreeIndividualTx = txCostForOneFlashLoan * 3;
  let cost;
  let price;

  console.log("Current ETH Price:", ethPrice);
  console.log("Current Gas Price:", gasPrice);

  price = (gasPrice * costOfThreeIndividualTx * ethPrice) / 1e9;
  console.log("Transcation Cost For Three Individual FlashLoan In Usd:", price);

  price = (gasPrice * txCostForThreeFlashLoan * ethPrice) / 1e9;
  console.log("Transcation Cost For Three Joint FlashLoan In Usd:", price);

  if (costOfThreeIndividualTx > txCostForThreeFlashLoan) {
    cost = costOfThreeIndividualTx - txCostForThreeFlashLoan;
    price = (gasPrice * cost * ethPrice) / 1e9;
    console.log("Amount Saved When Three FlashLoan Runs Jointly Usd:", price);
  }
}

calculateTxCost();
