#! /usr/bin/env python
from scapy.all import *
import pymysql

def monitor_callback(pkt):
    if not pkt.haslayer(Dot11): # Discard frames with no 802.11 headers
        return
    if pkt.type == 1: # Discard control frames
        return
    print pkt.time, pkt[Dot11].addr2
    con = pymysql.connect('192.168.31.120', 'test', 'password', 'users')
    con.execute("""INSERT INTO orders (connection, duration, freqconnection) VALUES ("%s", "%s", "%s")""" 
    con.commit()

sniff(prn=monitor_callback, store=0)
