

git:
  pkg.installed

https://github.com/nherbaut/sc-archi-gen.git:
   git.latest:
     - name: https://github.com/nherbaut/sc-archi-gen.git
     - target: /home/vagrant
     - force_clone: True
     - branch: master

/home/vagrant/.ssh:
   file.directory:
     - makedirs: True
     - mode: 500
     - user: vagrant
     - group: vagrant
     - require:
       - git: https://github.com/nherbaut/sc-archi-gen.git

cat /root/.ssh/authorized_keys  >> /home/vagrant/.ssh/authorized_keys:
  cmd.run:
    - require:
      - file: /home/vagrant/.ssh 

/home/vagrant/.ssh/authorized_keys:
  file.managed:
    - mode: 500
    - user: vagrant
    - group: vagrant
    - replace: False
    - watch:
      - cmd: cat /root/.ssh/authorized_keys  >> /home/vagrant/.ssh/authorized_keys



