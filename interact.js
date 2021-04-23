const { ethers } = require("ethers");
const USElection = require('./build/USElection.json')

const run = async function () {
    const provider = new ethers.providers.InfuraProvider("ropsten", "40c2813049e44ec79cb4d7e0d18de173")
    const wallet = new ethers.Wallet("1ea6a0ac245df86cc26df6d43b333db6e06315235bbf011a1f38a5709e102214", provider)
    const USElectionContract = new ethers.Contract("0x01e0DFa6C636f1e64383E131E3FFA84296cC3038", USElection.abi, wallet);
}