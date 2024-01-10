import os
import subprocess
import sys
import re
from apted import APTED
from apted.helpers import Tree


class Node:
    def __init__(self, name, path):
        self.id = path
        self.name = name
        self.children = []

    def add_child(self, node):
        self.children.append(node)


def calculate_node_count(node):
    """Calculate the number of nodes in the tree."""
    count = 1  # Count the current node

    # Recursively calculate the number of nodes for each child
    for child in node.children:
        count += calculate_node_count(child)

    return count
def get_Trees(prog,origin,target):
    path='./grammars-v4'
    match prog:
        case "java":
            pwd=path+'/java/java/JavaLexer.g4 '+path+"/java/java/JavaParser.g4 compilationUnit "
        case "python":
            pwd=path+'/python/python3/Python3Lexer.g4 '+path+"/python/python3/Python3Parser.g4 file_input "
        case "sql":
            pwd=path+'/sql/sqlite/SQLiteLexer.g4 '+path+"/sql/sqlite/SQLiteParser.g4 parse "
    origin_exec="antlr4-parse "+pwd+origin+" -tree"
    tree1=subprocess.Popen(origin_exec,stdout=subprocess.PIPE, shell=True,stderr=subprocess.DEVNULL).communicate()
    tree1=re.sub(r':\d+\s', ': ', str(tree1)).replace("{","L_brace").replace("}","R_brace")
    tree1=tree1.replace("(","{").replace(")","}").replace(" ","")
    len1=str(tree1).count("}")
    tree_origin=Tree.from_text(tree1)

    target_exec="antlr4-parse "+pwd+target+" -tree"
    tree2=subprocess.Popen(target_exec,stdout=subprocess.PIPE, shell=True,stderr=subprocess.DEVNULL).communicate()
    tree2=re.sub(r':\d+\s', ': ', str(tree2)).replace("{","L_brace").replace("}","R_brace")
    tree2=tree2.replace("(","{").replace(")","}").replace(" ","")
    len2=str(tree2).count("}")
    tree_target=Tree.from_text(tree2)

    return tree_origin,tree_target,max(len1,len2)

def Calaulte(lan,str1,str2):
    tree1,tree2,max_len=get_Trees(lan,str1,str2)
    apted = APTED(tree1, tree2)
    res = apted.compute_edit_distance()
    if res>max_len:
        return(0.0)
    else : return((max_len-res)/max_len) 

