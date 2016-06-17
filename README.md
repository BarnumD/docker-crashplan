# docker-crashplan
A dockerized version of Crashplan (Home/Small Business) with the ability to use the CrashPlanDesktop GUI remotely.

#To run:
docker run -d -h ${HOSTNAME} -e backupLoc="/mnt/backup" -v /docker/mounts/crashplan/data:/mnt/data -v /docker/mounts/crashplan/backup:/mnt/backup -p 4222:22 -p 4242-4243:4242-4243 -e "TZ=America/New York" --name crashplan crashplan


#Connect to CrashPlanDesktop GUI application remotely:
* Add your ssh public key to the /docker/mounts/crashplan/data/authorized_keys (If you need help generating a ssh key, there are lots of examples out there.)
* Use X11 forwarding to connect to Xterm
*  On Windows, use MobaXTerm. Setup a new connection. Configure it to connect to port 4222 on the docker host.  X11 forwarding should be checked.  Specify username: root. Execute command: xterm.
*  Connect.  As long as you set up mobaxterm and you have your putty agent configured, xterm will open.
*  Launch crashplandesktop by typing 'CrashPlanDesktop' into the xterm window.
