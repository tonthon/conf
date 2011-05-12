#-*-coding:utf-8-*-
"""
Script d'installation de fichiers de configuration
"""
import os

HERE = os.path.dirname(__file__)

def get_files_dir():
    return os.path.join(HERE, './files/')

def get_conf_files():
    return [os.path.join(get_files_dir(), f_name)
            for f_name in os.listdir(get_files_dir())if f_name.startswith('.')]

def copy_file(f_name, dest):
    cmd = "/bin/cp -rf '%s' '%s' " % (f_name, dest)
    print cmd
    os.system(cmd)

def install():
    destination = os.path.expanduser('~/')

    for f_name in get_conf_files():
        copy_file(f_name, destination)

if __name__ == '__main__':
    install()
