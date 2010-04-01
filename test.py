import networkx as nx
from random import choice, sample

class Level(object):
    def __init__(self, number):
        self.number = number
        self.keys = []

    def addKey(self, key):
        self.keys.append(key)

    def __repr__(self):
        return "L(%d)" % self.number

class Key(object):
    def __init__(self, levelA, levelB):
        if levelA.number < levelB.number:
            nodeA, nodeB = levelA, levelB
        else:
            nodeB, nodeA = levelA, levelB

        self.nodeA = nodeA
        self.nodeB = nodeB

    def __repr__(self):
        return "Key(%d,%d)" % (self.nodeA.number, self.nodeB.number)

    def __eq__(self, other):
        return self.nodeA == other.nodeA and self.nodeB == other.nodeB


def randomConnectedGraph(size):
    nodes = [Level(i) for i in range(size)]

    G = nx.Graph()
    G.add_nodes_from(nodes)

    components = nx.connected_components(G)
    while len(components) > 1:
        compA, compB = sample(components, 2)
        nodeA = choice(compA)
        nodeB = choice(compB)
        G.add_edge(nodeA, nodeB) 
        components = nx.connected_components(G)

    return G

def findAccessibleNodes(G, N, visited, keys):
    visited.append(N)
    for edge in G.edges([N]):
        M = edge[1] #the node on the other end of the edge
        if M not in visited and Key(*edge) in keys:
            findAccessibleNodes(G, M, visited, keys)

    return visited

def levelGraph(size):
    G = randomConnectedGraph(size)

    #pick a start node, S
    S = choice(G.nodes()) 
    
    accessibleKeys = []
    accessibleNodes = [S]
    visibleImpasse = G.edges([S])

    while len(visibleImpasse) > 0:
        edge = choice(visibleImpasse)
        dropNode = choice(accessibleNodes)
        dropNode.addKey(Key(*edge))
        accessibleKeys.append(Key(*edge))

        accessibleNodes = findAccessibleNodes(G, S, [], accessibleKeys)
        visibleImpasse = [edge for N in accessibleNodes for edge in G.edges([N]) if Key(*edge) not in accessibleKeys]

    return G, S

if __name__ == "__main__":
    G, S = levelGraph(10)
    print "Start Node: %s" % S
    for N in G.nodes():
        print "Node: %s" % N, "Neighbors: %s" % ", ".join(["%s"%M for M in G.neighbors(N)])
        for key in N.keys:
            print"     %s" % key


        

