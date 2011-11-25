# -*- coding: utf-8 -*-
# * File Name : ssh.py
#
# * Copyright (C) 2010 Gaston TJEBBES <tonthon21@gmail.com>
#   This software is distributed under GPLV3
#   License: http://www.gnu.org/licenses/gpl-3.0.txt
#
# * Creation Date : 30-08-2010
# * Last Modified : mar. 27 sept. 2011 15:14:11 CEST
#
# * Project : Usefull ssh tricks
#

import sys
import os
HERE = os.path.dirname(__file__)


def load_conf(fname=os.path.join(HERE, 'conf.ini')):
    return file(fname).read().splitlines()[0].strip()

def add_dots(name):
    if not name.startswith(':'):
        name = ':%s' % name
    return name

def connect(ip, _x = True):
    cmd = "/usr/bin/ssh "
    if _x:
        cmd += '-X '
    cmd += 'root@%s' % ip
    os.system(cmd)

def scp(ip, destination, args):
    cmd = 'scp -r %s %s'
    destination = add_dots(destination)
    destination = 'root@%s%s' % (ip, destination)
    cmd = cmd % (' '.join(args), destination)
    os.system(cmd)

def from_scp(ip, destination, args):
    print('Copying : %s' % (args,))
    print('Destination : %s' % destination)
    print('From : %s' % ip)
    cmd = "scp -r %s %s"
    origins = ['root@%s%s' % (ip, add_dots(a)) for a in args]
    cmd = cmd % (' '.join(origins), destination)
    print(cmd)
    os.system(cmd)

if __name__ == '__main__':
    ip = load_conf()
    if sys.argv[1] == 'ssh':
        connect(ip)
    elif sys.argv[1] == 'scp':
        scp(ip, sys.argv[2], sys.argv[3:])
    elif sys.argv[1] == 'fscp':
        from_scp(ip, sys.argv[2], sys.argv[3:])
