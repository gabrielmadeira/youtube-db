# Youtube - Trabalho Prático
# Fundamentos de Banco de Dados 2021/2
# Instituto de Informática - Universidade Federal do Rio Grande do Sul
# Gabriel Madeira (00322863)
# Henrique Borges (00326970)


import psycopg2
import pandas.io.sql as psql
import datetime

import warnings
warnings.filterwarnings('ignore')

conn = psycopg2.connect(
    host="localhost",
    database="fbd",
    user="postgres",
    password="12345678")

while(True):
	print("\nChoose your query:")
	print("1 - Movie ID, total profit with movie according to views and channel author name")
	print("2 - Name, price, amount of subtitles and audios of movies released before year X sorted by purchase price")
	print("3 - Number of views by category")
	print("4 - Engagement index by category")
	print("5 - Name of users who posted X hours of video or posted at least Y different things. Query to filter content creators.")
	print("6 - Returns the name of the channel/user that has been a member of all memberships for a given user")
	print("7 - All videos and which audios/subtitles are available")
	print("8 - Username and body of all comments for all videos of a given channel id")
	print("9 - Number of likes per content")
	print("10 - Average time watched by category")
	print("0 - Exit\n")
	queryID = int(input("Query ID: "))
	query = ""
	valid = True
	data = dict()
	
	if(queryID == 0):
		break
	
	if(queryID == 1):
		query = """
		SELECT views.id_video as MovieID, count(*)*(((avg(moviesfull.price_buy)+avg(moviesfull.price_rent))/2)) AS total, ChannelsUsers.name as channel
		FROM (VIEWS
		JOIN moviesfull ON (moviesfull.id = views.id_video)) JOIN ChannelsUsers ON (moviesfull.id_channel = ChannelsUsers.id)
		WHERE moviesfull.price_rent IS NOT NULL
		AND moviesfull.price_buy IS NOT NULL
		GROUP BY (views.id_video, ChannelsUsers.name)
		"""
	elif(queryID == 2):
		query = """
		SELECT name,
			   price_buy,
			   sub.qtdsub,
			   aud.qtdaud
		FROM moviesfull
		LEFT JOIN
		(SELECT id_video AS id,
			  count(*) AS qtdSub
		FROM subtitlesfilenames
		GROUP BY id_video) AS sub
		ON (sub.id=moviesfull.id)
		LEFT JOIN
		(SELECT id_video AS id,
			  count(*) AS qtdAud
		FROM audiosfilenames
		GROUP BY id_video) AS aud 
		ON (aud.id=moviesfull.id)
		WHERE creation_date_time < %(year)s
		ORDER BY price_buy; 
		"""
		data['year'] =  datetime.date(int(input("Year (X): ")), 1, 1);
	elif(queryID == 3):
		query = """
		SELECT sum(aux.count) AS VIEWS,
			   categories.name AS category
		FROM
		  (SELECT count(*),
				  videos.id,
				  videos.id_category
		   FROM videos
		   JOIN VIEWS ON (views.id_video = videos.id)
		   GROUP BY videos.id) AS aux
		JOIN categories ON (aux.id_category = categories.id)
		GROUP BY categories.name; 
		"""
	elif(queryID == 4):
		query = """
		SELECT (category_ratings.ratings/category_views.views) AS indice_engagement, category_ratings.category as category
		FROM
		  (SELECT sum(aux.count) AS VIEWS,
				  categories.name AS category
		   FROM
			 (SELECT count(*),
					 videos.id,
					 videos.id_category
			  FROM videos
			  JOIN VIEWS ON (views.id_video = videos.id)
			  GROUP BY videos.id) AS aux
		   JOIN categories ON (aux.id_category = categories.id)
		   GROUP BY categories.name) AS category_views
		NATURAL JOIN
		  (SELECT sum(aux.count) AS ratings,
				  categories.name AS category
		   FROM
			 (SELECT count(*),
					 videos.id,
					 videos.id_category
			  FROM videos
			  JOIN ratings ON (ratings.id_content = videos.id)
			  GROUP BY videos.id) AS aux
		   JOIN categories ON (aux.id_category = categories.id)
		   GROUP BY categories.name) AS category_ratings; 
		"""
	elif(queryID == 5):
		query = """
		SELECT ChannelsUsers.name
		FROM (ChannelsUsers
			  JOIN CONTENTS ON (ChannelsUsers.id = id_channel))
		LEFT JOIN Videos ON (Videos.id = Contents.id)
		GROUP BY ChannelsUsers.name
		HAVING SUM(Videos.duration) >= %(hours)s
		OR COUNT(*) >= %(qty)s; 
		"""
		data['hours'] = str(int(input("Hours of video (X): "))*3600)
		data['qty'] = input("Qty different things posted at least (Y): ")
	elif(queryID == 6):
		query = """
		SELECT name
		FROM ChannelsUsers C
		WHERE NOT EXISTS
			(SELECT Memberships.id
			 FROM Memberships
			 JOIN ChannelsUsers ON (id_channel = ChannelsUsers.id)
			 WHERE ChannelsUsers.name = %(username)s
			   AND Memberships.id not in
				 (SELECT Memberships.id AS ms
				  FROM (ChannelsUsers
						JOIN Members ON (ChannelsUsers.id = Members.id_member))
				  JOIN Memberships ON (Members.id_membership = Memberships.id)
				  WHERE ChannelsUsers.id = C.id));
		"""
		data['username'] = input("User/Channel name: ")
	elif(queryID == 7):
		query = """
		SELECT Videos.name, Dub.display_name as Dubs, Sub.display_name as Subs
		FROM Videos LEFT JOIN AudiosFilenames as Dub ON (Videos.id = Dub.id_video) 
		FULL JOIN SubtitlesFilenames as Sub ON (Videos.id = Sub.id_video and Dub.display_name = Sub.Display_name);
		"""
	elif(queryID == 8):
		query = """
		SELECT channelsusers.name,
			 content
		FROM comments
		JOIN channelsusers ON (comments.id_user = channelsusers.id) WHERE id_content in
		(SELECT id
		 FROM CONTENTS
		 WHERE id_channel=%(channelid)s);
		""" 
		data['channelid'] = input("Channel ID: ")
		
	elif(queryID == 9):
		query = """
		SELECT Contents.id as id_conteudo, COUNT(distinct(ChannelsUsers.id)) as number_of_likes
		FROM Contents JOIN Ratings ON (Contents.id = Ratings.id_content) JOIN ChannelsUsers ON (ChannelsUsers.id = Ratings.id_user)
		WHERE rating = TRUE
		GROUP BY Contents.id;
		"""
	elif(queryID == 10):
		query = """
		SELECT Categories.name AS category,
			 AVG(stop_time) AS watch_time
		FROM Videos
		JOIN VIEWS ON (id_video = Videos.id)
		JOIN Categories ON (categories.id = id_category) WHERE stop_time IS NOT NULL
		GROUP BY Categories.name;
		"""
	else:
		valid = False
	
	
	if(valid):
		print("\nQuery result:")
		table_result = psql.read_sql(query, conn, None, True, data)
		print(table_result)