#!/bin/bash
m.do 'dmesg |grep NVRM |grep Xid' ../hosts.0 |sort |grep NVRM
