# FCDocker

docker files to start on docker [FCUser](https://github.com/PsykeDady/FCUser) spring app

> WARNING: 
>
> of course, you must have docker installed and docker service started.

## SETTINGS

To config, edit "`avviadocker.sh`" line number 28: 

```bash
MYSQL_PASSWORD=
```

and add the desired mysql password for root user.

## USE

There are three different way to start the script: 

- Simple using `./avviodocker.sh` (from same directory of script) to start building process and container
- To force rebuilding (and the db complete reset) add `-f` flag: `./avviodocker.sh -f`
- To force rebuilding (but no db complete reset) add `-b` flag: `./avviodocker.sh -b`
- To simple restart stopped container, without any building process, use the `-r` flag: `./avviodocker.sh -r`

