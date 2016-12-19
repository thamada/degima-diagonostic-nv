#!/bin/bash

date >> ~/HWTEST.LOG
m.do '$PWD/run.exe 0 1 ' ./hosts.0 >> ~/HWTEST.LOG
m.do '$PWD/run.exe 1 1 ' ./hosts.0 >> ~/HWTEST.LOG
m.do '$PWD/run.exe 2 1 ' ./hosts.0 >> ~/HWTEST.LOG
m.do '$PWD/run.exe 3 1 ' ./hosts.0 >> ~/HWTEST.LOG

date >> ~/HWTEST.LOG
m.do '$PWD/run.exe 0 1 ' ./hosts.0 >> ~/HWTEST.LOG
m.do '$PWD/run.exe 1 1 ' ./hosts.0 >> ~/HWTEST.LOG
m.do '$PWD/run.exe 2 1 ' ./hosts.0 >> ~/HWTEST.LOG
m.do '$PWD/run.exe 3 1 ' ./hosts.0 >> ~/HWTEST.LOG

