salt "*" cmd.run 'docker rm -f $(docker ps -qa)' && salt "*" cmd.run 'service telegraf stop'
