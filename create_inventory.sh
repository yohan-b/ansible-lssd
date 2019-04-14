#!/usr/bin/python

#relays={"HLZURT1EXE3M": {"Bat": "Bat Diderot", "Salle": "Salle 1"}, "HLZURT1EXE3N": {"Bat": "D'alembert", "Salle": "Salle 2"}}
relays={"HLZURT1EXE3M": {"Bat": "Bat C", "Salle": "Salle C31"}}
inventory_file="associations_vm-location"

for relay in relays.keys():
  with open("inventory_" + relay, "w") as f: 
    f.write("# ansible host\n")
    f.write("[ansible_host]\n")
    f.write("localhost ansible_connection=local\n\n")
    f.write("# tracker node\n")
    f.write("[tracker]\n")
    f.write(relay.lower() + " node_type=tracker\n\n")
    f.write("# seeder node\n")
    f.write("[seeder]\n")
    f.write(relay.lower() + " node_type=seeder\n\n")
    f.write("# peer nodes\n")
    f.write("[peer]\n")
    with open(inventory_file, "r") as inventory:
      for line in inventory:
        if relays[relay]["Bat"] in line and relays[relay]["Salle"] in line:
          f.write(line.split(';')[0]+"\n")
