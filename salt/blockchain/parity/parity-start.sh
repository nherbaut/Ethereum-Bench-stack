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
salt "h0" state.apply blockchain.parity.test


