import csv
import array

users = []

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
		self.words = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
	def set_questions(self, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s):
		self.qs = [a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s]
	def get_id(self):
		return int(self.respid)
	def add_words(self, word_id):
		self.words[word_id] = self.words[word_id] + 1

def zero(value):
	if value == "":
		return -1
	else:
		return value

def get_users(filename):
	global users
	with open(filename, 'rU') as csvfile:
		rdr = csv.reader(csvfile, delimiter=',', quotechar='|')
		for row in rdr:
			if row[0] != "RESPID":
				respid = int(row[0])
				users[respid] = User(zero(row[0]), zero(row[1]), zero(row[2]), zero(row[3]), zero(row[4]), zero(row[5]), zero(row[6]), zero(row[7]))
				users[respid].set_questions(zero(row[8]), zero(row[9]), zero(row[10]), zero(row[11]), zero(row[12]), zero(row[13]), zero(row[14]), zero(row[15]), zero(row[16]), zero(row[17]), zero(row[18]), zero(row[19]), zero(row[20]), zero(row[21]), zero(row[22]), zero(row[23]), zero(row[24]), zero(row[25]), zero(row[26]))
	print("global users has been set")

def parse_file(filename):
	global users
	header = True
	place = 0
	with open(filename, 'rU') as csvfile:
		rdr = csv.reader(csvfile, delimiter=',', quotechar='|')
		for row in rdr:
			print("PROCESSED ROW: " + str(place))
			place = place + 1
			if header == False:
				parse_id = int(row[1])
				for i in range (5, 87):
					if users[parse_id] != {}:
						users[parse_id].add_words(i-5)
			else:
				header = False
	print("words added")

def write_new(newfilename):
	global users
	place = 0
	new_id = 0
	with open(newfilename, 'wb') as csvfile:
		wrtr = csv.writer(csvfile, delimiter=',') #, quotechar=' ', quoting=csv.QUOTE_ALL)
		wrtr.writerow(["RESPID", "GENDER", "AGE", "WORKING", "REGION", "MUSIC", "LIST_OWN", "LIST_BACK", "Q1", "Q2", "Q3", "Q4", "Q5", "Q6", "Q7", "Q8", "Q9", "Q10", "Q11", "Q12", "Q13", "Q14", "Q15", "Q16", "Q17", "Q18", "Q19","Uninspired","Sophisticated","Aggressive","Edgy","Sociable","Laid back","Wholesome","Uplifting","Intriguing","Legendary","Free","Thoughtful","Outspoken","Serious","Good lyrics","Unattractive","Confident","Old","Youthful","Boring","Current","Colourful","Stylish","Cheap","Irrelevant","Heartfelt","Calm","Pioneer","Outgoing","Inspiring","Beautiful","Fun","Authentic","Credible","Way out","Cool","Catchy","Sensitive","Mainstream","Superficial","Annoying","Dark","Passionate","Not authentic","Good Lyrics","Background","Timeless","Depressing","Original","Talented","Worldly","Distinctive","Approachable","Genius","Trendsetter","Noisy","Upbeat","Relatable","Energetic","Exciting","Emotional","Nostalgic","None of these","Progressive","Sexy","Over","Rebellious","Fake","Cheesy","Popular","Superstar","Relaxed","Intrusive","Unoriginal","Dated","Iconic","Unapproachable","Classic","Playful","Arrogant","Warm","Soulful"])
		for user in users:
			if user != {}:
				new_row = [new_id, user.gender, user.age, user.working, user.region, user.music, user.listown, user.listback]
				for ansr in user.qs:
					new_row.append(ansr)
				for times_said in user.words:
					new_row.append(times_said)
				wrtr.writerow(new_row)
				new_id = new_id + 1
			print("WRITTEN ROW: " + str(place))
			place = place + 1

def init_users():
	global users
	users = [{} for k in range(100000)]

def main():
	init_users()
	get_users('users.csv')
	parse_file('words.csv')
	write_new('merged.csv')

if __name__ == '__main__':
	main()
