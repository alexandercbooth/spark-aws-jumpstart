sudo yum install tmux
sudo pip install ipython==5.3.0 jupyter notebook
sudo pip install https://dist.apache.org/repos/dist/dev/incubator/toree/0.2.0/snapshots/dev1/toree-pip/toree-0.2.0.dev1.tar.gz
jupyter toree install --spark_home=/usr/lib/spark/ --user
