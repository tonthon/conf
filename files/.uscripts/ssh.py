# -*- coding: utf-8 -*-
# * File Name : ssh.py
#
# * Copyright (C) 2010 Gaston TJEBBES <tonthon21@gmail.com>
#   This software is distributed under GPLV3
#   License: http://www.gnu.org/licenses/gpl-3.0.txt
#
# * Creation Date : 30-08-2010
# * Last Modified : mar. 10 juil. 2012 13:46:17 CEST
#
# * Project : Usefull ssh tricks
#
"""
    Usefull tool for handling ssh connections
"""

import argparse
import ConfigParser

import sys
import os
HERE = os.path.dirname(__file__)
DEFAULTCONF = os.path.join(HERE, 'conf.ini')

def build_parser():
    parser = argparse.ArgumentParser(description='SSH tools', add_help=True)
    parser.add_argument('-c', '--command',
           help='one of [connect,scp,fscp]',
           choices=['connect', 'scp', 'fscp'],
           required=True,
           action="store"
           )
    parser.add_argument('-s', '--server',
           help="the server name (section of the conf file)",
           action="store", default=None)
    parser.add_argument('-f', '--filename', default=DEFAULTCONF,
           help="An alternative conf file default={0}".format(DEFAULTCONF),
           action="store")
    parser.add_argument('paths', action="store", nargs='*')
    return parser

def load_server_conf(fname=os.path.join(HERE, 'conf.ini'), servername=None):
    config = ConfigParser.RawConfigParser({'user':'root', 'key_file':''})
    config.read(fname)
    if config.has_section(servername):
        ret_value = dict(config.items(servername))
        if not ret_value.has_key('name'):
            ret_value['name'] = servername
    else:
        ret_value = []
        for serv in config.sections():
            ret_dict = dict(config.items(serv))
            if not ret_dict.has_key('name'):
                ret_dict['name'] = serv
            ret_value.append(ret_dict)
    return ret_value

def add_dots(name):
    """
        Add : in front of name if needed (for scp)
    """
    if not name.startswith(':'):
        name = ':%s' % name
    return name

def launch_command(cmd):
    """
        launch the command
    """
    print("Launching : {0}".format(cmd))
    os.system(cmd)

def get_ssh_command(server_conf):
    """
        return the ssh command
    """
    opts = get_ssh_opts(server_conf)
    return "/usr/bin/ssh -X {0} {1[user]}@{1[host]}".format(opts,
                                                            server_conf)

def get_ssh_key_opt(server_conf):
    """
        returns the options needed for specifying the ssh key
    """
    ssh_key = server_conf.get('key_file')
    if ssh_key:
        if not os.path.isfile(ssh_key):
            print("Please give me access to your specific files")
            sys.exit(1)
        keyopt = "-i {0}".format(ssh_key)
    else:
        keyopt = ""
    return keyopt

def get_ssh_opts(server_conf, port_opt='-p'):
    """
        returns the ssh options
    """
    key_opt = get_ssh_key_opt(server_conf)
    port = server_conf.get('port', 22)
    port_opt = "{0} {1}".format(port_opt, port)
    return "{0} {1}".format(key_opt, port_opt)

def get_remote_dir(server_conf, directory):
    """
        Return the remote directory's fullpath
    """
    directory = add_dots(directory)
    directory = '{0[user]}@{0[host]}{1}'.format(server_conf, directory)
    return directory

def get_scp_cmd(server_conf, destination, tocopy):
    """
        return the scp command
    """
    cmd = "scp -r {0} {1} {2}"

    opts = get_ssh_opts(server_conf, port_opt='-P')
    destination = get_remote_dir(server_conf, destination)
    tocopy = ' '.join(tocopy)
    return cmd.format(opts, tocopy, destination)

def get_fscp_cmd(server_conf, destination, tocopy):
    """
        Return a scp command for the from scp call
    """
    cmd = "scp -r {0} {1} {2}"

    opts = get_ssh_opts(server_conf)
    origins = ' '.join([get_remote_dir(server_conf, directory)
                                        for directory in tocopy])
    return cmd.format(opts, origins, destination)

def connect(server_conf, _x = True):
    """
        Connect to remote host via ssh
    """
    cmd = get_ssh_command(server_conf)
    launch_command(cmd)

def scp(server_conf, destination, tocopy):
    """
        Scp to remote host
    """
    print("Copying : {0}".format(tocopy))
    print("Destination : {0}".format(destination))
    print("To : {0}".format(server_conf.get('name', server_conf['host'])))
    cmd = get_scp_cmd(server_conf, destination, tocopy)
    launch_command(cmd)

def from_scp(server_conf, destination, tocopy):
    """
        scp from remote host
    """
    print("Copying : {0}".format(tocopy))
    print("Destination : {0}".format(destination))
    print("From : {0}".format(server_conf.get('name', server_conf['host'])))
    cmd = get_fscp_cmd(server_conf, destination, tocopy)
    launch_command(cmd)

def main():
    parser = build_parser()
    arguments = parser.parse_args()
    command = arguments.command
    filename = arguments.filename
    server = arguments.server
    server_conf = load_server_conf(filename, server)

    if isinstance(server_conf, list):
        for i, serv in enumerate(server_conf):
            print("[{0}] {1} ({2})".format(i+1, serv['host'],
                                            serv.get('name')))
        num = int(raw_input("Which server do you want to connect to ?"))
        server_conf = server_conf[num-1]
    if 'passphrase' in server_conf:
        print("Remember the passphrase : {0} ;)".format(
                                                    server_conf['passphrase']))

    if command == 'connect':
        connect(server_conf)
    else:
        destdir = arguments.paths.pop(0)
        tocopy = arguments.paths
        if not tocopy:
            print("Missing arguments")
            sys.exit(1)
        if command == 'scp':
            scp(server_conf, destdir, tocopy)
        elif command == 'fscp':
            from_scp(server_conf, destdir, tocopy)



if __name__ == '__main__':
    main()
