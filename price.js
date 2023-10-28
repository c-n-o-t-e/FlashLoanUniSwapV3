import fetch from "node-fetch";
const apiKey = "U772ATWP1Z8J3MNMFUXXFPYD213PEVEXAZ";
const etherscanURL = `https://api.etherscan.io/api?module=gastracker&action=gasoracle&apikey=${apiKey}`;
const ethURL =
  "https://api.coingecko.com/api/v3/simple/price?ids=ethereum&vs_currencies=usd";

async function getEthereumPrice() {
  const response = await fetch(ethURL);
  const data = await response.json();
  const ethPrice = data.ethereum.usd;

  const response0 = await fetch(etherscanURL);
  const data0 = await response0.json();
  const gasPrice = data0.result.ProposeGasPrice;

  const price = (gasPrice * 30820 * ethPrice) / 1e9;

  console.log("Current ETH Price:", ethPrice);
  console.log("Current Gas Price:", gasPrice);
  console.log("Transcation Cost In Usd:", price);
}

getEthereumPrice();
