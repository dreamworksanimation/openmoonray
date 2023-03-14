These scripts can be used to test distributed Arras on a single machine.

In a shell, run the script 'run_minicoord' from a release. This should start minicoord running and leave you with an interactive python prompt
In another shell (on the same machine) run 'run_node'. This should start a new arras4_node process, which will register with minicoord.
In a third shell run 'run_arras_render <rdlafilepath>'. This should start arras_render using minicoord and the node to render the file.

You should be able to start multiple nodes to test multi-node rendering.
To test across multiple machines, use the same method as the scripts, but replace 'localhost' in run_node with the minicoord host name

run_minicoord uses Rez to enable the requests and tornado third-party packages. If do not have rez or these packages, the script will need changes.