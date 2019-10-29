module.exports = {

  networks: {
    ganache: {
      host: "127.0.0.1",     
      port: 7545,            
      network_id: 5777,      
    },

    infra: {
      host: "{{ salt['mine.get']("h1","datapath_ip")["h1"][0] }}",     
      port: 8545,            
      network_id: 61997,       
      gasLimit: "0x346DC5D638865",
      gasPrice: "0x0",
    },

  },

  mocha: {
    // timeout: 100000
  },

  compilers: {
    solc: {
      version: "0.5.0"
    }
  }
}
