# Spark or: How I learned to Stop Worrying and Love Big Data
![](images/spark-logo-trademark.png)

## Relaunching a cluster
If you have already gone through setting up a vpc once, you don't need to again and you can launch a cluster with the following steps
1. Navigate to the scripts directory and source the `.env` file,
```bash
cd scripts
. .env
```
2. relaunch a cluster,
```bash
. create-cluster.sh
```
Wait a couple of minutes and then ssh into your new cluster :tada:

If you haven't already setup a vpc, follow the directions in [Module 1](01-Module-1.md)


## [Module I](01-Module-1.md)
In the first part, we are going to have the following goals:
1. signup for aws
2. configure aws
3. launch a spark cluster
