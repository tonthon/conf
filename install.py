#-*-coding:utf-8-*-
"""
Script d'installation de fichiers de configuration
"""
from sys import argv
from os import listdir, system

HERE = path.dirname(__file__)

def get_conf_files():
    return [f_name for f_name in listdir(path.join(HERE, './files/'))if f_name.startswith('.')]

def copy_file(f_name, dest):
    system("/bin/cp -f '%s' '%s' " % (f_name, dest))

def install():
    if len(argv) > 1:
        destination = argv[1]
    else:
        destination = '~/'

    for f_name in get_conf_files():
        copy_file(f_name, dest)
if __name__ == '__main__':
    install()
