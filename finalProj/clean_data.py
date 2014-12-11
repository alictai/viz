import csv

class User:
	def __init__(self, rid, g, a, w, r, m, lo, lb):
		self.respid = rid
		self.gender = g
		self.age = a
		self.working = w
		self.region = r
		self.music = m
		self.listown = lo
		self.listback = lb
		self.words = []
	def set_questions(self, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s):
		self.qs = [a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s]
	def add_word(self, word):
		self.words.append(word)

def get_users(filename, pulleddate):
	userz = []
	with open(filename, 'rU') as csvfile:
		rdr = csv.reader(csvfile, delimiter=',', quotechar='|')
		for row in rdr:
			userz.append(User(row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7]))
	return userz


# def parse_file(filename, bcodes, pulleddate):
# 	output = []
# 	curr_building = ""
# 	with open(filename, 'rU') as csvfile:
# 		rdr = csv.reader(csvfile, delimiter=',', quotechar='|')
# 		possible_caps = []
# 		for row in rdr:
# 			#set the room/building header
# 			if (row[1] == '' and row[2] == '' and row[3] == '' and row[4] == '' and row[5] == '' and row[6] == '' and row[7] == '' and row[8] == '' and row[9] == '' and row[10] == ''):
# 				curr_building = row[0]
# 			elif (row[0] == '' and row [8]):
# 				possible_caps.append(int(row[9]))
# 			else:
# 				# updating previous capacity based on the additional configurations
# 				if (len(possible_caps) > 0):
# 					output[len(output) - 1].cap = max(possible_caps)
# 					possible_caps = []

# 				# ignoring the random header lines everywhere
# 				if (row[0] != 'Tufts University' and row[0] != 'Room' and row[0] != pulleddate and row[0] != ''):
# 					# room description has a fucking comma in it
# 					cap = ''
# 					if (row[8] != '0'):
# 						#print row
# 						description = row[2] + row[3]
# 						description = description.strip('"')
# 						cap = Room(curr_building, row[0], description, row[7], int(row[10]))
# 					#room description does not have a comma in it
# 					else:
# 						cap = Room(curr_building, row[0], row[2], row[7], int(row[9]))
# 					cap.set_code(bcodes[curr_building])
# 					output.append(cap)
# 	#for obj in output:
# 	#	obj.print_self()
# 	return output

# def write_new(newfilename, data):
# 	with open(newfilename, 'wb') as csvfile:
# 		wrtr = csv.writer(csvfile, delimiter=',') #, quotechar=' ', quoting=csv.QUOTE_ALL)
# 		wrtr.writerow(["Building", "Code", "Room", "Room_Code", "Description", "Capacity"])
# 		for obj in data:
# 			room_code = obj.building_code + " " + obj.room
# 			wrtr.writerow([obj.building, obj.building_code, obj.room, room_code, obj.descrip, obj.cap])

def main():
	users = get_users('users.csv')
	# parsed = parse_file('Room_Capacities_Computer_Science_Project.csv', codes, '10/30/2014 2:43 PM NR')
	# write_new('Rooms.csv', parsed)

if __name__ == '__main__':
	main()
