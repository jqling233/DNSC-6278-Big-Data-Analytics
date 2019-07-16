#!/usr/bin/env python

import sys
import re
from datetime import datetime

# regular expression to extract the parts of the line that are inside the brackets
regex = "^.*\[(.*)\].*$"


def process_line(line):
	line = line.strip()
	dt = re.match(regex, line).group(1)
	# convert the string to date, but get rid of the offset since it causes errors with strptime
	try:
		dt_obj = datetime.strptime(dt[0:11], '%d/%b/%Y')
		# re-convert the date object to year-month
		return(dt_obj.strftime("%Y-%m"))
	except ValueError:
		return("Bad or Missing Timestamp")


if __name__ == '__main__':
	for line in sys.stdin:
		output = process_line(line)
		sys.stdout.write("{}\t1\n".format(output))
