[Unit]
Description=Consul Agent
After=network.target

[Service]
User=root
ExecStart=/usr/local/bin/consul agent -dev -config-dir=/etc/consul.d/server
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure
RestartForceExitStatus=SIGPIPE
KillMode=control-group
