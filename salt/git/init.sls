git:
  pkg.installed

https://github.com/nherbaut/sc-archi-gen.git:
   git.latest:
     - name: https://github.com/nherbaut/sc-archi-gen.git
     - target: /opt/sc-archi-gen
     - branch: master
   

bc-deps:
  npm.bootstrap:
    - name: /opt/sc-archi-gen
