""" ex_import.py - Learn how to import a module in python

  In this exercise we try to import a module and call a function.

"""
import ex_helloworld as mysuperlib

mysuperlib.say_hello("World")
mysuperlib.say_hello(5)
mysuperlib.say_hello(0.01640)
mysuperlib.say_hello([ 3, 2.15, "World", 'X' ])
mysuperlib.say_hello( range(10) )
mysuperlib.say_hello( [ i**3 for i in xrange(10) ] )