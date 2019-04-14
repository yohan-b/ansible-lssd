ansible-lssd
============

Large scale server deploys using BitTorrent. aria2c, NodeJS Bittorrent-tracker and mktorrent are used.


DESCRIPTION
-----------

ansible-lssd  is a method of using Bittorrent to distribute files to a large amount of servers within a production environment. 

ansible-lssd operates as a playbook of [Ansible](https://github.com/ansible/ansible).
These playbooks require Ansible 1.4.

These playbooks were tested on CentOS 7.x (ansible 2.6) with peers on Centos 7.x and Centos 6.x.

Advantage
---------

There is the following advantage as compared with Murder. 
* *Ruby is not required*  to run on only python.
* *Capistrano is not required*. run in the ansible playbooks.
* Environment setup is automated by playbook.


Installation of software required minimum
-----------------------------------------

From EPEL:
# yum -y install ansible


HOW IT WORKS
------------

Same as the "[HOW IT WORKS](https://github.com/lg/murder/blob/master/README.md#how-it-works)" of Murder.


CONFIGURATION
-----------------------

You define `tracker`, `seeder` and `peer` server to inventory (./production) file.

All involved servers must have python installed.

The file group_vars/all contains the configuration.

MANUAL USAGE
------------

Modify a ./production and ./group_vars/all, manually define servers:

./production:
  ```INI:production
  # ansible host
  [ansible_host]
  localhost ansible_connection=local
  
  # tracker node
  [tracker]
  10.0.0.1 node_type=tracker
  
  # seeder node
  [seeder]
  10.0.0.1 node_type=seeder
  
  # peer nodes
  [peer]
  10.1.1.1
  10.1.1.2
  10.1.1.3
  ```

group_vars/all:
  ```YAML:group_vars/all
  # deploy tag
  tag: Deploy1
  
  # path
  seeder_files_path:  ~/builds
  destination_path:   /opt/hoge  # or some other directory
  ```

The destination_path, by setup.yml, specify the directory to be placed in the all server of Murder library and support files etc..

Then manually run the ansible playbooks:

1. Start the tracker:

  ```bash:
  $ ansible-playbook -i production start_tracker.yml
  ```

2. Create a torrent from a directory of files on the seeder, and start seeding:

  ```bash:
  # copy to seeder node
  $ scp -r ./builds 10.0.0.1:~/builds
  
  # create torrent file
  $ ansible-playbook -i production create_torrent.yml
  
  # start seeding
  $ ansible-playbook -i production start_seeder.yml
  ```

3. Distribute the torrent to all peers:

  ```bash:
  $ ansible-playbook -i production deploy.yml -f 1000
  ```

4. Stop the seeder and tracker:

  ```bash:
  $ ansible-playbook -i production stop_seeder_and_tracker.yml
  ```

When this finishes, all peers will have the files in /opt/hoge/Deploy1


MAIN PLAYBOOKS REFERENCE
------------------------

* `create_torrent.yml:`
  * Create torrent file on seeder node.
* `deploy.yml:`
  * Deploy files on peer nodes.
* `setup.yml:`
  * Install the software required for each node.
* `full_deploy.yml:`
  * Run all Playbook deploy from the setup.
* `start_seeder.yml:`
  * start seeding.
* `start_tracker.yml:`
  * start tracker.
* `stop_all_peers.yml:`
  * stop all peer client.
* `stop_seeder_and_tracker.yml:`
  * stop seeding and tracker.


NOTES
------------------------

You may hit the request length limit (fixed in newer aria2 releases) :
https://github.com/aria2/aria2/commit/e220c5384961f9261f19c28cd0b85f76f06d8993#diff-03671aebef9174610c96db97917b960a

Workaround is using "-l 22" as mktorrent option to make less pieces.
