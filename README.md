## Uniswap V3 FlashLoan With a Buggy Dex

This repo contains flashloan gotten from UniSwap V3 that interacts with a buggy dex and takes tokens from the DEX.

It also test cost for running multiple flashloan and single flashloan to ascertain which path is gas cheaper.

## Upon Cloning Run

`cd FlashLoanUniSwapV3`
`forge install`
`FORK_URL=https://eth-mainnet.g.alchemy.com/v2/your-id`
`forge test --fork-url $FORK_URL --mp test/FlashLoan.t.sol --gas-report --optimize --optimizer-runs 20000 -vv`
