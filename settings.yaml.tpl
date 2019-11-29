login: nherbaut
pwd: 
api-backend: https://api.grid5000.fr/
ssh_key_file_public: /home/nherbaut/.ssh/id_rsa.pub
ssh_key_file_private: /home/nherbaut/.ssh/id_rsa
g5k_ssh_key_file_public: /home/nherbaut/.ssh/g5k.pub
mailto: nicolas.herbaut@univ-paris1.fr
grid5k_ProxyCommand_domain_alias: g5k
environment: ubuntu1804-x64-min
default_site: nancy
g5k_ssh_key_file_private: /home/nherbaut/.ssh/g5k
salt_host_control_iface: eno1
salt_host_data_iface: eno1
salt_minion_template: /home/nherbaut/workspace/Ethereum-Bench-stack/templates/minion.tpl
salt_master_template: /home/nherbaut/workspace/Ethereum-Bench-stack/templates/master.tpl
salt_states_repo_url: https://github.com/nherbaut/Ethereum-Bench-stack
salt_states_repo_branch: master
salt_state_dest_folder: /srv
salt_master_precommands:
  - apt-get update
  - apt-get install git curl --yes
salt_minion_precommands:
  - apt-get update
  - apt-get install curl git --yes
g5k_interface_name_mapping:
  nancy: eno1
  grenoble: enp24s0f0
  dahu: enp24s0f0
  lille: eno1
