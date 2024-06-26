const PrivateKeyProvider = require('@truffle/hdwallet-provider');
const privateKeys = [
'0x8f2a55949038a9610f50fb23b5883af3b4ecb3c3bb792cbcefbd1542c692be63',
'0xc87509a1c067bbde78beb793e6fa76530b6382a4c0241e5e4a9ec0a0f44dc0d3',
'0xae6ae8e5ccbfb04590405997ee2d52d2b330726137b875053c36d94e974d162f'
];
const privateKeyProvider = new PrivateKeyProvider(
privateKeys,
'http://127.0.0.1:8555',
0,
3
);
module.exports = {
  networks: {
   besu:{
    provider:privateKeyProvider,
    network_id: '*'// network_id: '1234'
   }
  },
  compilers: {
    solc: {
      version: "0.8.0", // Use version 0.8.0
      settings: {
        optimizer: {
          enabled: true,
          runs: 200
        },
        evmVersion: "istanbul" // Optionally specify EVM version
      }
    }
  }
};