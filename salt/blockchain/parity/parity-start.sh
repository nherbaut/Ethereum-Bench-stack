salt "*" state.apply blockchain.parity.orch.cleanup
salt "*" state.apply blockchain.parity.installed
salt "*" saltutil.sync_all
salt "*" mine.update
salt "*" state.apply blockchain.parity.configured
salt "*" state.apply blockchain.parity.running
salt "*" state.apply blockchain.parity.orch.account-authority
salt "*" state.apply blockchain.parity.orch.account-user
salt "*" mine.update
salt "*" state.apply blockchain.parity.stopped
salt "*" state.apply blockchain.parity.configured
salt "*" state.apply blockchain.parity.running
salt "*" mine.update
salt "*" state.apply blockchain.parity.connected


curl --data '{"jsonrpc":"2.0","method":"personal_sendTransaction","params":[{"from":"0x00b0d44425a6f83c54b6a9fe2dc7d3fedec2defb","to":"0x005eed3d40f82e8928fd797d8b3748ee80971cf8","value":"0xde0b6b3a7640000"}, "h0"],"id":0}' -H "Content-Type: application/json" -X POST 10.0.0.11:8540
sleep 15
echo "there should be money there:"
curl --data '{"jsonrpc":"2.0","method":"eth_getBalance","params":["0x005eed3d40f82e8928fd797d8b3748ee80971cf8", "latest"],"id":1}' -H "Content-Type: application/json" -X POST 10.0.0.11:8540

