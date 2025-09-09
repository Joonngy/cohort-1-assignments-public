const from = eth.accounts[0];
const contractDeployer = "0xe175105828d7e693cfede9fefb67fb61e95e0b28";
eth.sendTransaction({
  from: from,
  to: contractDeployer,
  value: web3.toWei(100, "ether"),
});
// PK: be44593f36ac74d23ed0e80569b672ac08fa963ede14b63a967d92739b0c8659
