# -*- coding: utf-8 -*-
"""Conversion script for RVK-XML dump to JSKOS.

It is possible to send the Objects directly into a MongoDB instance, Object by
Object using the Function pushOne() or multiple Objects at once using the
Function pushMultiple().
It is also possible to write the Objects into a newline-delimited JSON File
with one JSKOS Concept on each line using the Function writeResultToFile().
"""

import codecs
import json
import platform
import pymongo
import re
import sys
from lxml import etree


class Conversion(object):
    """The Conversion Class for the Conversion Task."""

    def __init__(self):
        """Initialise Functions."""
        super(Conversion, self).__init__()
        # Raise Exception if Python 2 is used
        try:
            assert sys.version_info >= (
                3, 0), 'Please start this Script using Python 3.'
        except AssertionError as e:
            vers = platform.python_version()
            e.args += ('You are using Python ' + vers, 'If you have started ' +
                       'this Script from Command Line, please use ' +
                       'python3 + <scriptname> instead of ' +
                       'python + <scriptname>.')
            raise
        # Define the XML Stuff
        # FIXME: Encoding is the encoding of the Source XML File e.g. UTF-8
        # enc = 'utf-8'
        enc = 'iso-8859-1'
        # FIXME: xmlfile has to be specified with the Source File
        xmlfile = codecs.open('files/rvko_2017_3.xml', 'r', encoding=enc)
        # xmlfile = codecs.open('files/test3_rvko.xml', 'r', encoding=enc)
        parser = etree.XMLParser(recover=True)
        rvko = etree.parse(xmlfile, parser)
        rvk_root = rvko.getroot()
        xmlfile.close()
        # Define other Variables
        count = 0  # To count the number of results
        span = re.compile(
            '^\w{1,}\s{1}\d{1,5}\s{1}-\s{1}\w{1,}\s{1}\d{1,5}$'
        )   # Regex to look for number spans, e.g. 'AB 12345 - CD 67890'
        insert_list = []  # List for the MongoDB-Upload
        # rvkuri = 'http://bartoc.org/en/node/533'
        rvkuri = 'http://dewey.info/scheme/rvk'
        urispace = 'http://uri.gbv.de/terminology/rvk/'
        skosconcept = 'http://www.w3.org/2004/02/skos/core#Concept'
        skosnumberspan = skosconcept + '/NumberSpan'

        # Perform Operations
        dict_scheme = {}  # Dict to save the Scheme URI
        dict_scheme['uri'] = rvkuri

        # Iterate over all Nodes in the XML File to use them later as Objects
        for node in rvk_root.xpath('//node'):
            dict_node = {}      # Dictionary to save Node Results
            dict_node['inScheme'] = list()
            dict_node['inScheme'].append(dict_scheme)
            register_list = []  # List to save possible <register> Entries
            node_notation = node.attrib['notation']
            # Check for badly encoded Umlaute
            node_notation = self.replaceUmlaute(node_notation)
            node_uri = self.conceptURI(node_notation, urispace)
            dict_node['notation'] = list()
            dict_node['notation'].append(node_notation)
            node_preflabel = node.attrib['benennung']
            # Check for badly encoded Umlaute
            node_preflabel = self.replaceUmlaute(node_preflabel)
            dict_preflabel = {}  # Dictionary to save the Object's prefLabel
            dict_preflabel['de'] = node_preflabel
            dict_node['prefLabel'] = dict_preflabel
            dict_node['uri'] = node_uri
            dict_node['type'] = list()
            # Look for the correct type
            if span.match(node_notation) is not None:
                dict_node['type'].append(skosnumberspan)
            else:
                dict_node['type'].append(skosconcept)

            # Iterate over all Children of the Node and add them to
            # Object's narrower
            for children in node.findall('./children'):
                if children is not None:
                    dict_node['narrower'] = list()
                    for child in children.findall('./node'):
                        dict_child = {}  # Dictionary to save Children of Node
                        dict_child_preflabel = {}
                        list_child_notation = []
                        child_notation = child.attrib['notation']
                        # Check for badly encoded Umlaute
                        child_notation = self.replaceUmlaute(child_notation)
                        dict_child['notation'] = list()
                        dict_child['notation'].append(child_notation)
                        list_child_notation.append(child_notation)
                        child_preflabel = child.attrib['benennung']
                        # Check for badly encoded Umlaute
                        child_preflabel = self.replaceUmlaute(child_preflabel)
                        dict_child_preflabel['de'] = child_preflabel
                        dict_child['prefLabel'] = dict_child_preflabel
                        dict_node['narrower'].append(dict_child)

            for notes in node.findall('./content'):
                if notes is not None:
                    bemerkung = notes.attrib['bemerkung']
                    # Check for badly encoded Umlaute
                    bemerkung = self.replaceUmlaute(bemerkung)

            for register in node.findall('./register'):
                dict_node['instructionNote'] = list()
                register_text = register.text
                # Check for badly encoded Umlaute
                register_text = self.replaceUmlaute(register_text)
                register_text = ' '.join(register_text.split())
                register_list.append(register_text)

                if notes is not None or register is not None:
                    dict_node['topicalTerm'] = list()
                    if notes is not None:
                        dict_node['instructionNote'].append(bemerkung)

                    if register is not None:
                        for i in range(0, len(register_list)):
                            dict_node['topicalTerm'].append(register_list[i])

            # Iterate over Parents of the Node and add them to
            # Object's broader
            for parentC in node.xpath('./parent::*'):
                if parentC.tag == 'children':
                    for parent in parentC.xpath('./parent::*'):
                        dict_parent = {}
                        dict_parent['notation'] = list()
                        dict_parent_preflabel = {}
                        parent_notation = parent.attrib['notation']
                        # Check for badly encoded Umlaute
                        parent_notation = self.replaceUmlaute(parent_notation)
                        dict_parent['notation'].append(parent_notation)
                        parent_label = parent.attrib['benennung']
                        # Check for badly encoded Umlaute
                        parent_label = self.replaceUmlaute(parent_label)
                        dict_parent_preflabel['de'] = parent_label
                        parent_uri = self.conceptURI(parent_notation, urispace)
                        dict_parent['uri'] = parent_uri
                        dict_parent['prefLabel'] = dict_parent_preflabel
                        dict_node['broader'] = dict_parent

            # Build List to use for Batch Push to MongoDB also used
            # if the result should be written to a File
            count += 1
            insert_list.append(dict_node)
            # Print the Process to the Terminal as proof that
            # there is actually something happening
            if count % 1000 == 0:
                print(str(count) + ' nodes processed.\t' + node_notation)

            # Push Entries of Node Dictionary into MongoDB one by one
            # FIXME: Remove leading # in the next line to use
            # self.pushOne(dict_node, count, node_notation)

        # Push multiple Entries into MongoDB
        # FIXME: Remove leading # in the next line to use
        self.pushMultiple(insert_list)

        # Write Entries into a file
        # FIXME: Remove leading # in the next line to use
        # self.writeResultToFile(insert_list)

    def conceptURI(self, notation, urispace):
        """Build the needed URI.

        Takes the URL stored in urispace and combines it with
        the String stored in notation to build the URI from it.
        """
        uri = []
        notation = urispace + ' '.join(notation.split())
        uri.append(notation)
        return(uri[0])

    def conceptType(self, notation):
        """Build the needed SKOS Type.

        Makes a List from all SKOS-Types that were handed over
        to this Function.
        """
        skostype = []
        skostype.append(notation)
        return(skostype[0])

    def replaceUmlaute(self, check):
        """Alters wrongly coded Strings into correct UTF-8 encoded Strings.

        there were some Encoding-Issues if a File was pre-processed with a
        Windows-System and afterwards this Script was run on a Linux-System.
        Therefore every Character in a String will be checked for bad Encoding
        and replaced with the correct Character using a Python-Dictionary.
        """
        replacements = {
            'Ã': 'Ö',
            'Ã¶': 'ö',
            'Ã': 'Ä',
            'Ã¤': 'ä',
            'Ã': 'Ü',
            'Ã¼': 'ü',
            'Ã': 'ß'
        }
        for src, target in replacements.items():
            if src in check:
                check = check.replace(src, target)
        return(check)

    def pushOne(self, dict_node, count, node_notation):
        """Push Results one by one into the MongoDB.

        The function mongoCredentials() is called and the Mongo-DB-Credentials
        are stored in the variable collection.
        The Variable result is only needed if the actual storing process should
        be printed to the Terminal using the Mongo-DB-IDs. In this case
        the # before the print Command needs to be removed.
        """
        collection = self.mongoCredentials()
        result = collection.insert_one(dict_node)
        if count % 1000 == 0:
            print(str(count) + ' nodes processed.\t' + node_notation)
        # FIXME: Remove the # in the next line to print the IDs
        # print(result.inserted_id)

    def pushMultiple(self, insert_list):
        """Push Results in Steps of 1000 into the MongoDB.

        The function mongoCredentials() is called and the Mongo-DB-Credentials
        are stored in the variable collection.
        The Variable result is only needed if the actual storing process should
        be printed to the Terminal using the Mongo-DB-IDs. In this case
        the # before the print Commands needs to be removed.
        """
        collection = self.mongoCredentials()
        push_list = []
        for i in range(0, len(insert_list), 1000):
            if len(insert_list) < 1000:
                j = i + len(insert_list)
                push_list.extend(insert_list[0:len(insert_list)])
                del insert_list[0:len(insert_list)]
                result = collection.insert_many(push_list)
                print(str(j) + ' results pushed into the Database.')
                # FIXME: Remove the # in the next line to print the IDs
                # print(result.inserted_ids)
            else:
                j = i + 1000
                push_list.extend(insert_list[0:1000])
                del insert_list[0:1000]
                result = collection.insert_many(push_list)
                print(str(j) + ' nodes processed.')
                # FIXME: Remove the # in the next line to print the IDs
                # print(result.inserted_ids)
            del push_list[::]

    def writeResultToFile(self, insert_list):
        """Dump Results in a JSON file.

        This Function writes the Conversion Results into a JSON-File named
        jskos.json. It will be UTF-8 encoded and intended with four Spaces.
        The number of processed Items is printed to the Terminal.
        """
        with open('jskos.json', 'w', encoding='utf-8') as jskos:
            for i in range(0, len(insert_list)):
                json.dump(insert_list[i], jskos, ensure_ascii=False, indent=4)
                if i % 1000 == 0:
                    print(str(i) + ' nodes processed.')

    def mongoCredentials(self):
        """Return the Credentials for the MongoDB.

        Alter the Log In Credentials for the MongoDB in this Function
        as needed.
        ip is the Variable to store the IP of the Database Server.
        port ist the Variable to store the Database Server Port for MongoDB.
        client opens the MongoClient Function.
        db is the Variable in which the Database Name is stored.
        collection is the Variable in which the Collection Name is stored.

        ismaster is only used to check the Connection to the MongoDB-Databse
        and the Admin Mode is only used for this.
        """
        # FIXME: Enter the correct IP or Hostname
        ip = 'esx-128.gbv.de'
        # ip = 'localhost'
        # FIXME: Enter the correct Port Number
        port = 27017
        client = pymongo.MongoClient(ip, port)
        # FIXME: Enter the correct Databse Name
        db = client.GBVDatabase
        # db = client.testdatabase
        # FIXME: Enter the correct Collection Name
        collection = db.rvkConcepts1
        # collection = db.rvkotest1

        # Catch possible Exception while connecting to MongoDB Server
        # client.admin is just used to try to establish a connection to the
        # Database. There is no actual Operation using it.
        try:
            ismaster = client.admin.command("ismaster")
            print('Connection to MongoDB: ' + ip + ':' + str(port) +
                  ': succesfully established!\n')
        except pymongo.errors.ConnectionFailure as e:
            print('Could not connect to MongoDB: %s' % e)
        return(collection)


# Runs the Class
Conversion()
